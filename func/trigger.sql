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

	CREATE TRIGGER mytable_log
	AFTER INSERT OR UPDATE OR DELETE
	ON my_schema.mytable
	FOR EACH ROW
	EXECUTE PROCEDURE my_schema.audit_trigger();
