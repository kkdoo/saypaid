class Subscriptions::CreateService < BaseService
  class CustomerNotFoundError < StandardError; end
  class PlanNotFoundError < StandardError; end
  class AtLeastOnePriceRequired < StandardError; end

  def initialize(layer, params)
    @layer = layer
    @params = params
  end

  def call
    @customer = find_customer
    @plan = find_plan
    raise AtLeastOnePriceRequired if @plan.current_version.prices.count == 0

    Subscription.transaction do
      subscription_version_id = SecureRandom.uuid
      @subscription = @layer.subscriptions.build(subscription_params)
      @subscription.customer = @customer
      @subscription.current_version_id = subscription_version_id
      @subscription.save!
      @subscription_version = @subscription.subscription_versions.build(
        id: subscription_version_id,
        **subscription_version_params,
      )
      @subscription_version.plan_version_id = @plan.current_version_id
      calc_periods
      @subscription_version.save!
    end
    Events::CreateService.new(@subscription.layer, name: "subscriptions.create", object: @subscription).call

    Subscriptions::StartService.new(@subscription).call
    @subscription
  end

  protected

  def find_customer
    @layer.customers.find(@params[:customer_id])
  rescue ActiveRecord::RecordNotFound
    raise CustomerNotFoundError
  end

  def find_plan
    @layer.plans.find_by!(code: @params[:plan_code])
  rescue ActiveRecord::RecordNotFound
    raise PlanNotFoundError
  end

  def subscription_params
    @params.permit(
      :pay_in_advance,
    )
  end

  def subscription_version_params
    @params.permit(
      :start_at,
    )
  end

  def trial_length
    @params[:trial_in_days].to_i.days
  end

  def calc_periods
    if trial_length > 0
      @subscription_version.trial_end = @subscription_version.start_at + trial_length
      @subscription_version.current_period_start = @subscription_version.trial_end
    else
      @subscription_version.current_period_start = @subscription_version.start_at
    end
    @subscription_version.current_period_end = @subscription_version.current_period_start + @plan.interval_length
  end
end
