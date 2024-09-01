class CreateAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :default_currency_id, limit: 5, null: false
      t.datetime :discarded_at, index: true
      t.timestamps
    end
  end
end
