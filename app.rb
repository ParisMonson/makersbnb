require 'sinatra/base'
require 'sinatra/reloader'

# DatabaseConnection.connect

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

  private


end