FactoryBot.define do
  factory :layer do
    account
    name { 'Test layer' }
    status { 'active' }
    livemode { false }
  end
end
