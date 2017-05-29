require 'open-uri'
require 'json'

def get_response(input)
  # str = 'http://www.cleverbot.com/getreply?key=' + ENV["CLEVERBOT_API"] + "&input=" + input
  url = 'http://www.cleverbot.com/getreply?key=' + "CC2g9KbtVvRwl87D1nGBMdcBprw" + "&input=" + input
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

puts get_response("Do you like chocolate")
