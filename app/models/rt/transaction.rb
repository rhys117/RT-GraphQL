class RT::Transaction < ActiveRecord::Base
  establish_connection :request_tracker
  self.table_name = 'transactions'
  self.inheritance_column = :_type_disabled

  belongs_to :ticket, class_name: 'Ticket', foreign_key: :objectid
  belongs_to :attachment, class_name: 'Attachment', foreign_key: :id, primary_key: :transactionid
  
  alias_attribute :new_value, :new_value
  alias_attribute :old_value, :oldvalue
end