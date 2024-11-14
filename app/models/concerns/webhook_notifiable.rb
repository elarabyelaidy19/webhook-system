module WebhookNotifiable
  extend ActiveSupport::Concern

  included do
    after_commit :notify_webhooks, on: :create
  end

  private

  def notify_webhooks
    event_type = "#{self.class.name.underscore}.created"
    payload = self.as_json
    binding.irb
    WebhookDeliveryService.new(event_type:, payload:).call
  end
end
