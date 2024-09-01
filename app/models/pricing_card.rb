# == Schema Information
#
# Table name: pricing_cards
#
#  id               :uuid             not null, primary key
#  discarded_at     :datetime
#  name             :string           not null
#  trial_in_days    :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  plan_id          :uuid             not null
#  pricing_table_id :uuid             not null
#
# Indexes
#
#  index_pricing_cards_on_discarded_at  (discarded_at)
#
class PricingCard < ApplicationRecord
  include Discard::Model

  belongs_to :pricing_table
  has_many :pricing_card_features
  belongs_to :plan
end
