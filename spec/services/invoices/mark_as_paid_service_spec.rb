require 'rails_helper'

RSpec.describe Invoices::MarkAsPaidService do
  let(:layer) { create(:layer) }
  let(:invoice) { create(:invoice, layer:) }
  let(:subscription) { create(:subscription, layer:) }
  let(:gold_subscription) { create(:subscription, layer:) }
  let(:service) { described_class.new(invoice) }

  before do
    travel_to Time.current

    invoice.line_items << build(:line_item, subscription_version: subscription.current_version)
    invoice.line_items << build(:line_item, subscription_version: gold_subscription.current_version)
  end

  context '#call' do
    shared_examples 'skipped with' do |status|
      it "skipped when #{status}" do
        expect(invoice.status).to eq(status)

        expect {
          expect(service.call).to eq(false)
        }.to_not change { invoice.status }
      end
    end

    context 'when draft' do
      let(:invoice) { create(:invoice, status: :draft) }

      it_behaves_like 'skipped with', 'draft'
    end

    context 'when open' do
      let(:invoice) { create(:invoice, status: :open) }

      it "mark invoice as paid_fully" do
        expect {
          expect(service.call).to_not eq(false)
        }.to change { invoice.status }.from('open').to('paid_fully')
      end

      context 'when subscriptions mark was succefful' do
        it "invoice will be paid" do
          expect(Subscriptions::MarkAsPaidService).to receive(:new).
            with(kind_of(Subscription), invoice).
            and_return(double(call: true)).
            twice

          expect(service.call).to_not eq(false)
          expect(invoice.reload.status).to eq('paid_fully')
        end
      end

      context "one of mark subscription will be failed" do
        it "invoice status will be reverted" do
          sub_mark_service = double('subscriptions:mark_as_paid_service')
          expect(sub_mark_service).to receive(:call).and_raise(ActiveRecord::Rollback)
          expect(Subscriptions::MarkAsPaidService).to receive(:new).with(kind_of(Subscription), invoice).
            and_return(sub_mark_service)

          expect(service.call).to_not eq(false)
          expect(invoice.reload.status).to_not eq('paid_fully')
        end
      end
    end
  end
end
