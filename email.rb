require 'mail'
require 'json'

config_json = JSON.parse(File.read('email_config.json'))

smtp = { :address => 'smtp.163.com', :port => 25, :domain => '163.com',:user_name => config_json['from'], 
	 :password => config_json['password'], :enable_starttls_auto => true, :openssl_verify_mode => 'none' }

Mail.defaults { delivery_method :smtp, smtp }

mail = Mail.new do
  from      config_json['from']
  subject   config_json['subject']
  body      config_json['body']
end

#构造一个匹配文件名中时间的正则表达式,匹配需要发送的文件
time_regexp = Time.now.strftime('%Y.%m.%d')
Dir.foreach '.' do |filename|
  unless filename.match(/#{time_regexp}/).nil?
    mail.add_file filename
  end
end

#逐个联系人发送
config_json['to'].each do |to|
  mail.to = to
  mail.deliver
  puts "email sent"
end
