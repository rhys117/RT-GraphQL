module Mutations
  class EditTicket < BaseMutation
    description "Edit a ticket"

    argument :effectiveId, ID, required: true
    argument :attributes, Types::TicketAttributes, required: false
    argument :custom_fields, Types::CustomFieldAttributes, required: false

    # return type from the mutation
    type Types::TicketType

    def resolve(effective_id:, attributes: {}, custom_fields: {})
      attributes_hash = attributes.to_h
      custom_fields_hash = {}
      unless custom_fields.empty?
        custom_fields.names.each_with_index { |name, index| custom_fields_hash[name] = custom_fields.values[index] }
      end

      rest_ticket = RT::REST::Ticket.new(id: effective_id)
      rest_ticket.edit(attributes: attributes_hash, custom_fields: custom_fields_hash)

      RT::Ticket.find(effective_id).reload
    end
  end
end
