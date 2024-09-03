require 'rails_helper'

RSpec.shared_examples 'authenticate' do
  context 'when unauthorized' do
    let(:headers) { nil }

    it 'is unauthorized' do
      do_request

      expect(response.status).to eq(401)
    end
  end

  context 'with invalid token' do
    let(:headers) { auth_with('invalid_token') }

    it 'is unauthorized' do
      do_request

      expect(response.status).to eq(401)
      expect(body_json['status']).to eq(401)
      expect(body_json['message']).to eq('Unauthorized')
    end
  end

  context 'with valid token' do
    let(:headers) { auth_with(layer.id) }

    it 'be successful' do
      do_request

      expect(response.status).to eq(success_status)
    end
  end
end
