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
class Plan < ApplicationRecord
  include Discard::Model

  belongs_to :layer
  belongs_to :currency
  has_many :plan_versions, -> { order(created_at: :desc) }
  belongs_to :current_version, class_name: "PlanVersion", optional: true
  has_many :pricing_cards
end
