require "net/http"
class LoginController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => :create
skip_before_filter :require_login
  def index
  end
  def login
  	http = Net::HTTP.new("api.dotards.net", 3001)
	
	request = Net::HTTP::Post.new("/api/v1/users/login")
	request.set_form_data({"username" => params[:username], "password" => params[:password]})
	puts params[:username]
	#http.set_form_data({"q" => "ruby", "lang" => "en"}, ';')
	response = http.request(request)

	# Use nokogiri, hpricot, etc to parse response.body.

	#request = Net::HTTP::Get.new("/users/1")
	#response = http.request(request)
	# As with POST, the data is in response.body.

	#request = Net::HTTP::Put.new("/users/1")
	#request.set_form_data({"users[login]" => "changed"})
	#response = http.request(request)

	#request = Net::HTTP::Delete.new("/users/1")
	#response = http.request(request)
  end
  def auth
    http = Net::HTTP.new("api.dotards.net", 3000)

    request = Net::HTTP::Post.new("/api/v1/users/login")
    request.set_form_data({"username" => params[:username], "password" => params[:password]})
    puts params[:username]
	response = http.request(request)
	
	#render json: {response: response.body}
	#json_response = JSON.parse(response.body)
	json = ActiveSupport::JSON.decode(response.body)
	code = json["code"]
	user = json["user"]
	if code==0
	  puts 'Logged in redirect to raids activity'
	  session[:user_id] = user["id"]
	  session[:moderator] = user["moderator"]
	  session[:logged_in] = true
	  redirect_to :controller => 'raids', :action => 'index'
	else
	  puts 'Wrong username or password entered try again bitch'
	  redirect_to :controller => 'login', :action => 'index'
	end
	
        #http.set_form_data({"q" => "ruby", "lang" => "en"}, ';')
        #        response = http.request(request)
        #
  end
  def register

  end
end
