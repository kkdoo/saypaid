class V1::SubscriptionsApi < Grape::API
  version "v1", using: :path

  format :json
  prefix :api

  resource :subscriptions do
    params do
      requires :customer_id, type: String
      requires :plan_code, type: String
      requires :start_at, type: String
      requires :pay_in_advance, type: Boolean
    end
    post do
      @subscription = Subscriptions::CreateService.new(current_layer, permitted_params).call
      present @subscription, with: Entities::Subscription
    rescue Subscriptions::CreateService::CustomerNotFoundError
      error!({ status: 400, message: "Customer not found" }, 400)
    rescue Subscriptions::CreateService::PlanNotFoundError
      error!({ status: 400, message: "Plan not found" }, 400)
    rescue Subscriptions::CreateService::AtLeastOnePriceRequired
      error!({ status: 400, message: "Plan should have at least one price" }, 400)
    end
  end
end
