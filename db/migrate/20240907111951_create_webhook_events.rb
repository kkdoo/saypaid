class CreateWebhookEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :webhook_events, id: :uuid do |t|
      t.uuid :event_id, null: false
      t.uuid :webhook_endpoint_id, null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end
  end
end
