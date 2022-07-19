require 'spec_helper'
require "rack/test"
require_relative '../../app'

describe Application do
  include Rack::Test::Methods


  let(:app) { Application.new }

  context "GET /signup" do
    it 'returns 200 OK' do
      response = get('/signup')
      expect(response.status).to eq(200)
      expect(response.body).to include("</form>")
      expect(response.body).to include("<html>")
      expect(response.body).to include("Create Account")
    end
  end

  context "POST /signup" do
    it 'redirects to /signup/success if credentials uniq.' do

      response = post('/signup', params = { email: "parismonson@yahoo.com", password: "hash_password" })
      last_response.should be_redirect
      follow_redirect!
      last_request.url.should == "http://example.org/signup/success"
    end
  end
end