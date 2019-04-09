class RT::Link < RequestTrackerRecord
  self.table_name = 'links'
  self.inheritance_column = :_type_disabled
end