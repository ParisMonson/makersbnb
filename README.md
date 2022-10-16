MakersBNB
=================

<div align="left">
  <img alt="GitHub top language" src="https://img.shields.io/github/languages/top/EvSivtsova/makersbnb">
</div>
<div>
  <img src="https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white"/>&nbsp
  <img src="https://img.shields.io/badge/Sinatra-black?style=for-the-badge&logo=Sinatra&logoColor=white" alt="Sinatra"/>
  <img src="https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white"/> 
  <img src="https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white"/>
  <img src="https://img.shields.io/badge/css3-%231572B6.svg?style=for-the-badge&logo=css3&logoColor=white"/>
  <img src="https://img.shields.io/badge/RSpec-blue?style=for-the-badge&logo=Rspec&logoColor=white" alt="Rspec"/>
</div><br>

This is a Makers' Academy challenge from week 5.

We were asked to create a web app that connects property owners and potential renters, similar to AirBnb.

## Meet the team

* [Ev](https://github.com/EvSivtsova)<br>
* [Joe](https://github.com/Joseph-ER)<br>
* [Karolina](https://github.com/karolina-codes)
* [Paris](https://github.com/ParisMonson)<br>

## Code Design

We followed MVC model when working on this chalenge. We designed **three schemas** with PostgreSQL:
1. Users (can be both renters and hosts).
2. Spaces that can be rented. This schema references the users table to identify hosts. 
3. Reservations that stores the details of the reservations:
   * the space rented out - references the spaces schema.
   * the renter and host identities - references the users schema.
   * the start and the end date of the booking.
   
These schemas gave us enough flexibility to develop features in line with our user stories while minimizing the duplication of the data.

While creating the database and the seeds, we've test-driven models that are responsible for CRUD operations, which operate on their respective schemas:

1. User and User Repository Classes
2. Space and Space Repository Classes
3. Reservation and Reservation Repository Classes

Afterwards we've test-driven the Application class, which functions as a controller, and the views, thus connecting the frontend and the backend. 

The result is a simple app that allows the users to create accounts, and list and rent spaces with the use of a calendar.

Following the completion of the group project, I added some additional tests to increase coverage and cover more edge cases, and refactored some of the code (wip). 

## TechBit

Technologies used:

* Ruby(3.0.0)
* RVM(1.29.12)
* Sinatra(2.2)
* Rack-test (2.0)
* PG(1.4)
* Webrick(1.7)

Testing:
* Rspec(3.11)
* Simplecov(Test Coverage)
* Rubocop(1.20)

Clone the repository and run bundle install to install the dependencies within the folder:

```
git clone https://github.com/EvSivtsova/makersbnb.git
cd makersbnb
bundle install
```

To run the app in the browser:

```
createdb makersbnb
psql -h 127.0.0.1 makersbnb < spec/seeds/makers_bnb.sql
rackup
```

Go to `http://localhost:9292` to play with the app.

To run the tests:

```
createdb makers_bnb_test
rspec
rubocop
```
Please view screenshots of some of the test results [here](https://github.com/EvSivtsova/makersbnb/tree/main/outputs).
