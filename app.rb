require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/json'
require 'json'
require 'pony'

config_file 'config.yml'

get '/ping' do
	json pong: true, time: Time.now.to_s
end

post '/mail' do
	destination = params[:destination]

	Pony.mail(
	{
		:from => params[:sender],
	    :to => destination,
	    :subject => 'Request From: ' + params[:name],
	    :body => params[:body],
	    :via => :smtp,
	    :via_options => {
	     :address              => settings.smtp.address,
	     :port                 => settings.smtp.port,
	     :enable_starttls_auto => settings.smtp.starttls_auto,
	     :user_name            => settings.smtp.user,
	     :password             => settings.smtp.password,
	     :authentication       => settings.smtp.auth_type, 
	     :domain               => settings.smtp.domain 
		}
	})	
end
