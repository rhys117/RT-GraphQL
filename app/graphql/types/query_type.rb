module Types
  class QueryType < Types::BaseObject
    description "The query root of this schema"

    field :ticket, TicketType, null: true do
      description "Find a ticket by ID"
      argument :id, ID, required: true
    end

    def ticket(id:)
      RT::Ticket.find(id)
    end

    field :queue, QueueType, null: false do
      description "Find a queue by ID"
      argument :id, ID, required: true
    end

    def queue(id:)
      RT::Queue.find(id)
    end

    field :queue_by_name, QueueType, null: false do
      description "Find a queue by Name"
      argument :name, String, required: true
    end

    def queue_by_name(name:)
      RT::Queue.find_by_name(name)
    end

    field :user, UserType, null: false do
      description "Find a user by ID"
      argument :id, ID, required: true
    end

    def user(id:)
      RT::User.find(id)
    end

    field :user_by_email, UserType, null: true do
      description "Find a user by email"
      argument :email, String, required: true
    end

    def user_by_email(email:)
      RT::User.find_by_emailaddress(email)
    end
  end
end
