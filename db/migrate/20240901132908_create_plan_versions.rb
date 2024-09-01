class CreatePlanVersions < ActiveRecord::Migration[7.2]
  def change
    create_table :plan_versions, id: :uuid do |t|
      t.uuid :plan_id, null: false
      t.timestamps
    end
  end
end
