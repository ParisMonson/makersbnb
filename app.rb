require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/space_repository"
require_relative "lib/user_repository"

DatabaseConnection.connect

class Application < Sinatra::Base
  # This allows the app code to refresh
  # without having to restart the server.
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

  get "/" do
    @spaces = SpaceRepository.new.all
    @user = UserRepository.new.find_by_id(session[:user_id]) if session[:user_id]
  
    erb :index
  end
end
