class AdminSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :username, :role , :created_at
end


