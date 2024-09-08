require 'rails_helper'

RSpec.describe DeliverEventToWebhookEndpointJob, type: :job do
  context '#perform_async' do
    let(:layer) { create(:layer) }
    let(:webhook_endpoint) { create(:webhook_endpoint, layer:) }
    let(:event) { create(:event, layer:) }
    let(:webhook_event) { create(:webhook_event, webhook_endpoint:, event:) }
    let(:service) { double(:service) }

    it 'call service' do
      expect(service).to receive(:call)
      expect(WebhookEvents::DeliverEventService).to receive(:new).with(webhook_event).and_return(service)

      described_class.new.perform(webhook_event.id)
    end
  end
end
