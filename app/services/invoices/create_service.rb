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
      @invoice.finalize!
    else
      @invoice.save!
    end
    @invoice
  end

  protected

  def finalize_invoice?
    @finalize && @invoice.may_finalize?
  end
end
