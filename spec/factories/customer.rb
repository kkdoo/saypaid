FactoryBot.define do
  factory :customer do
    layer
    name { 'Bob Marley' }
    email { 'bob@example.com' }
  end
end
