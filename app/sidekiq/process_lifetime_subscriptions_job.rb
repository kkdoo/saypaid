class ProcessLifetimeSubscroptionsJob
  include Sidekiq::Job

  def perform(*args)
    Processors::SubscriptionLifetimeService.new(evented_at: Time.current).call
  end
end
