CREATE EXTENSION IF NOT EXISTS citext;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

--ASSUMPTIONS:
-- users are hosts and guests
-- a host can also be a guest
-- a guest can also be a host
-- one host can have many properties
-- one guest can have many properties
-- one property can have only one host
-- one property can have many guests but one guest at any given time


DROP TABLE IF EXISTS "public"."users" CASCADE;

CREATE TABLE IF NOT EXISTS users (
  user_id uuid DEFAULT uuid_generate_v4 (),
  first_name text NOT NULL,
  last_name text NOT NULL,
  email citext NOT NULL UNIQUE,
  password text NOT NULL,
  PRIMARY KEY (user_id)
);

DROP TABLE IF EXISTS "public"."spaces" CASCADE;

CREATE TABLE IF NOT EXISTS spaces (
  space_id uuid DEFAULT uuid_generate_v4 (),
  title text NOT NULL,
  description varchar (500),
  address text NOT NULL,
  price_per_night money NOT NULL,
  available_from date,
  available_to date,
  host_id uuid NOT NULL,
  PRIMARY KEY (space_id),
  CONSTRAINT fk_host 
    FOREIGN KEY (host_id) REFERENCES users(user_id)
);

DROP TABLE IF EXISTS "public"."reservations" CASCADE;

CREATE TABLE IF NOT EXISTS reservations (
  reservation_id uuid DEFAULT uuid_generate_v4 (),
  host_id uuid NOT NULL,
  guest_id uuid NOT NULL,
  space_id uuid NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  number_night int NOT NULL,
  confirmed boolean,
  PRIMARY KEY (id),
  CONSTRAINT fk_host 
    FOREIGN KEY (host_id) REFERENCES users(user_id),
  CONSTRAINT fk_guest 
    FOREIGN KEY (guest_id) REFERENCES users(user_id),
  CONSTRAINT fk_space 
    FOREIGN KEY (space_id) REFERENCES spaces(space_id)
);

