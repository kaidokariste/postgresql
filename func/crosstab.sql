CREATE TABLE premierleague (
  team1  VARCHAR,
  city VARCHAR, -- extra column that can be added
  team2  VARCHAR, -- will be column headers
  result VARCHAR -- will be crosstab values
);

INSERT INTO premierleague (team1, city, team2, result) VALUES
  ('TOT', 'London', 'Liverpool', '2:1'),
  ('TOT', 'London','Manchester City', '1:1'),
  ('TOT', 'London', 'Chelsea', '1:0'),
  ('LIV', 'Liverpool','Tottenham', '1:2'),
  ('LIV', 'Liverpool','West Ham', '4:2'),
  ('EVE', 'Liverpool','Chelsea', '1:1'),
  ('CHE', 'London','Liverpool', '1:1'),
  ('CHE', 'London','Arsenal', '0:0'),
  ('CHE', 'London','Tottenham', '0:1');

-- Crosstab will turn this into columns
-- Arsenal
-- Chelsea
-- Liverpool
-- Manchester City
-- Tottenham
-- West Ham
-- + adds team1 column

-- ordering in both crosstab queris is essential. Otherwise it may recognize where
-- one team1 results are ending and others are beginning
SELECT *
FROM crosstab(
$ct_query$
  select
   team1,
   city as extra_col,
   team2 as category,
   result as value
   from
      premierleague
   order by team1
$ct_query$,
$cat_query$ select distinct team2  from premierleague order by 1 $cat_query$)
AS ct(home TEXT, city text, ars TEXT, che TEXT, liv TEXT, mci TEXT, tot TEXT, whu TEXT );

