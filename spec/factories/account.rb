FactoryBot.define do
  factory :account do
    default_currency { Currency.find('USD') }
  end
end
