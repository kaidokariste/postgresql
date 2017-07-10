/* Adding foreign key constarint assuming we have two tables child and parent like order and product */
ALTER TABLE child ADD FOREIGN KEY(column_child) REFERENCES parent (column_parent);

/* Primary key */
ALTER TABLE parent ADD PRIMARY KEY(column_parent);