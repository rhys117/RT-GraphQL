class RT::Queue < ActiveRecord::Base
  establish_connection :request_tracker
  self.table_name = 'queues'

  has_many :tickets, foreign_key: 'queue'
end
