class AccessTokenService
  def self.call
    new.call
  end

  def call
    return token_cache if token_expires_at > Time.now

    fetch_token
  end

  private

  def request_body
    {
      grant_type: "client_credentials",
      client_id: client_id,
      scope: scope,
      client_secret: client_secret
    }
  end

  def client_id
    ENV["CLIENT_ID"]
  end

  def scope
    ENV["RESOURCE_URL"] + "/.default"
  end

  def client_secret
    ENV["CLIENT_SECRET"]
  end

  def tenant_id
    ENV["TENANT_ID"]
  end

  def token_cache
    @@token_cache ||= fetch_token
  end

  def token_expires_at
    @@token_expiry ||= 1.minute.ago
  end

  def fetch_token
    url = "https://login.microsoftonline.com/#{tenant_id}/oauth2/v2.0/token"

    request = Typhoeus::Request.new(
      url,
      method: :post,
      body: request_body,
      headers: {
        Accept: "application/json",
        "Content-Type" => "application/x-www-form-urlencoded"
      }
    )
    response = request.run
    parsed_response = JSON.parse(response.body)
    # the expiry is returned in the response but expire in 45 minutes for now
    # parsed_response["expires_in"]
    @@token_expiry = 45.minutes.from_now
    @@token_cache = parsed_response["access_token"]
  end
end
