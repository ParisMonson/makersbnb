require_relative 'reservation_repository'

def reset_tables
  sql_seed = File.read('/Users/paris/Desktop/Projects/makersbnb/spec/')
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

  xit "creates a new reservation" do
    reservation = Reservation.new
    reservation.host_id = 1
    reservation.guest_id = 2
    reservation.space_id =
    reservation.start_date = 
    reservation.end_date =
    reservation.number_nights =
    reservation.confirmed =

  end

  
end