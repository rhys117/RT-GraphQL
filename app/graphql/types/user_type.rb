class Types::UserType < Types::BaseObject
  field :id, ID,                          null: false
  field :name, String,                    null: true
  field :email, String,                   null: true
  field :organisation, String,            null: true
  field :nickname, String,                null: true
  field :real_name, String,               null: true
  field :tickets, [Types::TicketType],    null: true
  field :reminders, [Types::TicketType],  null: true
end
