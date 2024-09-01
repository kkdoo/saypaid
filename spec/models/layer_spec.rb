require 'rails_helper'

RSpec.describe Layer, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:plans) }
    it { should have_many(:customers) }
    it { should have_many(:subscriptions) }
    it { should have_many(:pricing_tables) }
  end

  describe 'db' do
    include_examples "have column #discarded_at"
  end

  describe 'enums' do
    it do
      should define_enum_for(:status).
        with_values(draft: 'draft', active: 'active', disabled: 'disabled').
        backed_by_column_of_type(:string)
    end
  end
end
