class UserSerializer < ActiveModel::Serializer
  include ApplicationHelper

  attributes :id, :email, :username, :avatar_url, :patreon_access_token, :created_at

  def avatar_url
    return nil unless object.avatar.prsent?

    cdn_for(object.avatar)
  end
end
