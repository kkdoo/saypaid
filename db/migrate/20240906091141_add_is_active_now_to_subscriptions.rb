class AddIsActiveNowToSubscriptions < ActiveRecord::Migration[7.2]
  def change
    add_column :subscriptions, :is_active_now, :boolean, default: false, null: false
  end
end
