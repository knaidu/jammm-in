=begin
Pony.mail (
  :to => 'prakash.raman.ka@gmail.com',
  :from => 'invite@jammm.in',
  :subject => 'Second',
  :body => 'Welcome to jammm.in',
  :via => :smtp,
  :smtp => {
          :host => 'smtp.gmail.com',
          :port => '587',
          :tls => true,
          :user => 'invite@jammm.in',
          :password => '3WiseMen',
          :auth => :login,
          :domain => 'jammm.in'
  }
)
=end

DEFAULT_MAIL_DETAILS = {
#  :to => 'prakash.raman.ka@gmail.com',
#  :from => 'invite@jammm.in',
#  :subject => 'Second',
#  :body => 'Welcome to jammm.in',
  :via => :smtp,
  :smtp => {
    :host => 'smtp.gmail.com',
    :port => '587',
    :tls => true,
#    :user => 'invite@jammm.in',
#    :password => 'password',
    :auth => :login,
    :domain => 'jammm.in'
  }
}

def mail(details={})
  mail_details = DEFAULT_MAIL_DETAILS.clone
  mail_details[:from] = details[:from]
  mail_details[:to] = details[:to]
  mail_details[:subject] = details[:subject]
  mail_details[:body] = details[:body]
  mail_details[:smtp][:user] = details[:from]
  mail_details[:smtp][:password] = details[:password]
  mail_details[:content_type] = "text/html"
  
  Pony.mail(mail_details)
end

def test_mail
  mail({
    :from => "support@jammm.in",
    :subject => "Jammm.in",
    :body => "tets",
    :password => "3WiseMen",
    :to => "prakash.raman.ka@gmail.com"
  })
end