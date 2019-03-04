-- Using for loop to to walk trough row set

DO LANGUAGE plpgsql
  $$
  DECLARE
    cUser CURSOR (v_username VARCHAR) FOR
      SELECT username,
             firstname,
             surname
      FROM myschema.users
      WHERE username = v_username;

    -- Using FOR LOOP, it is not necessary to define row variable;

  BEGIN

    << search_user >> -- label for loop
    FOR rUser IN cUser('myusername')
      LOOP

        RAISE INFO 'Firstname: %, Surname: %', rUser.firstname, rUser.surname;

      END LOOP search_user;
  END;
  $$;

/*
Example of using cursor to make copy of a schema
*/

DO LANGUAGE plpgsql
  $$
  DECLARE
    cTables CURSOR FOR
      SELECT schemaname,
             tablename
      FROM pg_tables
      WHERE schemaname = 'schema_to_copy';

    -- Using FOR LOOP, it is not necessary to define row variable;

  BEGIN

    << create_archive >> -- label for loop
    FOR rTable IN cTables
      LOOP
        EXECUTE ' create table archive.' || rTable.tablename || ' (like ' || rTable.schemaname || '.' ||
                rTable.tablename || ' including all);';
        EXECUTE ' insert into  archive.' || rTable.tablename || ' select * from ' || rTable.schemaname || '.' ||
                rTable.tablename;
        RAISE INFO 'schema: %, table: %', rTable.schemaname, rTable.tablename;

      END LOOP create_archive;
  END;
  $$
