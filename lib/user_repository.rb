require "user"
require "database_connection"

class UserRepository
  def all
    sql = "SELECT * FROM users;"
    result_set = DatabaseConnection.exec_params(sql, [])
    users = []
    result_set.each do |result|
      user = assign_user(result)
      users << user
    end
    return users
  end

  def create_user(new_user)
    sql = "INSERT INTO users (first_name, last_name, email, password) VALUES
    ($1, $2, $3, crypt($4, gen_salt('bf',4)));"
    params = [new_user.first_name, new_user.last_name, new_user.email, new_user.password]
    result_set = DatabaseConnection.exec_params(sql, params)
  end

  def delete_user(first_name, last_name, email)
    sql = "DELETE FROM users WHERE users.first_name = $1 AND users.last_name = $2 AND users.email = $3;"
    params = [first_name, last_name, email]
    DatabaseConnection.exec_params(sql, params)
    return nil
  end

  def find_user(first_name, email)
    sql = "SELECT * FROM users WHERE users.first_name = $1 AND users.email = $2;"
    params = [first_name, email]
    result_set = DatabaseConnection.exec_params(sql, params)
    if result_set.to_a.empty?
      return nil
    else
      found_user = assign_user(result_set[0])
    end
    return found_user
  end

  def valid_login?(email, password)
    sql = "SELECT * FROM users WHERE users.email = $1 AND users.password = crypt($2, password);"
    params = [email, password]
    result_set = DatabaseConnection.exec_params(sql, params)
    result_set.to_a.empty? ? false : true
  end

  private

  def assign_user(result)
    user = User.new
    user.user_id = result["user_id"]
    user.first_name = result["first_name"]
    user.last_name = result["last_name"]
    user.email = result["email"]
    user.password = result["password"]
    return user
  end
end