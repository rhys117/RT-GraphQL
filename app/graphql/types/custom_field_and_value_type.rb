class Types::CustomFieldAndValueType < Types::BaseObject
  field :name, String, null: false
  field :value, String, null: true
end
