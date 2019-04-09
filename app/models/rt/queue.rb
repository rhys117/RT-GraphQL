class RT::Queue < RequestTrackerRecord
  self.table_name = 'queues'

  has_many :tickets, foreign_key: :queue
  has_many :object_custom_fields, foreign_key: :objectid
  has_many :custom_fields, through: :object_custom_fields
end
