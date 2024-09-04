require 'rails_helper'

RSpec.shared_examples 'authenticate' do
  shared_examples 'unauthorized' do
    it 'return unauthorized response' do
      do_request

      expect(response.status).to eq(401)
      expect(body_json['status']).to eq(401)
      expect(body_json['message']).to eq('Unauthorized')
    end
  end

  context 'when unauthorized' do
    let(:headers) { nil }

    it_behaves_like 'unauthorized'
  end

  context 'with invalid token' do
    let(:headers) { auth_with('invalid_token') }

    it_behaves_like 'unauthorized'
  end

  context 'when expired token in future' do
    let(:headers) { auth_with(token.key) }

    before do
      token.update!(expired_at: 10.minutes.from_now)
    end

    it 'have successful response' do
      do_request

      expect(response.status).to eq(success_status)
    end
  end

  context 'when expired token in back' do
    let(:headers) { auth_with(token.key) }

    before do
      token.update!(expired_at: 1.second.ago)
    end

    it_behaves_like 'unauthorized'
  end

  context 'with valid token' do
    let(:headers) { auth_with(token.key) }

    it 'have successful response' do
      do_request

      expect(response.status).to eq(success_status)
    end
  end
end
