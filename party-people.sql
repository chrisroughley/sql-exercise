DROP DATABASE IF EXISTS party_people;
CREATE DATABASE party_people;

\c party_people;

CREATE TABLE parties (
  party_id SERIAL PRIMARY KEY,
  party_name VARCHAR NOT NULL,
  party_location VARCHAR NOT NULL,
  party_date TIMESTAMP NOT NULL
);

CREATE TABLE drinks (
  drink_id SERIAL PRIMARY KEY,
  drink_name VARCHAR NOT NULL,
  description VARCHAR NOT NULL
);

CREATE TABLE team_members (
  member_id SERIAL PRIMARY KEY,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  favourite_drink_id INT REFERENCES drinks(drink_id)
);

CREATE TABLE party_attendees (
  party_id INT,
  attending_member_id INT,
  FOREIGN KEY (party_id) REFERENCES parties(party_id),
  FOREIGN KEY (attending_member_id) REFERENCES team_members(member_id),
  PRIMARY KEY (party_id, attending_member_id)
);

INSERT INTO parties 
  (party_name, party_location, party_date)
VALUES
  ('Christmas Party', 'The French - Manchester', '2021-12-20 19:00:00'),
  ('Summber BBQ', 'Chris''s house - Bolton', '2022-07-25 18:00:00');

INSERT INTO drinks
  (drink_name, description)
VALUES
  ('Pepsi', 'Cola flavoured carbonated soft drink'),
  ('Peroni', 'Italian pale larger'),
  ('Martini', 'Cocktail made with gin and vermouth'),
  ('Fanta', 'Orange flavoured carbonated soft drink'),
  ('Snowball', 'Cocktail made with Advocaat and lemonade'),
  ('Amstel', 'Light pilsner malt larger');

INSERT INTO team_members
  (first_name, last_name, favourite_drink_id)
VALUES
  ('Joe', 'Bloggs', 1),
  ('Lisa', 'Sue', 1),
  ('John', 'Doe', 2),
  ('Mary', 'Jane', NULL),
  ('Gareth', 'Barry', 3),
  ('Elon', 'Musk', 5),
  ('Greta', 'Thunberg', NULL);

INSERT INTO party_attendees
  (party_id, attending_member_id)
VALUES
  (1,1),
  (1,2),
  (1,3),
  (1,6),
  (2,2),
  (2,3),
  (2,4),
  (2,5),
  (2,7);
  
SELECT party_date FROM parties
WHERE party_name = 'Christmas Party';

SELECT team_members.first_name, team_members.last_name, team_members.favourite_drink_id 
FROM party_attendees
JOIN team_members ON team_members.member_id = party_attendees.attending_member_id
JOIN parties ON parties.party_id = party_attendees.party_id
WHERE party_name = 'Christmas Party';

SELECT parties.party_name, COUNT(party_attendees.party_id)::INT AS number_of_people 
FROM party_attendees
JOIN parties ON parties.party_id = party_attendees.party_id
GROUP BY parties.party_name
ORDER BY number_of_people DESC;