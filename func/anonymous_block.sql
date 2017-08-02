-- Anonymous block without declaration part

DO LANGUAGE plpgsql
$$
BEGIN
  RAISE INFO 'What am I doing inside here?';
END;
$$

-- Anonymous block with declaration block

DO LANGUAGE plpgsql
$$
DECLARE
  my_variable VARCHAR := 'Executable anonymos block';
BEGIN
  RAISE INFO '%', my_variable;
END;
$$
