class CreateInvoices < ActiveRecord::Migration[7.2]
  def change
    create_table :invoices, id: :uuid do |t|
      t.uuid :layer_id, null: false
      t.uuid :customer_id, null: false
      t.integer :status, default: 0, null: false
      t.string :currency_id, limit: 5, null: false
      t.datetime :due_date, null: false
      t.decimal :total, precision: 20, scale: 5, null: false
      t.datetime :discarded_at, index: true

      t.timestamps
    end
  end
end
