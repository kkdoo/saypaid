require 'rails_helper'

RSpec.describe Processors::SubscriptionLifetimeService do
  let(:layer) { create(:layer) }
  let(:plan) { create(:plan, layer:) }
  let(:customer) { create(:customer, layer:) }
  let(:service) { described_class.new(Time.current) }

  context '#call' do
    before(:each) do
      freeze_time
      # active subscription will be skipped
      create_subscription(
        layer:,
        customer:,
        version: {
          current_period_start: 30.days.ago,
          current_period_end: 1.day.from_now,
        },
        attrs: attributes_for(:subscription, :active),
      )

      # ready to start
      create_subscription(
        layer:,
        customer:,
        version: {
          current_period_start: Time.current,
          current_period_end: 1.month.from_now,
        },
        attrs: attributes_for(:subscription),
      )

      # trial is ended
      create_subscription(
        layer:,
        customer:,
        version: {
          trial_end: Time.current,
          current_period_start: Time.current,
          current_period_end: 1.month.from_now,
        },
        attrs: attributes_for(:subscription, :trial),
      )

      # terminated now
      create_subscription(
        layer:,
        customer:,
        version: {
          current_period_start: Time.current,
          current_period_end: 1.month.from_now,
          terminate_at: Time.current,
        },
        attrs: attributes_for(:subscription, :trial),
      )

      # ready for next period
      create_subscription(
        layer:,
        customer:,
        version: {
          current_period_start: 1.month.ago,
          current_period_end: Time.current,
        },
        attrs: attributes_for(:subscription, :active),
      )
    end

    it 'process subscriptions lifetime' do
      # one create and one trial
      expect(Subscriptions::StartService).to receive(:new).
        and_return(double(call: true)).
        twice
      # one terminated
      expect(Subscriptions::TerminateService).to receive(:new).
        and_return(double(call: true))
      # and one that ready for next period
      expect(Subscriptions::StartNextPeriodService).to receive(:new).
        and_return(double(call: true))
      service.call
    end
  end
end
