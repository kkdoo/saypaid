class Middleware::AuthTokenMiddleware < Grape::Middleware::Auth::Base
  def _call(env)
    @env = env
    @current_token = nil
    if decoded_token.presence
      # NOTE: only secret token now allowed
      @current_token = Token.not_expired.secret.find_by(key: decoded_token)
      @current_token.touch(:last_used_at) if @current_token
    end
    return error!({ status: 401, message: "Unauthorized" }, 401) unless @current_token

    env['current_token'] = @current_token
    status, headers, body = app.call(env)

    [status, headers, body]
  end

  protected

  def error!(body, status)
    Rack::Response.new(
      body.to_json,
      status,
      { 'Content-Type' => 'application/json' }
    )
  end

  def auth_param
    @env['HTTP_AUTHORIZATION'].to_s.split(" ", 2).second
  end

  def decode_credentials
    ::Base64.decode64(auth_param || "")
  end

  def decoded_token
    @decoded_token ||= decode_credentials.split(":", 2).first
  end
end
