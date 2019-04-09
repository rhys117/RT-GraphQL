class RT::Ticket < RT::TicketBase
  default_scope { where "tickets.effectiveid = tickets.id AND tickets.type = 'ticket'" }

  # only ever return effective ticket
  def self.find(id)
    entry = RT::Ticket.select(:effectiveid, :type).unscoped.where(id: id).limit(1)&.first
    raise "Ticket #{id} does not exist" if entry.nil?
    raise "#{id} is a reminder. Use RT::Reminder Class" if entry.type == 'reminder'

    super(entry.effectiveid)
  end

  def self.rest_create(queue_name:, subject:, owner_name: 'Nobody', initial_comment: '', session: RT::Session.new)
    RT::REST::Ticket.new(queue_name: queue_name, subject: subject, owner_name: owner_name,
                         initial_comment: initial_comment, session: session)
  end

  def reminders
    join = RT::Reminder.joins("JOIN links ON tickets.id = links.localbase OR tickets.id = links.localtarget")
    join.where(links: {localtarget: current_and_merged_ids, type: 'RefersTo' })
  end

  def no_reminder?
    reminders.where(owner: owner.id).where.not(status: NOT_RESOLVED_STATUSES).count.zero?
  end
end
