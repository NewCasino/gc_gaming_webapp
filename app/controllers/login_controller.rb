require "net/http"
class LoginController < ApplicationController
  def index
  end
  def login
  	http = Net::HTTP.new("api.dotards.net:3000")

	request = Net::HTTP::Post.new("/api/v1/users/login")
	request.set_form_data({"username" => params[:username], "password" => params[:password]})
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
end
