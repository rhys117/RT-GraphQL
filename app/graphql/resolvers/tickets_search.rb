require 'search_object/plugin/graphql'

class Resolvers::TicketsSearch
  include SearchObject.module(:graphql)

  description "Returns tickets matching query."

  def self.with_scope(get_scope)
    Class.new(self) do
      scope do
        # This adds support for dynamic and static scopes
        if get_scope.respond_to? :call
          get_scope.call(object, filters, context)
        else
          get_scope
        end
      end
    end
  end

  type types[Types::TicketType]
  scope { RT::Ticket.all }

  option(:status, type: types.String) { |scope, value| scope.where status: value }
  option(:ownerId, type: types.String) { |scope, value| scope.where owner: value }
end