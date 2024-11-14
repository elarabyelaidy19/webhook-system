class AddSecretToWebhook < ActiveRecord::Migration[8.0]
  def change
    add_column :webhooks, :secret, :string
    add_index :webhooks, :secret, unique: true
  end
end
