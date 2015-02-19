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
-- Name: insert_into_join_table_with_unique_catch_categories_tags(text, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_into_join_table_with_unique_catch_categories_tags(category_id_tag text, tag_id_tag text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare category_id integer; declare tag_id integer; begin begin insert into tags (tag) values(category_id_tag) returning id into category_id; exception when unique_violation then select id into category_id from tags where tag = category_id_tag; end; begin insert into tags (tag) values(tag_id_tag) returning id into tag_id; exception when unique_violation then select id into tag_id from tags where tag = tag_id_tag; end; insert into categories_tags (category_id,tag_id) values(category_id,tag_id); end; $$;


ALTER FUNCTION autogen.insert_into_join_table_with_unique_catch_categories_tags(category_id_tag text, tag_id_tag text) OWNER TO denevell;

--
-- Name: insert_into_join_table_with_unique_catch_koans_tags(text, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_into_join_table_with_unique_catch_koans_tags(koan_id_message text, tag_id_tag text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare koan_id integer; declare tag_id integer; begin insert into koans (message) values(koan_id_message) returning id into koan_id; begin insert into tags (tag) values(tag_id_tag) returning id into tag_id; exception when unique_violation then select id into tag_id from tags where tag = tag_id_tag; end; insert into koans_tags (koan_id,tag_id) values(koan_id,tag_id); end; $$;


ALTER FUNCTION autogen.insert_into_join_table_with_unique_catch_koans_tags(koan_id_message text, tag_id_tag text) OWNER TO denevell;

--
-- Name: insert_into_join_table_with_unique_catch_tmp_multicolumn_tags(text, text, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_into_join_table_with_unique_catch_tmp_multicolumn_tags(koan_id_message text, multi_id_one text, multi_id_two text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare koan_id integer; declare multi_id integer; begin insert into koans (message) values(koan_id_message) returning id into koan_id; insert into tmp_multicolumn (one,two) values(multi_id_one,multi_id_two) returning id into multi_id; insert into tmp_multicolumn_tags (koan_id,multi_id) values(koan_id,multi_id); end; $$;


ALTER FUNCTION autogen.insert_into_join_table_with_unique_catch_tmp_multicolumn_tags(koan_id_message text, multi_id_one text, multi_id_two text) OWNER TO denevell;

SET search_path = public, pg_catalog;

--
-- Name: autogen_join_table_inserts(); Type: FUNCTION; Schema: public; Owner: denevell
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
-- Name: autogen_join_table_inserts_with_unique_catch(); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION autogen_join_table_inserts_with_unique_catch() RETURNS void
    LANGUAGE plpgsql
    AS $$
declare s text;
declare r record;
begin
                for r in select * from in_join_table_sp_insert_functions_with_unique_catch loop
                                    raise notice '%', r."sql";
                                            execute r."sql";
                                                end loop;
end;
$$;


ALTER FUNCTION public.autogen_join_table_inserts_with_unique_catch() OWNER TO denevell;

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

--
-- Name: ex_koan_delete(integer); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION ex_koan_delete(_id integer) RETURNS void
    LANGUAGE sql
    AS $$

delete from koans where id=_id;

$$;


ALTER FUNCTION public.ex_koan_delete(_id integer) OWNER TO denevell;

--
-- Name: ex_koan_insert(text, text[]); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION ex_koan_insert(_msg text, _tags text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$

declare tagIds integer[];
declare aKoanId integer;

begin
        select in_insert_koan(_msg) into aKoanId;
        select in_insert_tag_ignore_error(_tags) into tagIds;
        perform in_koans_tags_insert(aKoanId, tagIds);
end;

$$;


ALTER FUNCTION public.ex_koan_insert(_msg text, _tags text[]) OWNER TO denevell;

--
-- Name: ex_koan_update(integer, text, text[]); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION ex_koan_update(_id integer, _koan text, _tags text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$

    declare tagIds integer[];

    begin
        update koans set message=_koan where id=_id;
        delete from koans_tags where koan_id=_id;
        select in_insert_tag_ignore_error(_tags) into tagIds;
        perform in_koans_tags_insert(_id, tagIds);
    end; 

$$;


ALTER FUNCTION public.ex_koan_update(_id integer, _koan text, _tags text[]) OWNER TO denevell;

--
-- Name: ex_koans_all(text); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION ex_koans_all(_tag text) RETURNS json
    LANGUAGE plpgsql
    AS $$

    declare jsonToReturn json;

    begin

        if _tag='' then
            select array_to_json(array_agg(x), true) into jsonToReturn from 
                    (select t0.id, t0.message, array_agg(tag) as tags
                    from koans t0
                    left join koans_tags t1 on t1.koan_id=t0.id
                    left join tags t2 on t2.id=t1.tag_id
                    group by t0.id, t0.message
                    order by t0.id) x;
        else

            select array_to_json(array_agg(x), true) into jsonToReturn from 
                    (select t0.id, t0.message, in_get_tags_by_koan_id(t0.id) as tags
                    from koans t0
                    join koans_tags t1 on t1.koan_id=t0.id
                    join tags t2 on t2.id=t1.tag_id
                    where t2.tag = _tag
                    order by t0.id) x;
        end if;

        return jsonToReturn;

    end;

$$;


ALTER FUNCTION public.ex_koans_all(_tag text) OWNER TO denevell;

--
-- Name: in_get_tags_by_koan_id(integer); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION in_get_tags_by_koan_id(_id integer) RETURNS text[]
    LANGUAGE sql
    AS $$

    select array_agg(x.tag) from (select t1.tag
            from koans_tags t0
            join tags t1 on t1.id = t0.tag_id
            where t0.koan_id=_id) x;

$$;


ALTER FUNCTION public.in_get_tags_by_koan_id(_id integer) OWNER TO denevell;

--
-- Name: in_insert_koan(text); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION in_insert_koan(_text text) RETURNS integer
    LANGUAGE plpgsql
    AS $$

declare id_ int;

begin

        insert into koans (message) values(_text) returning id into id_;
        return id_;

end;
$$;


ALTER FUNCTION public.in_insert_koan(_text text) OWNER TO denevell;

--
-- Name: in_insert_tag_ignore_error(text[]); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION in_insert_tag_ignore_error(_tags text[]) RETURNS integer[]
    LANGUAGE plpgsql
    AS $$ 

declare aTag text;
declare anId integer;
declare tagIds integer[];

begin 
        
    foreach aTag in array _tags
    loop
        begin
            insert into tags (tag) values(aTag) returning id into anId;
            tagIds := array_append(tagIds, anId);
            exception when unique_violation 
            then
            select id into anId from tags where tag=aTag;
            tagIds := array_append(tagIds, anId);
        end;
    end loop;
    --select id into id_ from tags where tag=_tag;
    return tagIds;

end;

$$;


ALTER FUNCTION public.in_insert_tag_ignore_error(_tags text[]) OWNER TO denevell;

--
-- Name: in_koans_tags_insert(integer, integer[]); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION in_koans_tags_insert(_koanid integer, _tagids integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
    declare aTagId integer;
    begin
        foreach aTagId in array _tagIds loop
        begin
            insert into koans_tags values(_koanid, aTagId);
        end; 
        end loop;
    end;

$$;


ALTER FUNCTION public.in_koans_tags_insert(_koanid integer, _tagids integer[]) OWNER TO denevell;

--
-- Name: _columns; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _columns AS
 SELECT columns.table_name,
    columns.column_name,
    columns.data_type,
    columns.column_default,
    columns.is_nullable
   FROM information_schema.columns
  ORDER BY columns.column_name;


ALTER TABLE _columns OWNER TO denevell;

--
-- Name: _columns_foreign_key; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _columns_foreign_key AS
 SELECT kcu.table_name,
    kcu.column_name,
    kcu.constraint_name
   FROM (information_schema.key_column_usage kcu
     LEFT JOIN information_schema.table_constraints tc ON (((tc.constraint_name)::text = (kcu.constraint_name)::text)))
  WHERE ((tc.constraint_type)::text = 'FOREIGN KEY'::text);


ALTER TABLE _columns_foreign_key OWNER TO denevell;

--
-- Name: _columns_primary_key; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _columns_primary_key AS
 SELECT t0.table_name,
    t1.column_name,
    t2.data_type,
    t0.constraint_name
   FROM ((information_schema.table_constraints t0
     JOIN information_schema.constraint_column_usage t1 ON (((t0.constraint_name)::text = (t1.constraint_name)::text)))
     JOIN information_schema.columns t2 ON ((((t2.table_name)::text = (t0.table_name)::text) AND ((t2.column_name)::text = (t1.column_name)::text))))
  WHERE ((t0.constraint_type)::text = 'PRIMARY KEY'::text);


ALTER TABLE _columns_primary_key OWNER TO denevell;

--
-- Name: _tables_public; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _tables_public AS
 SELECT tables.table_name
   FROM information_schema.tables
  WHERE ((((tables.table_schema)::text = 'public'::text) AND ((tables.table_name)::text <> 'schema_version'::text)) AND ((tables.table_type)::text = 'BASE TABLE'::text));


ALTER TABLE _tables_public OWNER TO denevell;

--
-- Name: _columns_public; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _columns_public AS
 SELECT t0.table_name,
    t1.column_name,
    t1.data_type,
    t1.column_default,
    t1.is_nullable
   FROM (_tables_public t0
     LEFT JOIN _columns t1 ON (((t0.table_name)::text = (t1.table_name)::text)))
  ORDER BY t0.table_name, t1.column_name;


ALTER TABLE _columns_public OWNER TO denevell;

--
-- Name: _columns_unique; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _columns_unique AS
 SELECT t0.table_name,
    t0.column_name
   FROM (information_schema.constraint_column_usage t0
     JOIN information_schema.table_constraints t1 ON (((t1.constraint_name)::text = (t0.constraint_name)::text)))
  WHERE ((t1.constraint_type)::text = 'UNIQUE'::text);


ALTER TABLE _columns_unique OWNER TO denevell;

--
-- Name: _sp_simple_inserts; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _sp_simple_inserts AS
 SELECT t0.table_name,
    (((((((((((((((('create or replace function autogen.insert_'::text || (t0.table_name)::text) || ' ('::text) || insert_sp_name_args.args) || ') '::text) || 'returns '::text) || (
        CASE
            WHEN (pk.data_type IS NOT NULL) THEN (pk.data_type)::character varying
            ELSE 'void'::character varying
        END)::text) || ' language sql as $x$ insert into '::text) || (t0.table_name)::text) || ' ('::text) || insert_name_args.args) || ') values('::text) || insert_name_args.args) || ') '::text) ||
        CASE
            WHEN (pk.data_type IS NOT NULL) THEN ('returning '::text || (pk.column_name)::text)
            ELSE ''::text
        END) || ';'::text) || '$x$;'::text) AS sql
   FROM (((_tables_public t0
     LEFT JOIN ( SELECT cp.table_name,
            array_to_string(array_agg((cp.column_name)::text), ','::text) AS args
           FROM _columns_public cp
          GROUP BY cp.table_name) insert_name_args ON (((insert_name_args.table_name)::text = (t0.table_name)::text)))
     LEFT JOIN ( SELECT cp.table_name,
            array_to_string(array_agg(cp.col_type), ','::text) AS args
           FROM ( SELECT _columns_public.table_name,
                    (((_columns_public.column_name)::text || ' '::text) || (_columns_public.data_type)::text) AS col_type
                   FROM _columns_public) cp
          GROUP BY cp.table_name) insert_sp_name_args ON (((insert_sp_name_args.table_name)::text = (t0.table_name)::text)))
     LEFT JOIN ( SELECT _columns_primary_key.table_name,
            _columns_primary_key.column_name,
            _columns_primary_key.data_type
           FROM _columns_primary_key) pk ON (((pk.table_name)::text = (t0.table_name)::text)));


ALTER TABLE _sp_simple_inserts OWNER TO denevell;

--
-- Name: _sp_simple_inserts_excluding_defaults; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _sp_simple_inserts_excluding_defaults AS
 SELECT t0.table_name,
    (((((((((((((((('create or replace function autogen.insert_'::text || (t0.table_name)::text) || ' ('::text) || insert_sp_name_args.args) || ') '::text) || 'returns '::text) || (
        CASE
            WHEN (pk.data_type IS NOT NULL) THEN (pk.data_type)::character varying
            ELSE 'void'::character varying
        END)::text) || ' language sql as $x$ insert into '::text) || (t0.table_name)::text) || ' ('::text) || insert_name_args.args) || ') values('::text) || insert_name_args.args) || ') '::text) ||
        CASE
            WHEN (pk.data_type IS NOT NULL) THEN ('returning '::text || (pk.column_name)::text)
            ELSE ''::text
        END) || ';'::text) || '$x$;'::text) AS sql
   FROM (((_tables_public t0
     LEFT JOIN ( SELECT cp.table_name,
            array_to_string(array_agg((cp.column_name)::text), ','::text) AS args
           FROM _columns_public cp
          WHERE (cp.column_default IS NULL)
          GROUP BY cp.table_name) insert_name_args ON (((insert_name_args.table_name)::text = (t0.table_name)::text)))
     LEFT JOIN ( SELECT cp.table_name,
            array_to_string(array_agg(cp.col_type), ','::text) AS args
           FROM ( SELECT _columns_public.table_name,
                    (((_columns_public.column_name)::text || ' '::text) || (_columns_public.data_type)::text) AS col_type
                   FROM _columns_public
                  WHERE (_columns_public.column_default IS NULL)) cp
          GROUP BY cp.table_name) insert_sp_name_args ON (((insert_sp_name_args.table_name)::text = (t0.table_name)::text)))
     LEFT JOIN ( SELECT _columns_primary_key.table_name,
            _columns_primary_key.column_name,
            _columns_primary_key.data_type
           FROM _columns_primary_key) pk ON (((pk.table_name)::text = (t0.table_name)::text)));


ALTER TABLE _sp_simple_inserts_excluding_defaults OWNER TO denevell;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories_tags; Type: TABLE; Schema: public; Owner: denevell; Tablespace: 
--

CREATE TABLE categories_tags (
    tag_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE categories_tags OWNER TO denevell;

--
-- Name: in_columns_as_declared_var; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_columns_as_declared_var AS
 SELECT t0.table_name,
    t0.column_name,
    ((('declare '::text || (t0.column_name)::text) || ' '::text) || (t0.data_type)::text) AS declared_var
   FROM _columns_public t0;


ALTER TABLE in_columns_as_declared_var OWNER TO denevell;

--
-- Name: in_columns_public_non_default; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_columns_public_non_default AS
 SELECT t0.table_name,
    t0.column_name,
    t0.data_type,
    t0.is_nullable
   FROM _columns_public t0
  WHERE (t0.column_default IS NULL);


ALTER TABLE in_columns_public_non_default OWNER TO denevell;

--
-- Name: in_foreign_key_referenced_columns; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_foreign_key_referenced_columns AS
 SELECT t0.constraint_name,
    t1.table_name,
    t1.column_name
   FROM (_columns_foreign_key t0
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
   FROM (_columns_foreign_key t0
     JOIN in_foreign_key_referenced_columns t1 ON (((t0.constraint_name)::text = (t1.constraint_name)::text)));


ALTER TABLE in_foreign_keys_and_referenced_table_column OWNER TO denevell;

--
-- Name: in_columns_referenced_tables; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_columns_referenced_tables AS
 SELECT t0.table_name,
    t0.column_name,
    t1.referenced_table_name AS "references"
   FROM (_columns_public t0
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
     JOIN _columns t1 ON (((t1.table_name)::text = (t0.table_name)::text)))
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
-- Name: in_returning_pk_statement; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_returning_pk_statement AS
 SELECT t0.table_name,
        CASE
            WHEN (t1.column_name IS NOT NULL) THEN ('returning '::text || (t1.column_name)::text)
            ELSE ''::text
        END AS returning_statement
   FROM (_tables_public t0
     LEFT JOIN _columns_primary_key t1 ON (((t0.table_name)::text = (t1.table_name)::text)));


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
   FROM _columns_public t0
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
     LEFT JOIN _columns_public t1 ON ((((t1.table_name)::text = (in_sp_params.table_name)::text) AND ((t1.column_name)::text = (in_sp_params.column_name)::text))))
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
-- Name: in_join_table_columns_select_into_via_unique_statement; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_columns_select_into_via_unique_statement AS
 SELECT t0.table_name,
    t0.column_name,
    t0.insert_statement,
    create_select_into_on_unique_column((t2.table_name)::text, (t0.column_name)::text, (((t0.column_name)::text || '_'::text) || (t2.column_name)::text)) AS select_into_via_unique
   FROM ((in_join_table_columns_insert_statement t0
     LEFT JOIN in_columns_referenced_tables t1 ON ((((t1.table_name)::text = (t0.table_name)::text) AND ((t1.column_name)::text = (t0.column_name)::text))))
     LEFT JOIN _columns_unique t2 ON (((t2.table_name)::text = (t1."references")::text)));


ALTER TABLE in_join_table_columns_select_into_via_unique_statement OWNER TO denevell;

--
-- Name: in_join_table_columns_insert_statement_with_unique_catch; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_columns_insert_statement_with_unique_catch AS
 SELECT t0.table_name,
    t0.column_name,
        CASE
            WHEN (t0.select_into_via_unique IS NULL) THEN (t0.insert_statement || ';'::text)
            ELSE (((('begin '::text || t0.insert_statement) || '; exception when unique_violation then '::text) || t0.select_into_via_unique) || '; end;'::text)
        END AS sql
   FROM in_join_table_columns_select_into_via_unique_statement t0;


ALTER TABLE in_join_table_columns_insert_statement_with_unique_catch OWNER TO denevell;

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
-- Name: in_join_table_columns_insert_statements_with_unique_catche_agg; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_columns_insert_statements_with_unique_catche_agg AS
 SELECT t0.table_name,
    array_to_string(array_agg(t0.sql), ' '::text) AS insert_statement
   FROM in_join_table_columns_insert_statement_with_unique_catch t0
  GROUP BY t0.table_name;


ALTER TABLE in_join_table_columns_insert_statements_with_unique_catche_agg OWNER TO denevell;

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
-- Name: in_join_table_sp_insert_functions_with_unique_catch; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_sp_insert_functions_with_unique_catch AS
 SELECT t1.table_name,
    (((((((((('create or replace function autogen.insert_into_join_table_with_unique_catch_'::text || (t0.table_name)::text) || ' ('::text) || t1.param_name_conat_agg) || ') returns void language plpgsql as $function$ '::text) || t2.declare_var_statements) || ' begin '::text) || t3.insert_statement) || ' '::text) || t4.insert_statement) || '; end; $function$;'::text) AS sql
   FROM ((((in_join_tables t0
     JOIN in_join_table_sp_params_concat_agg t1 ON (((t1.table_name)::text = (t0.table_name)::text)))
     JOIN in_join_table_sp_declared_vars t2 ON (((t2.table_name)::text = (t0.table_name)::text)))
     JOIN in_join_table_columns_insert_statements_with_unique_catche_agg t3 ON (((t3.table_name)::text = (t0.table_name)::text)))
     JOIN in_join_table_final_inserts t4 ON (((t4.table_name)::text = (t0.table_name)::text)));


ALTER TABLE in_join_table_sp_insert_functions_with_unique_catch OWNER TO denevell;

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

