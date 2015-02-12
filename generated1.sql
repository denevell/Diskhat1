CREATE FUNCTION autogen_simple_inserts() RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare s text;
declare r record;
begin
        for r in select * from in_all_tables_with_params_concantenated loop
            s = 'create or replace function autogen.insert_' 
            || r."table_name" || ' '
            || r."all_sp_params" || ' '
            || 'returns void language sql as $x$ insert into '
            || r."table_name" || ' ' 
            || r."all_params" || ' ' 
            || r."all_values" || ';'
            || '$x$;';
            raise notice '%', s;
            execute s;
        end loop;
end;
$_$;


ALTER FUNCTION public.autogen_simple_inserts() OWNER TO denevell;

--
-- Name: autogen_simple_inserts_excluding_defaults(); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION autogen_simple_inserts_excluding_defaults() RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare s text;
declare r record;
begin
        for r in select * from in_all_tables_with_params_excluding_defaults_concantenated loop
            s = 'create or replace function autogen.insert_excluding_defaults_' 
            || r."table_name" || ' '
            || r."all_sp_params" || ' '
            || 'returns void language sql as $x$ insert into '
            || r."table_name" || ' ' 
            || r."all_params" || ' ' 
            || r."all_values" || ';'
            || '$x$;';
            raise notice '%', s;
            execute s;
        end loop;
end;
$_$;


ALTER FUNCTION public.autogen_simple_inserts_excluding_defaults() OWNER TO denevell;

--
--
-- Name: in_all_columns_wth_type; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_all_columns_wth_type AS
 SELECT columns.table_name,
    columns.column_name,
    columns.data_type,
    columns.column_default,
    columns.is_nullable
   FROM information_schema.columns;


ALTER TABLE in_all_columns_wth_type OWNER TO denevell;

--
-- Name: in_get_all_public_tables; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_get_all_public_tables AS
 SELECT tables.table_name
   FROM information_schema.tables
  WHERE ((((tables.table_schema)::text = 'public'::text) AND ((tables.table_name)::text <> 'schema_version'::text)) AND ((tables.table_type)::text = 'BASE TABLE'::text));


ALTER TABLE in_get_all_public_tables OWNER TO denevell;

--
-- Name: in_all_columns_in_public_tables; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_all_columns_in_public_tables AS
 SELECT t0.table_name,
    t1.column_name,
    t1.data_type,
    t1.column_default,
    t1.is_nullable
   FROM (in_get_all_public_tables t0
     LEFT JOIN in_all_columns_wth_type t1 ON (((t0.table_name)::text = (t1.table_name)::text)));


ALTER TABLE in_all_columns_in_public_tables OWNER TO denevell;

--
-- Name: in_all_foreign_key_constraints; Type: VIEW; Schema: public; Owner: denevell
--

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


ALTER TABLE in_all_foreign_key_constraints OWNER TO denevell;

--
-- Name: in_all_columns_and_foreign_key; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_all_columns_and_foreign_key AS
 SELECT t0.table_name,
    t0.column_name,
    t0.data_type,
    t0.column_default,
    t0.is_nullable,
    t1.constraint_name
   FROM (in_all_columns_in_public_tables t0
     LEFT JOIN in_all_foreign_key_constraints t1 ON ((((t0.table_name)::text = (t1.table_name)::text) AND ((t0.column_name)::text = (t1.column_name)::text))));


ALTER TABLE in_all_columns_and_foreign_key OWNER TO denevell;

--
-- Name: in_all_columns_with_foreign_key_table_and_column; Type: VIEW; Schema: public; Owner: denevell
--

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


ALTER TABLE in_all_columns_with_foreign_key_table_and_column OWNER TO denevell;

--
-- Name: in_all_columns_with_foreign_key_table_and_column_as_array; Type: VIEW; Schema: public; Owner: denevell
--

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


ALTER TABLE in_all_columns_with_foreign_key_table_and_column_as_array OWNER TO denevell;

--
-- Name: in_all_tables_with_params; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_all_tables_with_params AS
 SELECT in_all_columns_with_foreign_key_table_and_column.table_name,
    ((('_'::text || (in_all_columns_with_foreign_key_table_and_column.column_name)::text) || ' '::text) || (in_all_columns_with_foreign_key_table_and_column.data_type)::text) AS param,
    ('_'::text || (in_all_columns_with_foreign_key_table_and_column.column_name)::text) AS param_input,
    in_all_columns_with_foreign_key_table_and_column.column_default,
    in_all_columns_with_foreign_key_table_and_column.column_name
   FROM in_all_columns_with_foreign_key_table_and_column
  ORDER BY in_all_columns_with_foreign_key_table_and_column.table_name;


ALTER TABLE in_all_tables_with_params OWNER TO denevell;

--
-- Name: in_all_tables_with_params_concantenated; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_all_tables_with_params_concantenated AS
 SELECT in_all_tables_with_params.table_name,
    (('('::text || array_to_string(array_agg((in_all_tables_with_params.column_name)::text), ','::text)) || ')'::text) AS all_params,
    (('values('::text || array_to_string(array_agg(in_all_tables_with_params.param_input), ','::text)) || ')'::text) AS all_values,
    (('('::text || array_to_string(array_agg(in_all_tables_with_params.param), ','::text)) || ')'::text) AS all_sp_params
   FROM in_all_tables_with_params
  GROUP BY in_all_tables_with_params.table_name;


ALTER TABLE in_all_tables_with_params_concantenated OWNER TO denevell;

--
-- Name: in_all_tables_with_params_excluding_defaults_concantenated; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_all_tables_with_params_excluding_defaults_concantenated AS
 SELECT in_all_tables_with_params.table_name,
    (('('::text || array_to_string(array_agg((in_all_tables_with_params.column_name)::text), ','::text)) || ')'::text) AS all_params,
    (('values('::text || array_to_string(array_agg(in_all_tables_with_params.param_input), ','::text)) || ')'::text) AS all_values,
    (('('::text || array_to_string(array_agg(in_all_tables_with_params.param), ','::text)) || ')'::text) AS all_sp_params
   FROM in_all_tables_with_params
  WHERE (in_all_tables_with_params.column_default IS NULL)
  GROUP BY in_all_tables_with_params.table_name;


ALTER TABLE in_all_tables_with_params_excluding_defaults_concantenated OWNER TO denevell;

