class CharactersController < ApplicationController
  def index
	uri = URI("http://dotards.net:3000/api/v1/characters/mychars")
	uri.query = URI.encode_www_form(params)
	res = Net::HTTP.get_response(uri)
	res.body.force_encoding("ISO-8859-1").encode("UTF-8")
	@mychars = ActiveSupport::JSON.decode(res.body)
	
  end

  def add
  end
end
