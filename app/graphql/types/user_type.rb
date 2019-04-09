class Types::UserType < Types::BaseObject
  field :id, ID,                                          null: false
  field :name, String,                                    null: true
  field :email, String,                                   null: true
  field :organisation, String,                            null: true
  field :nickname, String,                                null: true
  field :real_name, String,                               null: true
  field :tickets_missing_reminder, [Types::TicketType],   null: true
  field :tickets, function: Resolvers::TicketsSearch
  field :reminders, function: Resolvers::RemindersSearch
end
