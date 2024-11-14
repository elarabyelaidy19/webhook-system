class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_forgery_protection
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header
    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue JWT::DecodeError
      render json: { error: "Invalid token" }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def authenticate_user!
    render json: { error: "Not authorized" }, status: :unauthorized unless current_user
  end
end
