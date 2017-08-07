-- Create function

CREATE OR REPLACE FUNCTION "kaido.kariste".odd_or_even_number(par_number INTEGER)
  RETURNS TEXT
AS
$$
DECLARE
  divisor INTEGER := 2;
BEGIN
  IF par_number % divisor = 0
  THEN
    RETURN 'Even number';
  ELSE
    RETURN 'Odd number';
  END IF;
END;
$$
LANGUAGE plpgsql;

-- Appropriate comments to function
COMMENT ON FUNCTION "kaido.kariste".odd_or_even_number(INTEGER) IS 'Check if the number is even or odd';


--SELECT "kaido.kariste".odd_or_even_number(20);


CREATE OR REPLACE FUNCTION "kaido.kariste".random_number_clock()
  RETURNS VOID -- do not return anything
AS
$$
DECLARE
  random_number INTEGER;
BEGIN

  FOR i IN 1..10 LOOP
    random_number := (SELECT round((random() * 100) :: NUMERIC, 0)); -- generate random number
    RAISE INFO '%', random_number;
    PERFORM pg_sleep(3); -- delays the printout
  END LOOP;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION "kaido.kariste".random_number_clock() IS 'Prints out to console random number after every 3 seconds';

--SELECT "kaido.kariste".random_number_clock();