# == Schema Information
#
# Table name: plan_versions
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :uuid             not null
#
require 'rails_helper'

RSpec.describe PlanVersion, type: :model do
  describe 'associations' do
    it { should belong_to(:plan) }
    it do
      should have_many(:subscription_versions).order(created_at: :desc).
        inverse_of(:plan_version)
    end
    it { should have_many(:prices).class_name('Prices::Base') }
  end
end
