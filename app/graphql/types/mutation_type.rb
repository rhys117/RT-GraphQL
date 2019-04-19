module Types
  class MutationType < Types::BaseObject
    field :signin_user, mutation: Mutations::SignInUser
    field :create_ticket, mutation: Mutations::CreateTicket
    field :edit_ticket, mutation: Mutations::EditTicket
  end
end
