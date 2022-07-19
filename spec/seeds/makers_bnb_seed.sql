TRUNCATE TABLE users RESTART IDENTITY CASCADE;
TRUNCATE TABLE spaces RESTART IDENTITY CASCADE;
TRUNCATE TABLE reservations RESTART IDENTITY CASCADE;
 
INSERT INTO users (first_name, last_name, email, password) VALUES
('John', 'Parker', 'test2@example.com', crypt('password2', gen_salt('bf', 8))),
('Anna', 'Jones', 'ajones@example.com', crypt('password3', gen_salt('bf', 8))),
('Liz', 'Smith', 'lizs@example.com', crypt('password4', gen_salt('bf', 8))),
('Michael', 'Tyson', 'mt1245@example.com', crypt('password5', gen_salt('bf', 8)));
 
WITH john AS (
   SELECT user_id FROM users WHERE first_name = 'John')
 
 INSERT INTO spaces (title, description, address, price_per_night, available_from, available_to, host_id)
   SELECT 'beach view', 'a modern house on the beach', 'Camber S1 00J', 100, '2022/07/19', '2022/11/19', user_id
   FROM john;
 
WITH anna AS (
   SELECT user_id FROM users WHERE first_name = 'Anna')
  
 INSERT INTO spaces (title, description, address, price_per_night, available_from, available_to, host_id)
   SELECT 'mountain view', 'a modern house in the mountains', 'Alpes 12345', 150, '2022/06/19', '2022/09/19', user_id
   FROM anna;
 
WITH anna AS (
  SELECT user_id FROM users WHERE first_name = 'Anna')
 
  INSERT INTO spaces (title, description, address, price_per_night, available_from, available_to, host_id)
    SELECT 'review view', 'a house in the banks of the Rhodes', 'Crillon 12345', 80,'2022/03/19', '2023/09/19', user_id
    FROM anna; 
 
WITH michael AS (
  SELECT user_id FROM users WHERE first_name = 'Michael')
  
  INSERT INTO spaces (title, description, address, price_per_night, available_from, available_to, host_id)
    SELECT 'city getaway', 'a bright private room in Central London', 'London SW1 0UJ', 300, '2022/07/19', '2023/07/17', user_id
    FROM michael;
 
 
WITH anna AS (
   SELECT user_id AS host_id FROM users WHERE first_name = 'Anna'),
 
  annas_space AS (
    SELECT space_id FROM spaces WHERE address = 'Alpes 12345'),
 
  john AS (
    SELECT user_id AS guest_id FROM users WHERE first_name = 'John')
  
    INSERT INTO reservations (start_date, end_date, number_night, confirmed, host_id, guest_id, space_id)
      SELECT
      '2022-07-22',
      '2022-07-31',
      9,
      true,
      host_id , guest_id, space_id FROM anna, john, annas_space;
 
WITH john AS (
   SELECT user_id AS host_id FROM users WHERE first_name = 'John'),
 
  jones_space AS (
    SELECT space_id FROM spaces WHERE address = 'Camber S1 00J'),
 
  anna AS (
    SELECT user_id AS guest_id FROM users WHERE first_name = 'Anna')
  
    INSERT INTO reservations (start_date, end_date, number_night, confirmed, host_id, guest_id, space_id)
      SELECT
      '2022-07-19',
      '2022-08-31',
      43,
      true,
      host_id , guest_id, space_id FROM john, anna, jones_space;
 
WITH anna AS (
   SELECT user_id AS host_id FROM users WHERE first_name = 'Anna'),
 
  annas_space AS (
    SELECT space_id FROM spaces WHERE address = 'Alpes 12345'),
 
  liz AS (
    SELECT user_id AS guest_id FROM users WHERE first_name = 'Liz')
  
    INSERT INTO reservations (start_date, end_date, number_night, confirmed, host_id, guest_id, space_id)
      SELECT
      '2022-09-01',
      '2022-09-07',
      6,
      false,
      host_id, guest_id, space_id FROM anna, liz, annas_space;
 
WITH michael AS (
   SELECT user_id AS host_id FROM users WHERE first_name = 'Michael'),
 
  michaels_space AS (
    SELECT space_id FROM spaces WHERE address = 'London SW1 0UJ'),
 
  liz AS (
    SELECT user_id AS guest_id FROM users WHERE first_name = 'Liz')
  
    INSERT INTO reservations (start_date, end_date, number_night, confirmed, host_id, guest_id, space_id)
      SELECT
      '2022-12-25',
      '2023-01-05',
      11,
      true,
      host_id , guest_id, space_id FROM michael, liz, michaels_space;