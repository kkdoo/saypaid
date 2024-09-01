class CreatePricingTables < ActiveRecord::Migration[7.2]
  def change
    create_table :pricing_tables, id: :uuid do |t|
      t.uuid :layer_id, null: false
      t.string :code, null: false
      t.string :name
      t.datetime :discarded_at, index: true
      t.timestamps
    end
  end
end
