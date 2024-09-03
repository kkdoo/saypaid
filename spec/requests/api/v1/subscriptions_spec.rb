require 'rails_helper'

RSpec.describe RootApi, type: :request do
  let(:layer) { create(:layer) }
  let(:customer) { create(:customer, layer:) }
  let(:plan) { create(:plan, layer:) }

  context 'POST /subscriptions' do
    let(:customer_id) { customer.id }
    let(:plan_code) { plan.code }
    let(:params) do
      {
        customer_id: customer_id,
        plan_code: plan_code,
        start_at: Time.now.to_fs,
        pay_in_advance: true,
      }
    end
    let(:do_request) { post "/api/v1/subscriptions", headers:, params: }
    let(:success_status) { 201 }

    include_examples 'authenticate'

    context 'when logged in' do
      let(:headers) { auth_with(layer.id) }

      context 'when success' do
        it 'create customer' do
          expect do
            do_request
          end.to change { layer.subscriptions.count }.by(1)

          expect(response.status).to eq(success_status)
        end
      end

      context 'when failed' do
        context 'due to customer not found' do
          let(:customer_id) { 'wrong_customer_id' }

          it 'return error that customer was not found' do
            expect do
              do_request
            end.to_not change { layer.subscriptions.count }

            expect(response.status).to eq(400)
            expect(body_json['status']).to eq(400)
            expect(body_json['message']).to eq('Customer not found')
          end
        end

        context 'due to plan not found' do
          let(:plan_code) { 'wrong_plan_code' }

          it 'return error that plan was not found' do
            expect do
              do_request
            end.to_not change { layer.subscriptions.count }

            expect(response.status).to eq(400)
            expect(body_json['status']).to eq(400)
            expect(body_json['message']).to eq('Plan not found')
          end
        end

        context 'due to plan do not have any price' do
          before do
            plan.current_version.prices.destroy_all
          end

          it 'return error that plan was not found' do
            expect do
              do_request
            end.to_not change { layer.subscriptions.count }

            expect(response.status).to eq(400)
            expect(body_json['status']).to eq(400)
            expect(body_json['message']).to eq('Plan should have at least one price')
          end
        end
      end
    end
  end
end
