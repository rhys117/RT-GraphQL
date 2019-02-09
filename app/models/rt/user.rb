class RT::User < ActiveRecord::Base
  establish_connection :request_tracker
  has_many :tickets, -> { where type: 'ticket' }, foreign_key: 'owner'
  has_many :reminders, -> { where type: 'reminder' }, class_name: 'Ticket', foreign_key: 'owner'
  has_many :group_members, class_name: 'GroupMember', foreign_key: :memberid
  has_many :groups, class_name: 'Group', through: :group_members

  alias_attribute :email, :emailaddress
  alias_attribute :real_name, :realname
  alias_attribute :organisation, :organization
end