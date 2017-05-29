require 'sinatra'
require 'twilio-ruby'
require 'open-uri'
require 'json'

lyrics = ["Never gonna give you up, never gonna let you down
          Never gonna run around and desert you
          Never gonna make you cry, never gonna say goodbye
          Never gonna tell a lie and hurt you"]

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

def get_response(input)
  url = 'http://www.cleverbot.com/getreply?key=' + ENV["CLEVERBOT_API"] + "&input=" + input
  # url = 'http://www.cleverbot.com/getreply?key=' + "API" + "&input=" + input
  r = open(url)

  if r.status[0] == "200"
    doc = ""

    r.each do |line|
      doc << line
    end

    doc = JSON.parse(doc, :symbolize_names => true)
    response = doc[:output]

    return response
  end


end


def get_quote
  r = open('http://www.yerkee.com/api/fortune')

  if r.status[0] == "200"
    doc = ""

    r.each do |line|
      doc << line
    end

    doc = JSON.parse(doc, :symbolize_names => true)
    quote = doc[:fortune]

    return quote
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
      r.message lyrics[0]
    elsif body.include?("quote")
      r.message get_quote
    else
      r.message get_response(body)
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
