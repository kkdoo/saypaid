require 'rails_helper'

RSpec.describe Subscriptions::CreateService do
  let(:layer) { create(:layer) }
  let(:plan) { create(:plan, layer:) }
  let(:customer) { create(:customer, layer:) }

  before do
    travel_to Time.current
  end

  shared_examples 'create subscription' do
    let(:params) do
      { customer_id: customer.id, plan_code: plan.code, start_at: time, pay_in_advance: true, trial_in_days: }
    end
    let(:service) { described_class.new(layer, strong_params(params)) }

    it 'create subscription' do
      expect do
        service.call
      end.to change { Subscription.count }.by(1)

      sub = Subscription.last
      expect(sub.layer).to eq(layer)
      expect(sub.customer).to eq(customer)
      expect(sub.status).to eq(expected_status)
      expect(sub.current_version.plan).to eq(plan)
      expect(sub.current_version.trial_end).to eq(trial_end)
      expect(sub.current_version.current_period_start).to_not be_nil
      expect(sub.current_version.current_period_end).to be > sub.current_version.current_period_start
    end
  end

  context 'errors' do
    let(:service) { described_class.new(layer, strong_params(params)) }
    let(:time) { Time.current }
    let(:trial_in_days) { nil }

    context 'when customer not found' do
      let(:another_customer) { create(:customer) }
      let(:params) do
        { customer_id: another_customer.id, plan_code: plan.code, start_at: time, pay_in_advance: true, trial_in_days: }
      end

      it 'raise CustomerNotFoundError' do
        expect(Subscription.count).to eq(0)

        expect do
          service.call
        end.to raise_error(described_class::CustomerNotFoundError)

        expect(Subscription.count).to eq(0)
      end
    end

    context 'when plan not found' do
      let(:another_plan) { create(:plan_without_prices) }
      let(:params) do
        { customer_id: customer.id, plan_code: another_plan.code, start_at: time, pay_in_advance: true, trial_in_days: }
      end

      it 'raise PlanNotFoundError' do
        expect(Subscription.count).to eq(0)

        expect do
          service.call
        end.to raise_error(described_class::PlanNotFoundError)

        expect(Subscription.count).to eq(0)
      end
    end

    context 'when plan do not have any prices' do
      let(:plan) { create(:plan_without_prices, layer:) }
      let(:params) do
        { customer_id: customer.id, plan_code: plan.code, start_at: time, pay_in_advance: true, trial_in_days: }
      end

      it 'raise AtLeastOnePriceRequired' do
        expect(Subscription.count).to eq(0)

        expect do
          service.call
        end.to raise_error(described_class::AtLeastOnePriceRequired)

        expect(Subscription.count).to eq(0)
      end
    end
  end

  context 'without trial period' do
    let(:trial_in_days) { nil }
    let(:trial_end) { nil }

    context 'when have to be charged' do
      context 'with current time' do
        let(:time) { Time.current }
        let(:expected_status) { 'pending' }

        before do
          expect_any_instance_of(Subscription).to receive(:process_pending)
        end

        include_examples 'create subscription'
      end

      context 'in past' do
        let(:time) { 1.day.ago }
        let(:expected_status) { 'pending' }

        before do
          expect_any_instance_of(Subscription).to receive(:process_pending)
        end

        include_examples 'create subscription'
      end

      context 'in future' do
        let(:time) { 1.day.from_now }
        let(:expected_status) { 'created' }

        include_examples 'create subscription'
      end
    end

    context 'without charge amount' do
      before do
        allow_any_instance_of(Subscription).to receive(:charge_amount).and_return(0)
      end

      context 'with current time' do
        let(:time) { Time.current }
        let(:expected_status) { 'active' }

        include_examples 'create subscription'
      end

      context 'in past' do
        let(:time) { 1.day.ago }
        let(:expected_status) { 'active' }

        include_examples 'create subscription'
      end

      context 'in future' do
        let(:time) { 1.day.from_now }
        let(:expected_status) { 'created' }

        include_examples 'create subscription'
      end
    end
  end

  context 'with trial period' do
    let(:trial_in_days) { 5 }
    let(:trial_end) { time + 5.days }

    context 'with current time' do
      let(:time) { Time.current }
      let(:expected_status) { 'trial' }

      include_examples 'create subscription'
    end

    context 'in past' do
      let(:time) { 1.day.ago }
      let(:expected_status) { 'trial' }

      include_examples 'create subscription'
    end

    context 'in future' do
      let(:time) { 1.day.from_now }
      let(:expected_status) { 'created' }

      include_examples 'create subscription'
    end
  end
end
