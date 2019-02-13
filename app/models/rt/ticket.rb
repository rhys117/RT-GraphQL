class RT::Ticket < ActiveRecord::Base
  establish_connection :request_tracker
  self.table_name = 'tickets'
  self.inheritance_column = :_type_disabled
  default_scope { where "effectiveid = id" }

  belongs_to :queue_obj, class_name: 'Queue', foreign_key: :queue

  has_many :custom_fields, class_name: 'ObjectCustomFieldValue', foreign_key: :objectid

  has_many :groups, class_name: 'Group', foreign_key: :instance
  has_one :requestor_group, -> { where type: 'Requestor' }, class_name: 'Group', foreign_key: :instance
  has_many :requestors, through: :requestor_group, class_name: 'User', source: :users

  # Below does not account for merged tickets transactions - If added remove custom methods below
=begin
    has_many :transactions, class_name: 'Transaction', foreign_key: :objectid
    has_many :attachments, through: :transactions, class_name: 'Attachment', source: :attachment
    has_many :comment_transactions, -> { where "type = ? OR type = ?", 'Comment', 'Create' }, class_name: 'Transaction', foreign_key: :objectid
    has_many :comments, through: :comment_transactions, class_name: 'Attachment', source: :attachment
=end

  has_one :owner_obj, class_name: 'User', primary_key: :creator, foreign_key: :id
  has_one :creator, class_name: 'User', primary_key: :creator, foreign_key: :id
  has_one :last_updated_by, class_name: 'User', primary_key: :creator, foreign_key: :id

  alias_attribute :effective_id, :effectiveid
  alias_attribute :last_updated, :lastupdated

  # only ever return effective ticket
  def self.find(id)
    id = RT::Ticket.select(:effectiveid).unscoped.where(id: id).limit(1)&.first&.effectiveid
    super(id)
  end

  def merged_ticket_ids
    RT::Ticket.select(:id).unscoped.where(effectiveid: id)
  end

  def transactions
    RT::Transaction.where(objectid: merged_ticket_ids)
  end

  def transaction_ids
    transactions.select(:id)
  end

  def attachments
    transaction_ids.where(objecttype: 'RT::Ticket').map { |ent| RT::Attachment.find_by_transactionid(ent.id) }
  end

  def comments
    transaction_ids.where("objecttype = ? AND (type = ? OR type = ?)", 'RT::Ticket', 'Comment', 'Create')
      .map { |ent| RT::Attachment.find_by_transactionid(ent.id) }
  end

  def correspondence
    transaction_ids.where("objecttype = ? AND type = ?", 'RT::Ticket', 'Correspond')
      .map { |ent| RT::Attachment.find_by_transactionid(ent.id) }
  end

  def comments_and_correspondence
    transaction_ids.where("objecttype = ? AND (type = ? OR type = ? OR type = ?)",
                          'RT::Ticket', 'Comment', 'Correspond', 'Create')
      .map { |ent| RT::Attachment.find_by_transactionid(ent.id) }
  end

  # This setup is to avoid stack to deep errors due to RT database structure
  def queue
    queue_obj
  end

  def owner
    owner_obj
  end
end