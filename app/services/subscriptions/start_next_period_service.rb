class Subscriptions::StartNextPeriodSubscriptionService
  def initialize(subscription)
    @subscription = subscription
  end

  def call
    @subscription_version = subscription.current_version

    if @subscription_version.current_period_expired?
      if @subscription.may_terminate?
        Subscriptions::TerminateService.new(@subscription).call
      else
        new_start, new_end = calc_new_period

        if is_terminated_in_new_period?(new_end)
          new_end = @subscription_version.terminate_at
        end

        @subscription_version.current_period_start = new_start
        @subscription_version.current_period_end = new_end
        @subscription_version.save!
        # TODO: notify about next period
      end
    end
  end

  protected

  def is_terminated_in_new_period?(end_at)
    return false if @subscription_version.terminate_at.nil?
    @subscription_version.terminate_at <= end_at
  end

  def calc_new_period
    new_start = @subscription_version.current_period_end
    [
      new_start,
      new_start + @subscription_version.plan.interval_length,
    ]
  end
end
