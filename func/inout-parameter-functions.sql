/*Using IN and OUT parameters to get row output*/

CREATE OR REPLACE FUNCTION my_schema.team(
 INOUT team_name varchar(20), 
 OUT points integer, 
 OUT week integer)
 AS
 $$
 begin
   select
   team_name, 
   p0.points,
   p0.week 
   from my_schema.premierleague p0 into team_name, points, week
   where p0.club = team_name;
 end;
 $$
 LANGUAGE plpgsql;


select my_schema.team(club) from my_schema.premierleague;
select * from my_schema.team('Liverpool');

CREATE OR REPLACE FUNCTION my_schema.team_param(
 INOUT team_name varchar(20), 
 OUT points integer, 
 OUT week integer)
 AS
 $$
 begin
  points := 100;
  week := 99;
 end;
 $$
 LANGUAGE plpgsql;

 select * from my_schema.team_param('Manchester United');
 drop function my_schema.team_param cascade;

 select * from my_schema.premierleague