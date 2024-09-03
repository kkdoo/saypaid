require 'rails_helper'

RSpec.describe RootApi, type: :request do
  let(:layer) { create(:layer) }

  context 'POST /customers' do
    let(:params) { attributes_for(:customer) }
    let(:do_request) { post "/api/v1/customers", headers:, params: }
    let(:success_status) { 201 }

    include_examples 'authenticate'

    context 'when logged in' do
      let(:headers) { auth_with(layer.id) }

      it 'create customer' do
        expect do
          do_request
        end.to change { layer.customers.count }.by(1)

        expect(response.status).to eq(success_status)
      end
    end
  end
end
