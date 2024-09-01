class CreateCurrencies < ActiveRecord::Migration[7.2]
  def change
    create_table :currencies, id: :string, limit: 5 do |t|
      t.timestamps
    end
  end
end
