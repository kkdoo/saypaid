# == Schema Information
#
# Table name: plans
#
#  id                 :uuid             not null, primary key
#  code               :string           not null
#  discarded_at       :datetime
#  interval           :integer          not null
#  interval_count     :integer          not null
#  name               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  currency_id        :string(5)        not null
#  current_version_id :uuid             not null
#  layer_id           :uuid             not null
#
# Indexes
#
#  index_plans_on_discarded_at  (discarded_at)
#
require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'associations' do
    it { should belong_to(:layer) }
    it { should belong_to(:currency) }
    it { should belong_to(:current_version).class_name("PlanVersion").optional }
    it { should have_many(:plan_versions).order(created_at: :desc).inverse_of(:plan) }
    it { should have_many(:pricing_cards) }
    it { should have_many(:prices).through(:current_version) }
  end

  describe 'validations' do
    it do
      should define_enum_for(:interval).with_values(
        day: 0,
        week: 1,
        month: 2,
        year: 3,
      ).backed_by_column_of_type(:integer)
    end

    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:interval) }
    it { should validate_presence_of(:interval_count) }
  end

  describe 'works with discarded' do
    let(:factory_name) { :plan }
    it_behaves_like 'discarded'
  end
end
