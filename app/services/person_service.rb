module PersonService
  SERVICE_URL = "https://services.odata.org/V4/(S(gmx1uq2bp0xpimyk404pusya))/OData/OData.svc/Persons"

  class List
    def self.call
      new.call
    end

    def call
      response = Typhoeus.get(SERVICE_URL)

      JSON.parse(response.body)["value"].map do |person_hash|
        Person.new_from_hash(person_hash)
      end
    end
  end

  class Fetch
    attr_reader :person_id

    def initialize(person_id:)
      @person_id = person_id
    end

    def self.call(**args)
      new(args).call
    end

    def call
      response = Typhoeus.get(SERVICE_URL + "(#{person_id})")
      Person.new_from_hash(JSON.parse(response.body))
    end
  end

  class Update
    attr_reader :person_id, :person_name

    def initialize(person_id:, person_name:)
      @person_id = person_id
      @person_name = person_name
    end

    def self.call(**args)
      new(args).call
    end

    def call
      body = {
        "@odata.type" => "ODataDemo.Person",
        "Name" => person_name
      }.to_json

      request = Typhoeus::Request.new(
        SERVICE_URL + "(#{person_id})",
        method: :patch,
        body: body,
        headers: {
          Accept: "application/json",
          "Content-Type" => "application/json;odata.metadata=minimal"
        }
      )
      request.run
    end
  end

  class Create
    attr_reader :person_name

    def initialize(person_name:)
      @person_name = person_name
    end

    def self.call(**args)
      new(args).call
    end

    def call
      body = {
        "@odata.type" => "ODataDemo.Person",
        "Name" => person_name,
        "ID" => Count.call
      }.to_json

      request = Typhoeus::Request.new(
        SERVICE_URL,
        method: :post,
        body: body,
        headers: {
          Accept: "application/json",
          "Content-Type" => "application/json;odata.metadata=minimal"
        }
      )
      request.run
    end
  end

  class Delete
    attr_reader :person_id

    def initialize(person_id:)
      @person_id = person_id
    end

    def self.call(**args)
      new(args).call
    end

    def call
      request = Typhoeus::Request.new(
        "#{SERVICE_URL}(#{person_id})",
        method: :delete
      )
      request.run
    end
  end

  class Count
    def self.call
      new.call
    end

    def call
      response = Typhoeus.get("#{SERVICE_URL}?$count=true")
      JSON.parse(response.body)["@odata.count"]
    end
  end
end
