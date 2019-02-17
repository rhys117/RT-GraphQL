class Types::LinkType < Types::BaseObject
  field :type, String,              null: false
  field :ticket, Types::TicketType, null: false
end
