module Types
  class MutationType < Types::BaseObject
    field :signin_user, mutation: Mutations::SignInUser
  end
end
