# == Schema Information
#
# Table name: accounts
#
#  id                  :uuid             not null, primary key
#  discarded_at        :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  default_currency_id :string(5)        not null
#
# Indexes
#
#  index_accounts_on_discarded_at  (discarded_at)
#
require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { should have_many(:layers) }
    it { should belong_to(:default_currency) }
  end

  describe 'works with discarded' do
    let(:factory_name) { :account }
    it_behaves_like 'discarded'
  end
end
