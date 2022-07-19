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
      new_user.user_id = 1
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
      new_user.user_id = 1
      new_user.first_name = 'Paris'
      new_user.last_name = 'Monson'
      new_user.email = 'paris@mail.com'
      new_user.password = '123'
      repo.create_user(new_user)
      new_user2 = User.new
      new_user2.user_id = 2
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
end
