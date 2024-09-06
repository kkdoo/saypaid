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
  include AASM
  include Discarded

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

  validates :status, presence: true

  scope :is_active, -> { where(is_active_now: true) }
  scope :is_not_active, -> { where(is_active_now: false) }

  scope :ready_to_start, -> {
    is_not_active.created.or(Subscription.trial).
      joins(:current_version).
      where(SubscriptionVersion.arel_table[:start_at].lteq(Time.current))
  }

  scope :trial_is_ended, -> {
    is_active.trial.
      joins(:current_version).
      where(SubscriptionVersion.arel_table[:trial_end].lteq(Time.current))
  }

  scope :terminated_now, -> {
    is_active.active.or(Subscription.is_active.trial).
      joins(:current_version).
      where(SubscriptionVersion.arel_table[:terminate_at].lteq(Time.current))
  }

  scope :ready_for_next_period, -> {
    is_active.
      joins(:current_version).
      where(SubscriptionVersion.arel_table[:current_period_end].lteq(Time.current))
  }

  aasm column: :status, enum: true, whiny_persistence: true do
    state :created, initial: true
    state :trial, :pending, :active, :incomplete, :past_due, :terminated, :canceled, :unpaid

    event :activate, guard: :time_to_start?, success: :notify_event_start do
      transitions from: [:created], to: :trial, guard: :time_to_trial?, after: :on_trial
      transitions from: [:created, :trial], to: :pending, guard: :required_charge?, after: :on_pending
      transitions from: [:created, :trial], to: :active, after: :on_active
    end

    event :paid do
      transitions from: :pending, to: :active, after: :on_active
    end

    event :terminate, guard: :is_terminated_now? do
      transitions from: [:created, :trial, :pending, :active, :incomplete, :past_due, :unpaid],
                  to: :canceled, guard: :is_canceled?, after: :on_canceled
      transitions from: [:created, :trial, :pending, :active, :incomplete, :past_due, :unpaid],
                  to: :terminated, after: :on_terminated
    end
  end

  def time_to_start?
    time = Time.current
    current_version.start_at <= time && time < current_version.current_period_end
  end

  def time_to_trial?
    time = Time.current
    current_version.trial_end && time < current_version.trial_end && time_to_start?
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

  def can_be_terminated?
    %w(created trial pending active incomplete past_due unpaid).include?(status.to_s)
  end

  def is_canceled?
    current_version.cancelation_time.present?
  end

  def is_terminated_now?
    return false if current_version.terminate_at.nil?
    current_version.terminate_at <= Time.current
  end

  def current_period_expired?
    time = Time.current
    time >= current_version.current_period_end ||
      (current_version.terminate_at ? time >= current_version.terminate_at : false)
  end

  def on_trial
    self.is_active_now = true
  end

  def on_pending
    self.is_active_now = true
    Invoices::CreateService.new(self, finalize: true).call
  end

  def on_active
    self.is_active_now = true
  end

  def on_terminated
    self.is_active_now = false
  end
  alias_method :on_canceled, :on_terminated

  def notify_event_start
    # TODO: notify subscription.start
  end

  def notify_event_next_period
    # TODO: notify subscription.next_period
  end

  def create_event_on_change
    # TODO: notify subscription.updated
  end
end
