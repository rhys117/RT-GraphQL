module Types
  class AuthProviderUserInput < BaseInputObject
    graphql_name "AUTH_PROVIDER_USER"

    argument :username, String, required: true
    argument :password, String, required: true
  end
end