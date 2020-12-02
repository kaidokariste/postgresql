
CREATE OR REPLACE FUNCTION "kaido.kariste".generate_loan_schedule(
    loan_amount NUMERIC,
    period_in_months INTEGER,
    year_int_rate NUMERIC)

    -- Final table that the function should return
    RETURNS TABLE (
        payment_number      INTEGER,
        payment_month       VARCHAR,
        monthly_payment     NUMERIC,
        principal_payment   NUMERIC,
        interest_payment    NUMERIC,
        principal_remaining NUMERIC
    )
AS
$$
DECLARE
    payment           NUMERIC;
    interest_payment  NUMERIC;
    principal_payment NUMERIC;
    month_int_rate    NUMERIC; -- Monthly interest rate
    total_interest    NUMERIC DEFAULT 0;
    n                 INTEGER DEFAULT 0;
    payment_month_date timestamp;
BEGIN

    -- Calculate monthly interest
    month_int_rate := year_int_rate / 1200;

    -- Monthly payment
    payment := (month_int_rate * loan_amount) / (1 - (1 / (1 + month_int_rate) ^ period_in_months));

    -- Create initial empty table, where to save loan schedule rows
    CREATE TEMPORARY TABLE generated_schedule (
        payment_number      INTEGER,
        payment_month       VARCHAR,
        monthly_payment     NUMERIC,
        principal_payment   NUMERIC,
        interest_payment    NUMERIC,
        principal_remaining NUMERIC
    )
    ON COMMIT DROP;

    -- First row of schedule. Row number 0 - represents the starting principal
    INSERT INTO generated_schedule(payment_number, payment_month, monthly_payment, principal_payment, interest_payment,
                                   principal_remaining)
    VALUES (n, to_char(now(), 'month YYYY'),0, 0, 0, loan_amount);

    -- Generate schedule
    WHILE n < period_in_months
        LOOP
            n := n + 1;
            interest_payment := month_int_rate * loan_amount;
            principal_payment := payment - interest_payment;
            loan_amount := loan_amount - principal_payment;
            payment_month_date := now() + (n || ' month')::interval;

            -- Total payable interest calculation
            total_interest := total_interest + interest_payment;

            -- Row info for payments
            INSERT INTO generated_schedule(payment_number,
                                           payment_month,
                                           monthly_payment,
                                           principal_payment,
                                           interest_payment,
                                           principal_remaining)
            VALUES (n,
                    to_char(payment_month_date, 'month YYYY'),
                    round(payment, 2),
                    round(principal_payment, 2),
                    round(interest_payment, 2),
                    round(loan_amount, 2));

        END LOOP;

    RETURN QUERY SELECT * FROM generated_schedule;

END;
$$ LANGUAGE plpgsql;


-- Create tample from function
drop table if exists buy_computer;
CREATE TEMPORARY TABLE buy_computer
AS
    SELECT *
    FROM "kaido.kariste".generate_loan_schedule(loan_amount => 1000, period_in_months => 24, year_int_rate => 12);

select * from buy_computer;
select sum(principal_payment), sum(interest_payment) from buy_computer;