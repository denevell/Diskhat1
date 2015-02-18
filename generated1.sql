--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: autogen; Type: SCHEMA; Schema: -; Owner: denevell
--

CREATE SCHEMA autogen;


ALTER SCHEMA autogen OWNER TO denevell;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = autogen, pg_catalog;

--
-- Name: insert_into_join_table_categories_tags(text, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION autogen_join_table_inserts() RETURNS void
    LANGUAGE plpgsql
    AS $$
declare s text;
declare r record;
begin
                for r in select * from in_join_table_sp_insert_functions loop
                                    raise notice '%', r."sql";
                                            execute r."sql";
                                                end loop;
end;
$$;


ALTER FUNCTION public.autogen_join_table_inserts() OWNER TO denevell;

--
-- Name: autogen_simple_inserts(); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION autogen_simple_inserts() RETURNS void
    LANGUAGE plpgsql
    AS $$
declare s text;
declare r record;
begin
        for r in select * from in_sp_simple_inserts loop
            raise notice '%', r."sql";
            execute r."sql";
        end loop;
end;
$$;


ALTER FUNCTION public.autogen_simple_inserts() OWNER TO denevell;

--
-- Name: autogen_simple_inserts_excluding_defaults(); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION autogen_simple_inserts_excluding_defaults() RETURNS void
    LANGUAGE plpgsql
    AS $$
declare s text;
declare r record;
begin
        for r in select * from in_sp_simple_inserts_excluding_defaults loop
            raise notice '%', r."sql";
            execute r."sql";
        end loop;
end;
$$;


ALTER FUNCTION public.autogen_simple_inserts_excluding_defaults() OWNER TO denevell;

--
-- Name: create_select_into_on_unique_column(text, text, text); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION create_select_into_on_unique_column(table_name_with_unique text, value_into text, value_match text) RETURNS text
    LANGUAGE plpgsql
    AS $$
    declare str text;
    begin
        select 'select ' || t0.column_name || ' into ' || value_into || ' from ' || t0.table_name || ' where ' || t1.column_name || ' = ' || value_match into str 
        from in_primary_key_constraints t0 
        join in_columns_unique t1 on t1.table_name = t0.table_name and t1.table_name = table_name_with_unique;
        return str;
    end;
$$;


ALTER FUNCTION public.create_select_into_on_unique_column(table_name_with_unique text, value_into text, value_match text) OWNER TO denevell;

CREATE VIEW in_columns AS
 SELECT columns.table_name,
    columns.column_name,
    columns.data_type,
    columns.column_default,
    columns.is_nullable
   FROM information_schema.columns;


ALTER TABLE in_columns OWNER TO denevell;

--
-- Name: in_tables_public; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_tables_public AS
 SELECT tables.table_name
   FROM information_schema.tables
  WHERE ((((tables.table_schema)::text = 'public'::text) AND ((tables.table_name)::text <> 'schema_version'::text)) AND ((tables.table_type)::text = 'BASE TABLE'::text));


ALTER TABLE in_tables_public OWNER TO denevell;

--
-- Name: in_columns_public; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_columns_public AS
 SELECT t0.table_name,
    t1.column_name,
    t1.data_type,
    t1.column_default,
    t1.is_nullable
   FROM (in_tables_public t0
     LEFT JOIN in_columns t1 ON (((t0.table_name)::text = (t1.table_name)::text)));


ALTER TABLE in_columns_public OWNER TO denevell;

--
-- Name: in_columns_as_declared_var; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_columns_as_declared_var AS
 SELECT t0.table_name,
    t0.column_name,
    ((('declare '::text || (t0.column_name)::text) || ' '::text) || (t0.data_type)::text) AS declared_var
   FROM in_columns_public t0;


ALTER TABLE in_columns_as_declared_var OWNER TO denevell;

--
-- Name: in_columns_public_non_default; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_columns_public_non_default AS
 SELECT t0.table_name,
    t0.column_name,
    t0.data_type,
    t0.is_nullable
   FROM in_columns_public t0
  WHERE (t0.column_default IS NULL);


ALTER TABLE in_columns_public_non_default OWNER TO denevell;

--
-- Name: in_foreign_key_constraints; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_foreign_key_constraints AS
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


ALTER TABLE in_foreign_key_constraints OWNER TO denevell;

--
-- Name: in_foreign_key_referenced_columns; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_foreign_key_referenced_columns AS
 SELECT t0.constraint_name,
    t1.table_name,
    t1.column_name
   FROM (in_foreign_key_constraints t0
     LEFT JOIN information_schema.constraint_column_usage t1 ON (((t0.constraint_name)::text = (t1.constraint_name)::text)));


ALTER TABLE in_foreign_key_referenced_columns OWNER TO denevell;

--
-- Name: in_foreign_keys_and_referenced_table_column; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_foreign_keys_and_referenced_table_column AS
 SELECT t0.constraint_name,
    t0.table_name,
    t0.column_name,
    t1.table_name AS referenced_table_name,
    t1.column_name AS referenced_column_name
   FROM (in_foreign_key_constraints t0
     JOIN in_foreign_key_referenced_columns t1 ON (((t0.constraint_name)::text = (t1.constraint_name)::text)));


ALTER TABLE in_foreign_keys_and_referenced_table_column OWNER TO denevell;

--
-- Name: in_columns_referenced_tables; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_columns_referenced_tables AS
 SELECT t0.table_name,
    t0.column_name,
    t1.referenced_table_name AS "references"
   FROM (in_columns_public t0
     LEFT JOIN in_foreign_keys_and_referenced_table_column t1 ON ((((t1.table_name)::text = (t0.table_name)::text) AND ((t1.column_name)::text = (t0.column_name)::text))));


ALTER TABLE in_columns_referenced_tables OWNER TO denevell;

--
-- Name: in_columns_referenced_tables_only; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_columns_referenced_tables_only AS
 SELECT t0.table_name,
    t0.column_name,
    t0."references"
   FROM in_columns_referenced_tables t0
  WHERE (t0."references" IS NOT NULL)
  ORDER BY t0.table_name;


ALTER TABLE in_columns_referenced_tables_only OWNER TO denevell;

--
-- Name: in_columns_unique; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_columns_unique AS
 SELECT t0.table_name,
    t0.column_name
   FROM (information_schema.constraint_column_usage t0
     JOIN information_schema.table_constraints t1 ON (((t1.constraint_name)::text = (t0.constraint_name)::text)))
  WHERE ((t1.constraint_type)::text = 'UNIQUE'::text);


ALTER TABLE in_columns_unique OWNER TO denevell;

--
-- Name: in_is_join_table; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_is_join_table AS
 SELECT t0.table_name,
    (count((t0."references")::text) > 0) AS join_table
   FROM in_columns_referenced_tables t0
  GROUP BY t0.table_name;


ALTER TABLE in_is_join_table OWNER TO denevell;

--
-- Name: in_join_tables; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_tables AS
 SELECT t0.table_name
   FROM in_is_join_table t0
  WHERE (t0.join_table = true);


ALTER TABLE in_join_tables OWNER TO denevell;

--
-- Name: in_join_table_columns; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_columns AS
 SELECT t0.table_name,
    t1.column_name,
    t1.data_type
   FROM (in_join_tables t0
     JOIN in_columns t1 ON (((t1.table_name)::text = (t0.table_name)::text)))
  ORDER BY t0.table_name, t1.column_name;


ALTER TABLE in_join_table_columns OWNER TO denevell;

--
-- Name: in_join_table_column_names_agg; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_column_names_agg AS
 SELECT t0.table_name,
    array_agg((t0.column_name)::text) AS name_agg
   FROM in_join_table_columns t0
  GROUP BY t0.table_name;


ALTER TABLE in_join_table_column_names_agg OWNER TO denevell;

--
-- Name: in_join_table_sp_params; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_sp_params AS
 SELECT t0.table_name,
    t0.column_name AS insert_column_name,
    (((t0.column_name)::text || '_'::text) || (t1.column_name)::text) AS sp_param_name,
    t1.data_type AS sp_param_type
   FROM (in_columns_referenced_tables_only t0
     JOIN in_columns_public_non_default t1 ON (((t0."references")::text = (t1.table_name)::text)));


ALTER TABLE in_join_table_sp_params OWNER TO denevell;

--
-- Name: in_join_table_sp_params_name_agg; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_sp_params_name_agg AS
 SELECT t0.table_name,
    t0.insert_column_name,
    array_agg(t0.sp_param_name) AS param_name_agg
   FROM in_join_table_sp_params t0
  GROUP BY t0.table_name, t0.insert_column_name;


ALTER TABLE in_join_table_sp_params_name_agg OWNER TO denevell;

--
-- Name: in_primary_key_constraints; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_primary_key_constraints AS
 SELECT t0.table_name,
    t1.column_name,
    t2.data_type,
    t0.constraint_name
   FROM ((information_schema.table_constraints t0
     JOIN information_schema.constraint_column_usage t1 ON (((t0.constraint_name)::text = (t1.constraint_name)::text)))
     JOIN information_schema.columns t2 ON ((((t2.table_name)::text = (t0.table_name)::text) AND ((t2.column_name)::text = (t1.column_name)::text))))
  WHERE ((t0.constraint_type)::text = 'PRIMARY KEY'::text);


ALTER TABLE in_primary_key_constraints OWNER TO denevell;

--
-- Name: in_returning_pk_statement; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_returning_pk_statement AS
 SELECT t0.table_name,
        CASE
            WHEN (t1.column_name IS NOT NULL) THEN ('returning '::text || (t1.column_name)::text)
            ELSE ''::text
        END AS returning_statement
   FROM (in_tables_public t0
     LEFT JOIN in_primary_key_constraints t1 ON (((t0.table_name)::text = (t1.table_name)::text)));


ALTER TABLE in_returning_pk_statement OWNER TO denevell;

--
-- Name: in_sp_params; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_sp_params AS
 SELECT t0.table_name,
    ((('_'::text || (t0.column_name)::text) || ' '::text) || (t0.data_type)::text) AS param,
    ('_'::text || (t0.column_name)::text) AS param_input,
    (''::character varying)::information_schema.character_data AS column_default,
    t0.column_name
   FROM in_columns_public t0
  ORDER BY t0.table_name, t0.column_name;


ALTER TABLE in_sp_params OWNER TO denevell;

--
-- Name: in_sp_params_excluding_defaults_concatenated; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_sp_params_excluding_defaults_concatenated AS
 SELECT in_sp_params.table_name,
    (('('::text || array_to_string(array_agg((in_sp_params.column_name)::text), ','::text)) || ')'::text) AS all_params,
    (('values('::text || array_to_string(array_agg(in_sp_params.param_input), ','::text)) || ')'::text) AS all_values,
    (('('::text || array_to_string(array_agg(in_sp_params.param), ','::text)) || ')'::text) AS all_sp_params
   FROM (in_sp_params
     LEFT JOIN in_columns_public t1 ON ((((t1.table_name)::text = (in_sp_params.table_name)::text) AND ((t1.column_name)::text = (in_sp_params.column_name)::text))))
  WHERE (t1.column_default IS NULL)
  GROUP BY in_sp_params.table_name;


ALTER TABLE in_sp_params_excluding_defaults_concatenated OWNER TO denevell;

--
-- Name: in_simple_insert_into_excluding_defaults; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_simple_insert_into_excluding_defaults AS
 SELECT t0.table_name,
    ((('insert into '::text || (t0.table_name)::text) || ' '::text) || t0.all_params) AS sql
   FROM in_sp_params_excluding_defaults_concatenated t0;


ALTER TABLE in_simple_insert_into_excluding_defaults OWNER TO denevell;

--
-- Name: in_join_table_columns_insert_statement; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_columns_insert_statement AS
 SELECT t0.table_name,
    t0.column_name,
    ((((((t3.sql || ' values('::text) || array_to_string(t4.param_name_agg, ','::text)) || ') '::text) || t5.returning_statement) || ' into '::text) || (t0.column_name)::text) AS insert_statement
   FROM ((((in_join_table_columns t0
     JOIN in_columns_referenced_tables_only t2 ON ((((t2.column_name)::text = (t0.column_name)::text) AND ((t2.table_name)::text = (t0.table_name)::text))))
     JOIN in_simple_insert_into_excluding_defaults t3 ON (((t3.table_name)::text = (t2."references")::text)))
     JOIN in_join_table_sp_params_name_agg t4 ON ((((t0.table_name)::text = (t4.table_name)::text) AND ((t4.insert_column_name)::text = (t0.column_name)::text))))
     JOIN in_returning_pk_statement t5 ON (((t2."references")::text = (t5.table_name)::text)))
  ORDER BY t0.table_name;


ALTER TABLE in_join_table_columns_insert_statement OWNER TO denevell;

--
-- Name: in_join_table_columns_insert_statements_agg; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_columns_insert_statements_agg AS
 SELECT t0.table_name,
    (array_to_string(array_agg(t0.insert_statement), '; '::text) || ';'::text) AS insert_statement
   FROM in_join_table_columns_insert_statement t0
  GROUP BY t0.table_name;


ALTER TABLE in_join_table_columns_insert_statements_agg OWNER TO denevell;

--
-- Name: in_join_table_declared_vars; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_declared_vars AS
 SELECT t0.table_name,
    t1.declared_var
   FROM (in_join_table_columns t0
     JOIN in_columns_as_declared_var t1 ON ((((t1.column_name)::text = (t0.column_name)::text) AND ((t1.table_name)::text = (t0.table_name)::text))))
  ORDER BY t0.table_name;


ALTER TABLE in_join_table_declared_vars OWNER TO denevell;

--
-- Name: in_join_table_final_inserts; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_final_inserts AS
 SELECT t0.table_name,
    (((t6.sql || ' values('::text) || array_to_string(t7.name_agg, ','::text)) || ')'::text) AS insert_statement
   FROM ((in_join_tables t0
     JOIN in_simple_insert_into_excluding_defaults t6 ON (((t6.table_name)::text = (t0.table_name)::text)))
     JOIN in_join_table_column_names_agg t7 ON (((t7.table_name)::text = (t0.table_name)::text)))
  ORDER BY t0.table_name;


ALTER TABLE in_join_table_final_inserts OWNER TO denevell;

--
-- Name: in_join_table_sp_declared_vars; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_sp_declared_vars AS
 SELECT t0.table_name,
    (array_to_string(array_agg(t1.declared_var), '; '::text) || ';'::text) AS declare_var_statements
   FROM (in_join_table_columns t0
     JOIN in_columns_as_declared_var t1 ON ((((t0.table_name)::text = (t1.table_name)::text) AND ((t0.column_name)::text = (t1.column_name)::text))))
  GROUP BY t0.table_name, t0.data_type
  ORDER BY t0.table_name;


ALTER TABLE in_join_table_sp_declared_vars OWNER TO denevell;

--
-- Name: in_join_table_sp_params_concat; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_sp_params_concat AS
 SELECT t0.table_name,
    ((t0.sp_param_name || ' '::text) || (t0.sp_param_type)::text) AS param_name_concat
   FROM in_join_table_sp_params t0
  ORDER BY t0.table_name;


ALTER TABLE in_join_table_sp_params_concat OWNER TO denevell;

--
-- Name: in_join_table_sp_params_concat_agg; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_sp_params_concat_agg AS
 SELECT t0.table_name,
    array_to_string(array_agg(t0.param_name_concat), ','::text) AS param_name_conat_agg
   FROM in_join_table_sp_params_concat t0
  GROUP BY t0.table_name;


ALTER TABLE in_join_table_sp_params_concat_agg OWNER TO denevell;

--
-- Name: in_join_table_sp_insert_functions; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_sp_insert_functions AS
 SELECT t1.table_name,
    (((((((((('create or replace function autogen.insert_into_join_table_'::text || (t0.table_name)::text) || ' ('::text) || t1.param_name_conat_agg) || ') returns void language plpgsql as $function$ '::text) || t2.declare_var_statements) || ' begin '::text) || t3.insert_statement) || ' '::text) || t4.insert_statement) || '; end; $function$;'::text) AS sql
   FROM ((((in_join_tables t0
     JOIN in_join_table_sp_params_concat_agg t1 ON (((t1.table_name)::text = (t0.table_name)::text)))
     JOIN in_join_table_sp_declared_vars t2 ON (((t2.table_name)::text = (t0.table_name)::text)))
     JOIN in_join_table_columns_insert_statements_agg t3 ON (((t3.table_name)::text = (t0.table_name)::text)))
     JOIN in_join_table_final_inserts t4 ON (((t4.table_name)::text = (t0.table_name)::text)));


ALTER TABLE in_join_table_sp_insert_functions OWNER TO denevell;

--
-- Name: in_join_tables_sp_params_concatenated; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_tables_sp_params_concatenated AS
 SELECT t0.table_name,
    t0.insert_column_name,
    ((t0.sp_param_name || ' '::text) || (t0.sp_param_type)::text) AS sp_param
   FROM in_join_table_sp_params t0
  ORDER BY t0.table_name;


ALTER TABLE in_join_tables_sp_params_concatenated OWNER TO denevell;

--
-- Name: in_join_tables_sp_params_concatenated_agg; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_tables_sp_params_concatenated_agg AS
 SELECT t0.table_name,
    t0.insert_column_name,
    array_agg(t0.sp_param) AS sp_param_agg
   FROM in_join_tables_sp_params_concatenated t0
  GROUP BY t0.table_name, t0.insert_column_name
  ORDER BY t0.table_name;


ALTER TABLE in_join_tables_sp_params_concatenated_agg OWNER TO denevell;

--
-- Name: in_returns_pk_statement; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_returns_pk_statement AS
 SELECT t0.table_name,
        CASE
            WHEN (t1.constraint_name IS NOT NULL) THEN ('returns '::text || (t1.data_type)::text)
            ELSE 'returns void'::text
        END AS returns_statement
   FROM (in_sp_params t0
     LEFT JOIN in_primary_key_constraints t1 ON (((t0.table_name)::text = (t1.table_name)::text)))
  GROUP BY t0.table_name,
        CASE
            WHEN (t1.constraint_name IS NOT NULL) THEN ('returns '::text || (t1.data_type)::text)
            ELSE 'returns void'::text
        END;


ALTER TABLE in_returns_pk_statement OWNER TO denevell;

--
-- Name: in_sp_params_concantenated; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_sp_params_concantenated AS
 SELECT in_sp_params.table_name,
    (('('::text || array_to_string(array_agg((in_sp_params.column_name)::text), ','::text)) || ')'::text) AS all_params,
    (('values('::text || array_to_string(array_agg(in_sp_params.param_input), ','::text)) || ')'::text) AS all_values,
    (('('::text || array_to_string(array_agg(in_sp_params.param), ','::text)) || ')'::text) AS all_sp_params
   FROM in_sp_params
  GROUP BY in_sp_params.table_name;


ALTER TABLE in_sp_params_concantenated OWNER TO denevell;

--
-- Name: in_simple_inserts; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_simple_inserts AS
 SELECT t0.table_name,
    ((((((('insert into '::text || (t0.table_name)::text) || ' '::text) || t0.all_params) || ' '::text) || t0.all_values) || ' '::text) || t2.returning_statement) AS sql
   FROM ((in_sp_params_concantenated t0
     LEFT JOIN in_returns_pk_statement t1 ON (((t1.table_name)::text = (t0.table_name)::text)))
     LEFT JOIN in_returning_pk_statement t2 ON (((t2.table_name)::text = (t0.table_name)::text)));


ALTER TABLE in_simple_inserts OWNER TO denevell;

--
-- Name: in_simple_inserts_excluding_defaults; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_simple_inserts_excluding_defaults AS
 SELECT t0.table_name,
    ((((((('insert into '::text || (t0.table_name)::text) || ' '::text) || t0.all_params) || ' '::text) || t0.all_values) || ' '::text) || t2.returning_statement) AS sql
   FROM ((in_sp_params_excluding_defaults_concatenated t0
     LEFT JOIN in_returns_pk_statement t1 ON (((t1.table_name)::text = (t0.table_name)::text)))
     LEFT JOIN in_returning_pk_statement t2 ON (((t2.table_name)::text = (t0.table_name)::text)));


ALTER TABLE in_simple_inserts_excluding_defaults OWNER TO denevell;

--
-- Name: in_sp_simple_inserts; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_sp_simple_inserts AS
 SELECT t0.table_name,
    ((((((((((((((('create or replace function autogen.insert_'::text || (t0.table_name)::text) || ' '::text) || t0.all_sp_params) || ' '::text) || t1.returns_statement) || ' language sql as $x$ insert into '::text) || (t0.table_name)::text) || ' '::text) || t0.all_params) || ' '::text) || t0.all_values) || ' '::text) || t2.returning_statement) || ';'::text) || '$x$;'::text) AS sql
   FROM ((in_sp_params_concantenated t0
     LEFT JOIN in_returns_pk_statement t1 ON (((t1.table_name)::text = (t0.table_name)::text)))
     LEFT JOIN in_returning_pk_statement t2 ON (((t2.table_name)::text = (t0.table_name)::text)));


ALTER TABLE in_sp_simple_inserts OWNER TO denevell;

--
-- Name: in_sp_simple_inserts_excluding_defaults; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_sp_simple_inserts_excluding_defaults AS
 SELECT t0.table_name,
    ((((((((((((((('create or replace function autogen.insert_excluding_defaults_'::text || (t0.table_name)::text) || ' '::text) || t0.all_sp_params) || ' '::text) || t1.returns_statement) || ' language sql as $x$ insert into '::text) || (t0.table_name)::text) || ' '::text) || t0.all_params) || ' '::text) || t0.all_values) || ' '::text) || t2.returning_statement) || ';'::text) || '$x$;'::text) AS sql
   FROM ((in_sp_params_excluding_defaults_concatenated t0
     LEFT JOIN in_returns_pk_statement t1 ON (((t1.table_name)::text = (t0.table_name)::text)))
     LEFT JOIN in_returning_pk_statement t2 ON (((t2.table_name)::text = (t0.table_name)::text)));


ALTER TABLE in_sp_simple_inserts_excluding_defaults OWNER TO denevell;

--
-- Name: koans_id_seq; Type: SEQUENCE; Schema: public; Owner: denevell
--

CREATE SEQUENCE koans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE koans_id_seq OWNER TO denevell;

--
-- Name: koans; Type: TABLE; Schema: public; Owner: denevell; Tablespace: 
--

CREATE TABLE koans (
    id integer DEFAULT nextval('koans_id_seq'::regclass) NOT NULL,
    message text
);


ALTER TABLE koans OWNER TO denevell;

--
-- Name: koans_tags; Type: TABLE; Schema: public; Owner: denevell; Tablespace: 
--

CREATE TABLE koans_tags (
    koan_id integer,
    tag_id integer
);


ALTER TABLE koans_tags OWNER TO denevell;

--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: denevell; Tablespace: 
--

CREATE TABLE schema_version (
    version_rank integer NOT NULL,
    installed_rank integer NOT NULL,
    version character varying(50) NOT NULL,
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE schema_version OWNER TO denevell;

--
-- Name: str; Type: TABLE; Schema: public; Owner: denevell; Tablespace: 
--

CREATE TABLE str (
    "?column?" text
);


ALTER TABLE str OWNER TO denevell;

--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: denevell
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tags_id_seq OWNER TO denevell;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: denevell; Tablespace: 
--

CREATE TABLE tags (
    id integer DEFAULT nextval('tags_id_seq'::regclass) NOT NULL,
    tag text
);


ALTER TABLE tags OWNER TO denevell;

--
-- Name: tmp; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW tmp AS
 SELECT t0.table_name,
    t0.column_name,
    t0.insert_statement,
    create_select_into_on_unique_column((t1.table_name)::text, (t0.column_name)::text, (((t0.column_name)::text || '_'::text) || (t1.column_name)::text)) AS create_select_into_on_unique_column
   FROM ((in_join_table_columns_insert_statement t0
     LEFT JOIN in_columns_referenced_tables t2 ON ((((t2.table_name)::text = (t0.table_name)::text) AND ((t2.column_name)::text = (t0.column_name)::text))))
     LEFT JOIN in_columns_unique t1 ON (((t1.table_name)::text = (t2."references")::text)));


ALTER TABLE tmp OWNER TO denevell;

--
-- Name: tmp_multicolumn_id_seq; Type: SEQUENCE; Schema: public; Owner: denevell
--

CREATE SEQUENCE tmp_multicolumn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tmp_multicolumn_id_seq OWNER TO denevell;

--
-- Name: tmp_multicolumn; Type: TABLE; Schema: public; Owner: denevell; Tablespace: 
--

CREATE TABLE tmp_multicolumn (
    id integer DEFAULT nextval('tmp_multicolumn_id_seq'::regclass) NOT NULL,
    one text,
    two text
);


ALTER TABLE tmp_multicolumn OWNER TO denevell;

--
-- Name: tmp_multicolumn_tags; Type: TABLE; Schema: public; Owner: denevell; Tablespace: 
--

CREATE TABLE tmp_multicolumn_tags (
    multi_id integer,
    koan_id integer
);


ALTER TABLE tmp_multicolumn_tags OWNER TO denevell;

--
-- Name: koans_pkey; Type: CONSTRAINT; Schema: public; Owner: denevell; Tablespace: 
--

ALTER TABLE ONLY koans
    ADD CONSTRAINT koans_pkey PRIMARY KEY (id);


--
-- Name: schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: denevell; Tablespace: 
--

ALTER TABLE ONLY schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (version);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: denevell; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: tmp_multicolumn_pkey; Type: CONSTRAINT; Schema: public; Owner: denevell; Tablespace: 
--

ALTER TABLE ONLY tmp_multicolumn
    ADD CONSTRAINT tmp_multicolumn_pkey PRIMARY KEY (id);


--
-- Name: unique_tag; Type: CONSTRAINT; Schema: public; Owner: denevell; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT unique_tag UNIQUE (tag);


--
-- Name: schema_version_ir_idx; Type: INDEX; Schema: public; Owner: denevell; Tablespace: 
--

CREATE INDEX schema_version_ir_idx ON schema_version USING btree (installed_rank);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: denevell; Tablespace: 
--

CREATE INDEX schema_version_s_idx ON schema_version USING btree (success);


--
-- Name: schema_version_vr_idx; Type: INDEX; Schema: public; Owner: denevell; Tablespace: 
--

CREATE INDEX schema_version_vr_idx ON schema_version USING btree (version_rank);


--
-- Name: categories_tags_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: denevell
--

ALTER TABLE ONLY categories_tags
    ADD CONSTRAINT categories_tags_category_id_fkey FOREIGN KEY (category_id) REFERENCES tags(id);


--
-- Name: categories_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: denevell
--

ALTER TABLE ONLY categories_tags
    ADD CONSTRAINT categories_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tags(id);


--
-- Name: koans_tags_koan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: denevell
--

ALTER TABLE ONLY koans_tags
    ADD CONSTRAINT koans_tags_koan_id_fkey FOREIGN KEY (koan_id) REFERENCES koans(id) ON DELETE CASCADE;


--
-- Name: koans_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: denevell
--

ALTER TABLE ONLY koans_tags
    ADD CONSTRAINT koans_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tags(id);


--
-- Name: tmp_multicolumn_tags_koan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: denevell
--

ALTER TABLE ONLY tmp_multicolumn_tags
    ADD CONSTRAINT tmp_multicolumn_tags_koan_id_fkey FOREIGN KEY (koan_id) REFERENCES koans(id);


--
-- Name: tmp_multicolumn_tags_multi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: denevell
--

ALTER TABLE ONLY tmp_multicolumn_tags
    ADD CONSTRAINT tmp_multicolumn_tags_multi_id_fkey FOREIGN KEY (multi_id) REFERENCES tmp_multicolumn(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

