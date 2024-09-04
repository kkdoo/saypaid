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
class Invoice < ApplicationRecord
  MAX_DUE_LENGTH = 3.days

  include AASM
  include Discarded

  belongs_to :layer
  belongs_to :customer
  belongs_to :currency
  has_many :line_items, dependent: :destroy

  enum :status, { draft: 0, open: 1, paid_fully: 2, voided: 3 }

  validates :total, :due_date, :currency_id, presence: true
  validates :total, numericality: {
    greater_than_or_equal_to: 0.00000,
    less_than_or_equal_to: 999_999_999_999_999,
  }

  after_discard do
    line_items.discard_all! if line_items.count > 0
  end

  aasm column: :status, enum: true, whiny_persistence: true do
    state :draft, initial: true
    state :open, :paid_fully, :voided

    event :finalize do
      transitions from: :draft, to: :open
    end

    event :paid do
      transitions from: :open, to: :paid_fully
    end

    event :void do
      transitions from: [:draft], to: :voided, after: :discard!
      transitions from: [:open], to: :voided
    end
  end
end