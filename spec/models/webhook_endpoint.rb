# == Schema Information
#
# Table name: events
#
#  id          :uuid             not null, primary key
#  data        :text             not null
#  name        :string           not null
#  object_type :string           not null
#  status      :integer          default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  layer_id    :uuid             not null
#
require 'rails_helper'

RSpec.describe WebhookEndpoint, type: :model do
  describe 'associations' do
    it { should belong_to(:layer) }
    it { should have_many(:webhook_events) }
    it { should have_many(:events).through(:webhook_events) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(enabled: 0, disabled: 1, unaccessible: 2) }
  end

  describe 'validations' do
    it { should validate_presence_of(:url) }
  end

  describe 'works with discarded' do
    let(:factory_name) { :webhook_endpoint }
    it_behaves_like 'discarded'
  end
end
