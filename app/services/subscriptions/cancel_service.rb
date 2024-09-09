class Subscriptions::CancelService
  def initialize(subscription, cancelation_time, terminate_at: nil)
    @subscription = subscription
    @layer = @subscription.layer
    @cancelation_time = cancelation_time
    @terminate_at = terminate_at
  end

  def call
    if can_be_terminated?
      current_version.update(
        terminate_at: @terminate_at || current_version.current_period_end,
        cancelation_time: @cancelation_time,
      )

      terminate_if_possible
    end
  end

  protected

  def current_version
    @current_version ||= @subscription.current_version
  end

  def can_be_terminated?
    %w[created trial pending active incomplete past_due unpaid].
      include?(@subscription.status)
  end

  def terminate_if_possible
    terminate_service = Subscriptions::TerminateService.new(@subscription)
    if terminate_service.can_be_terminated?
      terminate_service.call
    end
  end
end
