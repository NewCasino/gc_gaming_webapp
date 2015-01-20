class RaidsController < ApplicationController

@@currentraid = ''

  def index
        http = Net::HTTP.new("api.dotards.net", 3000)
        request = Net::HTTP::Get.new("/api/v1/raids")
        response = http.request(request)
        @raids = ActiveSupport::JSON.decode(response.body)
  end

  def create
  end

  def details
	uri = URI('http://dotards.net:3000/api/v1/raids/details')
	uri.query = URI.encode_www_form(params)
	puts params[:id]
	res = Net::HTTP.get_response(uri)
	res.body.force_encoding("ISO-8859-1").encode("UTF-8")
	@raiddetails = ActiveSupport::JSON.decode(res.body)
	@raid = @raiddetails["raid"]
	@@currentraid = @raid
	if session[:logged_in].nil?
	 #if user is not logged in don't do anything (view only mode)
	else
	 	#Check if user is already signed up for the raid
	 	http = Net::HTTP.new("api.dotards.net", 3000)

        request = Net::HTTP::Post.new("/api/v1/raids/signedup")
        request.set_form_data({"id" => @raid["id"], "userid" => session[:user_id]})
        response = http.request(request)

        json = ActiveSupport::JSON.decode(response.body)
        @signedup = json["signedup"]
	end
  end

  def signup
    http = Net::HTTP.new("api.dotards.net", 3000)

    #Have user select character and role
    request = Net::HTTP::Post.new("/api/v1/raids/sign_up")
    request.set_form_data({"id" => @@currentraid["id"], "userid" => session[:user_id], "characterid" => "4", "role" => "ROLE"})
    response = http.request(request)

    json = ActiveSupport::JSON.decode(response.body)
    code = json["code"]
    if code == 0
	redirect_to :controller => 'raids', :action => 'details', :id => @@currentraid["id"]
    end
  end

  def signoff

    http = Net::HTTP.new("api.dotards.net", 3000)

  	#Have user select character and role
    request = Net::HTTP::Post.new("/api/v1/raids/sign_off")
    request.set_form_data({"id" => @@currentraid["id"], "userid" => session[:user_id]})

    puts 'Sign Off'
    response = http.request(request)

    json = ActiveSupport::JSON.decode(response.body)
    code = json["code"]
    if code == 0
    	redirect_to :controller => 'raids', :action => 'details', :id => @@currentraid["id"]
    end

  end
end
