class Customers::CreateService < BaseService
  def initialize(layer, params)
    @layer = layer
    @params = params
  end

  def call
    @customer = @layer.customers.create!(customer_params)
    Events::CreateService.new(@customer.layer, name: "customers.create", object: @customer).call
    @customer
  end

  protected

  def customer_params
    @params.permit(
      :email, :name,
    )
  end
end
