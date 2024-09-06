class Subscriptions::ActivateService
  def initialize(subscription)
    @subscription = subscription
  end

  def call
    @subscription.activate! if @subscription.may_activate?
  end
end
