-- Array datatypes
CREATE TABLE "kaido.kariste".my_array_table (
  date_array_one_dim    DATE [],
  integer_array_one_dim INTEGER [],
  text_array_two_dim    TEXT [] [],
  integer_array_two_dim INTEGER [] []
);

/*Inserting into array*/

INSERT INTO "kaido.kariste".my_array_table (date_array_one_dim)
VALUES ('{2017-07-07,2016_06-06, 2015-05-05}');

INSERT INTO "kaido.kariste".my_array_table (integer_array_one_dim)
VALUES ('{2,0,1,7}');

INSERT INTO "kaido.kariste".my_array_table (text_array_two_dim)
VALUES ('{{Apple, 49 kcal}, {Banana, 95 kcal}, {Blackberries, 26 kcal} }');

INSERT INTO "kaido.kariste".my_array_table (integer_array_two_dim)
VALUES ('{{31, 45},{56, 87}, {0,100},{45, 87}}');

/*Accessing Arrays - array index in pgsql starts from 1 */

SELECT date_array_one_dim [1]
FROM "kaido.kariste".my_array_table
WHERE date_array_one_dim [1] IS NOT NULL; -- result 2017-07-07

SELECT integer_array_one_dim [1 :3]
FROM "kaido.kariste".my_array_table; -- result {2,0,1}

SELECT text_array_two_dim
FROM "kaido.kariste".my_array_table; -- result {{Apple,49 kcal},{Banana,95 kcal},{Blackberries,26 kcal}}

SELECT text_array_two_dim [1] [1]
FROM "kaido.kariste".my_array_table; -- result Apple

SELECT text_array_two_dim [1 :3] [1]
FROM "kaido.kariste".my_array_table; -- result {{Apple},{Banana},{Blackberries}}

SELECT text_array_two_dim [1 :3] [2] -- This will take out both sub arrays and both elements from these sub arrays
FROM "kaido.kariste".my_array_table; -- Result {{Apple,49 kcal},{Banana,95 kcal},{Blackberries,26 kcal}}

-- Updating array
UPDATE "kaido.kariste".my_array_table
SET integer_array_one_dim = '{18, 6, 18, 85}'
WHERE integer_array_one_dim IS NULL;

/*Any array can be updated also using single element*/
UPDATE "kaido.kariste".my_array_table
SET integer_array_one_dim [4] = 98
WHERE integer_array_one_dim [1] = 2; -- result {2,0,1,7} -> {2,0,1,98}

/*If we want to update specific slice then*/
UPDATE "kaido.kariste".my_array_table
SET integer_array_one_dim [2 :3] = '{10, 10}'
WHERE integer_array_one_dim [1] = 18; -- result {18, 6, 18, 85} -> {18,10,10,85}

/*Adding element to array*/

-- using array_append(anyarray, anyelement)

UPDATE "kaido.kariste".my_array_table
SET date_array_one_dim = array_append(date_array_one_dim, '{1991-08-20}');
-- result {2017-07-07,2016-06-06,2015-05-05,1991-08-20} and null values were updated to 1 dim.

-- Using concatenation example date[] || date []
UPDATE "kaido.kariste".my_array_table
SET date_array_one_dim = date_array_one_dim || ARRAY ['1998-01-01', '1999-06-01'] :: DATE []
WHERE text_array_two_dim IS NOT NULL;

-- In Postgres 9.4 adding element to two dimensiona array has no good solution.

/*Searching from array*/

SELECT *
FROM "kaido.kariste".my_array_table
WHERE 18 = ANY (integer_array_one_dim); -- serches from array where any element = 18

SELECT *
FROM "kaido.kariste".my_array_table
WHERE 18 = ALL (integer_array_one_dim); -- search from array where all elements = 18

SELECT *
FROM "kaido.kariste".my_array_table
WHERE 'Apple' = ANY (text_array_two_dim); -- searching from two dimensional array works the same

