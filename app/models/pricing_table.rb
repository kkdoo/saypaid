# == Schema Information
#
# Table name: pricing_tables
#
#  id           :uuid             not null, primary key
#  code         :string           not null
#  discarded_at :datetime
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  layer_id     :uuid             not null
#
# Indexes
#
#  index_pricing_tables_on_discarded_at  (discarded_at)
#
class PricingTable < ApplicationRecord
  include Discard::Model

  belongs_to :layer
  has_many :pricing_cards
end
