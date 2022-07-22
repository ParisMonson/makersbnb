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
  enable :sessions

  get "/" do
    @spaces = SpaceRepository.new.all
    @user_repo = UserRepository.new
    @logged_in_user = UserRepository.new.find_by_id(session[:user_id]) if session[:user_id]

    erb :index
  end

  get "/signup" do
    return erb(:signup)
  end

  post "/signup" do
    @error = nil
    signup_input_validation
    if @error != nil
      @error
      return erb(:signup)
    else
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
    end
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

  post "/request/?" do
    available_from = params[:available_from]
    available_to = params[:available_to]
    date_regex = /^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$/

    if date_regex.match?(available_from) && date_regex.match?(available_to)
      redirect "/request/success"
    end

    redirect "/request/fail"
  end

  get "/request/success" do
    erb :request_success
  end

  get "/request/fail" do
    erb :request_fail
  end
  
  get "/requests" do
    unless session[:user_id].nil?
      @reservation_repo = ReservationRepository.new
      @space_repo = SpaceRepository.new
      @user_repo = UserRepository.new
      @id = session[:user_id]
      return erb(:requests)
    end
    redirect "/login"
  end

  get "/newspace" do
    if session[:user_id] == nil
      redirect"/login"
    end
    return erb(:new_space)
  end

  post "/newspace" do
    if session[:user_id] == nil
      redirect"/login"
    end
    @error = nil
    input_validation
    if @error != nil
      p @error
      return erb(:new_space)
    else
      repo_spaces = SpaceRepository.new
      new_space = Space.new
      new_space.title = params[:title]
      new_space.description = params[:description]
      new_space.address = params[:address]
      new_space.price_per_night = params[:price_per_night]
      new_space.available_from = params[:available_from]
      new_space.available_to = params[:available_to]
      new_space.host_id = session[:user_id]
      repo_spaces.create(new_space)
      @space = SpaceRepository.new.find_by_host_id(session[:user_id])[-1]
      @host = UserRepository.new.find_by_id(session[:user_id])
      return erb(:new_space_success)
    end 
  end

  
  get "/:space_id" do
    space_id = params[:space_id]
    @space = SpaceRepository.new.find_by_space_id(space_id)[0]
    @host_name = UserRepository.new.find_by_id(@space.host_id).first_name
    
    erb :individual_space
  end
  
  post "/requests/:reservation_id" do
    repo = ReservationRepository.new
    repo.confirm_reservation(params[:reservation_id])
    redirect "/requests"
  end

  private

  def input_validation
    if (params[:title].length == 0 || params[:address].length == 0 || params[:price_per_night].length == 0 || params[:available_from].length == 0 || params[:available_to.length == 0])
      @error = "missing information error"
    elsif params[:price_per_night].match?(/[^\d.]/)
      @error = "price format error"
    elsif params[:title].match?(/[^\w\s?!.,']/i)
      @error = "invalid title"
    elsif params[:description].match?(/[^\w\s?!.,']/i)
      @error = "invalid description" 
    elsif params[:address].match?(/[^\w\s.,']/i)
      @error = "invalid address"
    end
    return @error
  end

  def signup_input_validation
    repo_users = UserRepository.new
    if ((params[:first_name].length == 0) || (params[:last_name].length == 0) || (params[:email].length == 0) || (params[:password].length == 0))
      @error = "input_missing"
    elsif (params[:first_name].match?(/[^a-z\s-]{2,30}/i)|| params[:last_name].match?(/[^a-z\s-]{2,30}/i))
      @error = "invalid_name"
    elsif !repo_users.find_user(params[:email]).nil?
      @error = "existing_email"
    end
    return @error
  end
  
end
