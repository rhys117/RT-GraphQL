class Types::HistoryType < Types::BaseObject
  field :id, ID,                                null: false
  field :type, String,                          null: false
  field :old_value, String,                     null: true
  field :new_value, String,                     null: true
  field :attachments, [Types::AttachmentType],  null: true
  field :creator, Types::UserType,               null: false
end
