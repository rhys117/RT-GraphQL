class Types::CustomFieldType < Types::BaseObject
  field :name, String, null: false
  field :options, [Types::CustomFieldValueType], null: false
end
