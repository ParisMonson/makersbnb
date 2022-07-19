require 'sinatra/base'
require 'sinatra/reloader'

# DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    enable :sessions
  end

  get "/signup" do
    return erb(:signup)
  end
  post "/signup" do
    # Need UserRepository to check if email is in use
  end