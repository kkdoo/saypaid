# == Schema Information
#
# Table name: pricing_card_features
#
#  id              :uuid             not null, primary key
#  discarded_at    :datetime
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pricing_card_id :uuid             not null
#
# Indexes
#
#  index_pricing_card_features_on_discarded_at  (discarded_at)
#
class PricingCardFeature < ApplicationRecord
  include Discard::Model

  belongs_to :pricing_card
end
