class RootApi < Grape::API
  http_basic do |token|
    # TODO: use api key here, but now we use just account id
    @layer = Layer.find_by(id: token)
    unless @layer
      error!({ status: 401, message: "Unauthorized" }, 401)
    end
    true
  end

  helpers do
    def current_layer
      @layer
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
    message = error.record.errors.full_messages.join(", ")
    error!({ status: 400, message: }, 400)
  end

  mount V1::CustomersApi => '/'
end
