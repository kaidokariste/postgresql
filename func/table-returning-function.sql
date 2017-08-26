/*
 * SQL language example returning a row.
 */
 
CREATE OR REPLACE FUNCTION my_schema.team_table_sql(team_name varchar)
RETURNS TABLE(club varchar, points integer, week integer) 
AS
$$
   select
   p0.club, 
   p0.points,
   p0.week 
   from my_schema.premierleague p0 
   where p0.club = team_name;
 $$ LANGUAGE sql
 
-- Calling out function
select * from my_schema.team_table_sql('Chelsea');
select (my_schema.team_table_sql('Chelsea')).points;

/*
Same function but writen in plpgsql
*/

CREATE OR REPLACE FUNCTION my_schema.team_table_pg(team_name varchar)
RETURNS TABLE(club varchar, points integer, week integer) 
AS
$$
begin
  return query  select club, points, week from my_schema.premierleague where club = team_name;
end;
 $$ LANGUAGE plpgsql

select * from my_schema.team_table_pg('Chelsea');


