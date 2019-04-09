class RT::ObjectCustomFieldValue < RequestTrackerRecord
  self.table_name = 'objectcustomfieldvalues'

  belongs_to :ticket, class_name: 'Ticket', foreign_key: :id, primary_key: :objectid
  belongs_to :custom_field, class_name: 'CustomField', foreign_key: :customfield, primary_key: :id

  alias_attribute :value, :content

  def name
    custom_field.name
  end

  alias_method :field, :name
end