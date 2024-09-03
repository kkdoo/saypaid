FactoryBot.define do
  factory :plan_version do
    plan

    after(:create) do |plan_version|
      create(:flat_price, plan_version:)
    end
  end
end
