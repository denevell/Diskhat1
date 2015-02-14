--
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
-- Name: in_columns_and_foreign_keys; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_columns_and_foreign_keys AS
 SELECT t0.table_name,
    t0.column_name,
    t0.data_type,
    t0.column_default,
    t0.is_nullable,
    t1.constraint_name
   FROM (in_columns_public t0
     LEFT JOIN in_foreign_key_constraints t1 ON ((((t0.table_name)::text = (t1.table_name)::text) AND ((t0.column_name)::text = (t1.column_name)::text))));


ALTER TABLE in_columns_and_foreign_keys OWNER TO denevell;

--
-- Name: in_columns_and_foreign_key_table_columns; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_columns_and_foreign_key_table_columns AS
 SELECT t0.table_name,
    t0.column_name,
    t0.data_type,
    t0.column_default,
    t0.is_nullable,
    t0.constraint_name,
    t1.table_name AS foreign_key_table,
    t1.column_name AS foreign_key_column
   FROM (in_columns_and_foreign_keys t0
     LEFT JOIN information_schema.constraint_column_usage t1 ON (((t0.constraint_name)::text = (t1.constraint_name)::text)));


ALTER TABLE in_columns_and_foreign_key_table_columns OWNER TO denevell;

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
 SELECT in_columns_and_foreign_key_table_columns.table_name,
    ((('_'::text || (in_columns_and_foreign_key_table_columns.column_name)::text) || ' '::text) || (in_columns_and_foreign_key_table_columns.data_type)::text) AS param,
    ('_'::text || (in_columns_and_foreign_key_table_columns.column_name)::text) AS param_input,
    in_columns_and_foreign_key_table_columns.column_default,
    in_columns_and_foreign_key_table_columns.column_name
   FROM in_columns_and_foreign_key_table_columns
  ORDER BY in_columns_and_foreign_key_table_columns.table_name;


ALTER TABLE in_sp_params OWNER TO denevell;

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

CREATE FUNCTION autogen_simple_inserts() RETURNS void
    LANGUAGE plpgsql
    AS $$
declare s text;
declare r record;
begin
                for r in select * from in_all_tables_with_params_simple_inserts loop
                                    raise notice '%', r."sql";
                                            execute r."sql";
                                                end loop;
end;
$$;


CREATE FUNCTION autogen_simple_inserts_excluding_defaults() RETURNS void
    LANGUAGE plpgsql
    AS $$
declare s text;
declare r record;
begin
                for r in select * from in_all_tables_with_params_simple_inserts_excluding_defaults loop
                                    raise notice '%', r."sql";
                                            execute r."sql";
                                                end loop;
end;
$$;

