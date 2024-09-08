require 'rails_helper'

RSpec.describe Events::DeliverService do
  let(:layer) { create(:layer) }
  let(:event) { create(:event, layer:) }
  let(:service) { described_class.new(event) }

  context '#call' do
    before(:each) do
      # enabled
      create_list(:webhook_endpoint, 2, layer:,)
      # ignored
      create(:webhook_endpoint)
      create(:webhook_endpoint, layer:, status: 'disabled')
      create(:webhook_endpoint, layer:, status: 'unaccessible')
    end

    it 'create new webhook_event object for each enabled endpoint' do
      expect {
        service.call
      }.to change { event.webhook_events.count }.by(2)
    end

    it 'run deliver job for each webhook endpoint' do
      expect {
        service.call
      }.to change { DeliverEventToWebhookEndpointJob.jobs.count }.by(2)
    end
  end
end
