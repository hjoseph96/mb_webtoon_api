class RefreshPatreonJob
  include Sidekiq::Job

  def perform
    @expired_patrons = User.where('patreon_expires_at < ?', Date.today)

    @expired_patrons.each do |p|
      @client = PatreonService.new(p)
      @client.refresh_user_tokens

      @client.fetch_patreon_identity
      response = @client.is_an_active_patron?
      if response.try(:[], :error).present?
        NewsletterMailer.with(user: p).inactive_patron.deliver_now

        p.update!(is_ad_free: false)
      else
        p.update!(is_ad_free: true)
      end
    end

  end
end
