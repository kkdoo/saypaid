class V1::CustomersApi < Grape::API
  version "v1", using: :path

  format :json
  prefix :api

  resource :customers do
    params do
      optional :name, type: String
      optional :email, type: String
    end
    post do
      @customer = Customers::CreateService.new(current_layer, permitted_params).call
      present @customer, with: Entities::Customer
    end
  end
end
