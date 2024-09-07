class Subscriptions::MarkAsPaidService
  def initialize(subscription)
    @subscription = subscription
  end

  def call
    return false unless can_be_active?

    @subscription.update!(
      status: Subscription.statuses[:active],
      is_active_now: true,
    )

    @subscription
  end

  def can_be_active?
    @subscription.pending? && invoice_paid_fully?
  end

  def invoice_paid_fully?
    # TODO: check invoice for payments
    true
  end
end
