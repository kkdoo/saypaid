class CreateLineItems < ActiveRecord::Migration[7.2]
  def change
    create_table :line_items, id: :uuid do |t|
      t.uuid :invoice_id, null: false
      t.uuid :subscription_version_id, null: false
      t.decimal :amount, precision: 20, scale: 5, null: false
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
