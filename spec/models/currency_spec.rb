require 'rails_helper'

RSpec.describe Currency, type: :model do
  describe 'associations' do
    it { should have_many(:accounts).with_foreign_key('default_currency_id') }
    it { should have_many(:plans) }
  end
end
