require 'patreon'
require 'httparty'

class PatreonService

  def initialize(user, code = nil)
    @user = user
    @code = code

    # TODO: Set redirect url to react and have them provide the params[:code] + user info
    @redirect_uri = 'http://localhost:3000/api/v1/patreon'

    patreon_cid = Rails.application.credentials.dig(:patreon).dig(:client_id)
    patreon_secret = Rails.application.credentials.dig(:patreon).dig(:client_secret)
    @oauth_client = Patreon::OAuth.new(patreon_cid, patreon_secret)
  end

  def is_a_patron?
    memberships = @response['included'].filter {|relationship| relationship['type'] == 'member'}

    our_campaign_id = Rails.application.credentials.dig(:patreon).dig(:campaign_id)
    subscription = memberships.filter {|m| m.dig('relationships', 'campaign', 'data', 'id') == our_campaign_id.to_s }

    return { error: 'User is not a patron on Patreon' } unless subscription.present?

    is_active_patron = subscription[0]['attributes']['patron_status'] == 'active_patron'
    if is_active_patron
      true
    else
      { error: 'User is a patron, but needs to pay...' }
    end
  end

  def refresh_user_tokens
    @tokens = @oauth_client.refresh_token(@user.patreon_refresh_token, @redirect_uri)
    set_patreon_fields
  end

  def fetch_tokens
    raise StandardError.new('"code" parameter not given during initialize') unless @code.present?

    @tokens = @oauth_client.get_tokens(@code, @redirect_uri)
  end

  def fetch_patreon_identity
    patreon_api_url = 'https://www.patreon.com/api/oauth2/v2'
    url = "#{patreon_api_url}/identity?include=memberships.campaign&fields[member]=patron_status"

    @response = JSON.parse(HTTParty.get(url, headers: { 'Authorization' => "Bearer #{@tokens['access_token']}" }).body)
  end

  def set_patreon_fields
    date = DateTime.now
    added_seconds = @tokens['expires_in']
    expiry_date = date + Rational(added_seconds, 86400)

    @user.update!(
      patreon_access_token: @tokens['access_token'],
      patreon_refresh_token: @tokens['refresh_token'],
      patreon_expires_at: expiry_date
    )
  end
end