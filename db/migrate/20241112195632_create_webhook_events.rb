class CreateWebhookEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :webhook_events do |t|
      t.references :webhook, null: false, foreign_key: true
      t.string :event, null: false
      t.jsonb :payload, null: false
      t.string :status, null: false
      t.text :error_message
      t.integer :retry_count, null: false, default: 0

      t.timestamps
    end

    add_index :webhook_events, [ :webhook_id, :created_at ]
    add_index :webhook_events, :status
  end
end
