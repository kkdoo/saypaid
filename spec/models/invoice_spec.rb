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
require 'rails_helper'

RSpec.describe Invoice, type: :model do
  context 'associations' do
    it { should belong_to(:layer) }
    it { should belong_to(:customer) }
    it { should belong_to(:currency) }
    it { should have_many(:line_items) }
  end

  context 'validations' do
    it { should define_enum_for(:status).with_values(draft: 0, open: 1, paid_fully: 2, voided: 3) }
    it { should validate_presence_of(:total) }
    it do
      should validate_numericality_of(:total).
        is_greater_than_or_equal_to(0.00000).
        is_less_than_or_equal_to(999_999_999_999_999)
    end
    it { should validate_presence_of(:due_date) }
  end

  let(:factory_name) { :invoice }
  it_behaves_like 'discarded'
end
