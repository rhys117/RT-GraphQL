class RT::Transaction < ActiveRecord::Base
  establish_connection :request_tracker
  self.table_name = 'transactions'
  self.inheritance_column = :_type_disabled

  belongs_to :ticket, class_name: 'Ticket', foreign_key: :objectid
  has_one :creator, class_name: 'User', primary_key: :creator, foreign_key: :id
  has_many :attachments, class_name: 'Attachment', foreign_key: :transactionid
  
  alias_attribute :new_value, :newvalue
  alias_attribute :old_value, :oldvalue
end
