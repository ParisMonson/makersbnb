require_relative "../lib/space_repository"

def reset_tables
  seed_sql = File.read("spec/seeds/makers_bnb_seed.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "makers_bnb_test" })
  connection.exec(seed_sql)
end

describe SpaceRepository do
  before(:each) do
    reset_tables
  end

  it "returns all spaces" do
    repo = SpaceRepository.new
    spaces = repo.all

    expect(spaces.length).to eq 4
    expect(spaces.first.address).to eq "Camber S1 00J"
    expect(spaces.first.title).to eq "beach view"
    expect(spaces.first.description).to eq "a modern house on the beach"
    expect(spaces.first.price_per_night).to eq "$100.00"
    expect(spaces.first.available_from).to eq "2022-07-19"
    expect(spaces.first.available_to).to eq "2022-11-19"
    expect(spaces.last.address).to eq "London SW1 0UJ"
    expect(spaces.last.title).to eq "city getaway"
    expect(spaces.last.description).to eq "a bright private room in Central London"
    expect(spaces.last.available_from).to eq "2022-07-19"
    expect(spaces.last.available_to).to eq "2023-07-17"
  end

  it "finds a space by host_id" do
    repo = SpaceRepository.new
    host_id = repo.all.first.host_id
    space = repo.find_by_host_id(host_id)[0]

    expect(space.address).to eq "Camber S1 00J"
    expect(space.title).to eq "beach view"
    expect(space.price_per_night).to eq "$100.00"
    expect(space.description).to eq "a modern house on the beach"
    expect(space.available_from).to eq "2022-07-19"
    expect(space.available_to).to eq "2022-11-19"
  end

  it "adds a new space to the repo" do
    repo = SpaceRepository.new
    repo.create(double(:space, address: "address", title: "title", description: "description", price_per_night: "$100.00", available_from: "2022/07/19", available_to: "2022/08/01", host_id: repo.all.first.host_id))
    spaces = repo.all

    expect(spaces.length).to eq 5
    expect(spaces.last.address).to eq "address"
    expect(spaces.last.title).to eq "title"
    expect(spaces.last.price_per_night).to eq "$100.00"
    expect(spaces.last.description).to eq "description"
    expect(spaces.last.available_from).to eq "2022-07-19"
    expect(spaces.last.available_to).to eq "2022-08-01"
  end

  xit "deletes a space from the repo" do
    repo = SpaceRepository.new
    space = repo.all.last
    repo.delete(space)
    spaces = repo.all

    expect(spaces.length).to eq 3
    expect(spaces.last.address).to eq "Crillon 12345 "
    expect(spaces.last.title).to eq "review view"
    expect(spaces.last.description).to eq "a house in the banks of the Rhodes"
    expect(spaces.last.price_per_night).to eq "$80.00"
    expect(spaces.last.available_from).to eq "2022-03-19"
    expect(spaces.last.available_to).to eq "2022-07-17"
  end

  it "updates the description of a space" do
    repo = SpaceRepository.new
    spaces = repo.all
    space = spaces.first
    space.description = "new description"

    repo.update_description(space)

    expect(spaces.first.description).to eq "new description"
  end

  it "updates the title of a space" do
    repo = SpaceRepository.new
    spaces = repo.all
    space = spaces.first
    space.title = "new title"

    repo.update_title(space)

    expect(spaces.first.title).to eq "new title"
  end

  it "updates the availability of a space" do
    repo = SpaceRepository.new
    spaces = repo.all
    space = spaces.last
    space.available_from = "2022-08-01"
    space.available_to = "2022-08-02"
    repo.update_availability(space)

    expect(spaces.last.available_from).to eq "2022-08-01"
    expect(spaces.last.available_to).to eq "2022-08-02"
  end
end
