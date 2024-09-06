class Invoices::MarkAsPaidService < BaseService
  def initialize(invoice)
    @layer = invoice.layer
    @invoice = invoice
  end

  def call
    if @invoice.may_paid?
      ActiveRecord::Base.transaction do
        @invoice.paid!
        @invoice.subscriptions.each do |subscription|
          subscription.paid!
        end
      end
    end

    @invoice
  end
end
