class Types::TicketAttributes < Types::BaseInputObject
  description "Attributes for updating a ticket"

  argument :subject, String, required: false
  argument :status, String, required: false
  argument :owner, String, required: false
  argument :due, String, required: false
  argument :queue_name, String, required: false
end