require_relative 'reservation_repository'

def reset_tables
  sql_seed = File.read('/Users/paris/Desktop/Projects/makersbnb/spec/seed.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(sql_seed)
end

RSpec.describe ReservationRepository do
  before(:each) do
    reset_tables
  end

  it "gets all reservations" do
    repo =  ReservationRepository.new
    reservations = repo.all
    expect(reservations[0].id).to eq 1
    expect(reservations[0].space_id).to eq X
    expect(reservations[0].start_date).to eq X
    expect(reservations[0].end_date).to eq X
    expect(reservations[0].number_nights).to eq X
    expect(reservations[0].confirmed).to eq X
  end

  # xit "creates a new reservation" do
  #   reservation = Reservation.new
  #   reservation_repo = ReservationRepository.new
  #   user_repo = UserRepository.new
  #   users = user_repo.all
  #   host_id = users[0].id
  #   guest_id = users[1].id
  #   reservation.host_id = host_id
  #   reservation.guest_id = guest_id
  #   reservation.space_id = X
  #   reservation.start_date = X
  #   reservation.end_date = X
  #   reservation.number_nights = X
  #   reservation.confirmed = X
  # end
  xit "finds a reservation by ID" do
    repo = ReservationRepository.new
    reservations = repo.find(1)
    expect(reservations[0].id).to eq 1
    expect(reservations[0].start_date).to eq X
    expect(reservations[0].end_date).to eq X
    expect(reservations[0].number_nights).to eq X
    expect(reservations[0].confirmed).to eq X
  end
  # xit "finds a reservation by Guest_id" do
  #   repo = ReservationRepository.new
  #   reservations = repo.all
  #   guest_id = reservations[0].guest_id

  #   reservation = repo.find_by_guest_id(guest_id)

    
  #   expect(reservation[0].start_date).to eq X
  #   expect(reservation[0].end_date).to eq X
  #   expect(reservation[0].number_nights).to eq X
  #   expect(reservation[0].confirmed).to eq X
  # end
  it "deletes a reservation by id" do
    repo = ReservationRepository.new
    repo.delete(1)
    reservations = repo.all
    expect(reservations.length).to eq X
    expect(reservations.first.id).to eq(2)
  end

  
end