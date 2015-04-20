require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/json'
require 'json'
require 'aws/ses'

config_file 'config.yml'

class ParamsMissingError
end

class MailSendError
end

get '/' do
	status 200
	'nothing to see here, move along'
end

get '/ping' do
	status 200
	json pong: true, time: Time.now.to_s
end

post '/mail' do
	destination = params[:destination]
	name 				= params[:name]
	message 		= params[:message]
	sender      = params[:sender]

	unless destination && name && message && sender
		raise ParamsMissingError
	end

	ses = AWS::SES::Base.new(
	  access_key_id:     ENV['SES_KEY_ID'], 
	  secret_access_key: ENV['SES_KEY'],
	  server: settings.ses['server']
	)

	ses.send_email(
    to:        [destination],
    source:    sender,
    subject:   settings.subject_prepend + ' : ' + name,
    text_body: name + ' : ' + message
	)

	status 200
	json message: settings.success_message
end

error ParamsMissingError do
	status 400
	json error: settings.unprocessable_message
end

error MailSendError do
	status 503
	json error: settings.fail_message
end
