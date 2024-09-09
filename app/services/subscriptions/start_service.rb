class Subscriptions::StartService
  def initialize(subscription)
    @subscription = subscription
  end

  def call
    @current_version = @subscription.current_version

    return false unless can_be_started?

    @subscription.update!(
      status: new_subscription_status,
      is_active_now: true,
    )

    create_event

    if @subscription.pending?
      Invoices::CreateService.new(@subscription, finalize: true).call
    end

    @subscription
  end

  protected

  def can_be_started?
    !@subscription.is_active_now && @subscription.created? && time_to_start?
  end

  def time_to_start?
    time = Time.current
    @current_version.start_at <= time && time < @current_version.current_period_end
  end

  def time_to_trial?
    time = Time.current
    @current_version.trial_end && time < @current_version.trial_end
  end

  def new_subscription_status
    if time_to_trial?
      Subscription.statuses[:trial]
    elsif @subscription.required_charge?
      Subscription.statuses[:pending]
    else
      Subscription.statuses[:active]
    end
  end

  def create_event
    Events::CreateService.new(@subscription.layer, name: "subscriptions.start", object: @subscription).call
  end
end
