# == Schema Information
#
# Table name: plan_versions
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :uuid             not null
#
class PlanVersion < ApplicationRecord
  belongs_to :plan
  belongs_to :subscription_version
  has_many :prices
end
