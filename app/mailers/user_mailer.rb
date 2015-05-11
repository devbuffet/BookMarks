class UserMailer < ActionMailer::Base
  include ApplicationHelper
  # this will change once we go live...
  # default from: Rails.application.config.siteUserName

  def signup_sendMail(user, subject_tx)
    @user = user

    mail to: user.email, subject: subject_tx, bcc:ENV['gmailUserName']
  end

  def passwordreset_sendMail(user, subject_tx)
    @user = user
     @url_tx = Rails.application.config.url + "users/" + user.id.to_s + "/edit?token=" + user.code_tx.to_s
    mail to: user.email, subject: subject_tx
  end 
end
