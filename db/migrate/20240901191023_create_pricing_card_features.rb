class CreatePricingCardFeatures < ActiveRecord::Migration[7.2]
  def change
    create_table :pricing_card_features, id: :uuid do |t|
      t.uuid :pricing_card_id, null: false
      t.string :name, null: false
      t.datetime :discarded_at, index: true
      t.timestamps
    end
  end
end
