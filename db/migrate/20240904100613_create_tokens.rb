class CreateTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :tokens, id: :uuid do |t|
      t.uuid :layer_id, null: false
      t.integer :kind, null: false
      t.string :key, null: false
      t.datetime :expired_at
      t.datetime :last_used_at
      t.datetime :discarded_at, index: true

      t.timestamps
    end

    add_index :tokens, :key, unique: true, where: '(discarded_at IS NULL)'
  end
end
