class Webhook < ApplicationRecord
  URL_REGEX = URI::DEFAULT_PARSER.make_regexp(%w[http https])
  has_many :webhook_events, dependent: :destroy

  validates :url, presence: true, format: { with: URL_REGEX }
  validates :user_id, presence: true
  validate :validate_url_reachability
  before_validation :generate_secret, on: :create


  scope :active, -> { where(active: true) }

  private

  def validate_url_reachability
    WebhookVerificationService.new(url).verify!
  rescue WebhookVerificationService::VerificationError => e
    errors.add(:url, e.message)
  end

  def generate_secret
    return if secret.present?

    self.secret = SecureRandom.hex(32)
  end
end
