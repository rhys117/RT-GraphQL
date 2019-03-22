class Types::QueueType < Types::BaseObject
  field :id, ID,                        null: false
  field :name, String,                  null: false
  field :description, String,           null: true
  field :tickets, [Types::TicketType],  null: true
end
