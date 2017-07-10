/*
Multi line comments in SQL can be added using forward and back slash and asterisk .
All between these symbols are treatened as comment. Comments should be as nuch as necessary to
read your code later.
*/

-- Line comments in Postgres can be added using two minus signs like here

SELECT 'Hello to beginner course!';

SELECT E'So ... Who want\'s to learns PostgreSQL?';

SELECT $dollarquote$ Most foolproof is to use double dollars for escape.;
Even such characters like ''' , wich otherwise would broke everything.$dollarquote$;

SELECT $$Why don't I see normal names? just ?column? $$;

SELECT 'Look column name to know my name :) ' as Topolino;
SELECT 'People also know me as: ' as "Mickey Mouse";
