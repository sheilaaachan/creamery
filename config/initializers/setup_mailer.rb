ActionMailer::Base.smtp_settings = {
	:address => "sheilaaachan@gmail.com",
	:port => 587,
	:user_name => "sheilaaachan",
	:password => "secret",
	:authentication => "plain",
	:enable_starttls_auto => true
}