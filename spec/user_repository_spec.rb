require 'user'
require 'user_repository'

def reset_users_table
  sql_seed = File.read('spec/seeds/makers_bnb.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec_params(sql_seed)
end

describe UserRepository do
  before(:each) do
    reset_users_table
  end

  context 'create_user#' do
    it 'Adds a new user to the users table' do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = 'Paris'
      new_user.last_name = 'Monson'
      new_user.email = 'paris@mail.com'
      new_user.password = '123'
      expect { repo.create_user(new_user) }.not_to raise_error
    end
  end

  context 'all#' do
    it 'Returns all existing users with all their data' do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = 'Paris'
      new_user.last_name = 'Monson'
      new_user.email = 'paris@mail.com'
      new_user.password = '123'
      repo.create_user(new_user)
      new_user2 = User.new
      new_user2.first_name = 'Ev'
      new_user2.last_name = 'Sivtsova'
      new_user2.email = 'ev@mail.com'
      new_user2.password = 'hi'
      repo.create_user(new_user2)
      users = repo.all
      expect(users.length).to eq(2)
      expect(users.first.first_name).to eq('Paris')
      expect(users.last.first_name).to eq('Ev')
    end
  end

  context "delete_user(first_name, last_name, email)# method" do
    it "deletes a user when first_name and last_name match existing user record" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = 'Paris'
      new_user.last_name = 'Monson'
      new_user.email = 'paris@mail.com'
      new_user.password = '123'
      repo.create_user(new_user)
      expect(repo.all.length).to eq(1)
      expect { repo.delete_user("Paris", "Monson", "paris@mail.com")  } .not_to raise_error
      expect(repo.all.length).to eq(0)
    end
    it "fails to delete a user when first_name and last_name do not match existing user record" do
      repo = UserRepository.new
      new_user = User.new
      new_user.first_name = 'Paris'
      new_user.last_name = 'Sovtsova'
      new_user.email = 'paris@mail.com'
      new_user.password = '123'
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
      new_user.first_name = 'Paris'
      new_user.last_name = 'Monson'
      new_user.email = 'paris@mail.com'
      new_user.password = '123'
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
      new_user.first_name = 'Paris'
      new_user.last_name = 'Monson'
      new_user.email = 'paris@mail.com'
      new_user.password = '123'
      repo.create_user(new_user)
      expect(repo.all.length).to eq(1)
      user_id = repo.all[0].user_id
      found_user = repo.find_user("Paris", "joe@mail.com")
      expect(found_user).to eq(nil)
    end
  end

end