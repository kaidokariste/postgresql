-- Lets assume we have defined sequence uus_id_seq
-- returns next value from sequence
SELECT NEXTVAL('myschema.uus_id_seq');
-- current value (can only be seen when when you ask first "next value")
SELECT CURRVAL('myschema.uus_id_seq');
-- set sequence value to 1888
SELECT SETVAL('myschema.uus_id_seq', 1888);
SELECT CURRVAL('myschema.uus_id_seq'); -- 1888
-- set dynamically sequence value to max (id) + 100 from some table
SELECT SETVAL('myschema.uus_id_seq', (select max(id)+100 from mytable));