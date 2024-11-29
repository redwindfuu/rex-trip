# == Schema Information
#
# Table name: admins
#
#  id              :bigint           not null, primary key
#  uuid            :uuid             not null
#  username        :string
#  password_digest :string
#  role            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class AdminSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :username, :role, :created_at
end
