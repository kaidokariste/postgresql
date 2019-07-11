-- Add check constraint to my_table look if the name is not emty string
ALTER TABLE my_table ADD CHECK (name_column <> '');

-- Add unique constraint to my table, named my_constraint_name to column column_product_no
ALTER TABLE my_table ADD CONSTRAINT my_constraint_name UNIQUE (column_product_no);

-- Add column NOT NULL constraint
ALTER TABLE myTable ALTER COLUMN name_column SET NOT NULL;
