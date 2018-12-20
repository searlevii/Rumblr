require 'sinatra'
require "sinatra/reloader"

# Run this script with `bundle exec ruby app.rb`
require 'sqlite3'
require 'active_record'

#require model classes
# require './models/cake.rb'
require './models/post.rb'
require './models/user.rb'

# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'
require 'csv'

# Connect to a sqlite3 database
# If you feel like you need to reset it, simply delete the file sqlite makes
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/development.db'
)

register Sinatra::Reloader
enable :sessions

get '/' do
  erb :login
end

get '/home' do
  erb :home
end

get '/signup' do
  erb :signup
end

post '/signup' do
  new_user = User.create(first_name: params["first_name"], last_name: params["last_name"], email: params["email"], gender: params["gender"], birthday: params["birthday"], password: params["password"], username: params["username"])
  session[:user_id] = new_user.id
  redirect 'home'
end

post '/' do
  customer = User.find_by(username: params["username"], password: params["password"])
  if customer
    session[:user_id] = customer.id
    redirect 'home'
  else 
    redirect '/'
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect '/'
end