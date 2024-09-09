require 'rails_helper'

RSpec.describe Subscriptions::CancelService do
  let(:layer) { create(:layer) }
  let(:plan) { create(:plan, layer:) }
  let(:customer) { create(:customer, layer:) }
  let(:cancelation_time) { 2.days.ago }
  let(:terminate_at) { nil }
  let(:subscription_attrs) { attributes_for(:subscription, :active) }
  let(:version_attrs) do
    {
      current_period_start: 30.days.ago,
      current_period_end: 1.day.from_now,
    }
  end
  let(:subscription) do
    create_subscription(
      layer:,
      customer:,
      version: version_attrs,
      attrs: subscription_attrs,
    )
  end
  let(:service) { described_class.new(subscription, cancelation_time, terminate_at:) }
  let(:current_version) { subscription.current_version }

  before do
    freeze_time
  end

  context '#call' do
    context 'when termination not passed' do
      it 'schedule termination time to end of current period' do
        service.call

        aggregate_failures do
          expect(subscription.status).to eq('active')
          expect(current_version.cancelation_time).to eq(cancelation_time)
          expect(current_version.terminate_at).to eq(current_version.current_period_end)
        end
      end
    end

    context 'when termination in future' do
      let(:terminate_at) { 10.days.from_now }

      it 'schedule termination time to end of current period' do
        service.call

        aggregate_failures do
          expect(subscription.status).to eq('active')
          expect(current_version.cancelation_time).to eq(cancelation_time)
          expect(current_version.terminate_at).to eq(terminate_at)
        end
      end
    end

    context 'when termination in back' do
      let(:cancelation_time) { 10.days.ago }
      let(:terminate_at) { 1.second.ago }

      it 'schedule termination time to future' do
        service.call

        aggregate_failures do
          expect(subscription.status).to eq('canceled')
          expect(current_version.cancelation_time).to eq(cancelation_time)
          expect(current_version.terminate_at).to eq(terminate_at)
        end
      end
    end

    context 'when already terminated' do
      let(:subscription_attrs) { attributes_for(:subscription, :terminated) }
      let(:old_terminate_at) { 2.days.ago }
      let(:version_attrs) do
        {
          current_period_start: 30.days.ago,
          current_period_end: 1.day.from_now,
          terminate_at: old_terminate_at,
        }
      end

      it 'skip termination' do
        service.call

        aggregate_failures do
          expect(subscription.status).to eq('terminated')
          expect(current_version.cancelation_time).to eq(nil)
          expect(current_version.terminate_at).to eq(old_terminate_at)
        end
      end
    end

    context 'when already canceled' do
      let(:subscription_attrs) { attributes_for(:subscription, :canceled) }
      let(:old_terminate_at) { 2.days.ago }
      let(:old_cancelation_time) { 3.days.ago }
      let(:version_attrs) do
        {
          current_period_start: 30.days.ago,
          current_period_end: 1.day.from_now,
          terminate_at: old_terminate_at,
          cancelation_time: old_cancelation_time,
        }
      end

      it 'skip termination' do
        service.call

        aggregate_failures do
          expect(subscription.status).to eq('canceled')
          expect(current_version.cancelation_time).to eq(old_cancelation_time)
          expect(current_version.terminate_at).to eq(old_terminate_at)
        end
      end
    end
  end
end
