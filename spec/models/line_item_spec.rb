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
require 'rails_helper'

RSpec.describe LineItem, type: :model do
  context 'associations' do
    it { should belong_to(:invoice) }
    it { should belong_to(:subscription_version) }
  end

  context 'validations' do
    it { should validate_presence_of(:amount) }
    it do
      should validate_numericality_of(:amount).
        is_greater_than_or_equal_to(0.00000).
        is_less_than_or_equal_to(999_999_999_999_999)
    end
  end

  let(:factory_name) { :line_item }
  it_behaves_like 'discarded'
end