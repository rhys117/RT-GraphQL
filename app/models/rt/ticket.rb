class RT::Ticket < RT::TicketBase
  default_scope { where "tickets.effectiveid = tickets.id AND tickets.type = 'ticket'" }

  # only ever return effective ticket
  def self.find(id)
    entry = RT::Ticket.select(:effectiveid, :type).unscoped.where(id: id).limit(1)&.first
    raise "Ticket #{id} does not exist" if entry.nil?
    raise "#{id} is a reminder. Use RT::Reminder Class" if entry.type == 'reminder'

    super(entry.effectiveid)
  end

  def refers_to
    links_query(type: 'RefersTo')
  end

  def referred_to_by
    links_query(type: 'ReferredToBy')
  end

  def depends_on
    links_query(type: 'DependsOn')
  end

  def depended_on_by
    links_query(type: 'DependedOnBy')
  end

  def parents
    RT::Ticket.joins("JOIN links ON tickets.id = links.localbase OR tickets.id = links.localtarget")
        .where("links.localbase IN (?) AND links.type = ?", merged_ticket_ids.ids, 'MemberOf')
        .where("tickets.type = ?", 'ticket').where.not("tickets.id = ?", id)
  end

  def children
    RT::Ticket.joins("JOIN links ON tickets.id = links.localbase OR tickets.id = links.localtarget")
        .where("links.localtarget IN (?) AND links.type = ?", merged_ticket_ids.ids, 'MemberOf')
        .where("tickets.type = ?", 'ticket').where.not("tickets.id = ?", id)
  end

  private

  def links_query(type:)
    RT::Ticket.joins("JOIN links ON tickets.id = links.localbase OR tickets.id = links.localtarget")
        .where("(links.localbase IN (?) AND links.type = ?) OR (links.localtarget IN (?) AND links.type = ?)",
               merged_ticket_ids.ids, type, merged_ticket_ids.ids, LINKS_INVERTED_VALUES[type])
        .where("tickets.type = ?", 'ticket').where.not("tickets.id = ?", id)
  end
end