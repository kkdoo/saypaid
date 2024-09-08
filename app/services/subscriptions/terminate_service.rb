class Subscriptions::TerminateService
  def initialize(subscription)
    @subscription = subscription
  end

  def call
    @current_version = @subscription.current_version

    return false unless can_be_terminated?

    @subscription.update!(
      status: new_subscription_status,
      is_active_now: false,
    )

    @subscription
  end

  protected

  def can_be_terminated?
    have_terminateion_time? && in_valid_for_termination_state? && time_to_terminate?
  end

  def in_valid_for_termination_state?
    %w[ created trial pending active incomplete past_due unpaid ].include?(@subscription.status)
  end

  def have_terminateion_time?
    !!@current_version.terminate_at
  end

  def time_to_terminate?
    @current_version.terminate_at <= Time.current
  end

  def is_canceled_by_human?
    @current_version.cancelation_time.present?
  end

  def new_subscription_status
    if is_canceled_by_human?
      Subscription.statuses[:canceled]
    else
      Subscription.statuses[:terminated]
    end
  end
end
