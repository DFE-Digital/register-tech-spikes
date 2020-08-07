module ContactService
  class Config
    class << self
      def service_url
        ENV["SERVICE_URL"] + "contacts"
      end

      def bearer_token
        AccessTokenService.call
      end

      def auth_headers
        { "Authorization" => "Bearer #{bearer_token}" }
      end

      def headers
        {
          Accept: "application/json",
          "Content-Type" => "application/json;odata.metadata=minimal",
        }.merge(Config.auth_headers)
      end
    end
  end

  class List
    def self.call
      new.call
    end

    def call
      request = Typhoeus::Request.new(
        Config.service_url + "?$top=10&$orderby=createdon%20desc",
        method: :get,
        headers: Config.headers
      )

      response = request.run

      JSON.parse(response.body)["value"].map do |contact_hash|
        Contact.new_from_hash(contact_hash)
      end
    end
  end

  class Fetch
    attr_reader :contact_id

    def initialize(contact_id:)
      @contact_id = contact_id
    end

    def self.call(**args)
      new(args).call
    end

    def call
      request = Typhoeus::Request.new(
        Config.service_url + "(#{contact_id})",
        method: :get,
        headers: Config.headers
      )

      response = request.run
      Contact.new_from_hash(JSON.parse(response.body))
    end
  end

  class Update
    attr_reader :contact_id, :contact_first_name, :contact_last_name

    def initialize(contact_id:, contact_first_name:, contact_last_name:)
      @contact_id = contact_id
      @contact_first_name = contact_first_name
      @contact_last_name = contact_last_name
    end

    def self.call(**args)
      new(args).call
    end

    def call
      body = {
        "firstname" => contact_first_name,
        "lastname" => contact_last_name
      }.to_json

      request = Typhoeus::Request.new(
        Config.service_url + "(#{contact_id})",
        method: :patch,
        body: body,
        headers: Config.headers
      )

      request.run
    end
  end

  class Create
    attr_reader :contact_first_name, :contact_last_name

    def initialize(contact_first_name:, contact_last_name:)
      @contact_first_name = contact_first_name
      @contact_last_name = contact_last_name
    end

    def self.call(**args)
      new(args).call
    end

    def call
      body = {
        "firstname" => contact_first_name,
        "lastname" => contact_last_name,
        "contactid" => SecureRandom.uuid
      }.to_json

      request = Typhoeus::Request.new(
        Config.service_url,
        method: :post,
        body: body,
        headers: Config.headers
      )
      request.run
    end
  end

  class Delete
    attr_reader :contact_id

    def initialize(contact_id:)
      @contact_id = contact_id
    end

    def self.call(**args)
      new(args).call
    end

    def call
      request = Typhoeus::Request.new(
        "#{Config.service_url}(#{contact_id})",
        method: :delete,
        headers: Config.headers
      )
      request.run
    end
  end
end
