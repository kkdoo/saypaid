class CreateWebhookEndpoints < ActiveRecord::Migration[7.2]
  def change
    create_table :webhook_endpoints, id: :uuid do |t|
      t.uuid :layer_id, null: false
      t.string :url, null: false
      t.integer :status, default: 0, null: false
      t.datetime :discarded_at, index: true
      t.timestamps
    end
  end
end
