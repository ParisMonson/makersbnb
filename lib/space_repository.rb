require_relative "space"

class SpaceRepository
  def all
    sql = "SELECT * FROM spaces;"
    result_set = DatabaseConnection.exec_params(sql, [])
    return nil if result_set.to_a.length == 0
    map_PG_to_objects(result_set) # returns array of space objects
  end

  def find_by_host_id(host_id)
    sql = "SELECT * FROM spaces WHERE host_id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [host_id])
    return nil if result_set.to_a.length == 0
    map_PG_to_objects(result_set) # returns array of space objects
  end

  def find_by_title(title)
    sql = "SELECT * FROM spaces WHERE title = $1;"
    result_set = DatabaseConnection.exec_params(sql, [title])
    return nil if result_set.to_a.length == 0
    map_PG_to_objects(result_set) # returns array of space objects
  end

  def create(space)
    sql = "INSERT INTO spaces (title, description, address, price_per_night, available_from, available_to, host_id) VALUES ($1, $2, $3, $4, $5, $6, $7);"
    DatabaseConnection.exec_params(sql, [space.title, space.description, space.address, space.price_per_night, space.available_from, space.available_to, space.host_id])
    return nil
  end

  def delete(space_id)
    sql = "DELETE FROM spaces WHERE space_id = $1;"
    DatabaseConnection.exec_params(sql, [space_id])
    return nil
  end

  def update_availability(space)
    sql = "UPDATE spaces SET available_from = $1, available_to = $2 WHERE space_id = $3;"
    DatabaseConnection.exec_params(sql, [space.available_from, space.available_to, space.space_id])
    return nil
  end

  def update_description(space)
    sql = "UPDATE spaces SET description = $1 WHERE space_id = $2;"
    DatabaseConnection.exec_params(sql, [space.description, space.space_id])
    return nil
  end

  def update_title(space)
    sql = "UPDATE spaces SET title = $1 WHERE space_id = $2;"
    DatabaseConnection.exec_params(sql, [space.title, space.space_id])
    return nil
  end

  def find_by_space_id(space_id)
    sql = "SELECT * FROM spaces WHERE space_id = $1;"
    result_set = DatabaseConnection.exec_params(sql, [space_id])
    return nil if result_set.to_a.length == 0
    result = result_set[0]
    record_to_object(result)
  end

  private

  def map_PG_to_objects(result_set)
    spaces = []
    result_set.each do |record|
      space = record_to_object(record)
      spaces << space
    end
    spaces
  end

  def record_to_object(record)
    space = Space.new
    space.space_id = record["space_id"]
    space.title = record["title"]
    space.description = record["description"]
    space.address = record["address"]
    space.price_per_night = record["price_per_night"]
    space.available_from = record["available_from"]
    space.available_to = record["available_to"]
    space.host_id = record["host_id"]
    return space
  end  
end
