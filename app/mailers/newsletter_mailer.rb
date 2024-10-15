class NewsletterMailer < ApplicationMailer
  layout false

  def join
    @user = params[:user]
    mail(to: @user.email, subject: 'Unlock the Secrets of Mystery Babylon')
  end

  def inactive_patron
    @user = params[:user]
    mail(to: @user.email, subject: 'Unlock the Secrets of Mystery Babylon')
  end
end
