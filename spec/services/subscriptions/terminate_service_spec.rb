require 'rails_helper'

RSpec.describe Subscriptions::TerminateService do
  let(:layer) { create(:layer) }
  let(:plan) { subscription.plan }
  let(:customer) { create(:customer, layer:) }
  let(:current_version) { subscription.current_version }
  let(:subscription) { create(:subscription, layer:) }
  let(:service) { described_class.new(subscription) }

  before do
    travel_to Time.current
  end

  context '#call' do
    shared_examples 'successfully terminate' do |expected_status|
      it 'successfully terminate subscription' do
        expect {
          expect(service.call).to_not eq(false)
        }.to change { subscription.status }.to(expected_status)

        expect(subscription.is_active_now).to eq(false)
      end
    end

    shared_examples 'skip termination' do
      it 'skip suubscription termination' do
        expect {
          expect(service.call).to eq(false)
        }.to_not change { subscription.attributes }
      end
    end

    context 'when terminate_at is nil' do
      it_behaves_like 'skip termination'
    end

    context 'when terminate_at in future' do
      before(:each) do
        current_version.update(terminate_at: 5.minutes.from_now)
      end

      it_behaves_like 'skip termination'
    end

    shared_examples 'success terminates with status' do |expected_status|
      context 'when terminate_at already come' do
        context 'when is created' do
          before(:each) do
            current_version.update(terminate_at: 1.minute.ago)
          end

          it_behaves_like 'successfully terminate', expected_status
        end

        context 'when pending' do
          let(:subscription) { create(:subscription, :trial, layer:) }

          before do
            current_version.update(terminate_at: 1.minute.ago)
          end

          it_behaves_like 'successfully terminate', expected_status
        end

        context 'when trial' do
          let(:subscription) { create(:subscription, :trial, layer:) }

          before do
            current_version.update(terminate_at: 1.minute.ago)
          end

          it_behaves_like 'successfully terminate', expected_status
        end

        context 'when active' do
          let(:subscription) { create(:subscription, :active, layer:) }

          before do
            current_version.update(terminate_at: 1.minute.ago)
          end

          it_behaves_like 'successfully terminate', expected_status
        end
      end
    end

    context 'when canceled by human' do
      before(:each) do
        current_version.update(cancelation_time: 1.hour.ago)
      end

      it_behaves_like 'success terminates with status', 'canceled'
    end

    context 'when not canceled by user' do
      it_behaves_like 'success terminates with status', 'terminated'
    end
  end
end
