class Person
  attr_accessor :name, :id

  def self.new_from_hash(person_hash)
    person = Person.new
    person.name = person_hash["Name"]
    person.id = person_hash["ID"]
    person
  end
end
