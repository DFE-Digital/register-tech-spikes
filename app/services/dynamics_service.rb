module DynamicsService
  SERVICE_URL = "https://services.odata.org/V4/(S(omnrwvp0k30iwaruh1pknurf))/OData/OData.svc"

  class List
    def self.call
      new.call
    end

    def call
      # have to limit to the first two as Frodata is falling over
      # with the sub classes e.g #ODataDemo.Customer that are returned
      # in the response
      client["Persons"].first(2)
    end

    private

    def client
      client ||= FrOData::Service.new(DynamicsService::SERVICE_URL, name: "ODataDemo")
    end
  end

  class Fetch
    attr_reader :person_id

    def self.call(person_id:)
      new(person_id: person_id).call
    end

    def initialize(person_id:)
      @person_id = person_id
    end

    def call
      client["Persons"][person_id]
    end

    private

    def client
      client ||= FrOData::Service.new(DynamicsService::SERVICE_URL, name: "ODataDemo")
    end
  end

  class Update
    attr_reader :person_id, :person_name

    def self.call(person_id:, person_name:)
      new(person_id: person_id, person_name: person_name).call
    end

    def initialize(person_id:, person_name:)
      @person_id = person_id
      @person_name = person_name
    end

    def call
      person = client["Persons"][person_id]
      person["Name"] = person_name

      client["Persons"] << person
      person
    end

    private

    def client
      client ||= FrOData::Service.new(DynamicsService::SERVICE_URL, name: "ODataDemo")
    end
  end

  class Create
    attr_reader :person_name

    def self.call(person_name:)
      new(person_name: person_name).call
    end

    def initialize(person_name:)
      @person_name = person_name
    end

    def call
      person = client["Persons"].new_entity("Name" => person_name)
      client["Persons"] << person
      person
    end

    private

    def client
      client ||= FrOData::Service.new(DynamicsService::SERVICE_URL, name: "ODataDemo")
    end
  end
end
