require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/user_repository'
require_relative 'lib/space_repository'
# require_relative 'lib/reservation_repository'

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
    repo_users = UserRepository.new
    @user = User.new
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.email = params[:email]
    @user.password = params[:password]
    repo_users.create(@user)
    ### to look into user_id and sessions
    session[:user_id] = @user.user_id
    return erb(:spaces) ###
    # to add a conditional - if the input data is correct
  end
  
  get "/login" do
    return erb(:login)
  end
  
  post '/login' do
    user_repo = UserRepository.new
    if user_repo.valid_login?(params[:email], params[:password])
      @user = user_repo.find_by_email(params[:email])
      ### to look into user_id and sessions
      session[:user_id] = @user.user_id
      return erb(:spaces) ###
      # to add a conditional - if the input data is correct
    end
  end

  ###    erb(:spaces) - to copy from Karolina's index page + add "logout" +create space + session

end