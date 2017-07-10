-- Table inheritance
CREATE TABLE myschema.premium_liiga_club (
  club_name VARCHAR(50) NOT NULL,
  who_added VARCHAR(30) DEFAULT current_user
);


CREATE TABLE myschema.north_estonia_club ()
  INHERITS (myschema.premium_liiga_club);

CREATE TABLE myschema.other_estonia_club ()
  INHERITS (myschema.premium_liiga_club);

CREATE TABLE myschema.tallinn_club ()
  INHERITS (myschema.north_estonia_club);

INSERT INTO myschema.tallinn_club (club_name) VALUES
  ('Tallinna FC Flora'),
  ('Tallinna FC Levadia'),
  ('Nõmme Kalju FC'),
  ('FCI Tallinn');

-- What happened now?
SELECT * FROM myschema.tallinn_club;
SELECT * FROM myschema.north_estonia_club;
SELECT * FROM myschema.other_estonia_club;
SELECT * FROM myschema.premium_liiga_club;

INSERT INTO myschema.north_estonia_club (club_name) VALUES
  ('JK Narva Trans'),
  ('JK Sillamäe Kalev');

-- What happened?
SELECT * FROM myschema.tallinn_club;
SELECT * FROM myschema.north_estonia_club;
SELECT * FROM myschema.other_estonia_club;
SELECT * FROM myschema.premium_liiga_club;

INSERT INTO myschema.other_estonia_club (club_name) VALUES
  ('Paide Linnameeskond'),
  ('Tartu JK Tammeka'),
  ('Viljandi JK Tulevik'),
  ('Pärnu JK Vaprus');

-- What happened?
SELECT * FROM myschema.tallinn_club;
SELECT * FROM myschema.north_estonia_club;
SELECT * FROM myschema.other_estonia_club;
SELECT * FROM myschema.premium_liiga_club;

-- drop table myschema.premium_liiga_club cascade;

