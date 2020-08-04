module DynamicsService
  SERVICE_URL = "https://services.odata.org/V3/(S(omnrwvp0k30iwaruh1pknurf))/OData/OData.svc"

  class List
    def self.call
      new.call
    end

    def call
      client.Persons
      client.execute
    end

    private

    def client
      client ||= OData::Service.new(SERVICE_URL)
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
      client.Persons(person_id)
      client.execute
    end

    private

    def client
      client ||= OData::Service.new(SERVICE_URL)
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
      client.Persons(person_id)
      person = client.execute
      person.Name = person_name

      client.update_object(person)
      person
    end

    private

    def client
      client ||= OData::Service.new(SERVICE_URL)
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
      person = Person.new
      person.Name = person_name
      client.AddToPersons(person)
      client.save_changes
    end

    private

    def client
      client ||= OData::Service.new(SERVICE_URL)
    end
  end
end
