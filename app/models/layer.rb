# == Schema Information
#
# Table name: layers
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  livemode     :boolean          default(FALSE), not null
#  status       :string           default("draft"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :uuid             not null
#
# Indexes
#
#  index_layers_on_discarded_at  (discarded_at)
#
class Layer < ApplicationRecord
  include Discard::Model

  belongs_to :account
  has_many :plans
  has_many :customers
  has_many :subscriptions
end
