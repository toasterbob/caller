require 'twilio-ruby'

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]

@call = @client.account.calls.create(
  :from => '+14159341234',   # From your Twilio number
  :to => '+18004567890',     # To any number
  # Fetch instructions from this URL when the call connects
  :url => 'http://twimlets.com/holdmusic?Bucket=com.twilio.music.ambient'
)
