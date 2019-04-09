class RT::Group < RequestTrackerRecord
  self.table_name = 'groups'
  self.inheritance_column = :_type_disabled

  has_many :members, class_name: 'GroupMember', foreign_key: :groupid
  has_many :users, class_name: 'User', through: :members
end