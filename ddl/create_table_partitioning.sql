-- After postgres 10, partitioning become more native. Lets look the same example.
-- Most popular are range partition and list partition. Range partition is used
-- mostly for dates. List is used for partitioning by common value (like in example)

CREATE TABLE "kaido.kariste".estonia_football_club (
  club_name VARCHAR(50) NOT NULL,
  location VARCHAR,
  who_added VARCHAR(30) DEFAULT current_user
) PARTITION BY LIST(location);

CREATE TABLE "kaido.kariste".club_tallinn
    PARTITION OF "kaido.kariste".estonia_football_club FOR VALUES IN ('TALLINN');

CREATE TABLE "kaido.kariste".club_tartu
    PARTITION OF "kaido.kariste".estonia_football_club FOR VALUES IN ('TARTU');

CREATE TABLE "kaido.kariste".club_other
    PARTITION OF "kaido.kariste".estonia_football_club FOR VALUES IN ('OTHER');

INSERT INTO "kaido.kariste".estonia_football_club (club_name, location) VALUES
  ('Tallinna FC Flora','TALLINN'),
  ('Tallinna FC Levadia','TALLINN'),
  ('Nõmme Kalju FC','TALLINN'),
  ('FCI Tallinn','TALLINN');

-- Like it has seen here. You can insert data to parent and Postgres is now
-- able to
select * from "kaido.kariste".estonia_football_club;
select * from "kaido.kariste".club_tallinn;
select * from "kaido.kariste".club_tartu;

----------------------------------------------------------------------
-- Table inheritance, used before postgres 10
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

