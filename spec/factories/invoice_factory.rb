# == Schema Information
#
# Table name: invoices
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  due_date     :datetime         not null
#  status       :integer          default("draft"), not null
#  total        :decimal(20, 5)   not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  currency_id  :string(5)        not null
#  customer_id  :uuid             not null
#  layer_id     :uuid             not null
#
# Indexes
#
#  index_invoices_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :invoice do
    layer
    customer
    currency { Currency.find('USD') }
    status { 'draft' }
    due_date { Time.current + 3.days }
    total { 10 }

    trait :draft do
      status { 'draft' }
    end

    trait :open do
      status { 'open' }
    end
  end
end
