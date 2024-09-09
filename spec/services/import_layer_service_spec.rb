require 'rails_helper'

RSpec.describe ImportLayerService do
  let(:account) { create(:account) }
  let(:filename) { Rails.root.join("spec/files/layers.yml") }
  let(:file) { File.open(filename) }
  let(:service) { described_class.new(account, file) }

  context '#call' do
    it 'will import plans & pricing tables' do
      result = service.call

      layer = result.first
      aggregate_failures do
        expect(result.count).to eq(1)
        expect(account.layers.count).to eq(1)
        expect(layer.plans.count).to eq(5)
        expect(layer.pricing_tables.count).to eq(2)
      end
    end
  end
end
