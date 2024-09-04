# == Schema Information
#
# Table name: plans
#
#  id                 :uuid             not null, primary key
#  code               :string           not null
#  discarded_at       :datetime
#  interval           :integer          not null
#  interval_count     :integer          not null
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  currency_id        :string(5)        not null
#  current_version_id :uuid             not null
#  layer_id           :uuid             not null
#
# Indexes
#
#  index_plans_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :base_plan, class: 'Plan' do
    layer
    code { 'silver_monthly' }
    name { 'Silver Monthly' }
    currency_id { 'USD' }
    interval { 'month' }
    interval_count { 1 }

    before(:create) do |plan|
      plan.current_version_id = SecureRandom.uuid if plan.plan_versions.empty?
    end

    factory :plan_without_prices, class: 'Plan' do
      after(:create) do |plan|
        if plan.plan_versions.empty?
          create(:plan_version_without_prices, id: plan.current_version_id, plan: plan)
        end
      end
    end

    factory :plan do
      after(:create) do |plan|
        if plan.plan_versions.empty?
          create(:plan_version, id: plan.current_version_id, plan: plan)
        end
      end
    end
  end
end
