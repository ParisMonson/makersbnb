# require_relative "../lib/space_repository"

# def reset_tables
#   seed_sql = File.read("seeds/makers_bnb_test.sql")
#   connection = PG.connect({ host: "127.0.0.1", dbname: "makers_bnb_test" })
#   connection.exec(seed_sql)
# end

# describe SpaceRepository do
#   before(:each) do
#     reset_tables
#   end

#   it "returns all spaces" do
#     repo = SpaceRepository.new
#     spaces = repo.all

#     expect(spaces.length).to eq
#     expect(spaces.first.address).to eq
#     expect(spaces.first.title).to eq
#     expect(spaces.first.description).to eq
#     expect(spaces.first.available_from)
#     expect(spaces.first.available_to).to eq
#     expect(spaces.last.address).to eq
#     expect(spaces.last.title).to eq
#     expect(spaces.last.description).to eq
#     expect(spaces.last.available_from)
#     expect(spaces.last.available_to).to eq
#   end

#   it "finds a space by host_id" do
#     repo = SpaceRepository.new
#     space = repo.find_by_host_id()

#     expect(space.address).to eq
#     expect(space.title).to eq
#     expect(space.description).to eq
#     expect(space.available_from)
#     expect(space.available_to).to eq
#   end

#   it "adds a new space to the repo" do
#     repo = SpaceRepository.new
#     spaces = repo.all
#     repo.create(double(:space, address: "address", title: "title", description: "description", available_from: "2022/07/19", available_to: "2022/08/01"))

#     expect(spaces.length).to eq
#     expect(spaces.last.address).to eq
#     expect(spaces.last.title).to eq
#     expect(spaces.last.description).to eq
#     expect(spaces.last.available_from)
#     expect(spaces.last.available_to).to eq
#   end

#   it "deletes a space from the repo" do
#     repo = SpaceRepository.new
#     spaces = repo.all
#     space = spaces.last

#     repo.delete(space)
#     expect(spaces.length).to eq
#     expect(spaces.last.address).to eq
#     expect(spaces.last.title).to eq
#     expect(spaces.last.description).to eq
#     expect(spaces.last.available_from)
#     expect(spaces.last.available_to).to eq
#   end

#   it "updates the description of a space" do
#     repo = SpaceRepository.new
#     spaces = repo.all
#     space = spaces.first
#     space.description = "new description"

#     repo.update_description(space)

#     expect(spaces.first.description).to eq "new description"
#   end

#   it "updates the title of a space" do
#     repo = SpaceRepository.new
#     spaces = repo.all
#     space = spaces.first
#     space.title = "new title"

#     repo.update_title(space)

#     expect(spaces.first.title).to eq "new title"
#   end

#   it "updates the availability of a space" do
#   end
# end
