CREATE EXTENSION IF NOT EXISTS citext;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DROP TABLE IF EXISTS "public"."users";

CREATE TABLE IF NOT EXISTS users (
  user_id uuid DEFAULT uuid_generate_v4 (),
  first_name text NOT NULL,
  last_name text NOT NULL,
  email citext NOT NULL UNIQUE,
  password text NOT NULL,
  PRIMARY KEY (user_id)
);