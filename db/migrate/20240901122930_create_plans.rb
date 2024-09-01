class CreatePlans < ActiveRecord::Migration[7.2]
  def change
    create_table :plans, id: :uuid do |t|
      t.uuid :layer_id, null: false
      t.string :name
      t.string :code, null: false
      t.integer :interval, null: false
      t.integer :interval_count, null: false
      t.string :currency_id, limit: 5, null: false
      t.uuid :current_version_id, null: false
      t.datetime :discarded_at, index: true
      t.timestamps
    end
  end
end
