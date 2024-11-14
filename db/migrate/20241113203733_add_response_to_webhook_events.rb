class AddResponseToWebhookEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :webhook_events, :response, :jsonb, default: {}
  end
end
