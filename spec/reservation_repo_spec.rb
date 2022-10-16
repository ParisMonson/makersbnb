require_relative '../lib/reservation_repository'
require_relative '../lib/user_repository'
require_relative '../lib/space_repository'

def reset_tables
  sql_seed = File.read('spec/seeds/makers_bnb_seed.sql')
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

  it "creates a new reservation" do
    user_repo = UserRepository.new
    space_repo = SpaceRepository.new

    host = user_repo.find_user("ajones@example.com")
    guest = user_repo.find_user("test2@example.com")
    space = space_repo.find_by_title("review view")

    host_id = host.user_id
    guest_id = guest.user_id
    space_id = space[0].space_id

    reservation = Reservation.new
    reservation.host_id = host_id
    reservation.guest_id = guest_id
    reservation.space_id = space_id
    reservation.start_date = "2022-08-20"
    reservation.end_date = "2022-08-25"
    reservation.number_night = 5
    reservation.confirmed = "f"

    reservation_repo = ReservationRepository.new
    reservation_repo.create(reservation)
    reservations = reservation_repo.find_by_guest(guest_id)

    expect(reservations.length).to eq 2
    expect(reservations[1].host_id).to eq host_id
    expect(reservations[1].guest_id).to eq guest_id
    expect(reservations[1].space_id).to eq space_id
    expect(reservations[1].start_date).to eq "2022-08-20"
    expect(reservations[1].end_date).to eq "2022-08-25"
    expect(reservations[1].number_night).to eq 5
    expect(reservations[1].confirmed).to eq "f"
  end

  context "Reservation exists" do
    it "finds a reservation by Host_id" do
      reservation_repo = ReservationRepository.new
      user_repo = UserRepository.new
      user = user_repo.find_user("ajones@example.com")

      id = user.user_id
      reservations = reservation_repo.find_by_host(id)
      expect(reservations[1].start_date).to eq "2022-09-01"
      expect(reservations[1].end_date).to eq "2022-09-07"
      expect(reservations[1].number_night).to eq 6
      expect(reservations[1].confirmed).to eq "f"

      expect(reservations[0].start_date).to eq "2022-07-22"
      expect(reservations[0].end_date).to eq "2022-07-31"
      expect(reservations[0].number_night).to eq 9
      expect(reservations[0].confirmed).to eq "t"
    end

    it "returns nil if the Host doesn't exist" do
      reservation_repo = ReservationRepository.new
      reservation = reservation_repo.find_by_host('bbeb236a-46ba-49e9-b706-b59d0933f3b3')
      expect(reservation).to eq nil
    end

    it "finds a reservation by Guest_id" do
      reservation_repo = ReservationRepository.new
      user_repo = UserRepository.new
      user = user_repo.find_user("ajones@example.com")

      id = user.user_id
      reservations = reservation_repo.find_by_guest(id)
      expect(reservations[0].start_date).to eq "2022-07-19"
      expect(reservations[0].end_date).to eq "2022-08-31"
      expect(reservations[0].number_night).to eq 43
      expect(reservations[0].confirmed).to eq "t"
    end

    it "returns nil if the guest doesn't exist" do
      reservation_repo = ReservationRepository.new
      reservation = reservation_repo.find_by_guest('bbef236a-46ba-49e9-b706-b59d0933f3b3')
      expect(reservation).to eq nil
    end
  end

  it "deletes a reservation by id" do
    repo  = ReservationRepository.new
    expect(repo.all.length).to eq 4
    id = repo.all[-1].reservation_id
    repo.delete(id)
    reservation = repo.all
    expect(reservation.length).to eq 3
  end

  context "when searching by registraton id" do
    it "returns the reservaton object" do
      repo  = ReservationRepository.new
      id = repo.all[0].reservation_id
      reservation = repo.find_by_id(id)
      expect(reservation.start_date).to eq "2022-07-22"
      expect(reservation.end_date).to eq "2022-07-31"
      expect(reservation.number_night).to eq 9
    end

    it "returns nil if the reservation doesn't exist" do
      repo  = ReservationRepository.new
      reservation = repo.find_by_id('bbeb236a-46ba-49e9-b706-b59d0933f3b3')
      expect(reservation).to eq nil
    end
  end
end