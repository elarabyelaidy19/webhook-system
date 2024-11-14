class WebhookDeliveryService
  def self.call(event_type:, payload:)
    new(event_type:, payload:).call
  end


  def call
    Webhook.active.find_each do |webhook|
      webhook_event = WebhookEvent.create!(
        webhook:,
        event: event_type,
        payload:,
        status: "pending",
        )

        WebhookDeliveryJob.perform_later(webhook_event.id)
    end
  end

  private
  attr_reader :event_type, :payload
  def initialize(event_type:, payload:)
    @event_type = event_type
    @payload = payload
  end
end
