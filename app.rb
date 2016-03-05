require 'sinatra'
require 'sinatra/config_file'
require 'sinatra/json'
require 'json'
require 'aws/ses'
require 'active_support/core_ext/array'
require 'active_support/inflector'

config_file 'config.yml'

set :show_exceptions, false

class ParamsMissingError < StandardError
end

class MailSendError < StandardError
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
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Request-Method'] = '*'

  destination = params[:destination] || settings.default_destination
  name        = params[:name] || params[:message][:'full-name']
  message     = params[:message]
  sender      = params[:sender] || settings.default_sender

  if message.kind_of?(Hash)
    message = message.map {|k,v| "#{k.titleize}: #{v}"}.join("\r\n\n")
  end

  unless destination && name && message && sender
    raise ParamsMissingError
  end

  ses = AWS::SES::Base.new(
    access_key_id:     ENV['SES_KEY_ID'], 
    secret_access_key: ENV['SES_KEY'],
    server: settings.ses['server']
  )

  ses.send_email(
    to:        Array.wrap(destination),
    source:    sender,
    subject:   settings.subject_prepend + ' : ' + name,
    text_body: name + ": \r\n" + message
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

error do
  status 500
  json error: 'An internal server error occured. Please try again later.'
end