# == Schema Information
#
# Table name: webhook_events
#
#  id                  :uuid             not null, primary key
#  status              :integer          default("pending"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  event_id            :uuid             not null
#  webhook_endpoint_id :uuid             not null
#
class WebhookEvent < ApplicationRecord
  belongs_to :event
  belongs_to :webhook_endpoint

  enum :status, { pending: 0, accepted: 1, declined: 2, failed: 3 }

  validates :status, presence: true
end
