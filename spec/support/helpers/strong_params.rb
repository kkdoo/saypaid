module StrongParamsHelpers
  def strong_params(params)
    ActionController::Parameters.new(params)
  end
end

RSpec.configure do |config|
  config.include StrongParamsHelpers
end
