class DeliverEventToWebhookEndpointJob
  include Sidekiq::Job

  def perform(*args)
    webhook_event_id = args[0]
    webhook_event = WebhookEvent.find(webhook_event_id)

    WebhookEvents::DeliverEventService.new(webhook_event).call
  end
end
