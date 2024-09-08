class DeliverEventJob
  include Sidekiq::Job

  def perform(*args)
    event_id = args[0]
    event = Event.find(event_id)

    Events::DeliverService.new(event).call
  end
end
