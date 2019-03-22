class RT::Reminder < RT::TicketBase
  default_scope { where "effectiveid = id AND type = 'reminder'" }

  # only ever return effective ticket
  def self.find(id)
    entry = RT::Ticket.select(:effectiveid, :type).unscoped.where(id: id).limit(1)&.first
    raise "Ticket #{id} does not exist" if entry.nil?
    raise "#{id} is a ticket. Use RT::Ticket Class" if entry.type == 'ticket'

    super(entry.effectiveid)
  end

  alias_method :belongs_to, :refers_to

  def ticket
    refers_to.first
  end
end