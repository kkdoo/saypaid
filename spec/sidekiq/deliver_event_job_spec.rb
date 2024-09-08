require 'rails_helper'

RSpec.describe DeliverEventJob, type: :job do
  context '#perform_async' do
    let(:event) { create(:event) }
    let(:service) { double(:service) }

    it 'call service' do
      expect(service).to receive(:call)
      expect(Events::DeliverService).to receive(:new).with(event).and_return(service)

      DeliverEventJob.new.perform(event.id)
    end
  end
end
