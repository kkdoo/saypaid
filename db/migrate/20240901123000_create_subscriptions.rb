class CreateSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscriptions, id: :uuid do |t|
      t.uuid :layer_id, null: false
      t.uuid :customer_id, null: false
      t.uuid :current_version_id, null: false
      t.integer :status, null: false, default: 0
      t.boolean :pay_in_advance, null: false
      t.datetime :discarded_at, index: true
      t.timestamps
    end
  end
end
