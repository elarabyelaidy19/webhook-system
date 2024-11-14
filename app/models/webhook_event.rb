class WebhookEvent < ApplicationRecord
  MAX_RETRIES = 3


  enum :status, %w[pending processing completed failed].index_by(&:itself), null: false

  belongs_to :webhook, inverse_of: :webhook_events

  validates :event, presence: true
  validates :payload, presence: true
end
