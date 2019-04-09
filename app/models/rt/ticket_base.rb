class RT::TicketBase < RequestTrackerRecord
  self.table_name = 'tickets'
  self.inheritance_column = :_type_disabled

  LINKS_INVERTED_VALUES = { 'RefersTo' => 'ReferredToBy', 'ReferredToBy' => 'RefersTo',
                            'DependsOn' => 'DependedOnBy', 'DependedOnBy' => 'DependsOn',
                            'Child' => 'MemberOf', 'MemberOf' => 'Child' }.freeze

  belongs_to :queue_obj, class_name: 'Queue', foreign_key: :queue

  has_many :custom_fields, through: :queue_obj
  has_many :custom_field_values, class_name: 'ObjectCustomFieldValue', foreign_key: :objectid

  has_many :groups, class_name: 'Group', foreign_key: :instance
  has_one :requestor_group, -> { where type: 'Requestor' }, class_name: 'Group', foreign_key: :instance
  has_many :requestors, through: :requestor_group, class_name: 'User', source: :users

  has_one :owner_obj, class_name: 'User', primary_key: :owner, foreign_key: :id
  has_one :creator, class_name: 'User', primary_key: :creator, foreign_key: :id
  has_one :last_updated_by, class_name: 'User', primary_key: :lastupdatedby, foreign_key: :id

  alias_attribute :effective_id, :effectiveid
  alias_attribute :last_updated, :lastupdated

  def current_and_merged_ids
    RT::Ticket.unscoped.select(:id).where(effectiveid: id)
  end

  def transactions
    RT::Transaction.where(objectid: current_and_merged_ids).where.not(objecttype: 'RT::Group').order(:id)
  end

  alias_method :history, :transactions

  def transaction_ids
    transactions.select(:id)
  end

  def attachments
    RT::Attachment.where("transactionid IN (?)", transaction_ids.where(objecttype: 'RT::Ticket').ids)
  end

  def comments
    RT::Attachment.where("transactionid IN (?)", transaction_ids.where("objecttype = ? AND (type = ? OR type = ?)",
                                                                       'RT::Ticket', 'Comment', 'Create').ids)
  end

  def correspondence
    RT::Attachment.where("transactionid IN (?)", transaction_ids.where("objecttype = ? AND type = ?",
                                                                       'RT::Ticket', 'Correspond').ids)
  end

  def comments_and_correspondence
    RT::Attachment.where("transactionid IN (?)", transaction_ids.where("objecttype = ? AND (type = ? OR type = ? OR type = ?)",
                                                                        'RT::Ticket', 'Comment', 'Correspond', 'Create').ids)
  end

  def latest_update
    RT::Attachment.find_by_transactionid(transaction_ids.where("objecttype = ? AND (type = ? OR type = ? OR type = ?)",
                                                               'RT::Ticket', 'Comment', 'Correspond', 'Create').order(:id).last.id)
  end

  # Todo: Optimize to avoid hitting DB
  def custom_fields_and_values
    results = {}
    custom_fields.each { |field| results[field.name] = field.value_for(object_id: id) }

    results
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
    join = RT::Ticket.joins("JOIN links ON tickets.id = links.localbase OR tickets.id = links.localtarget")

    join.where(links: { localbase: current_and_merged_ids, type: 'MemberOf' })
        .or(join.where(links: { type: 'ticket' })).where.not(tickets: { id: id })
  end

  def children
    join = RT::Ticket.joins("JOIN links ON tickets.id = links.localbase OR tickets.id = links.localtarget")

    join.where("links.localtarget IN (?) AND links.type = ?", current_and_merged_ids, 'MemberOf')
        .where("tickets.type = ?", 'ticket').where.not("tickets.id = ?", id)
  end

  def all_links
    {
        depends_on: depends_on.to_a,
        depended_on_by: depended_on_by.to_a,
        refers_to: refers_to.to_a,
        referred_to_by: referred_to_by.to_a,
        parents: parents.to_a,
        children: children.to_a
    }
  end

  # This setup is to avoid stack to deep errors due to RT database structure
  def queue
    queue_obj
  end

  def owner
    owner_obj
  end

  private

  def links_query(type:)
    join = RT::Ticket.joins("JOIN links ON tickets.id = links.localbase OR tickets.id = links.localtarget")

    join.where(links: {localbase: current_and_merged_ids, type: type })
        .or(join.where(links: {localtarget: current_and_merged_ids, type: LINKS_INVERTED_VALUES[type] }))
  end
end

# Below does not account for merged tickets transactions - If added remove custom methods
=begin
    has_many :transactions, class_name: 'Transaction', foreign_key: :objectid
    has_many :attachments, through: :transactions, class_name: 'Attachment', source: :attachment
    has_many :comment_transactions, -> { where "type = ? OR type = ?", 'Comment', 'Create' }, class_name: 'Transaction', foreign_key: :objectid
    has_many :comments, through: :comment_transactions, class_name: 'Attachment', source: :attachment
=end
