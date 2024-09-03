class RemoveNameFromPricingCard < ActiveRecord::Migration[7.2]
  def change
    remove_column :pricing_cards, :name, :string, null: false
  end
end
