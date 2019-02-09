class RT::CustomField < ActiveRecord::Base
  establish_connection :request_tracker
  self.table_name = 'customfields'
  self.inheritance_column = :_type_disabled

  has_many :options, class_name: 'CustomFieldValue', foreign_key: 'customfield'
  has_many :used_on, class_name: 'ObjectCustomFieldValue', foreign_key: 'customfield'
end