-- Using for loop to to walk trough row set

DO LANGUAGE plpgsql
$$
DECLARE
    cUser CURSOR (v_username VARCHAR) FOR
    SELECT
      username,
      firstname,
      surname
    FROM myschema.users
    WHERE username = v_username;

  -- Using FOR LOOP, it is not necessary to define row variable;

BEGIN

  << search_user >> -- label for loop
  FOR rUser IN cUser('myusername') LOOP

    RAISE INFO 'Firstname: %, Surname: %', rUser.firstname, rUser.surname;

  END LOOP search_user;
END;
$$
