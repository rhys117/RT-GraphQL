module RT::REST
  class Ticket
    LOG = Rails.logger

    attr_reader :id

    def initialize(id:, session: RT::REST::Session.new)
      @session = session.client
      @id = id
    end

    def change_owner(new_owner:)
      raise "RT::REST::Ticket.change_owner Invalid username: #{new_owner}" if RT::User.find_by_name(new_owner).nil?

      # return true if already owner
      return true if RT::Ticket.find(@id).owner.name == new_owner

      response = @session.edit(id: @id,
                               owner: "#{new_owner}")
      response.to_s.downcase.include?('200 ok')
    end
  end
end