# == Schema Information
#
# Table name: subscriptions
#
#  id                 :uuid             not null, primary key
#  discarded_at       :datetime
#  is_active_now      :boolean          default(FALSE), not null
#  pay_in_advance     :boolean          not null
#  status             :integer          default("created"), not null
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
  include Discarded

  belongs_to :layer
  belongs_to :customer
  has_many :subscription_versions, -> { order(created_at: :desc) }, inverse_of: :subscription
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

  validates :status, presence: true

  scope :is_active, -> { where(is_active_now: true) }
  scope :is_not_active, -> { where(is_active_now: false) }

  scope :ready_to_start, -> {
    is_not_active.created.
      joins(:current_version).
      where(SubscriptionVersion.arel_table[:start_at].lteq(Time.current))
  }

  scope :trial_is_ended, -> {
    is_active.trial.
      joins(:current_version).
      where(SubscriptionVersion.arel_table[:trial_end].lteq(Time.current))
  }

  scope :terminated_now, -> {
    is_active.
      joins(:current_version).
      where(SubscriptionVersion.arel_table[:terminate_at].lteq(Time.current))
  }

  scope :ready_for_next_period, -> {
    is_active.
      joins(:current_version).
      where(SubscriptionVersion.arel_table[:current_period_end].lteq(Time.current))
  }

  def object_type
    "subscription"
  end

  def required_charge?
    pay_in_advance && charge_amount > 0
  end

  # TODO: calc charge amount
  def charge_amount
    amount
  end

  def amount
    return @amount if @amount

    @amount = 0
    current_version.plan_version.prices.each do |price|
      @amount += price.flat_fee
    end
    @amount
  end
end
