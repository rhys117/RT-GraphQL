require 'search_object/plugin/graphql'

class Resolvers::RemindersSearch
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

  type types[Types::ReminderType]

  scope do
    object.respond_to?(:reminders) ? object.reminders : RT::Reminder.all
  end

  # inline input type definition for the advance filter
  class ReminderFilter < ::Types::BaseInputObject
    argument :OR, [self], required: false
    argument :status, String, required: false
    argument :ownerId, Integer, required: false
  end

  OrderEnum = GraphQL::EnumType.define do
    name 'ReminderOrder'

    value 'PRIORITY'
  end

  # when "filter" is passed "apply_filter" would be called to narrow the scope
  option :filter, type: ReminderFilter, with: :apply_filter
  option :order, type: OrderEnum, default: 'PRIORITY'

  # apply_filter recursively loops through "OR" branches
  # WARNING: .with_scope can be overridden by filters
  def apply_filter(scope, value)
    branches = normalize_filters(value).reduce { |a, b| a.or(b) }
    scope.merge branches
  end

  def normalize_filters(value, branches = [])
    scope = RT::Reminder.all
    scope = scope.where(status: value['status']) if value['status']
    scope = scope.where(owner: value['ownerId']) if value['ownerId']

    branches << scope

    value['OR'].reduce(branches) { |s, v| normalize_filters(v, s) } if value['OR'].present?

    branches
  end

  def apply_order_with_priority(scope)
    scope.order 'priority DESC'
  end
end