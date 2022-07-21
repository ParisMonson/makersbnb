require "sinatra/base"
require "sinatra/reloader"
require_relative "lib/database_connection"
require_relative "lib/user_repository"
require_relative "lib/space_repository"
require_relative "lib/reservation_repository"

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
    #I think we need to check that the email is uniq at this stage <<<<<<
    repo_users = UserRepository.new
    new_user = User.new
    new_user.first_name = params[:first_name]
    new_user.last_name = params[:last_name]
    new_user.email = params[:email]
    new_user.password = params[:password]
    repo_users.create_user(new_user)
    @user = repo_users.find_user(params[:email])
    session[:user_id] = @user.user_id
    redirect "/signup/success"
    # to add a conditional - if the input data is correct
  end
  get "/signup/success" do
    return erb(:signup_success)
  end

  get "/login" do
    return erb(:login)
  end

  post "/login" do
    repo_users = UserRepository.new
    if repo_users.valid_login?(params[:email], params[:password])
      @user = repo_users.find_user(params[:email])
      session[:user_id] = @user.user_id
      redirect "/"
      ###
      # to add a conditional - if the input data is correct
    end
    redirect "/login/fail"
  end
  get "/login/fail" do
    return erb(:login_fail)
  end

  get "/logout" do
    session.delete(:user_id)
    redirect "/"
  end

  get "/" do
    @spaces = SpaceRepository.new.all
    @user_repo = UserRepository.new
    @logged_in_user = UserRepository.new.find_by_id(session[:user_id]) if session[:user_id]

    erb :index
  end
  get "/requests" do
    @repo = ReservationRepository.new
    @space_repo = SpaceRepository.new
    @user_repo = UserRepository.new
    @id = session[:user_id]

    return erb(:requests)
  end

  get "/:space_id" do
    space_id = params[:space_id]
    @space = SpaceRepository.new.find_by_space_id(space_id)[0]
    @host_name = UserRepository.new.find_by_id(@space.host_id).first_name

    erb :individual_space
  end
end
