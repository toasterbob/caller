require 'sinatra'
require 'twilio-ruby'

get '/' do
  "Hello World!"
end


post '/receive_sms' do
  content_type 'text/xml'

  response = Twilio::TwiML::Response.new do |r|
    if body == "hello"
      r.Message "Hi!"
    elsif body == "bye"
      r.message "Goodbye"
    else
      r.message "Thanks for the crackerjacks!"
    end
  end

  response.to_xml
end

post '/send_sms' do

  to = params["to"]
  message = params["body"]

  client = Twilio::REST::Client.new(
    ENV["TWILIO_ACCOUNT_SID"],
    ENV["TWILIO_AUTH_TOKEN"]
  )

  client.messages.create(
    to: to,
    from: "+12534263667",
    body: message
  )

end
