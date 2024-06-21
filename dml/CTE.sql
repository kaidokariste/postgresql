-- CTE with static values

WITH riigid(nimi, lühend) AS
             (VALUES ('Leedu', 'LT'), ('Soome', 'FI'))
SELECT *
FROM riigid;