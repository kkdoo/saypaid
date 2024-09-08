class Invoices::CreateService < BaseService
  def initialize(subscription, finalize:)
    @layer = subscription.layer
    @subscription = subscription
    @finalize = finalize
  end

  def call
    @subscription_version = @subscription.current_version
    @plan = @subscription_version.plan
    @invoice = @layer.invoices.build(
      customer_id: @subscription.customer_id,
      currency_id: @plan.currency_id,
      total: @subscription.amount,
      due_date: Time.current + Invoice::MAX_DUE_LENGTH,
    )
    @invoice.line_items.build(
      subscription_version_id: @subscription_version.id,
      amount: @subscription.amount,
    )
    if finalize_invoice?
      @invoice.status = Invoice.statuses[:open]
    end
    @invoice.save!

    Events::CreateService.new(@invoice.layer, name: "customers.create", object: @invoice).call

    @invoice
  end

  protected

  def finalize_invoice?
    @finalize && can_be_finalized?
  end

  def can_be_finalized?
    @invoice.draft?
  end
end
