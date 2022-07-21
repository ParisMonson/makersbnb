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

  get "/:host_name/:title" do
    @host_name = params[:host_name].split("_").join(" ")
    @title = params[:title].split("_").join(" ")

    @space = SpaceRepository.new.find_by_title(@title)[0]

    erb :individual_space
  end

  get "/newspace" do
    p session[:user_id]
    if session[:user_id] == nil
      return "not logged in"
    end
    return erb(:new_space)
  end

  post "/newspace" do
    p session[:user_id]
    @host_id = session[:user_id]
    #  @user = repo_users.find_user(params[:email])
   # session[:user_id]
    repo_spaces = SpaceRepository.new
    new_space = Space.new
    p new_space.title = params[:title]
    p new_space.description = params[:description]
   p  new_space.address = params[:address]
    p new_space.price_per_night = params[:price_per_night]
    # new_space.available_from = params[:available_from]
    # new_space.available_to = params[:available_to]
    p new_space.host_id = session[:user_id]
    repo_spaces.create(new_space)

   
    # redirect "/signup/success" 
  end
end


#---   <input type="hidden" name="host_id" value=<%session[:user_id]%>/>