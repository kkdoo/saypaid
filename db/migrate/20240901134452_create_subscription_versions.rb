class CreateSubscriptionVersions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscription_versions, id: :uuid do |t|
      t.uuid :subscription_id, null: false
      t.uuid :plan_version_id, null: false
      t.datetime :current_period_start, null: false
      t.datetime :current_period_end, null: false
      t.datetime :cancelation_time
      t.datetime :terminate_at
      t.datetime :start_at, null: false
      t.datetime :trial_end
      t.integer :quantity, null: false, default: 1
      t.timestamps
    end
  end
end
