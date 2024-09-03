module RequestsHelpers
  def encoded_credentials_for(user, password)
    ActionController::HttpAuthentication::Basic.encode_credentials(
      user,
      password,
    )
  end

  def auth_with(token)
    { accept: 'application/json', authorization: encoded_credentials_for(token, nil) }
  end

  def body_json
    return @body if @body
    raw_body = MultiJson.load(response.body)
    if raw_body.is_a?(Array)
      @body = raw_body.map do |o|
        o.with_indifferent_access
      end
    else
      @body = HashWithIndifferentAccess.new(raw_body)
    end
    @body
  end
end

RSpec.configure do |config|
  config.include RequestsHelpers, type: :request
end
