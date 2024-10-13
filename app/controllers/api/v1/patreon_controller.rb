
# TODO: Set redirect url to react and have them provide the params[:code] + user info

class Api::V1::PatreonController < ApplicationController
  def index
    redirect_uri = 'http://localhost:3000/api/v1/patreon'
    patreon_cid = Rails.application.credentials.dig(:patreon).dig(:client_id)
    patreon_secret = Rails.application.credentials.dig(:patreon).dig(:client_secret)
    oauth_client = Patreon::OAuth.new(patreon_cid, patreon_secret)
    tokens = oauth_client.get_tokens(params[:code], redirect_uri)
    access_token = tokens['access_token']

    patreon_api_url = 'https://www.patreon.com/api/oauth2/v2'
    url = "#{patreon_api_url}/identity?include=memberships.campaign&fields[member]=patron_status"
    response = JSON.parse(HTTParty.get(url, headers: { 'Authorization' => "Bearer #{access_token}" }).body)

    check_if_active_subscriber(response)
  end

  private

  def check_if_active_subscriber(response)
    memberships = response['included'].filter {|relationship| relationship['type'] == 'member'}

    our_campaign_id = Rails.application.credentials.dig(:patreon).dig(:campaign_id)
    subscription = memberships.filter {|m| m.dig('relationships', 'campaign', 'data', 'id') == our_campaign_id.to_s }

    unless subscription.present?
      render json: { error: 'User is not a patron on Patreon' }, status: :unauthorized
      return
    end

    is_active_patron = subscription[0]['attributes']['patron_status'] == 'active_patron'
    if is_active_patron
      # mark user ad-free
      render json: { success: true, message: 'User is now ad-free 🥳' }
    else
      render json: { error: 'User is a patron, but needs to pay...' }, status: :unauthorized
    end
  end
end