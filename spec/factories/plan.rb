FactoryBot.define do
  factory :plan do
    layer
    code { 'silver_monthly' }
    name { 'Silver Monthly' }
    currency_id { 'USD' }
    interval { 'month' }
    interval_count { 1 }

    before(:create) do |plan|
      plan.current_version_id = SecureRandom.uuid if plan.plan_versions.empty?
    end

    after(:create) do |plan|
      if plan.plan_versions.empty?
        create(:plan_version, id: plan.current_version_id, plan: plan)
      end
    end
  end
end
