class UserSerializer < ActiveModel::Serializer
  include ApplicationHelper

  attributes :id, :email, :username, :avatar_url, :patreon_access_token, :is_ad_free, :created_at

  def avatar_url
    return nil unless object.avatar.present?

    cdn_for(object.avatar)
  end
end
