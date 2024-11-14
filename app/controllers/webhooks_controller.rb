class WebhooksController < ApplicationController
  before_action :set_webhook, only: [ :show, :update, :destroy ]

  def index
    @webhooks = current_user.webhooks
    render json: @webhooks.as_json(except: [ :secret ])
  end

  def show
    render json: @webhook.as_json(except: [ :secret ])
  end

  def create
    @webhook = current_user.webhooks.new(webhook_params)

    if @webhook.save!
      render json: @webhook.as_json(except: [ :secret ]), status: :created
    else
      render json: { errors: @webhook.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @webhook.update(webhook_params)
      render json: @webhook.as_json(except: [ :secret ])
    else
      render json: { errors: @webhook.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @webhook.destroy
    head :no_content
  end

  private

  def set_webhook
    @webhook = current_user.webhooks.find_by!(id: params[:id])
  end

  def webhook_params
    params.require(:webhook).permit(:url, :active)
  end
end
