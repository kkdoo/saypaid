class AddPrevSubscritpionVersionIdToSubscriptionVersions < ActiveRecord::Migration[7.2]
  def change
    add_column :subscription_versions, :prev_id, :uuid
  end
end
