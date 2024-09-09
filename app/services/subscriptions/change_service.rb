class Subscriptions::ChangeService
  def initialize(subscription, new_plan, kind: :at_period_end)
    @subscription = subscription
    @layer = @subscription.layer
    @new_plan = new_plan
  end

  def call
    if expect_plan_change? & not_terminated?
      next_version = @subscription.subscription_versions.create!(
        prev_id: current_version.id,
        quantity: current_version.quantity,
        plan_version_id: @new_plan.current_version_id,
        start_at: current_version.start_at,
        trial_end: current_version.trial_end,
        current_period_start: current_version.current_period_end,
        current_period_end: current_version.current_period_end + @new_plan.interval_length,
      )
    end
  end

  protected

  def expect_plan_change?
    current_version.plan != @new_plan
  end

  def not_terminated?
    current_version.terminate_at.nil?
  end

  def current_version
    @current_version ||= @subscription.current_version
  end
end
