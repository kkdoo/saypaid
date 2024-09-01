class CreatePricingCards < ActiveRecord::Migration[7.2]
  def change
    create_table :pricing_cards, id: :uuid do |t|
      t.uuid :pricing_table_id, null: false
      t.uuid :plan_id, null: false
      t.string :name, null: false
      t.integer :trial_in_days, default: 0
      t.datetime :discarded_at, index: true
      t.timestamps
    end
  end
end
