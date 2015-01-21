class CharactersController < ApplicationController
@@newcharacter
  def index
	puts params
	uri = URI("http://dotards.net:3000/api/v1/characters/mychars")
	uri.query = URI.encode_www_form(params)
	res = Net::HTTP.get_response(uri)
	res.body.force_encoding("ISO-8859-1").encode("UTF-8")
	@mychars = ActiveSupport::JSON.decode(res.body)
	@chars = @mychars["characters"]
  end

  def add
  end

  def load_character
	myuri = 'http://eu.battle.net/api/wow/character/'+params[:charserver]+'/'+params[:charname]+'?fields=items'
	encoded_url = URI.encode(myuri)
	url = URI.parse(encoded_url)
	req = Net::HTTP::Get.new(url.to_s)
	res = Net::HTTP.start(url.host, url.port) {|http|
  	http.request(req)
	}
	json = ActiveSupport::JSON.decode(res.body)
	puts json
	@character = json
	@items = json["items"]
	@@newcharacter = @character
	redirect_to :controller => 'characters', :action => 'add', :name => @character["name"], :class => @character["class"], :race => @character["race"], :level => @character["level"], :itemlevelequipped => @items["averageItemLevelEquipped"], :itemleveltotal => @items["averageItemLevel"]
  end

  def save_character
	flag = @@newcharacter if defined?(@@newcharacter)
	if flag
	  #Send character to server
	  @newitems = @@newcharacter["items"]
	  http = Net::HTTP.new("api.dotards.net", 3000)

	  request = Net::HTTP::Post.new("/api/v1/characters/create")
    	  request.set_form_data({"lastModified" => @@newcharacter["lastModified"], "name" => @@newcharacter["name"], "realm" => @@newcharacter["realm"], "battlegroup" => @@newcharacter["battlegroup"], "class" => @@newcharacter["class"], "race" => @@newcharacter["race"], "gender" => @@newcharacter["gender"], "level" => @@newcharacter["level"], "achievementPoints" => @@newcharacter["achievementPoints"], "thumbnailurl" => "http://eu.battle.net/static-render/eu/"+@@newcharacter["thumbnail"], "itemleveltotal" => @newitems["averageItemLevel"], "itemlevelequipped" => @newitems["averageItemLevelEquipped"], "userid" => session[:user_id]})
	  response = http.request(request)
	
	  json = ActiveSupport::JSON.decode(response.body)
	  code = json["code"]
	  if code == 0
	  redirect_to :controller => 'characters', :action => 'index', :userid => session[:user_id]
	  @@newcharacter = nil
	  else
	  end
	else
	end
  end

end
