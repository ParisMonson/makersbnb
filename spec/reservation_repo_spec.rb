require_relative '../lib/reservation_repository'
require_relative '../lib/user_repository'

def reset_tables
  sql_seed = File.read('/Users/paris/Desktop/Projects/makersbnb/spec/seeds/makers_bnb_seed.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makers_bnb_test' })
  connection.exec(sql_seed)
end

RSpec.describe ReservationRepository do
  before(:each) do
    reset_tables
  end

  it "gets all reservations" do
    repo =  ReservationRepository.new
    reservations = repo.all
    expect(reservations.length).to eq 4
    expect(reservations[0].start_date).to eq "2022-07-22"
    expect(reservations[0].end_date).to eq "2022-07-31"
    expect(reservations[0].number_night).to eq 9
    expect(reservations[0].confirmed).to eq "t"
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
  it "finds a reservation by Host_id" do
    reservation_repo = ReservationRepository.new
    user_repo = UserRepository.new
    binding.irb
    users = user_repo.all
    id = users[0].user_id
    reservations = reservation_repo.find_by_user(id)
    expect(reservations[0].start_date).to eq "2022-09-01"
    expect(reservations[0].end_date).to eq "2022-09-07"
    expect(reservations[0].number_nights).to eq 6
    expect(reservations[0].confirmed).to eq "f"

    expect(reservations[1].start_date).to eq "2022-07-22"
    expect(reservations[1].end_date).to eq "2022-07-31"
    expect(reservations[1].number_nights).to eq 9
    expect(reservations[1].confirmed).to eq "t"
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
  xit "deletes a reservation by id" do
    repo = ReservationRepository.new
    repo.delete(1)
    reservations = repo.all
    expect(reservations.length).to eq X
    expect(reservations.first.id).to eq(2)
  end

  
end