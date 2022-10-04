class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("host_email", nil)
  layout "mailer"
end
