
# TODO: Set redirect url to react and have them provide the params[:code] + user info

class Api::V1::PatreonController < ApplicationController
  def create
    @client = PatreonService.new(current_user, params[:code])
    @client.fetch_tokens
    @client.fetch_patreon_identity
    @client.set_patreon_fields

    is_an_active_patron = @client.is_a_patron?

    if is_an_active_patron.class == Hash
      render json: { error: is_an_active_patron[:error] }, status: :unauthorized
      return
    end

    current_user.update!(is_ad_free: true) if is_an_active_patron

    render json: current_user
  end
end