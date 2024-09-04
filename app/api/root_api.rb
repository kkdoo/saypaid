class RootApi < Grape::API
  Grape::Middleware::Auth::Strategies.add(:auth_token, ::Middleware::AuthTokenMiddleware)

  auth :auth_token

  helpers do
    def current_token
      @current_token ||= env['current_token']
    end

    def current_layer
      @current_layer ||= current_token.layer
    end

    def permitted_params
      @permitted_params ||= ActionController::Parameters.new(declared_params)
    end

    def declared_params
      declared(params, include_missing: false)
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ status: 404, message: "Resource not found" }, 404)
  end

  rescue_from ActiveRecord::RecordInvalid do |error|
    pp error
    puts error.backtrace.join("\n\t")
    message = error.record.errors.full_messages.join(", ")
    error!({ status: 400, message: }, 400)
  end

  mount V1::CustomersApi => '/'
  mount V1::SubscriptionsApi => '/'
end
