class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :patreon_access_token, :confirmed_at, :created_at
end
