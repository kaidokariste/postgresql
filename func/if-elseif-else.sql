/* Conditional functions */

-- IF statement

DO LANGUAGE plpgsql
$$
DECLARE
  hello VARCHAR := 'Executable anonymos block';
BEGIN
  IF to_char(timeofday() :: TIMESTAMP, 'D') = '7'
  THEN
    RAISE INFO 'Saturday';
  END IF;

  RAISE INFO 'This is end';

END;
$$

-- IF-ELSEIF-ELSE and IF-ELSE

DO LANGUAGE plpgsql
$$
DECLARE
  country VARCHAR := 'Estonia';
BEGIN
  IF country = 'Estonia'
  THEN
    RAISE INFO 'Home';
  ELSIF country IN ('Estonia', 'Latvia', 'Lithuania')
    THEN
      RAISE INFO 'Baltics';
  ELSE
    RAISE INFO 'Some other country';
  END IF;
END;
$$
