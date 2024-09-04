require 'rails_helper'

RSpec.describe Invoices::CreateService do
  let(:layer) { create(:layer) }
  let(:customer) { create(:customer, layer:) }
  let(:subscription) { create(:subscription, layer:, customer:,) }
  let(:subscription_version) { subscription.current_version }
  let(:plan) { subscription_version.plan }

  before do
    travel_to Time.current
  end

  context '#call' do
    shared_examples 'create invoice' do
      it 'invoice will be created' do
        invoice = nil
        expect do
          invoice = service.call
        end.to change { layer.invoices.count }.by(1)

        expect(invoice).to be_persisted
        expect(invoice.customer_id).to eq(customer.id)
        expect(invoice.status).to eq(expected_status)
        expect(invoice.currency_id).to eq('USD')
        expect(invoice.total).to eq(subscription.amount)
        expect(invoice.due_date).to eq(Time.current + Invoice::MAX_DUE_LENGTH)
      end

      it 'will be created with line_item' do
        invoice = nil
        expect do
          invoice = service.call
        end.to change { LineItem.count }.by(1)

        expect(invoice.line_items.count).to eq(1)

        line_item = invoice.line_items.last
        expect(line_item.subscription_version_id).to eq(subscription_version.id)
        expect(line_item.amount).to eq(subscription.amount)
      end
    end

    context 'when finalized: true' do
      let(:service) { described_class.new(subscription, finalize: true) }
      let(:expected_status) { 'open' }

      include_examples 'create invoice'
    end

    context 'when finalized: false' do
      let(:service) { described_class.new(subscription, finalize: false) }
      let(:expected_status) { 'draft' }

      include_examples 'create invoice'
    end
  end
end
