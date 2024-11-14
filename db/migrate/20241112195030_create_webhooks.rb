class CreateWebhooks < ActiveRecord::Migration[8.0]
  def change
    create_table :webhooks do |t|
      t.string :url, null: false
      t.integer :user_id, null: false
      t.boolean :active, null: false, default: true
      t.datetime :last_delivery_at

      t.timestamps
    end
  end
end
