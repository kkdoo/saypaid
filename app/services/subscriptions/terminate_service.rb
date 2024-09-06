class Subscriptions::TerminateService
  def initialize(subscription)
    @subscription = subscription
  end

  def call
    @subscription.terminate! if @subscription.may_terminate?
  end
end
