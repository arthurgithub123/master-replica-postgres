CREATE TABLE products (
  id serial PRIMARY KEY,
  name VARCHAR (50) NOT NULL
);

INSERT INTO
  products (name)
VALUES
  ('product 1'),
  ('product 2'),
  ('product 3'),
  ('product 4');

CREATE EXTENSION pglogical;

SELECT pglogical.create_node(
  'crud_node',
  'host=master_database port=5432 dbname=shop user=postgres password=1234'
);

SELECT pglogical.create_replication_set(
  'read_replication_set',
  true, -- replicate_insert
  true, -- replicate_update
  true, -- replicate_delete
  true  -- replicate_truncate
);

SELECT pglogical.replication_set_add_table(
  'read_replication_set',
  'products',
  true,
  null,
  null
);
