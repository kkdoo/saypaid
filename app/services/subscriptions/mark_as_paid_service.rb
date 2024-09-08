class Subscriptions::MarkAsPaidService
  def initialize(subscription, invoice)
    @subscription = subscription
    @invoice = invoice
  end

  def call
    return false unless can_be_active?

    @subscription.update!(
      status: Subscription.statuses[:active],
      is_active_now: true,
    )

    @subscription
  end

  protected

  def can_be_active?
    @subscription.pending? && invoice_paid_fully?
  end

  def invoice_paid_fully?
    @invoice.paid_fully?
  end
end
