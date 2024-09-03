class AddNameToLayers < ActiveRecord::Migration[7.2]
  def change
    add_column :layers, :name, :string, null: false
  end
end
