/*
 * Create table of English Premierleague teams on educational purpose
*/

	CREATE TABLE my_schema.premierleague(
	id smallserial not null primary key, 
	club varchar,
	wdl integer[],
	points integer, 
	week integer
	);

/*
Create logging trigger for table premierleague
*/

	CREATE TABLE my_schema.audit_log (
	username text, -- who did the change
	event_time_utc timestamp, -- when the event was recorded
	table_name text, -- contains schema-qualified table name
	operation text, -- INSERT, UPDATE, DELETE or TRUNCATE
	before_value json, -- the OLD tuple value
	after_value json -- the NEW tuple value
	);

/*
 * Create audit trigger function
 */

	CREATE OR REPLACE FUNCTION my_schema.audit_trigger() RETURNS trigger AS $$ 
	DECLARE 
		old_row json := NULL; 
		new_row json := NULL; 
	BEGIN 
	
	IF TG_OP IN ('UPDATE','DELETE') THEN 
	old_row = row_to_json(OLD); 
	END IF; 
	
	IF TG_OP IN ('INSERT','UPDATE') THEN 

		new_row = row_to_json(NEW); 
	
	END IF; 
	
	INSERT INTO my_schema.audit_log( 
		username, 
		event_time_utc, 
		table_name, 
		operation, 
		before_value, 
		after_value 
	) VALUES ( 
		session_user, 
		current_timestamp AT TIME ZONE 'UTC', 
		TG_TABLE_SCHEMA || '.' || TG_TABLE_NAME, 
		TG_OP, 
		old_row, 
		new_row 
	); 
	RETURN NEW; 
	END; 
	$$ LANGUAGE plpgsql;

/*
 * Create audit trigger
 */ 

	CREATE TRIGGER premierleague_log 
	AFTER INSERT OR UPDATE OR DELETE 
	ON my_schema.premierleague 
	FOR EACH ROW 
	EXECUTE PROCEDURE my_schema.audit_trigger(); 

/*
 * Make some insertions 
 */

	insert into my_schema.premierleague (club,wdl,points,week) values 
	('Manchester City','{7,0,2}',21,9),
	('Arsenal','{6,1,2}',19,9),
	('Manchester United','{6,1,2}',19,9),
	('West Ham United','{5,5,2}',17,9),
	('Liverpool','{3,4,2}',13,9),
	('Chelsea','{3,2,4}',11,9),
	('Arsenal','{7,1,2}',22,10),
	('West Ham United','{6,2,2}',20,10),
	('Chelsea','{3,2,5}',11,10);

