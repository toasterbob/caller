require 'open-uri'
require 'json'

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

puts chuck_norris
