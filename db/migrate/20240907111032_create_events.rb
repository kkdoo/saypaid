class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events, id: :uuid do |t|
      t.uuid :layer_id, null: false
      t.string :object_type, null: false
      t.integer :status, default: 0, null: false
      t.text :data, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
