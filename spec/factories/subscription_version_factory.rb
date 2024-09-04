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
FactoryBot.define do
  factory :subscription_version do
    plan_version
    subscription
    current_period_start { Time.current }
    current_period_end { Time.current + 1.month }
    start_at { Time.current }
  end
end
