require 'sinatra'
require 'twilio-ruby'
require 'open-uri'
require 'json'

lyrics = "Never gonna give you up, never gonna let you down
          Never gonna run around and desert you
          Never gonna make you cry, never gonna say goodbye
          Never gonna tell a lie and hurt you"

get '/' do
  "Hello World!"
end

def get_advice
  r = open('http://api.adviceslip.com/advice')

  if r.status[0] == "200"
    doc = ""

    r.each do |line|
      doc << line
    end

    doc = JSON.parse(doc, :symbolize_names => true)
    advice = doc[:slip][:advice]

    return advice
  end

end


post '/receive_sms' do
  content_type 'text/xml'
  body = params['Body'].downcase

  response = Twilio::TwiML::Response.new do |r|
    if body.include?("hello") || body.include?("hi")
      r.Message "Hi!"
    elsif body.include?("bye")
      r.message "Goodbye"
    elsif body.include?("advice")
      r.message get_advice
    elsif body.include?("rick") || body.include?("astley")
      r.message lyrics
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
