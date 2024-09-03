FactoryBot.define do
  factory :flat_price, class: 'Prices::Flat' do
    plan_version
    flat_fee { 10.0 }
  end
end
