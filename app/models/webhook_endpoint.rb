# == Schema Information
#
# Table name: webhook_endpoints
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  status       :integer          default("enabled"), not null
#  url          :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  layer_id     :uuid             not null
#
# Indexes
#
#  index_webhook_endpoints_on_discarded_at  (discarded_at)
#
class WebhookEndpoint < ApplicationRecord
  include Discarded

  belongs_to :layer
  has_many :webhook_events
  has_many :events, through: :webhook_events

  enum :status, { enabled: 0, disabled: 1, unaccessible: 2 }

  validates :url, :status, presence: true
end
