require 'sinatra'
require 'twilio-ruby'
require 'open-uri'
require 'json'

lyrics = ["Never gonna give you up, never gonna let you down
          Never gonna run around and desert you
          Never gonna make you cry, never gonna say goodbye
          Never gonna tell a lie and hurt you"]

lyrics2 = "Never gonna give you up, never gonna let you down
Never gonna run around and desert you.
Never gonna make you cry, never gonna say goodbye
Never gonna tell a lie and hurt you."

get '/' do
   redirect '/index.html'
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

def chuck_norris

  r = open('http://api.icndb.com/jokes/random')

  if r.status[0] == "200"
    doc = ""

    r.each do |line|
      doc << line
    end

    doc = JSON.parse(doc, :symbolize_names => true)
    response = doc[:value][:joke]

    return response
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
    elsif body.include?("dice")
      r.message "I rolled a #{rand(6) + 1} and a #{rand(6) + 1}."
    elsif body.include?("advice")
      r.message get_advice
    elsif body.include?("rick") || body.include?("astley")
      r.message lyrics[0]
    elsif body.include?("quote")
      r.message get_quote
    elsif body.include?("twin peaks") || body.include?("agent cooper")
      r.message "Lunch was, uh, Six dollars and thirty one cents at the Lamplighter Inn. That's on Highway 2, near Lewis Fork. That was a tuna fish sandwich, slice of cherry pie and a cup of coffee. Damn good food. And, Diane, if you ever get up this way, that cherry pie is worth a stop."
    elsif body.include?("star wars")
      r.message "Luke, I am your father!"
    elsif body.include?("chuck norris")
      r.message chuck_norris
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
  redirect '/index.html'
end

post '/make_call' do

  to = params["to"]
  name = params["name"] || "monkey"
  # url = "http://twimlets.com/message?Message%5B0%5D=Hello%20" + name + '.%20%0ANever%20gonna%20give%20you%20up%2C%20never%20gonna%20let%20you%20down%0ANever%20gonna%20run%20around%20and%20desert%20you.%0ANever%20gonna%20make%20you%20cry%2C%20never%20gonna%20say%20goodbye%0ANever%20gonna%20tell%20a%20lie%20and%20hurt%20you.%0AGoodbye%20' + name + '.%20This%20song%20is%20for%20you&Message%5B1%5D=http%3A%2F%2Fwww.marknoizumi.com%2Fcaller%2Fnever_gonna_give_you_up.mp3&'

  @client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]

  @call = @client.account.calls.create(
    :from => '+12534263667',   # From your Twilio number
    :to => to,     # To any number
    # Fetch instructions from this URL when the call connects
    # Twilio::TwiML::Response.new do |r|
    #   r.Say "Hello #{name}. #{lyrics2} Goodbye #{name}. This song is for you"
    # end
    :url => 'http://twimlets.com/message?Message%5B0%5D=Hello%20Monkey.%20%0ANever%20gonna%20give%20you%20up%2C%20never%20gonna%20let%20you%20down%0ANever%20gonna%20run%20around%20and%20desert%20you.%0ANever%20gonna%20make%20you%20cry%2C%20never%20gonna%20say%20goodbye%0ANever%20gonna%20tell%20a%20lie%20and%20hurt%20you.%0AGoodbye%20Monkey.%20This%20song%20is%20for%20you&Message%5B1%5D=http%3A%2F%2Fwww.marknoizumi.com%2Fcaller%2Fnever_gonna_give_you_up.mp3&'
  )
end

# get '/rick-roll' do
#   Twilio::TwiML::Response.new do |r|
#     r.Say lyrics2
#   end
# end


get '/hello-monkey' do
  people = {
    '+13105625250' => 'Ambah Chun',
    '+19517190952' => 'Amy Chun.  Hi ya.  Hi ya.  Hi ya.',
    '+19515994796' => 'Noizumi Person',
    '+15103948491' => 'Emma Chun',
    '+19542782210' => 'Mark Chun',
    '+12089200640' => 'Witch Boy',
    '+15102990084' => 'Robinator',
    '+17604857276' => 'Marsha',
    '+17608314429' => 'Hiroshi',
  }
  name = people[params['From']] || 'Monkey'

  Twilio::TwiML::Response.new do |r|
    r.Say "Hello #{name}. #{lyrics2} Goodbye #{name}. This song is for you"
    r.Play "http://www.marknoizumi.com/caller/never_gonna_give_you_up.mp3"
    r.Say "Why are you still here?"

    r.Gather :numDigits => '1', :action => '/hello-monkey/handle-gather', :method => 'get' do |g|
      #g.Say 'To speak to a real monkey, press 1.'
      g.Say 'Press any key to start over.'
    end

  end.text
end

get '/hello-monkey/handle-gather' do
  redirect '/hello-monkey' #unless params['Digits'] == '1'
  # Twilio::TwiML::Response.new do |r|
  #   r.Dial '+13105551212' ### Connect the caller to Koko, or your cell
  #   r.Say 'The call failed or the remote party hung up. Goodbye.'
  # end.text
end
