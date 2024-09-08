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

RSpec.describe Event, type: :model do
  describe 'associations' do
    it { should belong_to(:layer) }
    it { should have_many(:webhook_events) }
    it { should have_many(:webhook_endpoints).through(:webhook_events) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, done: 1, failed: 2) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:data) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:object_type) }
  end

  describe 'on create' do
    let(:layer) { create(:layer) }

    it 'deliver to webhook endpoints' do
      expect {
        create(:event, layer:)
      }.to change { DeliverEventJob.jobs.count }.by(1)
    end
  end
end
