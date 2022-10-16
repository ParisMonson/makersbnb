require_relative './reservation'

class ReservationRepository
  def all
    sql = "SELECT * FROM reservations;"
    result_set = DatabaseConnection.exec_params(sql, [])
    convert(result_set)
  end

  def find_by_host(host_id)
    sql = "SELECT * FROM reservations WHERE host_id=$1;"
    result_set = DatabaseConnection.exec_params(sql, [host_id])
    return nil if result_set.to_a.length == 0
    convert(result_set)
  end

  def find_by_guest(guest_id)
    sql = "SELECT * FROM reservations WHERE guest_id=$1;"
    result_set = DatabaseConnection.exec_params(sql, [guest_id])
    return nil if result_set.to_a.length == 0
    convert(result_set)
  end

  def find_by_id(reservation_id)
    sql = "SELECT * FROM reservations WHERE reservation_id=$1;"
    result_set = DatabaseConnection.exec_params(sql, [reservation_id])
    return nil if result_set.to_a.length == 0
    record = result_set[0]
    assign_reservation(record)
  end

  def create(reservation)
    sql = "INSERT INTO reservations(host_id, guest_id, space_id, start_date, end_date, number_night, confirmed)
    VALUES($1, $2, $3, $4, $5, $6, $7);"
    params = [
      reservation.host_id,
      reservation.guest_id,
      reservation.space_id,
      reservation.start_date,
      reservation.end_date,
      reservation.number_night,
      reservation.confirmed
    ]
    DatabaseConnection.exec_params(sql, params)
  end

  def delete(reservation_id)
    sql = "DELETE FROM reservations WHERE reservation_id = $1;"
    DatabaseConnection.exec_params(sql, [reservation_id])
  end

  def confirm_reservation(reservation_id)
    sql = "UPDATE reservations SET confirmed = 't' WHERE reservation_id = $1;"
    DatabaseConnection.exec_params(sql, [reservation_id])
  end

  private

  def convert(result_set)
    reservations = []
    result_set.each do |record|
      reservations << assign_reservation(record)
    end
    reservations
  end

  def assign_reservation(record)
    reservation = Reservation.new
    reservation.reservation_id = record["reservation_id"]
    reservation.host_id = record["host_id"]
    reservation.guest_id = record["guest_id"]
    reservation.space_id = record["space_id"]
    reservation.start_date = record["start_date"]
    reservation.end_date = record["end_date"]
    reservation.number_night = record["number_night"].to_i
    reservation.confirmed = record["confirmed"]
    return reservation
  end
end