require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

# post '/receive_sms' do
#   content_type 'text/xml'
#
#   response = Twilio::TwiML::Response.new do |r|
#     r.Message "Hey thanks for messaging me!"
#   end
#
#   response.to_xml
# end


get '/' do
  "Hello World"
end
