require 'sinatra'
require "sinatra/reloader"

# Run this script with `bundle exec ruby app.rb`
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
if ENV['DATABASE_URL']
  require 'pg'
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  require 'sqlite3'
  ActiveRecord::Base.establish_connection(
    adapter: 'sqlite3',
    database: 'db/development.db'
  )
end

register Sinatra::Reloader
enable :sessions
set :port, 7777

get '/' do
  erb :login
end

get '/home' do
  @user = User.find(session[:user_id])
  @users = User.all
  @posts = Post.all
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

post '/home' do
  @user = User.find(session[:user_id])
  @userPost = Post.create(user_id: session[:user_id], username: @user.username, input: params["input"], title: params["title"])
  redirect '/home'
end

get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

get '/profile' do
  erb :profile
end
