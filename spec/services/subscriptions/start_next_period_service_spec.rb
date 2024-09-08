require 'rails_helper'

RSpec.describe Subscriptions::StartNextPeriodService do
  let(:layer) { create(:layer) }
  let(:plan) { subscription.plan }
  let(:customer) { create(:customer, layer:) }
  let(:current_version) { subscription.current_version }
  let(:subscription) { create(:subscription, layer:) }
  let(:service) { described_class.new(subscription) }
  let(:version) { {} }
  let(:subscription_attrs) { attributes_for(:subscription, :active) }
  let(:subscription) do
    create_subscription(
      layer:,
      customer:,
      version:,
      attrs: subscription_attrs,
    )
  end

  before do
    freeze_time
  end

  context '#call' do
    shared_examples 'will not change subscription' do
      it 'will not change current version' do
        expect {
          service.call
        }.to_not change { current_version.attributes }
      end
    end

    context 'when not active' do
      it_behaves_like 'will not change subscription'
    end

    context 'when active' do
      let(:version) {
        {
          current_period_start: 1.month.ago,
          current_period_end: Time.current,
        }
      }

      context 'expired' do
        context 'when not terminated' do
          it 'will be updated to new period' do
            service.call

            aggregate_failures do
              expect(current_version.current_period_start).to eq(Time.current)
              expect(current_version.current_period_end).to eq(1.month.from_now)
            end
          end
        end

        context 'when already terminated' do
          let(:terminate_at) { 5.days.ago }
          let(:subscription_attrs) { attributes_for(:subscription, :terminated) }
          let(:version) {
            {
              current_period_start: 1.month.ago,
              current_period_end: Time.current,
              terminate_at:,
            }
          }

          it 'will be updated to new period' do
            start_at = current_version.current_period_start
            end_at = current_version.current_period_end

            service.call

            aggregate_failures do
              expect(current_version.current_period_start).to eq(start_at)
              expect(current_version.current_period_end).to eq(end_at)
              expect(subscription.status).to eq('terminated')
              expect(subscription.is_active_now).to eq(false)
            end
          end
        end

        context 'when terminated_at in new period' do
          let(:terminate_at) { 5.days.from_now }
          let(:version) {
            {
              current_period_start: 1.month.ago,
              current_period_end: Time.current,
              terminate_at:,
            }
          }

          it 'will be updated to new period' do
            service.call

            aggregate_failures do
              expect(current_version.current_period_start).to eq(Time.current)
              expect(current_version.current_period_end).to eq(terminate_at)
            end
          end
        end
      end

      context 'not expired' do
        let(:version) {
          {
            current_period_start: 30.days.ago,
            current_period_end: 1.day.from_now,
          }
        }

        it_behaves_like 'will not change subscription'
      end
    end
  end
end
