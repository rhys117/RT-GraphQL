class Types::CustomFieldAttributes < Types::BaseInputObject
  description "Attributes for updating a custom field"

  argument :names, [String], required: true
  argument :values, [String], required: true
end