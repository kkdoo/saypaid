class Processors::SubscriptionLifetimeService < BaseService
  def initialize(evented_at)
    @evented_at = evented_at
  end

  def call
    Subscription.ready_to_start.find_each do |subscription|
      Subscriptions::ActivateService.new(subscription).call
    end
    Subscription.trial_is_ended.find_each do |subscription|
      Subscriptions::ActivateService.new(subscription).call
    end
    Subscription.terminated_now.find_each do |subscription|
      Subscriptions::TerminateService.new(subscription).call
    end
    Subscription.ready_for_next_period.find_each do |subscription|
      Subscriptions::StartNextPeriodService.new(subscription).call
    end
  end
end
