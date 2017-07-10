/*
This exercise will demostrate how to use temporary table and how they can be useful
*/
CREATE TABLE myschema.estonia_in_eurovision (
  year           CHAR(4), -- similar to varchar but empty spaces are filled with blanks
  song           VARCHAR,
  qualification  VARCHAR(15),
  final_position INTEGER
);

-- Insert past 5 yers results from http://eurovisionworld.com/?eurovision=estonia
INSERT INTO myschema.estonia_in_eurovision (
  year,
  song,
  qualification,
  final_position
) VALUES
  (2016, 'Play - Jüri Pootsmann', '18/18', NULL),
  (2015, 'Goodbye to Yesterday - Elina Born & Stig Rästa', '3/16', 7),
  (2014, 'Amazing - Tanja', '12/16', NULL),
  (2013, 'Et Uus Saaks Alguse', '10/16', 20),
  (2012, 'Kuula - Ott Lepland', '4/18', 6),
  (2011, 'Rockefeller Street - Getter Jaani', '9/19', '24');

/* How does the ordering by qualification work? */
-- select * from myschema.estonia_in_eurovision order by qualification;

-- Extract the position from string and after altering, add it to our current table
SELECT
  *,
  position('/' IN qualification)
FROM myschema.estonia_in_eurovision;
-- syntax in documentataion 	substring('Thomas' from 2 for 3)
-- Play a bit with our case : select substring('16/20' from 0 for 3) vs substring('16/20' from 1 for 2)
SELECT
  *,
  substring(qualification FROM 0 FOR position('/' IN qualification))
FROM myschema.estonia_in_eurovision;

-- We have done well so far,lets save tem as temporary results
CREATE TEMPORARY TABLE temporary_results AS
  SELECT
    year,
    substring(qualification FROM 0 FOR position('/' IN qualification)) AS semi_final
  FROM myschema.estonia_in_eurovision;

ALTER TABLE myschema.estonia_in_eurovision
  ADD COLUMN semi_final_place INTEGER;

-- look over your new table
UPDATE myschema.estonia_in_eurovision t1
SET semi_final_place = t2.semi_final :: INTEGER
FROM temporary_results t2
WHERE t1.year = t2.year;

-- Who got highest semi final place?
SELECT *
FROM myschema.estonia_in_eurovision
ORDER BY semi_final_place;
