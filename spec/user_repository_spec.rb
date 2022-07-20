require_relative "../lib/user"
require_relative "../lib/user_repository"

def reset_users_table
  sql_seed = File.read("spec/seeds/makers_bnb_seed.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makers_bnb_test" })
  connection.exec_params(sql_seed)
end

describe UserRepository do
  before(:each) do
    reset_users_table
  end

  context "create_user#" do
    it "Adds a new user to the users table" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = "Paris"
      new_user.last_name = "Monson"
      new_user.email = "paris@mail.com"
      new_user.password = "123"
      expect { repo.create_user(new_user) }.not_to raise_error
      expect(repo.all.length).to eq(5)
      expect(repo.all).to include(have_attributes(:first_name => "Paris", :last_name => "Monson", :email => "paris@mail.com"))
      # expect(repo.all).to include(have_attributes(:last_name => "Monson"))
      # expect(repo.all).to include(have_attributes(:email => "paris@mail.com"))
    end
  end

  context "all#" do
    it "Returns all existing users with all their data" do
      repo = UserRepository.new
      users = repo.all
      expect(users.length).to eq(4)
      expect(users).to include(have_attributes(:first_name => "Michael", :email => "mt1245@example.com"))
    end
  end

  # context "delete_user(first_name, last_name, email)# method" do
  #   it "deletes a user when first_name and last_name match existing user record" do
  #     repo = UserRepository.new
  #     expect(repo.all.length).to eq(4)
  #     expect { repo.delete_user("Michael", "Tyson", "mt1245@example.com") }.not_to raise_error
  #     expect(repo.all.length).to eq(3)
  #   end
  #   it "fails to delete a user when first_name and last_name and email do not match existing user record" do
  #     repo = UserRepository.new
  #     expect(repo.all.length).to eq(4)
  #     repo.delete_user("Paris", "Tyson", "mt1245@example.com")
  #     expect(repo.all.length).to eq(4)
  #   end
  # end

  context "find_user(first_name, email)#" do
    it "returns user details correctly for correct firstname and email" do
      repo = UserRepository.new
      test_id = repo.all[0].user_id
      user = repo.find_by_id(test_id)
      found_user = repo.find_user(user.first_name, user.email)
      expect(found_user.user_id).to eq(test_id)
    end

    it "does not return user details for incorrect firstname and email" do
      repo = UserRepository.new
      user_id = repo.all[0].user_id
      found_user = repo.find_user("Paris", "joe@mail.com")
      expect(found_user).to eq(nil)
    end
  end

  context "valid_login?#" do
    it "returns true if entered username and password match those in the system" do
      repo = UserRepository.new
      expect(repo.valid_login?("ajones@example.com", "password3")).to eq(true)
    end

    it "returns false if entered username and password do not match those in the system" do
      repo = UserRepository.new
      expect(repo.valid_login?("jones@example.com", "123")).to eq(false)
    end

    it "returns false if neither username of password match those in the system" do
      repo = UserRepository.new
      expect(repo.valid_login?("ajones@example.com", "12345")).to eq(false)
    end
  end

  it "finds a user by id" do
    repo = UserRepository.new
    user_id = repo.all.first.user_id
    found_user = repo.find_by_id(user_id)
    expect(found_user.first_name).to eq(repo.all.first.first_name)
    expect(found_user.email).to eq(repo.all.first.email)
  end
end
