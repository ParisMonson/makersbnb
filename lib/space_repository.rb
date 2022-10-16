require_relative "space"

class SpaceRepository
  def all
    sql = "SELECT * FROM spaces;"
    result_set = DatabaseConnection.exec_params(sql, [])

    map_PG_to_objects(result_set) # returns array of space objects
  end

  def find_by_host_id(host_id)
    sql = "SELECT * FROM spaces WHERE host_id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [host_id])

    map_PG_to_objects(result_set) # returns array of space objects
  end

  def find_by_title(title)
    sql = "SELECT * FROM spaces WHERE title = $1;"
    result_set = DatabaseConnection.exec_params(sql, [title])

    map_PG_to_objects(result_set) # returns array of space objects
  end

  def create(space)
    sql = "INSERT INTO spaces (title, description, address, price_per_night, available_from, available_to, host_id) VALUES ($1, $2, $3, $4, $5, $6, $7);"
    result_set = DatabaseConnection.exec_params(sql, [space.title, space.description, space.address, space.price_per_night, space.available_from, space.available_to, space.host_id])

    # side effect: returns PG object
  end

  def delete(space)
    sql = "DELETE FROM spaces WHERE space_id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [space.space_id])
    # side effect: returns PG object
  end

  def update_availability(space)
    sql = "UPDATE spaces SET available_from = $1, available_to = $2 WHERE space_id = $3;"
    result_set = DatabaseConnection.exec_params(sql, [space.available_from, space.available_to, space.space_id])

    # side effect: returns PG object
  end

  def update_description(space)
    sql = "UPDATE spaces SET description = $1 WHERE space_id = $2;"
    result_set = DatabaseConnection.exec_params(sql, [space.description, space.space_id])

    # side effect: returns PG object
  end

  def update_title(space)
    sql = "UPDATE spaces SET title = $1 WHERE space_id = $2;"
    result_set = DatabaseConnection.exec_params(sql, [space.title, space.space_id])

    # side effect: returns PG object
  end

  def find_by_space_id(space_id)
    sql = "SELECT * FROM spaces WHERE space_id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [space_id])

    map_PG_to_objects(result_set) # returns array of space objects
  end

  private

  def map_PG_to_objects(result_set)
    spaces = []

    result_set.each do |record|
      space = Space.new
      space.space_id = record["space_id"]
      space.title = record["title"]
      space.description = record["description"]
      space.address = record["address"]
      space.price_per_night = record["price_per_night"]
      space.available_from = record["available_from"]
      space.available_to = record["available_to"]
      space.host_id = record["host_id"]

      spaces << space
    end

    spaces
  end
end
