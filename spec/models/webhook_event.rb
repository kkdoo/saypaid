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

RSpec.describe WebhookEvent, type: :model do
  describe 'associations' do
    it { should belong_to(:event) }
    it { should belong_to(:webhook_event) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(
        pending: 0,
        sending: 1,
        accepted: 2,
        declined: 3,
        failed: 4,
        skipped: 5,
      )
    }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
  end
end
