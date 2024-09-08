class WebhookEvents::DeliverEventService < BaseService
  class RequestWasDeclined < StandardError; end

  attr_reader :response

  def initialize(webhook_event)
    @webhook_event = webhook_event
    @webhook_endpoint = webhook_event.webhook_endpoint
    @event = webhook_event.event
  end

  def call
    unless can_be_delivered?
      @webhook_event.skipped!
      return
    end

    @webhook_event.sending!

    @response = do_request

    if success_response?
      @webhook_event.accepted!
    else
      @webhook_event.declined!
      raise RequestWasDeclined
    end
  rescue RequestWasDeclined => e
    raise e
  rescue => e
    @webhook_event.failed!
    raise e
  end

  protected

  def can_be_delivered?
    @webhook_endpoint.enabled? && in_valid_status?
  end

  def in_valid_status?
    %w[pending declined failed].include?(@webhook_event.status)
  end

  def success_response?
    response.status >= 200 && response.status < 300
  end

  def do_request
    Excon.post(
      @webhook_endpoint.url,
      body: @event.data,
      headers: { "Content-Type" => "application/json" })
  end
end
