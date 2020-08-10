class Contact
  attr_accessor :id,:first_name, :last_name

  def self.new_from_hash(contact_hash)
    contact = Contact.new
    contact.first_name = contact_hash["firstname"]
    contact.last_name = contact_hash["lastname"]
    contact.id = contact_hash["contactid"]
    contact
  end
end
