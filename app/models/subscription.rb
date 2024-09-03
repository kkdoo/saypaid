# == Schema Information
#
# Table name: subscriptions
#
#  id                 :uuid             not null, primary key
#  discarded_at       :datetime
#  pay_in_advance     :boolean          not null
#  status             :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  current_version_id :uuid             not null
#  customer_id        :uuid             not null
#  layer_id           :uuid             not null
#
# Indexes
#
#  index_subscriptions_on_discarded_at  (discarded_at)
#
class Subscription < ApplicationRecord
  include Discard::Model

  belongs_to :layer
  belongs_to :customer
  has_many :subscription_versions, -> { order(created_at: :desc) }
  belongs_to :current_version, class_name: "SubscriptionVersion", optional: true

  enum :status, {
    created: 0,
    trial: 1,
    pending: 2,
    active: 3,
    incomplete: 4,
    past_due: 5,
    terminated: 6,
    canceled: 7,
    unpaid: 8,
  }
end
