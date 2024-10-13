require 'httparty'

class DefendiumService
  def self.check_for_spam(comment)
    url = 'https://api.defendium.com/check'

    response = HTTParty.post(url, body: {
      secret_key: Rails.application.credentials.dig(:defendium).dig(:secret_key),
      content: comment.body,
      author_email: comment.user.email
    }.to_json, headers: { 'Content-Type' => 'application/json' }).body

    JSON.parse(response)['result']
  end
end