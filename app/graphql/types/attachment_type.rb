class Types::AttachmentType < Types::BaseObject
  field :id, ID,                null: false
  field :transaction_id, ID,    null: false
  field :subject, String,       null: true
  field :content_type, String,  null: false
  field :content, String,       null: true
  field :type, String,          null: false
end
