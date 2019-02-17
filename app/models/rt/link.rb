class RT::Link < ActiveRecord::Base
  establish_connection :request_tracker
  self.table_name = 'links'
  self.inheritance_column = :_type_disabled
end