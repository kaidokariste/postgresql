-- Creating loops in functions

-- Simple loop
DO LANGUAGE plpgsql
$$
DECLARE
  count INTEGER := 0;
  sum   INTEGER := 0;
BEGIN

  << saja_arvu_summa >> -- LABEL
  LOOP
    count = count + 1;
    sum = sum + count;

    RAISE INFO 'Count: % | Summa: %', count, sum;

    IF count = 100
    THEN
      EXIT; -- exitt loop
    END IF;

  END LOOP saja_arvu_summa; -- LABEL

END;
$$

-- Same loop, but for exit - EXIT WHEN is used

DO LANGUAGE plpgsql
$$
DECLARE
  count INTEGER := 0;
  sum   INTEGER := 0;
BEGIN

  << saja_arvu_summa >> -- LABEL
  LOOP
    count = count + 1;
    sum = sum + count;
    EXIT WHEN count = 100; -- exit loop

  END LOOP saja_arvu_summa; -- LABEL

  RAISE INFO 'Count: % | Summa: %', count, sum;

END;
$$

--While loop
DO LANGUAGE plpgsql
$$
DECLARE
  count INTEGER := 0;
  sum   INTEGER := 0;
BEGIN

  << saja_arvu_summa >> -- LABEL
  WHILE count < 100 LOOP

    count = count + 1;
    sum = sum + count;

    RAISE INFO 'Count: % | Summa: %', count, sum;

  END LOOP saja_arvu_summa; -- LABEL

END;
$$

-- Using array to make conditional updating
DO LANGUAGE plpgsql $$
DECLARE
  names_array TEXT [] := ('{Kaido, Hannes, Mihkel, Vaiko}');
  first_name  TEXT;
BEGIN
  FOREACH first_name IN ARRAY names_array
  LOOP
    EXECUTE 'UPDATE my_table SET i_know_them = TRUE where fist_name =' || index_name;
  END LOOP;
END
$$;

--Using array looping and conditional if-else statements
DO LANGUAGE plpgsql $$
DECLARE
  arCountry TEXT [] := ('{Estonia, France, Spain, Italy}');
  arCapital TEXT [] := ('{Madrid, Tallinn, Paris, Rome}');
  vCountry  VARCHAR;
  vCapital  VARCHAR;
BEGIN
  FOREACH vCountry IN ARRAY arCountry
  LOOP
    RAISE INFO 'Country is %', vCountry;
    FOREACH vCapital IN ARRAY arCapital
    LOOP
      IF vCountry = 'Estonia' AND vCapital = 'Tallinn'
      THEN
        RAISE INFO '% is capital of %', vCapital, vCountry;
      ELSEIF vCountry = 'France' AND vCapital = 'Paris'
        THEN
          RAISE INFO '% is capital of %', vCapital, vCountry;
      ELSE
        RAISE INFO 'Relation between % and % is unknown', vCapital, vCountry;
      END IF;
    END LOOP;
  END LOOP;
END
$$;
