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
class LineItem < ApplicationRecord
  include Discarded

  belongs_to :invoice
  belongs_to :subscription_version

  validates :amount, presence: true
  validates :amount, numericality: {
    greater_than_or_equal_to: 0.00000,
    less_than_or_equal_to: 999_999_999_999_999,
  }
end
