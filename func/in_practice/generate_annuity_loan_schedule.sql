/*
 * This anonymos block will generate loan annuity schedule
 */

DO LANGUAGE plpgsql
$$
DECLARE
  payment           NUMERIC;
  present_value     NUMERIC := 5000;
  interest_payment  NUMERIC;
  principal_payment NUMERIC;
  period            INTEGER := 60; -- Months
  year_int_rate     NUMERIC := 15; -- Monthly interest rate
  month_int_rate    NUMERIC; -- Monthly interest rate
  total_interest    NUMERIC DEFAULT 0;
  n                 INTEGER DEFAULT 0;

BEGIN
  -- Calculate monthly interest
  month_int_rate := year_int_rate / 1200;

  -- Monthly payment
  payment := (month_int_rate * present_value) / (1 - (1 / (1 + month_int_rate) ^ period));

  -- First row of schedule
  RAISE INFO 'ROW: %, Credit sum: %, payment total: % , principal payment: 0, interest payment 0',
  n, present_value, round(payment, 2);

  -- Generate schedule

  WHILE n < period LOOP
    n := n + 1;
    interest_payment := month_int_rate * present_value;
    principal_payment := payment - interest_payment;
    present_value := present_value - principal_payment;

    -- Total payable interest calculation
    total_interest := total_interest + interest_payment;

    -- Row info for payments
    RAISE INFO 'ROW: %,  monthly payment: % , principal payment: %, interest payment %, Principal remaining: %,',
    n, round(payment, 2), round(principal_payment, 2), round(interest_payment, 2), round(present_value, 2);

  END LOOP;

  RAISE INFO 'ROW: TOTAL,  interest total: % .',
  round(total_interest, 2);
END;
$$