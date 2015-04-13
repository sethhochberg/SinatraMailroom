require 'sinatra/base'
require 'sinatra/config_file'
require 'pony'
require 'json'

class SinatraMailroom < Sinatra::Base
	register Sinatra::ConfigFile

	config_file 'config.yml'

	get '/ping' do
		content_type :json
		{pong: true, time: Time.now.to_s}.to_json
	end

	post '/mail' do
		Pony.mail(
		{
			:from => params[:name],
	    :to => 'myemailaddress',
	    :subject => params[:name] + "has contacted you via the Website",
	    :body => params[:comment],
	    :via => :smtp,
	    :via_options => {
	     :address              => 'smtp.gmail.com',
	     :port                 => '587',
	     :enable_starttls_auto => true,
	     :user_name            => 'myemailaddress',
	     :password             => 'mypassword',
	     :authentication       => :plain, 
	     :domain               => "localhost.localdomain" 
			}
		})
			    

   end
	end

end
