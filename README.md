

### [Rick Roller Live App][photojournal]
[photojournal]: https://rick-roller.herokuapp.com/index.html

![rick]
[rick]: ./assets/rick.png

## Rick Roller
Rick Roller is based on the popular activity known as Rick Rolling, which consists of pranking people into listening to Rick Astley's song "Never Gonna Give You Up".

https://en.wikipedia.org/wiki/Rickrolling

Rick Roller was designed using the Twilio API with the framework built in Ruby utilizing Sinatra and Rack as the web server interface.  The site is hosted on Heroku.  

### Web Application
The main usage of the web app is to enter someone's phone number.  The app will then call them and recite a series of Rick Astley lyrics utilizing Twilio's TwiML robot voice before bursting into the actual song of "Never Gonna Give You Up".  The power to annoy your friends and family with this simple app is limitless.  

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
