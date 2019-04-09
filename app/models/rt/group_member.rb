class RT::GroupMember < RequestTrackerRecord
  self.table_name = 'groupmembers'

  belongs_to :group, foreign_key: :groupid
  belongs_to :user, foreign_key: :memberid
end