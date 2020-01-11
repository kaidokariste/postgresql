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

CREATE OR REPLACE FUNCTION league_standing(par_gw integer)
RETURNS TABLE(place bigint, team_name varchar, gameweek_number integer, points integer, goal_difference integer, change_from_previous text) 
AS
$$
with current_gameweek as (
select 
team_name, gameweek_number, points, goal_difference, 
ROW_NUMBER() OVER(PARTITION BY gameweek_number ORDER BY points DESC, goal_difference DESC ) as position
from football_league fl
where gameweek_number = par_gw
),
previous_gameweek as (
select 
team_name, gameweek_number, points, goal_difference, 
ROW_NUMBER() OVER(PARTITION BY gameweek_number ORDER BY points DESC, goal_difference DESC ) as position
from football_league fl
where gameweek_number = (select max(gameweek_number) -1 from current_gameweek)
)
select cg.position, cg.team_name, cg.gameweek_number, cg.points, cg.goal_difference,   
	case when (pg.position - cg.position) > 0 then '+'|| (pg.position - cg.position)
	else coalesce((pg.position - cg.position), 0) ::text
	end as change_from_previous  
from current_gameweek cg
left join previous_gameweek pg on pg.team_name = cg.team_name
order by cg.position asc;
 $$ LANGUAGE sql
 
 select * from league_standing(3);


