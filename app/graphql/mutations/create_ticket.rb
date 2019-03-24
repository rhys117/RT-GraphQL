module Mutations
  class CreateTicket < BaseMutation
    description "Create new ticket"

    argument :subject, String, required: true
    argument :initial_comment, String, required: false
    argument :queue_name, String, required: true
    argument :owner, String, required: false
    
    # return type from the mutation
    type Types::TicketType

    def resolve(subject: nil, initial_comment: nil, queue_name:,  owner_name: 'Nobody')
      RT::Ticket.rest_create(subject: subject, queue_name: queue_name, initial_comment: initial_comment, owner_name: owner)
    end
  end
end
