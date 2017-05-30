

### [Rick Roller Live App][rickLive]
[rickLive]: https://rick-roller.herokuapp.com/index.html

![rick]

[rick]: ./assets/rick.png

## Rick Roller
Rick Roller is based on the popular activity known as Rick Rolling, which consists of pranking people into listening to Rick Astley's song "Never Gonna Give You Up".

https://en.wikipedia.org/wiki/Rickrolling

Rick Roller was designed using the Twilio API with the framework built in Ruby utilizing Sinatra and Rack as the web server interface.  The site is hosted on Heroku.  

### Web Application
The main usage of the web app is to enter someone's phone number.  The app will then call them and recite a series of Rick Astley lyrics utilizing Twilio's TwiML robot voice before bursting into the actual song of "Never Gonna Give You Up".  The power to annoy your friends and family with this simple app is limitless.  The call is done using a Twimlet.  Which is basically a proprietary response encoded in a URL.  This contains a combination of the words that the robot voice speaks as well as any mp3 files that need to be played.  

### Phone number
The app also has a phone number that can be dialed directly and then basically does the same thing as when you receive a call.  This could be given out to friends, asking them to call you at your new number.  But I actually envisioned it more as a fake number to give out to people who ask for your number that you don't want having your number.  They get a strange surprise when they try to call you.  

Utilizing Twilio's params one can actually identify the numbers that are calling and personal messages can be tailored specifically for them.  For example in the code snippet below you can find someone's name and call them by it.

```ruby
people = {
  '+13105551212' => 'John Doe',
  '+19515551234' => 'Chuck E. Cheese',
  '+12125559876' => 'Big Mac',
}
name = people[params['From']]

  Twilio::TwiML::Response.new do |r|
    r.Say "Hello #{name}"
  end
```

### Texting with actual Responses
This piece is where the App departs a bit from just Rick Rolling.  Going along with the idea that you can give this number out as a fake number.  The texting component actually will text responses back and one can hold a semblance of a conversation. Using the Twilio Response object, I parse out the message that was sent and then search it for key words.   

```ruby
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
```

I then combed the web and hooked it up to several APIs.  For example if you type Chuck Norris in your text message, the app will pull from a Chuck Norris joke API using the open-uri and json gems in Ruby.  

```ruby
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
```

Through the combination of APIs and random key words, the text interface can answer lots of questions and spit out all sorts of interesting quotes and random advice.  Ultimately, though I decided to find a chatbot and feed the responses that didn't meet the other criteria into it.  So, in theory it can hold conversations.  

So if you give this out as a fake number, it might take someone a little while to catch on if they just send a series of text messages.  

### Security for API Keys
I utilized Environment Variables (ENV) for API keys.   
```ruby
  client = Twilio::REST::Client.new(
    ENV["TWILIO_ACCOUNT_SID"],
    ENV["TWILIO_AUTH_TOKEN"]
  )
```
Heroku is quite easy to store them utilizing the user controls.

### Future Implementations
I would like to build out a few of my own APIs for the text messaging.  It would be great to build my own chat bot.  I would also like to build a movie quote database and a few others that could be tied into the text messaging.  I would like to find a weather API as well.  

I would also like to track individual users.  For example, the bot could remember conversation threads from certain users and store them away.  Also it might remember names.      
