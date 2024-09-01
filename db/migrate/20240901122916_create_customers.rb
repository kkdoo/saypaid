class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :customers, id: :uuid do |t|
      t.uuid :layer_id, null: false
      t.string :name
      t.string :email
      t.datetime :discarded_at, index: true
      t.timestamps
    end
  end
end
