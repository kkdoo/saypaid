# == Schema Information
#
# Table name: plan_versions
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :uuid             not null
#
FactoryBot.define do
  factory :plan_version do
    plan

    after(:create) do |plan_version|
      create(:flat_price, plan_version:)
    end
  end
end
