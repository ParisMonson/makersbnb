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
    it 'create a new user and redirects to /spaces' do
      response = post('/signup', params = { first_name: "Paris", last_name: "Monson", email: "parismonson@yahoo.com", password: "hash_password" })
    
      # expect(response.status).to eq(200)
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
    it 'redirects to /spaces if email and password have been validated' do
      response = post('/login', params = { email: "test2@example.com", password: "password2" })
      expect(response.status).to eq(200)    
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
end
