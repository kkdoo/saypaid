require 'rails_helper'

RSpec.describe WebhookEvents::DeliverEventService do
  let(:layer) { create(:layer) }
  let(:event) { create(:event, layer:) }
  let(:webhook_event) { create(:webhook_event, webhook_endpoint:, event:) }
  let(:service) { described_class.new(webhook_event) }

  context '#call' do
    context 'when cannot be delivered' do
      shared_examples 'have skipped status' do
        it 'ignore request sending & mark webhook event as skipped' do
          expect(service).to_not receive(:do_request)

          service.call

          expect(webhook_event.status).to eq('skipped')
        end
      end

      context 'when endpoint is disabled' do
        let(:webhook_endpoint) { create(:webhook_endpoint, layer:, status: 'disabled') }

        it_behaves_like 'have skipped status'
      end

      context 'when endpoint is unaccessible' do
        let(:webhook_endpoint) { create(:webhook_endpoint, layer:, status: 'unaccessible') }

        it_behaves_like 'have skipped status'
      end

      context 'when endpoint is enabled' do
        let(:webhook_endpoint) { create(:webhook_endpoint, layer:) }

        shared_examples 'webhook event status is' do |status|
          let(:webhook_event) do
            create(:webhook_event, webhook_endpoint:, event:, status:)
          end

          it_behaves_like 'have skipped status'
        end

        it_behaves_like 'webhook event status is', 'sending'
        it_behaves_like 'webhook event status is', 'accepted'
      end
    end

    context 'when endpoint is enabled' do
      let(:webhook_endpoint) { create(:webhook_endpoint, layer:) }

      context 'when do request' do
        context 'and response was success' do
          it "ignore request sending & mark webhook event as accepted" do
            expect(webhook_event).to receive(:sending!).and_call_original
            stub_request(:post, "https://example.com/callback").
              to_return(status: 200, body: "", headers: {})

            service.call

            expect(webhook_event.status).to eq('accepted')
          end
        end

        context 'when raise error inside service' do
          it "mark webhook event as failed" do
            expect(webhook_event).to receive(:sending!).and_call_original
            expect(service).to receive(:do_request).and_raise(StandardError)

            expect {
              service.call
            }.to raise_error(StandardError)

            expect(webhook_event.status).to eq('failed')
          end
        end

        context 'raise RequestWasDeclined error when request was incomplete' do
          shared_examples 'have declined status' do
            it "ignore request sending & mark webhook event as declined" do
              expect(webhook_event).to receive(:sending!).and_call_original
              stub_request(:post, "https://example.com/callback").
                to_return(status: response_code, body: "", headers: {})

              expect {
                service.call
              }.to raise_error(described_class::RequestWasDeclined)

              expect(webhook_event.status).to eq('declined')
            end
          end

          context 'and response was not found' do
            let(:response_code) { 404 }

            it_behaves_like 'have declined status'
          end

          context 'and response was internal error' do
            let(:response_code) { 500 }

            it_behaves_like 'have declined status'
          end

          context 'and response was redirect' do
            let(:response_code) { 301 }

            it_behaves_like 'have declined status'
          end
        end
      end
    end
  end
end
