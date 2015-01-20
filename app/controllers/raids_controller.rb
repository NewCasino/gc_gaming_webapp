class RaidsController < ApplicationController
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
	#SHOW SIGN UP for Raid appropiate
	if @signedup == true
	#show sign off
	else 
        #show sign up
	end
	end
  end

  def signup

  end
  
  def signoff

  end
end
