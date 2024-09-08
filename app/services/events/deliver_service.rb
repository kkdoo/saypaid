class Events::DeliverService
  def initialize(event)
    @event = event
    @layer = event.layer
  end

  def call
    @layer.webhook_endpoints.enabled.find_each do |webhook_endpoint|
      webhook_event = @event.webhook_events.create!(webhook_endpoint:)
      DeliverEventToWebhookEndpointJob.perform_async(webhook_event.id)
    end
  end
end
