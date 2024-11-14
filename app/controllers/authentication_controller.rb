class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [ :login, :signup ]

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def signup
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def me
    render json: current_user, status: :ok
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
