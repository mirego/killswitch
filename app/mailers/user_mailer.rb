class UserMailer < ApplicationMailer
  def welcome_email(user_id, token)
    @user = User.find(user_id)
    @token = token
    mail to: @user.email, subject: t('.subject')
  end
end
