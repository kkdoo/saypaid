# == Schema Information
#
# Table name: currencies
#
#  id         :string(5)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Currency, type: :model do
  describe 'associations' do
    it do
      should have_many(:accounts).with_foreign_key('default_currency_id').
        inverse_of(:default_currency)
    end
    it { should have_many(:plans) }
    it { should have_many(:invoices) }
  end

  describe 'db' do
    it do
      should have_db_column(:id).of_type(:string).
        with_options(primary: true, limit: 5)
    end
  end
end
