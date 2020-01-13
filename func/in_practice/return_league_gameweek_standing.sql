/*
 * Creating table returning function which will sho current standing of a league and change compared to previous GW
 * tags: table returning function, window function, wit clause
 */

CREATE TABLE IF NOT EXISTS football_league (
  some_id                SERIAL PRIMARY KEY,
  team_name              VARCHAR(30)  NOT NULL,
  gameweek_number        INTEGER NOT NULL,
  points			     INTEGER,
  goal_difference 		 INTEGER
);

select * from football_league;
--truncate table football_league;

insert into football_league(team_name, gameweek_number, points, goal_difference) values 
('LIVERPOOL',1,3,4),('CHELSEA',1,0,-3),('MANCHESTERCITY',1,0,-1),('ARSENAL',1,3,2),
('LIVERPOOL',2,6,5),('CHELSEA',2,1,-2),('MANCHESTERCITY',2,3,2),('ARSENAL',2,4,2),
('LIVERPOOL',3,7,5),('CHELSEA',3,2,-2),('MANCHESTERCITY',3,6,4),('ARSENAL',3,4,-3);

--  

CREATE OR REPLACE FUNCTION league_standing(par_gw INTEGER)
    RETURNS TABLE
            (
                place                BIGINT,
                team_name            VARCHAR,
                gameweek_number      INTEGER,
                points               INTEGER,
                goal_difference      INTEGER,
                change_from_previous TEXT
            )
AS
$$
WITH current_gameweek AS (
    SELECT   team_name,
             gameweek_number,
             points,
             goal_difference,
             ROW_NUMBER()
             OVER (PARTITION BY gameweek_number ORDER BY points DESC, goal_difference DESC ) AS position
      FROM football_league fl
      WHERE gameweek_number = par_gw),

     previous_gameweek AS (
         SELECT team_name,
                gameweek_number,
                points,
                goal_difference,
                ROW_NUMBER() OVER (PARTITION BY gameweek_number ORDER BY points DESC, goal_difference DESC ) AS position
       FROM football_league fl
       WHERE gameweek_number = (SELECT max(gameweek_number) - 1 FROM current_gameweek))
SELECT cg.position,
       cg.team_name,
       cg.gameweek_number,
       cg.points,
       cg.goal_difference,
       CASE
           WHEN (pg.position - cg.position) > 0 THEN '+' || (pg.position - cg.position)
           ELSE coalesce((pg.position - cg.position), 0) ::TEXT END AS change_from_previous
FROM current_gameweek cg
         LEFT JOIN previous_gameweek pg ON pg.team_name = cg.team_name
ORDER BY cg.position ASC;
$$ LANGUAGE SQL;
 
 select * from league_standing(1);
 select * from league_standing(2);
 select * from league_standing(3);

-- SOLUTION2 2 Using lag and temporary tables
-- Function for returning calculated results:
DROP FUNCTION IF EXISTS footbal_results(INTEGER);

CREATE OR REPLACE FUNCTION footbal_results(
    game_week INTEGER
)
  RETURNS TABLE (
    place BIGINT,
    team_name VARCHAR,
    gameweek_number INT,
    points INT,
    goal_difference INT,
    change_from_previous TEXT
  ) AS
$BODY$

DECLARE

BEGIN

  CREATE TEMPORARY TABLE temp_1_position ON COMMIT DROP AS
    SELECT
      t1.*,
      row_number() OVER (PARTITION BY t1.gameweek_number ORDER BY t1.points DESC, t1.goal_difference DESC) AS position
    FROM footbal t1;


  CREATE TEMPORARY TABLE temp_2_previous_position ON COMMIT DROP AS
    SELECT
      t1.*,
      coalesce( (lag(position, 1) OVER (PARTITION BY t1.team_name ORDER BY t1.gameweek_number) )::TEXT, 'None') AS previous_position
    FROM temp_1_position t1;

  CREATE TEMPORARY TABLE temp_3_change_from_previous ON COMMIT DROP AS
  SELECT
    t1.*,
    CASE WHEN t1.gameweek_number = 1 THEN t1.position::TEXT -- Week 1 - Exception
    ELSE
      ( CASE WHEN t1.previous_position::INT - position::INT > 0
              THEN '+' || (t1.previous_position::INT - position::INT)::TEXT
             ELSE (t1.previous_position::INT - position::INT)::TEXT END )
    END AS change_from_previous
  FROM temp_2_previous_position t1;

  CREATE TEMPORARY TABLE temp_4_final_dataset ON COMMIT DROP AS
     SELECT
      t1.position AS place,
      t1.team_name,
      t1.gameweek_number,
      t1.points,
      t1.goal_difference,
      t1.change_from_previous
     FROM temp_3_change_from_previous t1
     WHERE t1.gameweek_number = game_week
     ORDER BY t1.position;

  RETURN QUERY EXECUTE
  $$
     SELECT place, team_name, gameweek_number, points, goal_difference, change_from_previous FROM temp_4_final_dataset;
  $$;

END;
$BODY$
LANGUAGE plpgsql;

-- Testing
SELECT * FROM footbal_results(1);
SELECT * FROM footbal_results(2);
SELECT * FROM footbal_results(3);


