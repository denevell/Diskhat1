CREATE VIEW in_all_columns_wth_type AS
 SELECT columns.table_name,
    columns.column_name,
    columns.data_type,
    columns.column_default,
    columns.is_nullable
   FROM information_schema.columns;


CREATE VIEW in_get_all_public_tables AS
 SELECT tables.table_name
   FROM information_schema.tables
  WHERE ((((tables.table_schema)::text = 'public'::text) AND ((tables.table_name)::text <> 'schema_version'::text)) AND ((tables.table_type)::text = 'BASE TABLE'::text));


CREATE VIEW in_all_columns_in_public_tables AS
 SELECT t0.table_name,
    t1.column_name,
    t1.data_type,
    t1.column_default,
    t1.is_nullable
   FROM (in_get_all_public_tables t0
     LEFT JOIN in_all_columns_wth_type t1 ON (((t0.table_name)::text = (t1.table_name)::text)));


CREATE VIEW in_all_foreign_key_constraints AS
 SELECT kcu.constraint_catalog,
    kcu.constraint_schema,
    kcu.constraint_name,
    kcu.table_catalog,
    kcu.table_schema,
    kcu.table_name,
    kcu.column_name,
    kcu.ordinal_position,
    kcu.position_in_unique_constraint
   FROM (information_schema.key_column_usage kcu
     LEFT JOIN information_schema.table_constraints tc ON (((tc.constraint_name)::text = (kcu.constraint_name)::text)))
  WHERE ((tc.constraint_type)::text = 'FOREIGN KEY'::text);


CREATE VIEW in_all_columns_and_foreign_key AS
 SELECT t0.table_name,
    t0.column_name,
    t0.data_type,
    t0.column_default,
    t0.is_nullable,
    t1.constraint_name
   FROM (in_all_columns_in_public_tables t0
     LEFT JOIN in_all_foreign_key_constraints t1 ON ((((t0.table_name)::text = (t1.table_name)::text) AND ((t0.column_name)::text = (t1.column_name)::text))));


CREATE VIEW in_all_columns_with_foreign_key_table_and_column AS
 SELECT t0.table_name,
    t0.column_name,
    t0.data_type,
    t0.column_default,
    t0.is_nullable,
    t0.constraint_name,
    t1.table_name AS foreign_key_table,
    t1.column_name AS foreign_key_column
   FROM (in_all_columns_and_foreign_key t0
     LEFT JOIN information_schema.constraint_column_usage t1 ON (((t0.constraint_name)::text = (t1.constraint_name)::text)));


CREATE VIEW in_all_columns_with_foreign_key_table_and_column_as_array AS
 SELECT in_all_columns_with_foreign_key_table_and_column.table_name,
    array_agg((in_all_columns_with_foreign_key_table_and_column.column_name)::text) AS columns,
    array_agg((in_all_columns_with_foreign_key_table_and_column.data_type)::text) AS column_types,
    array_agg((in_all_columns_with_foreign_key_table_and_column.column_default)::text) AS column_default,
    array_agg((in_all_columns_with_foreign_key_table_and_column.is_nullable)::text) AS column_nullables,
    array_agg((in_all_columns_with_foreign_key_table_and_column.constraint_name)::text) AS foreign_key_names,
    array_agg((in_all_columns_with_foreign_key_table_and_column.foreign_key_table)::text) AS foreign_key_tables,
    array_agg((in_all_columns_with_foreign_key_table_and_column.foreign_key_column)::text) AS foreign_key_columns
   FROM in_all_columns_with_foreign_key_table_and_column
  GROUP BY in_all_columns_with_foreign_key_table_and_column.table_name;


CREATE VIEW in_all_tables_with_params AS
 SELECT in_all_columns_with_foreign_key_table_and_column.table_name,
    (((in_all_columns_with_foreign_key_table_and_column.column_name)::text || ' '::text) || (in_all_columns_with_foreign_key_table_and_column.data_type)::text) AS param,
    ('_'::text || (in_all_columns_with_foreign_key_table_and_column.column_name)::text) AS param_input
   FROM in_all_columns_with_foreign_key_table_and_column
  ORDER BY in_all_columns_with_foreign_key_table_and_column.table_name;


CREATE VIEW in_all_tables_with_params_concantenated AS
 SELECT in_all_tables_with_params.table_name,
    (('('::text || array_to_string(array_agg(in_all_tables_with_params.param), ','::text)) || ')'::text) AS all_params,
    (('values('::text || array_to_string(array_agg(in_all_tables_with_params.param_input), ','::text)) || ')'::text) AS all_values
   FROM in_all_tables_with_params
  GROUP BY in_all_tables_with_params.table_name;
