require 'user'
require 'database_connection'

class UserRepository
  def all
    sql = 'SELECT* FROM users;'
    result_set = DatabaseConnection.exec_params(sql, [])
    users = []
    result_set.each do |result|
      user = assign_user(result)
      users << user
    end
    users
  end

  def assign_user(result)
    user = User.new
    user.first_name = result['first_name']
    user.last_name = result['last_name']
    user.email = result['email']
    user.password = result['password']
    user
  end

  def create_user(new_user)
    sql = 'INSERT INTO users (first_name, last_name, email, password) VALUES
    ($1, $2, $3, $4);'
    params = [new_user.first_name, new_user.last_name, new_user.email, new_user.password]
    DatabaseConnection.exec_params(sql, params)
  end
end
