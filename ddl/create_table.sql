CREATE TABLE IF NOT EXISTS schema_name.table_name (
  some_id                SERIAL,
  some_group             VARCHAR(30)  NOT NULL,
  some_name              VARCHAR(100) NOT NULL,
  some_description       TEXT,
  some_value_with_check  TEXT CHECK (attr_value <> ''),
  some_one_dim_int_array INTEGER [],
  some_two_dim_int_array TEXT [] [],
  is_valid_default_true  BOOLEAN                     DEFAULT TRUE,
  valid_from_default_now TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  valid_to               TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (some_id),
  UNIQUE (some_group, some_name)
);

-- Add comments to table and column
COMMENT ON TABLE schema_name.table_name IS 'This table is in schema schema_name and called table_name';
COMMENT ON COLUMN schema_name.table_name.some_id IS 'This is autoincremental number and primary key';
