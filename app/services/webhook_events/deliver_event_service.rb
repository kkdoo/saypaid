class WebhookEndpoints::DeliverEventService < BaseService
  attr_reader :response

  def initialize(webhook_event)
    @webhook_event = webhook_event
    @webhook_endpoint = webhook_event.webhook_endpoint
    @event = webhook_event.event
  end

  def call
    @webhook_event.skipped! unless can_be_delivered?

    @webhook_event.sending!

    do_request

    if success_response?
      @webhook_event.accepted!
    else
      @webhook_event.declined!
      DeliverEventToWebhookEndpointJob.perform_async(@webhook_event.id)
    end
  rescue
    @webhook_event.failed!
  end

  protected

  def success_response?
    response.status >= 200 && response < 300
  end

  def can_be_delivered?
    @webhook_endpoint.enabled? && in_valid_status?
  end

  def in_valid_status?
    %w[pending declined failed].include?(@webhook_event.status)
  end

  def do_request
    @response ||= Excon.post(
      @webhook_endpoint.url,
      body: @event.data,
      headers: { "Content-Type" => "application/json" })
  end
end
