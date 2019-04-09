class RT::Attachment < RequestTrackerRecord
  self.table_name = 'attachments'

  belongs_to :its_transaction, class_name: 'Transaction', foreign_key: :transactionid

  alias_attribute :transaction_id, :transactionid
  alias_attribute :content_type, :contenttype

  def creator
    its_transaction.creator
  end

  def type
    its_transaction.type
  end
end
