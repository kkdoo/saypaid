class CreateLayers < ActiveRecord::Migration[7.2]
  def change
    create_table :layers, id: :uuid do |t|
      t.uuid :account_id, null: false
      t.boolean :livemode, null: false, default: false
      t.string :status, null: false, default: 'draft'
      t.datetime :discarded_at, index: true
      t.timestamps
    end
  end
end
