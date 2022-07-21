require "spec_helper"
require "rack/test"
require_relative "../../app"

def reset_makers_bnb_table
  seed_sql = File.read("spec/seeds/makers_bnb_seed.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makers_bnb_test" })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do
    reset_makers_bnb_table
  end

  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /signup" do
    it "returns 200 OK" do
      response = get("/signup")
      expect(response.status).to eq(200)
      expect(response.body).to include("</form>")
      expect(response.body).to include("<html>")
      expect(response.body).to include("Create Account")
      expect(response.body).to include('<input type="text" name="first_name"/><br>')
      expect(response.body).to include('<input type="text" name="last_name"/><br>')
      expect(response.body).to include('<input type="email" name="email"/><br>')
      expect(response.body).to include('<input type="password" name="password"/><br>')
      expect(response.body).to include('<input type="submit" class="submit_button" value="sign up"/>')
    end
  end

  context "POST /signup" do
    it 'create a new user and redirects to /signup/success' do
      response = post('/signup', params = { first_name: "Paris", last_name: "Monson", email: "parismonson@yahoo.com", password: "hash_password" })
    
      expect(last_response).to be_redirect

      user_repo = UserRepository.new.all
      expect(user_repo).to include(
        have_attributes(first_name: "Paris", last_name: "Monson", email: "parismonson@yahoo.com")
      ) 
      ### add tests for spaces
    end
  end

  context "GET /login" do
    it "returns 200 OK" do
      response = get("/login")
      expect(response.status).to eq(200)
      expect(response.body).to include("</form>")
      expect(response.body).to include("<html>")
      expect(response.body).to include("<h2>Log in</h2>")
      expect(response.body).to include('<input type="email" name="email"/><br>')
      expect(response.body).to include('<input type="password" name="password"/><br>')
      expect(response.body).to include('<input type="submit" class="submit_button" value="log in"/>')
    end
  end

  context "POST /login" do
    it 'redirects to / if email and password have been validated' do
      response = post('/login', params = { email: "test2@example.com", password: "password2" })
      expect(response).to be_redirect  
    end
  end

  context "GET /" do
    it "shows a list of properties" do
      response = get("/")
      expect(response.status).to eq 200
      expect(response.body).to include "Sign up"
      expect(response.body).to include "Login"
      expect(response.body).to include '<div class="spaces_list">'
    end
  end

  context "GET /:host_name/:title" do
    it "shows an individual space page" do
      response = get("/John/beach_view")
      expect(response.status).to eq 200
      expect(response.body).to include "<h1>MakersBNB</h1>"
      expect(response.body).to include '<a href="/" class="home">Go back to homepage</a>'
      expect(response.body).to include "<p>The host of this space is:"
    end
  end
  context "GET /signup/success" do
    it "shows a signup success message" do
      response = get("/signup/success")
      expect(response.status).to eq 200
      expect(response.body).to include("You have successfully created an account!")
      expect(response.body).to include("<html>")
      expect(response.body).to include("<a href='/login'>")
      expect(response.body).to include("<a href='/'>")
    end
  end
  context "GET /login/fail" do
    it "shows a wrong email or password message" do
      response = get("/login/fail")
      expect(response.status).to eq 200
      expect(response.body).to include("<h1>The password or email you entered is incorrect!</h1>")
      expect(response.body).to include("<html>")
      expect(response.body).to include("<body>")
      expect(response.body).to include("<a href='/login'>")
      expect(response.body).to include("a href='/signup'>")
    end
  end

  context "GET /newspace" do
    it "returns 200 OK and form for create a new space" do
      login = post('/login', params = { email: "test2@example.com", password: "password2" })
      response = get("/newspace")
      expect(response.status).to eq 200
      expect(response.body).to include('<form action="/newspace" method="POST">')
      expect(response.body).to include('<input type="text" name="title"/><br>')
      expect(response.body).to include('<input type="text" name="description"/><br>')
      expect(response.body).to include('<input type="text" name="address"/><br>')
      expect(response.body).to include('<input type="int" name="price_per_night"/><br>')
      expect(response.body).to include('<input type="date" name="available_from"/><br>')
      expect(response.body).to include('<input type="date" name="available_to"/><br>')
      expect(response.body).to include('<input type="submit" class="submit_button" value="create space"/>')
    end
  end

  context "POST /newspace" do
    it "returns 200 OK and adds the new user to the database" do
      login = post('/login', params = { email: "test2@example.com", password: "password2" })
      response = post('/newspace', params = { title: "new title", 
        description: "new description", 
        address: "new address", 
        price_per_night: "$250.00"}
        #available_from: "2022-07-20",
        #available_to: "2022-09-20" }
      )
    
      #expect(last_response).to be_redirect

      space_repo = SpaceRepository.new.all
      expect(space_repo).to include(
        have_attributes(title: "new title", 
        description: "new description",
        address: "new address", 
        price_per_night: "$250.00")
        #available_from: "2022-07-20",
        #available_to: "2022-09-20")
      ) 
      ### add tests for spaces
    end
  end
end
