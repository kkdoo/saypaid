class CreatePrices < ActiveRecord::Migration[7.2]
  def change
    create_table :prices, id: :uuid do |t|
      t.uuid :plan_version_id, null: false
      t.string :type, null: false
      t.decimal :flat_fee, precision: 20, scale: 5, default: 0
      t.timestamps
    end
  end
end
