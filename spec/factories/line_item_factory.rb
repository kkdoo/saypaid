# == Schema Information
#
# Table name: line_items
#
#  id                      :uuid             not null, primary key
#  amount                  :decimal(20, 5)   not null
#  discarded_at            :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  invoice_id              :uuid             not null
#  subscription_version_id :uuid             not null
#
# Indexes
#
#  index_line_items_on_discarded_at  (discarded_at)
#
FactoryBot.define do
  factory :line_item do
    invoice
    subscription_version
    amount { 10 }
  end
end
