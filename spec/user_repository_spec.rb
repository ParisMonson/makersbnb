require "user"
require "user_repository"

def reset_users_table
  sql_seed = File.read("spec/seeds/makers_bnb.sql")
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
    end
  end

  context "all#" do
    it "Returns all existing users with all their data" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = "Paris"
      new_user.last_name = "Monson"
      new_user.email = "paris@mail.com"
      new_user.password = "123"
      repo.create_user(new_user)
      new_user2 = User.new
      new_user2.first_name = "Ev"
      new_user2.last_name = "Sivtsova"
      new_user2.email = "ev@mail.com"
      new_user2.password = "hi"
      repo.create_user(new_user2)
      users = repo.all
      expect(users.length).to eq(2)
      expect(users.first.first_name).to eq("Paris")
      expect(users.last.first_name).to eq("Ev")
    end
  end

  context "delete_user(first_name, last_name, email)# method" do
    it "deletes a user when first_name and last_name match existing user record" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = "Paris"
      new_user.last_name = "Monson"
      new_user.email = "paris@mail.com"
      new_user.password = "123"
      repo.create_user(new_user)
      expect(repo.all.length).to eq(1)
      expect { repo.delete_user("Paris", "Monson", "paris@mail.com") }.not_to raise_error
      expect(repo.all.length).to eq(0)
    end
    it "fails to delete a user when first_name and last_name do not match existing user record" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = "Paris"
      new_user.last_name = "Sovtsova"
      new_user.email = "paris@mail.com"
      new_user.password = "123"
      repo.create_user(new_user)
      expect(repo.all.length).to eq(1)
      repo.delete_user("Paris", "Sovstova", "paris@mail.com")
      expect(repo.all.length).to eq(1)
    end
  end

  context "find_user(first_name, email)#" do
    it "returns user details correctly for correct firstname and email" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = "Paris"
      new_user.last_name = "Monson"
      new_user.email = "paris@mail.com"
      new_user.password = "123"
      repo.create_user(new_user)
      expect(repo.all.length).to eq(1)
      user_id = repo.all[0].user_id
      found_user = repo.find_user("Paris", "paris@mail.com")
      expect(found_user.user_id).to eq(user_id)
      expect(found_user.last_name).to eq("Monson")
    end

    it "does not return user details for incorrect firstname and email" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = "Paris"
      new_user.last_name = "Monson"
      new_user.email = "paris@mail.com"
      new_user.password = "123"
      repo.create_user(new_user)
      expect(repo.all.length).to eq(1)
      user_id = repo.all[0].user_id
      found_user = repo.find_user("Paris", "joe@mail.com")
      expect(found_user).to eq(nil)
    end
  end

  context "valid_login?#" do
    it "returns true if entered username and password match those in the system" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = "Paris"
      new_user.last_name = "Monson"
      new_user.email = "paris@mail.com"
      new_user.password = "123"
      repo.create_user(new_user)
      expect(repo.all.length).to eq(1)
      expect(repo.valid_login?("paris@mail.com", "123")).to eq(true)
    end

    it "returns false if entered username and password do not match those in the system" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = "Paris"
      new_user.last_name = "Monson"
      new_user.email = "paris@mail.com"
      new_user.password = "123"
      repo.create_user(new_user)
      expect(repo.all.length).to eq(1)
      expect(repo.valid_login?("joe@mail.com", "123")).to eq(false)
    end

    it "returns false if neither username of password match those in the system" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = "Paris"
      new_user.last_name = "Monson"
      new_user.email = "paris@mail.com"
      new_user.password = "123"
      repo.create_user(new_user)
      expect(repo.all.length).to eq(1)
      expect(repo.valid_login?("joe@mail.com", "12345")).to eq(false)
    end

    it "returns true for 2 succesful logins" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = "Paris"
      new_user.last_name = "Monson"
      new_user.email = "paris@mail.com"
      new_user.password = "123"
      repo.create_user(new_user)
      new_user2 = User.new
      new_user2.first_name = "Ev"
      new_user2.last_name = "Sivtsova"
      new_user2.email = "ev@mail.com"
      new_user2.password = "hi"
      repo.create_user(new_user2)
      expect(repo.all.length).to eq(2)
      expect(repo.valid_login?("paris@mail.com", "123")).to eq(true)
      expect(repo.valid_login?("ev@mail.com", "hi")).to eq(true)
    end
  end

  it "finds a user by id" do
    repo = UserRepository.new
    new_user = User.new
    new_user.first_name = "Paris"
    new_user.last_name = "Monson"
    new_user.email = "paris@mail.com"
    new_user.password = "123"
    repo.create_user(new_user)
    user_id = repo.all.first.user_id
    found_user = repo.find_by_id(user_id)

    expect(found_user.first_name).to eq "Paris"
    expect(found_user.email).to eq "paris@mail.com"
  end
end
