class Customers::CreateService < BaseService
  def initialize(layer, params)
    @layer = layer
    @params = params
  end

  def call
    @layer.customers.create!(customer_params)
  end

  protected

  def customer_params
    @params.permit(
      :email, :name,
    )
  end
end
