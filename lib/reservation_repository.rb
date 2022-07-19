require_relative './reservation'

class ReservationRepository
  def all
    sql = "SELECT * FROM reservations;"
    result_set = DatabaseConnection.exec_params(sql, [])
    convert(result_set)
  end

  # def find_by_guest_id(guest_id)

  # end

  # def find_by_host_id(host_id)

  # end

  # def create(reservation)
  #   sql = "INSERT INTO reservations(host_id, guest_id, space_id, start_date, end_date, number_nights, confirmed)
  #   VALUES($1, $2, $3, $4, $5, $6, $7);"
  #   params = [
  #     reservation.host_id,
  #     reservation.guest_id,
  #     reservation.space_id,
  #     reservation.start_date,
  #     reservation.end_date,
  #     reservation.number_nights,
  #     reservation.confirmed
  #   ]
  #   DatabaseConnection.exec_params(sql, params)
  # end

  def delete(id)
    sql = "DELETE FROM reservations WHERE id=$1;"
    DatabaseConnection.exec_params(sql, [id])
  end

  private

  def convert(result_set)
    reservations = []
    result_set.each do |record|
      reservation = Reservation.new
      reservation.id = record["id"]
      reservation.host_id = record["host_id"]
      reservation.guest_id = record["guest_id"]
      reservation.space_id = record["space_id"]
      reservation.start_date = record["start_date"]
      reservation.end_date = record["end_date"]
      reservation.number_nights = record["number_nights"]
      reservation.confirmed = record["confirmed"]
      reservations << reservation 
    end
  end
end