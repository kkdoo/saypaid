# == Schema Information
#
# Table name: subscription_versions
#
#  id                   :uuid             not null, primary key
#  cancelation_time     :datetime
#  current_period_end   :datetime         not null
#  current_period_start :datetime         not null
#  quantity             :integer          default(1), not null
#  start_at             :datetime         not null
#  terminate_at         :datetime
#  trial_end            :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  plan_version_id      :uuid             not null
#  prev_id              :uuid
#  subscription_id      :uuid             not null
#
require 'rails_helper'

RSpec.describe SubscriptionVersion, type: :model do
  describe 'associations' do
    it { should belong_to(:subscription) }
    it { should belong_to(:plan_version) }
    it { should have_one(:plan).through(:plan_version) }
    it { should have_many(:line_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:current_period_start) }
    it { should validate_presence_of(:current_period_end) }
  end
end
