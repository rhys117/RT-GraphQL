class RT::Attachment < ActiveRecord::Base
  establish_connection :request_tracker
  self.table_name = 'attachments'
end
