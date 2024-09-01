require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { should have_many(:layers) }
    it { should belong_to(:default_currency) }
  end
end
