class RT::Ticket < RT::TicketBase
  default_scope { where "effectiveid = id AND type = 'ticket'" }

  # only ever return effective ticket
  def self.find(id)
    entry = RT::Ticket.select(:effectiveid, :type).unscoped.where(id: id).limit(1)&.first
    raise "#{id} not found" if entry.nil?
    raise "#{id} is a reminder. Use RT::Reminder Class" if entry.type == 'reminder'

    super(entry.effectiveid)
  end
end