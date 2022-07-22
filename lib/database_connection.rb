require "pg"

class DatabaseConnection
  def self.connect
    if ENV['DATABASE_URL'] != nil
      @connection = PG.connect(ENV['DATABASE_URL'])
      return
    end
    database_name = if ENV["ENV"] == "test"
        "makers_bnb_test"
      else
        "makers_bnb"
      end
    @connection = PG.connect({ host: "127.0.0.1", dbname: database_name })
  end

  def self.exec_params(sql_query, params)
    @connection.exec_params(sql_query, params)
  end
end
