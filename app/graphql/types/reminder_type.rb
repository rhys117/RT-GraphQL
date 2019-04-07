class Types::ReminderType < Types::BaseObject
  field :effective_id, ID,                                            null: false
  field :type, String,                                                null: false
  field :ticket, Types::TicketType,                                   null: false
  field :subject, String,                                             null: false
  field :status, String,                                              null: false
  field :owner, Types::UserType,                                      null: false
  field :last_updated_by, Types::UserType,                            null: false
  field :creator, Types::UserType,                                    null: false
  field :resolved, GraphQL::Types::ISO8601DateTime,                   null: true
  field :last_updated, GraphQL::Types::ISO8601DateTime,               null: true
  field :due, GraphQL::Types::ISO8601DateTime,                        null: true
  field :priority,  Integer,                                          null: false
end
