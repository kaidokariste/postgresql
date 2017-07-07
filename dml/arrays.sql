-- Array datatypes
create table myschema.my_array_table(
  date_array_one_dim date [],
  integer_array_one_dim integer[],
  text_array_two_dim text[][],
  integer_array_two_dim integer[][]
);

select * from myschema.my_array_table;

INSERT INTO myschema.my_array_table(date_array_one_dim) VALUES ('{2017-07-07,2016_06-06, 2015-05-05}');
INSERT INTO myschema.my_array_table(integer_array_one_dim) VALUES ('{2,0,1,7}');
INSERT INTO myschema.my_array_table(text_array_two_dim) VALUES ('{{Apple, 49 kcal}, {} }');

INSERT INTO myschema.my_array(date_array_one_dim, integer_array_one_dim, text_array_two_dim, integer_array_two_dim) VALUES
('{2017-07-07,2016_06-06, 2015-05-05}','{10000, 10000, 10000, 10000}','{{"meeting", "lunch"}, {"training", "presentation"}}');



