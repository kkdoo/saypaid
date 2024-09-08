require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'associations' do
    it { should belong_to(:layer) }
    it { should belong_to(:customer) }
    it { should belong_to(:current_version).class_name("SubscriptionVersion").optional }
    it do
      should have_many(:subscription_versions).order(created_at: :desc).
        inverse_of(:subscription)
    end
  end

  describe 'validations' do
    it do
      should define_enum_for(:status).with_values(
        created: 0,
        trial: 1,
        pending: 2,
        active: 3,
        incomplete: 4,
        past_due: 5,
        terminated: 6,
        canceled: 7,
        unpaid: 8,
      ).backed_by_column_of_type(:integer)
    end

    it { should validate_presence_of(:status) }
  end

  describe 'works with discarded' do
    let(:factory_name) { :subscription }
    it_behaves_like 'discarded'
  end
end
