require "http"

class WebhookDeliveryJob < ApplicationJob
  class FailedRequestError < StandardError; end

  queue_as :default

  sidekiq_options retry: 3, dead: false
  sidekiq_retry_in do |retry_count|
    jitter = rand(30.seconds..10.minutes).to_i
    (retry_count ** 5) + jitter
  end

  def perform(webhook_event_id)
    webhook_event = WebhookEvent.find_by(id: webhook_event_id)
    return if webhook_event.nil?

    webhook = webhook_event.webhook
    return if webhook.nil?

    webhook_event.processing!
    payload = {
      event: webhook_event.event,
      payload: webhook_event.payload
    }.to_json


    signature = generate_signature(payload, webhook.secret)

    begin
      response = HTTP.timeout(30)
                    .headers(
                      "User-Agent" => "bevatellask/1.0",
                      "Content-Type" => "application/json",
                      "X-Webhook-Signature" => signature
                    )
                    .post(
                      webhook.url,
                      body: payload
                    )

      webhook_event.update(response: {
        headers: response.headers.to_h,
        code: response.code.to_i,
        body: response.body.to_s
      })

      if response.status.success?
        webhook_event.completed!
      else
        webhook_event.failed!
        webhook_event.update(error_message: "Request failed with status #{response.code}")
        webhook.increment!(:failed_deliveries)
        raise FailedRequestError, "Request failed with status #{response.code}"
      end

    rescue HTTP::TimeoutError
      webhook_event.failed!
      webhook_event.update(
        response: { error: "TIMEOUT_ERROR" },
        error_message: "Request timed out"
      )
      raise
    rescue StandardError => e
      webhook_event.failed!
      webhook_event.update(error_message: e.message)
      raise
    end
  end

  def generate_signature(payload, secret)
    OpenSSL::HMAC.hexdigest("SHA256", secret, payload)
  end
end
