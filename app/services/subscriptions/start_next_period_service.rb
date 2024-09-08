class Subscriptions::StartNextPeriodService
  def initialize(subscription)
    @subscription = subscription
  end

  def call
    @subscription_version = @subscription.current_version

    if @subscription.is_active_now? && current_period_expired?
      terminate_service = Subscriptions::TerminateService.new(@subscription)
      if terminate_service.can_be_terminated?
        terminate_service.call
      else
        new_start, new_end = calc_new_period

        if is_terminated_in_new_period?(new_end)
          new_end = @subscription_version.terminate_at
        end

        @subscription_version.current_period_start = new_start
        @subscription_version.current_period_end = new_end
        @subscription_version.save!

        create_event
      end
    end
  end

  protected

  def current_period_expired?
    time = Time.current
    time >= @subscription_version.current_period_end || subscription_is_terminated?
  end

  def subscription_is_terminated?
    time = Time.current
    @subscription_version.terminate_at ? time >= @subscription_version.terminate_at : false
  end

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

  def create_event
    Events::CreateService.new(
      @subscription.layer,
      name: "subscriptions.new_period",
      object: @subscription
    ).call
  end
end
