class Invoices::MarkAsPaidService < BaseService
  def initialize(invoice)
    @layer = invoice.layer
    @invoice = invoice
  end

  def call
    return false unless can_be_paid?

    ActiveRecord::Base.transaction do
      @invoice.paid_fully!
      @invoice.subscription_versions.find_each do |sub_version|
        Subscriptions::MarkAsPaidService.new(sub_version.subscription, @invoice).call
      end
    end

    @invoice
  end

  protected

  def can_be_paid?
    @invoice.open?
  end
end
