# == Schema Information
#
# Table name: subscription_versions
#
#  id                   :uuid             not null, primary key
#  cancelation_time     :datetime
#  current_period_end   :datetime         not null
#  current_period_start :datetime         not null
#  quantity             :integer          default(1), not null
#  start_at             :datetime         not null
#  terminate_at         :datetime
#  trial_end            :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  plan_version_id      :uuid             not null
#  subscription_id      :uuid             not null
#
class SubscriptionVersion < ApplicationRecord
  belongs_to :subscription
  belongs_to :plan_version
  has_one :plan, through: :plan_version
  has_many :line_items

  validates :start_at, :current_period_start, :current_period_end, presence: true
end
