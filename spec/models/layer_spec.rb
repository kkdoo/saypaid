# == Schema Information
#
# Table name: layers
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  livemode     :boolean          default(FALSE), not null
#  name         :string           not null
#  status       :string           default("draft"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :uuid             not null
#
# Indexes
#
#  index_layers_on_discarded_at  (discarded_at)
#
require 'rails_helper'

RSpec.describe Layer, type: :model do
  describe 'associations' do
    it { should belong_to(:account) }
    it { should have_many(:plans) }
    it { should have_many(:customers) }
    it { should have_many(:subscriptions) }
    it { should have_many(:pricing_tables) }
  end

  describe 'enums' do
    it do
      should define_enum_for(:status).
        with_values(draft: 'draft', active: 'active', disabled: 'disabled').
        backed_by_column_of_type(:string)
    end
  end

  describe 'works with discarded' do
    let(:factory_name) { :layer }
    it_behaves_like 'discarded'
  end
end
