class RT::CustomField < RequestTrackerRecord
  self.table_name = 'customfields'
  self.inheritance_column = :_type_disabled

  has_many :options, class_name: 'CustomFieldValue', foreign_key: 'customfield'
  has_many :object_values, class_name: 'ObjectCustomFieldValue', foreign_key: 'customfield'

  def value_for(object_id:)
    possible_value = object_values.where(objectid: object_id).limit(1)&.first
    possible_value&.content
  end
end