require 'rubygems'
require 'sinatra'
require 'json/ext'
require 'whois'
require 'retriable'
require 'twitter'
require 'yaml'

Dir[File.dirname(__FILE__) + "/models/*.rb"].each {|file| require file }

get '/' do
  @title = "MameNaker"

  erb :home
end

get '/name' do
  @title = 'New Video'
  @user = get_user(params[:fb_id])
  json :chronicle_new
end