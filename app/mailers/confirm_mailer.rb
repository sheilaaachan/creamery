class ConfirmMailer < ActionMailer::Base
  default from: "sheilaaachan@gmail.com"
  
  def new_user_msg(user)
    @user = user
    mail(:to => user.email, :subject => "Your Creamery Account Created")
  end
end
