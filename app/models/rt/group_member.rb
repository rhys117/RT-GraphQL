class RT::GroupMember < ActiveRecord::Base
  establish_connection :request_tracker
  self.table_name = 'groupmembers'

  belongs_to :group, foreign_key: :groupid
  belongs_to :user, foreign_key: :memberid
end