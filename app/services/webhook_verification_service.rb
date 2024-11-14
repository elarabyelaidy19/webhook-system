require "http"

class WebhookVerificationService
  class VerificationError < StandardError; end

  def initialize(url)
    @url = url
  end

  def verify!
    uri = URI.parse(@url)
    response = HTTP.get(uri)

    unless response.status.success?
      raise VerificationError, "URL is not reachable (status: #{response.status})"
    end

    true
  rescue URI::InvalidURIError
    raise VerificationError, "Invalid URL format"
  rescue SocketError, Timeout::Error, Errno::ECONNREFUSED
    raise VerificationError, "Could not connect to the URL"
  end
end
