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
-- Name: insert_categories_tags(integer, integer); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_categories_tags(category_id integer, tag_id integer) RETURNS void
    LANGUAGE sql
    AS $$ insert into categories_tags (category_id,tag_id) values(category_id,tag_id) ;$$;


ALTER FUNCTION autogen.insert_categories_tags(category_id integer, tag_id integer) OWNER TO denevell;

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
    AS $$ declare koan_id integer; declare tag_id integer;  begin insert into koans (message) values(koan_id_message) returning id into koan_id; begin insert into tags (tag) values(tag_id_tag) returning id into tag_id; exception when unique_violation then select id into tag_id from tags where tag = tag_id_tag; end; insert into koans_tags (koan_id,tag_id) values(koan_id,tag_id); end; $$;


ALTER FUNCTION autogen.insert_into_join_table_with_unique_catch_koans_tags(koan_id_message text, tag_id_tag text) OWNER TO denevell;

--
-- Name: insert_into_join_table_with_unique_catch_tmp_multicolumn_tags(text, text, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_into_join_table_with_unique_catch_tmp_multicolumn_tags(koan_id_message text, multi_id_one text, multi_id_two text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare koan_id integer; declare multi_id integer; begin insert into koans (message) values(koan_id_message) returning id into koan_id; insert into tmp_multicolumn (one,two) values(multi_id_one,multi_id_two) returning id into multi_id; insert into tmp_multicolumn_tags (koan_id,multi_id) values(koan_id,multi_id); end; $$;


ALTER FUNCTION autogen.insert_into_join_table_with_unique_catch_tmp_multicolumn_tags(koan_id_message text, multi_id_one text, multi_id_two text) OWNER TO denevell;

--
-- Name: insert_into_partial1_join_table_categories_tags(integer, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_into_partial1_join_table_categories_tags(category_id integer, tag_id_tag text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare tag_id integer;  begin insert into tags (tag) values(tag_id_tag) returning id into tag_id; insert into categories_tags (category_id,tag_id) values(category_id,tag_id); end; $$;


ALTER FUNCTION autogen.insert_into_partial1_join_table_categories_tags(category_id integer, tag_id_tag text) OWNER TO denevell;

--
-- Name: insert_into_partial1_join_table_koans_tags(integer, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_into_partial1_join_table_koans_tags(koan_id integer, tag_id_tag text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare tag_id integer;  begin insert into tags (tag) values(tag_id_tag) returning id into tag_id; insert into koans_tags (koan_id,tag_id) values(koan_id,tag_id); end; $$;


ALTER FUNCTION autogen.insert_into_partial1_join_table_koans_tags(koan_id integer, tag_id_tag text) OWNER TO denevell;

--
-- Name: insert_into_partial1_join_table_tmp_multicolumn_tags(integer, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_into_partial1_join_table_tmp_multicolumn_tags(koan_id integer, multi_id_one text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare multi_id integer;  begin insert into tmp_multicolumn (one,two) values(multi_id_one,multi_id_two) returning id into multi_id; insert into tmp_multicolumn_tags (koan_id,multi_id) values(koan_id,multi_id); end; $$;


ALTER FUNCTION autogen.insert_into_partial1_join_table_tmp_multicolumn_tags(koan_id integer, multi_id_one text) OWNER TO denevell;

--
-- Name: insert_into_partial2_join_table_categories_tags(integer, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_into_partial2_join_table_categories_tags(tag_id integer, category_id_tag text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare category_id integer;  begin insert into tags (tag) values(category_id_tag) returning id into category_id; insert into categories_tags (category_id,tag_id) values(category_id,tag_id); end; $$;


ALTER FUNCTION autogen.insert_into_partial2_join_table_categories_tags(tag_id integer, category_id_tag text) OWNER TO denevell;

--
-- Name: insert_into_partial2_join_table_koans_tags(integer, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_into_partial2_join_table_koans_tags(tag_id integer, koan_id_message text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare koan_id integer;  begin insert into koans (message) values(koan_id_message) returning id into koan_id; insert into koans_tags (koan_id,tag_id) values(koan_id,tag_id); end; $$;


ALTER FUNCTION autogen.insert_into_partial2_join_table_koans_tags(tag_id integer, koan_id_message text) OWNER TO denevell;

--
-- Name: insert_into_partial2_join_table_tmp_multicolumn_tags(integer, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_into_partial2_join_table_tmp_multicolumn_tags(multi_id integer, koan_id_message text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare koan_id integer;  begin insert into koans (message) values(koan_id_message) returning id into koan_id; insert into tmp_multicolumn_tags (koan_id,multi_id) values(koan_id,multi_id); end; $$;


ALTER FUNCTION autogen.insert_into_partial2_join_table_tmp_multicolumn_tags(multi_id integer, koan_id_message text) OWNER TO denevell;

--
-- Name: insert_koans(text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_koans(message text) RETURNS integer
    LANGUAGE sql
    AS $$ insert into koans (message) values(message) returning id;$$;


ALTER FUNCTION autogen.insert_koans(message text) OWNER TO denevell;

--
-- Name: insert_koans(integer, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_koans(id integer, message text) RETURNS integer
    LANGUAGE sql
    AS $$ insert into koans (id,message) values(id,message) returning id;$$;


ALTER FUNCTION autogen.insert_koans(id integer, message text) OWNER TO denevell;

--
-- Name: insert_koans_tags(integer, integer); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_koans_tags(koan_id integer, tag_id integer) RETURNS void
    LANGUAGE sql
    AS $$ insert into koans_tags (koan_id,tag_id) values(koan_id,tag_id) ;$$;


ALTER FUNCTION autogen.insert_koans_tags(koan_id integer, tag_id integer) OWNER TO denevell;

--
-- Name: insert_tags(text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_tags(tag text) RETURNS integer
    LANGUAGE sql
    AS $$ insert into tags (tag) values(tag) returning id;$$;


ALTER FUNCTION autogen.insert_tags(tag text) OWNER TO denevell;

--
-- Name: insert_tags(integer, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_tags(id integer, tag text) RETURNS integer
    LANGUAGE sql
    AS $$ insert into tags (id,tag) values(id,tag) returning id;$$;


ALTER FUNCTION autogen.insert_tags(id integer, tag text) OWNER TO denevell;

--
-- Name: insert_tmp_multicolumn(text, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_tmp_multicolumn(one text, two text) RETURNS integer
    LANGUAGE sql
    AS $$ insert into tmp_multicolumn (one,two) values(one,two) returning id;$$;


ALTER FUNCTION autogen.insert_tmp_multicolumn(one text, two text) OWNER TO denevell;

--
-- Name: insert_tmp_multicolumn(integer, text, text); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_tmp_multicolumn(id integer, one text, two text) RETURNS integer
    LANGUAGE sql
    AS $$ insert into tmp_multicolumn (id,one,two) values(id,one,two) returning id;$$;


ALTER FUNCTION autogen.insert_tmp_multicolumn(id integer, one text, two text) OWNER TO denevell;

--
-- Name: insert_tmp_multicolumn_tags(integer, integer); Type: FUNCTION; Schema: autogen; Owner: denevell
--

CREATE FUNCTION insert_tmp_multicolumn_tags(koan_id integer, multi_id integer) RETURNS void
    LANGUAGE sql
    AS $$ insert into tmp_multicolumn_tags (koan_id,multi_id) values(koan_id,multi_id) ;$$;


ALTER FUNCTION autogen.insert_tmp_multicolumn_tags(koan_id integer, multi_id integer) OWNER TO denevell;

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
-- Name: autogen_join_table_partial_inserts(); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION autogen_join_table_partial_inserts() RETURNS void
    LANGUAGE plpgsql
    AS $$
declare s text;
declare r record;
begin
                for r in select * from in_join_table_sp_partial1_insert_function loop
                                    raise notice '%', r."sql";
                                            execute r."sql";
                                                end loop;
                for r in select * from in_join_table_sp_partial2_insert_function loop
                                    raise notice '%', r."sql";
                                            execute r."sql";
                                                end loop;                                                
end;
$$;


ALTER FUNCTION public.autogen_join_table_partial_inserts() OWNER TO denevell;

--
-- Name: autogen_simple_inserts(); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION autogen_simple_inserts() RETURNS void
    LANGUAGE plpgsql
    AS $$
declare s text;
declare r record;
begin
        for r in select * from _sp_simple_inserts loop
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
        for r in select * from _sp_simple_inserts_excluding_defaults loop
            raise notice '%', r."sql";
            execute r."sql";
        end loop;
end;
$$;


ALTER FUNCTION public.autogen_simple_inserts_excluding_defaults() OWNER TO denevell;

--
-- Name: create_declared(text, text); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION create_declared(name text, type text) RETURNS text
    LANGUAGE plpgsql
    AS $$
    declare str text;
    begin
        return 'declare ' || name || ' ' || type || '';
    end;
$$;


ALTER FUNCTION public.create_declared(name text, type text) OWNER TO denevell;

--
-- Name: create_declareds(text[], text[]); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION create_declareds(names text[], types text[]) RETURNS text
    LANGUAGE plpgsql
    AS $$
    declare name text;
    declare type text;    
    declare str text;        
    begin
	str = '';
	
	for i in 1..array_length(names, 1) loop begin
		str = str || 'declare ' || names[i] || ' ' || types[i] || '; ';
	end; end loop;
	return str;
    end;
$$;


ALTER FUNCTION public.create_declareds(names text[], types text[]) OWNER TO denevell;

--
-- Name: create_insert(text, text, text); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION create_insert(table_name text, params text, param_values text) RETURNS text
    LANGUAGE plpgsql
    AS $$
    declare str text;
    begin
        return 'insert into ' || table_name || ' (' || params || ') ' || 'values(' || param_values || ')';
    end;
$$;


ALTER FUNCTION public.create_insert(table_name text, params text, param_values text) OWNER TO denevell;

--
-- Name: create_insert(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION create_insert(table_name text, params text, param_values text, returning_text text, into_text text) RETURNS text
    LANGUAGE plpgsql
    AS $$
    declare str text;
    begin
        return 'insert into ' || table_name || ' (' || params || ') ' || 'values(' || param_values || ')' 
        || ' returning ' || returning_text 
        || ' into ' || into_text;
    end;
$$;


ALTER FUNCTION public.create_insert(table_name text, params text, param_values text, returning_text text, into_text text) OWNER TO denevell;

--
-- Name: create_join_sp_params(text[], text[]); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION create_join_sp_params(names text[], types text[]) RETURNS text
    LANGUAGE plpgsql
    AS $$  
    declare str text;        
    begin
	str = '';
	
	for i in 1..array_length(names, 1) loop begin
		str = str || names[i] || ' ' || types[i];
		if array_length(names, 1)!=i then str=str || ', '; end if;
	end; end loop;
	return str;
    end;
$$;


ALTER FUNCTION public.create_join_sp_params(names text[], types text[]) OWNER TO denevell;

--
-- Name: create_select_into_on_unique_column(text, text); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION create_select_into_on_unique_column(table_name_param text, value_into text) RETURNS text
    LANGUAGE plpgsql
    AS $$
    declare str text;
    begin
	str = '';
        select 'select id into ' 
        || value_into 
        || ' from ' 
        || table_name_param 
        || ' where ' 
        || columns_unique.column_name 
        || ' = ' 
        || table_name_param 
        || '_' 
        || columns_unique.column_name into str 
        from _columns_unique columns_unique
        where columns_unique.table_name = table_name_param;
        if str is null then return ''; end if;
        return str || ';';
    end;
$$;


ALTER FUNCTION public.create_select_into_on_unique_column(table_name_param text, value_into text) OWNER TO denevell;

--
-- Name: create_select_into_on_unique_column(text, text, text); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION create_select_into_on_unique_column(table_name_with_unique text, value_into text, value_match text) RETURNS text
    LANGUAGE plpgsql
    AS $$
    declare str text;
    begin
        select 'select ' || t0.column_name || ' into ' || value_into || ' from ' || t0.table_name || ' where ' || t1.column_name || ' = ' || value_match into str 
        from _columns_primary_key t0 
        join _columns_unique t1 on t1.table_name = t0.table_name and t1.table_name = table_name_with_unique;
        return str;
    end;
$$;


ALTER FUNCTION public.create_select_into_on_unique_column(table_name_with_unique text, value_into text, value_match text) OWNER TO denevell;

--
-- Name: create_sp(text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION create_sp(sp_name text, sp_params text, sp_return_value text, sp_lang text, sp_declares text, sp_body text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
    declare str text;
    begin
        return 'create or replace function ' || sp_name || ' (' || sp_params 
        || ') returns ' || sp_return_value || ' language ' || sp_lang || ' as $function$ ' || sp_declares || ' begin ' || sp_body || ' end; $function$;';
    end;
$_$;


ALTER FUNCTION public.create_sp(sp_name text, sp_params text, sp_return_value text, sp_lang text, sp_declares text, sp_body text) OWNER TO denevell;

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
-- Name: insert_w_joins_koans(text, text, text, text); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION insert_w_joins_koans(koans_message text, tags_tag text, tmp_multicolumn_two text, tmp_multicolumn_one text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare tags_id integer; declare tmp_multicolumn_id integer; declare koans_id integer; begin insert into koans (message) values(koans_message) returning id into koans_id;insert into tags (tag) values(tags_tag) returning id into tags_id; insert into tmp_multicolumn (one,two) values(tmp_multicolumn_one,tmp_multicolumn_two) returning id into tmp_multicolumn_id;insert into koans_tags (koans_id,tags_id) values(koans_id,tags_id); insert into tmp_multicolumn_tags (koans_id,tmp_multicolumn_id) values(koans_id,tmp_multicolumn_id); end; $$;


ALTER FUNCTION public.insert_w_joins_koans(koans_message text, tags_tag text, tmp_multicolumn_two text, tmp_multicolumn_one text) OWNER TO denevell;

--
-- Name: insert_w_joins_uniques_koans(text, text, text, text); Type: FUNCTION; Schema: public; Owner: denevell
--

CREATE FUNCTION insert_w_joins_uniques_koans(koans_message text, tags_tag text, tmp_multicolumn_two text, tmp_multicolumn_one text) RETURNS void
    LANGUAGE plpgsql
    AS $$ declare tags_id integer; declare tmp_multicolumn_id integer; declare koans_id integer; begin insert into koans (message) values(koans_message) returning id into koans_id;insert into tags (tag) values(tags_tag) returning id into tags_id; insert into tmp_multicolumn (one,two) values(tmp_multicolumn_one,tmp_multicolumn_two) returning id into tmp_multicolumn_id;begin insert into koans_tags (koans_id,tags_id) values(koans_id,tags_id); exception when unique_violation then  end; begin insert into tmp_multicolumn_tags (koans_id,tmp_multicolumn_id) values(koans_id,tmp_multicolumn_id); exception when unique_violation then  end; end; $$;


ALTER FUNCTION public.insert_w_joins_uniques_koans(koans_message text, tags_tag text, tmp_multicolumn_two text, tmp_multicolumn_one text) OWNER TO denevell;

--
-- Name: array_accum(anyarray); Type: AGGREGATE; Schema: public; Owner: denevell
--

CREATE AGGREGATE array_accum(anyarray) (
    SFUNC = array_cat,
    STYPE = anyarray,
    INITCOND = '{}'
);


ALTER AGGREGATE public.array_accum(anyarray) OWNER TO denevell;

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
-- Name: _columns_referenced_tables_columns; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _columns_referenced_tables_columns AS
 SELECT t0.table_name,
    t0.column_name,
    t1.table_name AS referenced_table_name,
    t1.column_name AS referenced_column_name
   FROM (_columns_foreign_key t0
     JOIN ( SELECT t0_1.constraint_name,
            t1_1.table_name,
            t1_1.column_name
           FROM (_columns_foreign_key t0_1
             LEFT JOIN information_schema.constraint_column_usage t1_1 ON (((t0_1.constraint_name)::text = (t1_1.constraint_name)::text)))) t1 ON (((t0.constraint_name)::text = (t1.constraint_name)::text)))
  ORDER BY t0.table_name, t0.column_name;


ALTER TABLE _columns_referenced_tables_columns OWNER TO denevell;

--
-- Name: _tables_join; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _tables_join AS
 SELECT t0.table_name
   FROM _columns_referenced_tables_columns t0
  GROUP BY t0.table_name;


ALTER TABLE _tables_join OWNER TO denevell;

--
-- Name: _columns_join_tables; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _columns_join_tables AS
 SELECT t0.table_name,
    t1.column_name,
    t1.data_type
   FROM (_tables_join t0
     JOIN _columns t1 ON (((t1.table_name)::text = (t0.table_name)::text)))
  ORDER BY t0.table_name, t1.column_name;


ALTER TABLE _columns_join_tables OWNER TO denevell;

--
-- Name: _tables_public; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _tables_public AS
 SELECT tables.table_name
   FROM information_schema.tables
  WHERE ((((tables.table_schema)::text = 'public'::text) AND ((tables.table_name)::text <> 'schema_version'::text)) AND ((tables.table_type)::text = 'BASE TABLE'::text))
  ORDER BY tables.table_name;


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
-- Name: _columns_not_default; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _columns_not_default AS
 SELECT t0.table_name,
    t0.column_name,
    t0.data_type,
    t0.is_nullable
   FROM _columns_public t0
  WHERE (t0.column_default IS NULL);


ALTER TABLE _columns_not_default OWNER TO denevell;

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
-- Name: _sp_join_table_full_insert_params; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _sp_join_table_full_insert_params AS
 SELECT t0.table_name,
    t0.column_name AS insert_column_name,
    (((t0.column_name)::text || '_'::text) || (t1.column_name)::text) AS sp_param_name,
    t1.data_type AS sp_param_type
   FROM (_columns_referenced_tables_columns t0
     JOIN _columns_not_default t1 ON (((t0.referenced_table_name)::text = (t1.table_name)::text)));


ALTER TABLE _sp_join_table_full_insert_params OWNER TO denevell;

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

--
-- Name: _sp_table_param_names; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _sp_table_param_names AS
 SELECT _columns_not_default.table_name,
    _columns_not_default.column_name,
    _columns_not_default.data_type,
    (((_columns_not_default.table_name)::text || '_'::text) || (_columns_not_default.column_name)::text) AS sp_param
   FROM _columns_not_default;


ALTER TABLE _sp_table_param_names OWNER TO denevell;

--
-- Name: _tables_references; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _tables_references AS
 SELECT _columns_referenced_tables_columns.referenced_table_name AS table_name,
    unnest(array_agg(DISTINCT (_columns_referenced_tables_columns.table_name)::text)) AS "references"
   FROM _columns_referenced_tables_columns
  GROUP BY _columns_referenced_tables_columns.referenced_table_name
  ORDER BY _columns_referenced_tables_columns.referenced_table_name;


ALTER TABLE _tables_references OWNER TO denevell;

--
-- Name: _tables_intransitive_references; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _tables_intransitive_references AS
 SELECT t0.table_name,
    unnest(array_agg(DISTINCT (t1.table_name)::text)) AS intransitive_references
   FROM (_tables_references t0
     JOIN _tables_references t1 ON ((t1."references" = t0."references")))
  WHERE ((t1.table_name)::text <> (t0.table_name)::text)
  GROUP BY t0.table_name;


ALTER TABLE _tables_intransitive_references OWNER TO denevell;

--
-- Name: _tables_not_join; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _tables_not_join AS
 SELECT _tables_public.table_name
   FROM _tables_public
EXCEPT
 SELECT _tables_join.table_name
   FROM _tables_join;


ALTER TABLE _tables_not_join OWNER TO denevell;

--
-- Name: _sp_table_w_join_inserts; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _sp_table_w_join_inserts AS
 SELECT create_sp(('insert_w_joins_'::text || (tables.table_name)::text), (main_sp_params.params || sp_params.sql), 'void'::text, 'plpgsql'::text, declared.sql, (((((main_insert.sql || ';'::text) || table_inserts_grouped.sql) || ';'::text) || table_join_inserts_grouped.sql) || ';'::text)) AS create_sp
   FROM ((((((_tables_not_join tables
     JOIN ( SELECT table_references.table_name,
            create_join_sp_params(array_agg(param_names.sp_param), array_agg((param_names.data_type)::text)) AS sql
           FROM ((_tables_intransitive_references table_references
             JOIN _columns_not_default columns ON ((table_references.intransitive_references = (columns.table_name)::text)))
             JOIN _sp_table_param_names param_names ON ((((param_names.table_name)::text = table_references.intransitive_references) AND ((param_names.column_name)::text = (columns.column_name)::text))))
          GROUP BY table_references.table_name) sp_params ON (((sp_params.table_name)::text = (tables.table_name)::text)))
     JOIN ( SELECT cols.table_name,
            (create_join_sp_params(array_agg(param_names.sp_param), array_agg((param_names.data_type)::text)) || ', '::text) AS params
           FROM (_columns_not_default cols
             JOIN _sp_table_param_names param_names ON (((param_names.column_name)::text = (cols.column_name)::text)))
          GROUP BY cols.table_name) main_sp_params ON (((main_sp_params.table_name)::text = (tables.table_name)::text)))
     JOIN ( SELECT table_references.table_name,
            (((create_declareds(array_agg((table_references.intransitive_references || '_id'::text)), array_agg((columns.data_type)::text)) || 'declare '::text) || (table_references.table_name)::text) || '_id integer;'::text) AS sql
           FROM (_tables_intransitive_references table_references
             JOIN _columns_primary_key columns ON ((table_references.intransitive_references = (columns.table_name)::text)))
          GROUP BY table_references.table_name) declared ON (((declared.table_name)::text = (tables.table_name)::text)))
     JOIN ( SELECT table_inserts.table_name,
            array_to_string(array_agg(table_inserts.sql), '; '::text) AS sql
           FROM ( SELECT table_references.table_name,
                    create_insert(table_references.intransitive_references, columns.column_names, inputs.column_values, 'id'::text, ((table_references.intransitive_references || '_'::text) || 'id'::text)) AS sql
                   FROM ((_tables_intransitive_references table_references
                     JOIN ( SELECT _columns_not_default.table_name,
                            array_to_string(array_agg((_columns_not_default.column_name)::text), ','::text) AS column_names
                           FROM _columns_not_default
                          GROUP BY _columns_not_default.table_name) columns ON ((table_references.intransitive_references = (columns.table_name)::text)))
                     JOIN ( SELECT param_names.table_name,
                            array_to_string(array_agg(param_names.sp_param), ','::text) AS column_values
                           FROM _sp_table_param_names param_names
                          GROUP BY param_names.table_name) inputs ON ((table_references.intransitive_references = (inputs.table_name)::text)))) table_inserts
          GROUP BY table_inserts.table_name) table_inserts_grouped ON (((table_inserts_grouped.table_name)::text = (tables.table_name)::text)))
     JOIN ( SELECT cols.table_name,
            create_insert((cols.table_name)::text, array_to_string(array_agg((cols.column_name)::text), ','::text), array_to_string(array_agg(param_names.sp_param), ','::text), 'id'::text, ((cols.table_name)::text || '_id'::text)) AS sql
           FROM (_columns_not_default cols
             JOIN _sp_table_param_names param_names ON (((param_names.column_name)::text = (cols.column_name)::text)))
          GROUP BY cols.table_name) main_insert ON (((main_insert.table_name)::text = (tables.table_name)::text)))
     JOIN ( SELECT table_inserts.table_name,
            array_to_string(array_agg(table_inserts.sql), '; '::text) AS sql
           FROM ( SELECT table_references.table_name,
                    create_insert(table_references."references", columns.column_names, columns.column_names) AS sql
                   FROM ((_tables_references table_references
                     JOIN ( SELECT _columns_not_default.table_name,
                            array_to_string(array_agg((_columns_not_default.column_name)::text), ','::text) AS column_names
                           FROM _columns_not_default
                          GROUP BY _columns_not_default.table_name) columns ON ((table_references."references" = (columns.table_name)::text)))
                     JOIN ( SELECT param_names.table_name,
                            array_to_string(array_agg(param_names.sp_param), ','::text) AS column_values
                           FROM _sp_table_param_names param_names
                          GROUP BY param_names.table_name) inputs ON ((table_references."references" = (inputs.table_name)::text)))) table_inserts
          GROUP BY table_inserts.table_name) table_join_inserts_grouped ON (((table_join_inserts_grouped.table_name)::text = (tables.table_name)::text)));


ALTER TABLE _sp_table_w_join_inserts OWNER TO denevell;

--
-- Name: _sp_table_w_join_uniques_inserts; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW _sp_table_w_join_uniques_inserts AS
 SELECT create_sp(('insert_w_joins_uniques_'::text || (tables.table_name)::text), (main_sp_params.params || sp_params.sql), 'void'::text, 'plpgsql'::text, declared.sql, ((((main_insert.sql || ';'::text) || table_inserts_grouped.sql) || ';'::text) || table_join_inserts_grouped.sql)) AS create_sp
   FROM ((((((_tables_not_join tables
     JOIN ( SELECT table_references.table_name,
            create_join_sp_params(array_agg(param_names.sp_param), array_agg((param_names.data_type)::text)) AS sql
           FROM ((_tables_intransitive_references table_references
             JOIN _columns_not_default columns ON ((table_references.intransitive_references = (columns.table_name)::text)))
             JOIN _sp_table_param_names param_names ON ((((param_names.table_name)::text = table_references.intransitive_references) AND ((param_names.column_name)::text = (columns.column_name)::text))))
          GROUP BY table_references.table_name) sp_params ON (((sp_params.table_name)::text = (tables.table_name)::text)))
     JOIN ( SELECT cols.table_name,
            (create_join_sp_params(array_agg(param_names.sp_param), array_agg((param_names.data_type)::text)) || ', '::text) AS params
           FROM (_columns_not_default cols
             JOIN _sp_table_param_names param_names ON (((param_names.column_name)::text = (cols.column_name)::text)))
          GROUP BY cols.table_name) main_sp_params ON (((main_sp_params.table_name)::text = (tables.table_name)::text)))
     JOIN ( SELECT table_references.table_name,
            (((create_declareds(array_agg((table_references.intransitive_references || '_id'::text)), array_agg((columns.data_type)::text)) || 'declare '::text) || (table_references.table_name)::text) || '_id integer;'::text) AS sql
           FROM (_tables_intransitive_references table_references
             JOIN _columns_primary_key columns ON ((table_references.intransitive_references = (columns.table_name)::text)))
          GROUP BY table_references.table_name) declared ON (((declared.table_name)::text = (tables.table_name)::text)))
     JOIN ( SELECT table_inserts.table_name,
            array_to_string(array_agg(table_inserts.sql), '; '::text) AS sql
           FROM ( SELECT table_references.table_name,
                    create_insert(table_references.intransitive_references, columns.column_names, inputs.column_values, 'id'::text, ((table_references.intransitive_references || '_'::text) || 'id'::text)) AS sql
                   FROM ((_tables_intransitive_references table_references
                     JOIN ( SELECT _columns_not_default.table_name,
                            array_to_string(array_agg((_columns_not_default.column_name)::text), ','::text) AS column_names
                           FROM _columns_not_default
                          GROUP BY _columns_not_default.table_name) columns ON ((table_references.intransitive_references = (columns.table_name)::text)))
                     JOIN ( SELECT param_names.table_name,
                            array_to_string(array_agg(param_names.sp_param), ','::text) AS column_values
                           FROM _sp_table_param_names param_names
                          GROUP BY param_names.table_name) inputs ON ((table_references.intransitive_references = (inputs.table_name)::text)))) table_inserts
          GROUP BY table_inserts.table_name) table_inserts_grouped ON (((table_inserts_grouped.table_name)::text = (tables.table_name)::text)))
     JOIN ( SELECT cols.table_name,
            create_insert((cols.table_name)::text, array_to_string(array_agg((cols.column_name)::text), ','::text), array_to_string(array_agg(param_names.sp_param), ','::text), 'id'::text, ((cols.table_name)::text || '_id'::text)) AS sql
           FROM (_columns_not_default cols
             JOIN _sp_table_param_names param_names ON (((param_names.column_name)::text = (cols.column_name)::text)))
          GROUP BY cols.table_name) main_insert ON (((main_insert.table_name)::text = (tables.table_name)::text)))
     JOIN ( SELECT table_inserts.table_name,
            array_to_string(array_agg(table_inserts.sql), ' '::text) AS sql
           FROM ( SELECT table_references.table_name,
                    (((('begin '::text || create_insert(table_references."references", columns.column_names, columns.column_names)) || '; exception when unique_violation then '::text) || create_select_into_on_unique_column(table_references."references", (table_references."references" || '_id'::text))) || ' end;'::text) AS sql
                   FROM ((_tables_references table_references
                     JOIN ( SELECT _columns_not_default.table_name,
                            array_to_string(array_agg((_columns_not_default.column_name)::text), ','::text) AS column_names
                           FROM _columns_not_default
                          GROUP BY _columns_not_default.table_name) columns ON ((table_references."references" = (columns.table_name)::text)))
                     JOIN ( SELECT param_names.table_name,
                            array_to_string(array_agg(param_names.sp_param), ','::text) AS column_values
                           FROM _sp_table_param_names param_names
                          GROUP BY param_names.table_name) inputs ON ((table_references."references" = (inputs.table_name)::text)))) table_inserts
          GROUP BY table_inserts.table_name) table_join_inserts_grouped ON (((table_join_inserts_grouped.table_name)::text = (tables.table_name)::text)));


ALTER TABLE _sp_table_w_join_uniques_inserts OWNER TO denevell;

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
-- Name: in_join_table_columns_insert_statement; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_columns_insert_statement AS
 SELECT join_columns_referenced.table_name,
    join_columns_referenced.column_name,
    create_insert((join_columns_referenced.referenced_table_name)::text, insert_params.sql, array_to_string(insert_param_values.param_name_agg, ','::text), (primary_keys.column_name)::text, (join_columns_referenced.column_name)::text) AS insert_statement
   FROM (((_columns_referenced_tables_columns join_columns_referenced
     JOIN ( SELECT columns_not_default.table_name,
            array_to_string(array_agg((columns_not_default.column_name)::text), ','::text) AS sql
           FROM _columns_not_default columns_not_default
          GROUP BY columns_not_default.table_name) insert_params ON (((insert_params.table_name)::text = (join_columns_referenced.referenced_table_name)::text)))
     JOIN ( SELECT join_column_sp_names.table_name,
            join_column_sp_names.insert_column_name,
            array_agg(join_column_sp_names.sp_param_name) AS param_name_agg
           FROM _sp_join_table_full_insert_params join_column_sp_names
          GROUP BY join_column_sp_names.table_name, join_column_sp_names.insert_column_name) insert_param_values ON ((((join_columns_referenced.table_name)::text = (insert_param_values.table_name)::text) AND ((insert_param_values.insert_column_name)::text = (join_columns_referenced.column_name)::text))))
     JOIN ( SELECT _columns_primary_key.table_name,
            _columns_primary_key.column_name
           FROM _columns_primary_key) primary_keys ON (((primary_keys.table_name)::text = (join_columns_referenced.referenced_table_name)::text)))
  ORDER BY join_columns_referenced.table_name, join_columns_referenced.column_name;


ALTER TABLE in_join_table_columns_insert_statement OWNER TO denevell;

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
   FROM ( SELECT t0_1.table_name,
            t0_1.column_name,
            t0_1.insert_statement,
            create_select_into_on_unique_column((t2.table_name)::text, (t0_1.column_name)::text, (((t0_1.column_name)::text || '_'::text) || (t2.column_name)::text)) AS select_into_via_unique
           FROM ((in_join_table_columns_insert_statement t0_1
             LEFT JOIN _columns_referenced_tables_columns t1 ON ((((t1.table_name)::text = (t0_1.table_name)::text) AND ((t1.column_name)::text = (t0_1.column_name)::text))))
             LEFT JOIN _columns_unique t2 ON (((t2.table_name)::text = (t1.referenced_table_name)::text)))) t0;


ALTER TABLE in_join_table_columns_insert_statement_with_unique_catch OWNER TO denevell;

--
-- Name: in_join_table_sp_insert_functions; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_sp_insert_functions AS
 SELECT sp_params.table_name,
    create_sp(('autogen.insert_into_join_table_'::text || (join_tables.table_name)::text), sp_params.param_name_conat_agg, 'void'::text, 'plpgsql'::text, declared_vars.declared_vars, (((insert_statements.insert_statement || ' '::text) || final_insert_statement.insert_statement) || ';'::text)) AS sql
   FROM ((((_tables_join join_tables
     JOIN ( SELECT full_insert_params.table_name,
            create_join_sp_params(array_agg(full_insert_params.sp_param_name), array_agg((full_insert_params.sp_param_type)::text)) AS param_name_conat_agg
           FROM _sp_join_table_full_insert_params full_insert_params
          GROUP BY full_insert_params.table_name) sp_params ON (((sp_params.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT columns_public.table_name,
            create_declareds(array_agg((columns_public.column_name)::text), array_agg((columns_public.data_type)::text)) AS declared_vars
           FROM _columns_public columns_public
          GROUP BY columns_public.table_name) declared_vars ON (((declared_vars.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT t0_1.table_name,
            (array_to_string(array_agg(t0_1.insert_statement), '; '::text) || ';'::text) AS insert_statement
           FROM in_join_table_columns_insert_statement t0_1
          GROUP BY t0_1.table_name) insert_statements ON (((insert_statements.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT join_columns.table_name,
            create_insert((join_columns.table_name)::text, array_to_string(array_agg((join_columns.column_name)::text), ','::text), array_to_string(array_agg((join_columns.column_name)::text), ','::text)) AS insert_statement
           FROM _columns_join_tables join_columns
          GROUP BY join_columns.table_name) final_insert_statement ON (((final_insert_statement.table_name)::text = (join_tables.table_name)::text)));


ALTER TABLE in_join_table_sp_insert_functions OWNER TO denevell;

--
-- Name: in_join_table_sp_insert_functions_with_unique_catch; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_sp_insert_functions_with_unique_catch AS
 SELECT sp_params.table_name,
    create_sp(('autogen.insert_into_join_table_with_unique_catch_'::text || (join_tables.table_name)::text), sp_params.param_name_conat_agg, 'void'::text, 'plpgsql'::text, declared_vars.declared_vars, (((insert_statements.insert_statement || ' '::text) || final_insert_statement.insert_statement) || ';'::text)) AS sql
   FROM ((((_tables_join join_tables
     JOIN ( SELECT full_insert_params.table_name,
            create_join_sp_params(array_agg(full_insert_params.sp_param_name), array_agg((full_insert_params.sp_param_type)::text)) AS param_name_conat_agg
           FROM _sp_join_table_full_insert_params full_insert_params
          GROUP BY full_insert_params.table_name) sp_params ON (((sp_params.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT columns_public.table_name,
            create_declareds(array_agg((columns_public.column_name)::text), array_agg((columns_public.data_type)::text)) AS declared_vars
           FROM _columns_public columns_public
          GROUP BY columns_public.table_name) declared_vars ON (((declared_vars.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT t0_1.table_name,
            array_to_string(array_agg(t0_1.sql), ' '::text) AS insert_statement
           FROM in_join_table_columns_insert_statement_with_unique_catch t0_1
          GROUP BY t0_1.table_name) insert_statements ON (((insert_statements.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT join_columns.table_name,
            create_insert((join_columns.table_name)::text, array_to_string(array_agg((join_columns.column_name)::text), ','::text), array_to_string(array_agg((join_columns.column_name)::text), ','::text)) AS insert_statement
           FROM _columns_join_tables join_columns
          GROUP BY join_columns.table_name) final_insert_statement ON (((final_insert_statement.table_name)::text = (join_tables.table_name)::text)));


ALTER TABLE in_join_table_sp_insert_functions_with_unique_catch OWNER TO denevell;

--
-- Name: in_join_table_sp_partial1_insert_function; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_sp_partial1_insert_function AS
 SELECT sp_params.table_name,
    create_sp(('autogen.insert_into_partial1_join_table_'::text || (join_tables.table_name)::text), ((sp_param_direct.sp_param_direct || ', '::text) || sp_params.param_name_conat_agg), 'void'::text, 'plpgsql'::text, declared_vars.declared_vars, (((insert_statements.insert_statement || ' '::text) || final_insert_statement.insert_statement) || ';'::text)) AS sql
   FROM (((((_tables_join join_tables
     JOIN ( SELECT full_insert_params.table_name,
            create_join_sp_params((array_agg(full_insert_params.sp_param_name))[2:2], (array_agg((full_insert_params.sp_param_type)::text))[2:2]) AS param_name_conat_agg
           FROM _sp_join_table_full_insert_params full_insert_params
          GROUP BY full_insert_params.table_name) sp_params ON (((sp_params.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT columns_public.table_name,
            create_declareds((array_agg((columns_public.column_name)::text))[2:2], (array_agg((columns_public.data_type)::text))[2:2]) AS declared_vars
           FROM _columns_public columns_public
          GROUP BY columns_public.table_name) declared_vars ON (((declared_vars.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT columns_public.table_name,
            (((array_agg((columns_public.column_name)::text))[1] || ' '::text) || (array_agg((columns_public.data_type)::text))[1]) AS sp_param_direct
           FROM _columns_public columns_public
          GROUP BY columns_public.table_name) sp_param_direct ON (((sp_param_direct.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT t0_1.table_name,
            (array_to_string((array_agg(t0_1.insert_statement))[2:2], '; '::text) || ';'::text) AS insert_statement
           FROM in_join_table_columns_insert_statement t0_1
          GROUP BY t0_1.table_name) insert_statements ON (((insert_statements.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT join_columns.table_name,
            create_insert((join_columns.table_name)::text, array_to_string(array_agg((join_columns.column_name)::text), ','::text), array_to_string(array_agg((join_columns.column_name)::text), ','::text)) AS insert_statement
           FROM _columns_join_tables join_columns
          GROUP BY join_columns.table_name) final_insert_statement ON (((final_insert_statement.table_name)::text = (join_tables.table_name)::text)));


ALTER TABLE in_join_table_sp_partial1_insert_function OWNER TO denevell;

--
-- Name: in_join_table_sp_partial2_insert_function; Type: VIEW; Schema: public; Owner: denevell
--

CREATE VIEW in_join_table_sp_partial2_insert_function AS
 SELECT sp_params.table_name,
    create_sp(('autogen.insert_into_partial2_join_table_'::text || (join_tables.table_name)::text), ((sp_param_direct.sp_param_direct || ', '::text) || sp_params.param_name_conat_agg), 'void'::text, 'plpgsql'::text, declared_vars.declared_vars, (((insert_statements.insert_statement || ' '::text) || final_insert_statement.insert_statement) || ';'::text)) AS sql
   FROM (((((_tables_join join_tables
     JOIN ( SELECT full_insert_params.table_name,
            create_join_sp_params((array_agg(full_insert_params.sp_param_name))[1:1], (array_agg((full_insert_params.sp_param_type)::text))[1:1]) AS param_name_conat_agg
           FROM _sp_join_table_full_insert_params full_insert_params
          GROUP BY full_insert_params.table_name) sp_params ON (((sp_params.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT columns_public.table_name,
            create_declareds((array_agg((columns_public.column_name)::text))[1:1], (array_agg((columns_public.data_type)::text))[1:1]) AS declared_vars
           FROM _columns_public columns_public
          GROUP BY columns_public.table_name) declared_vars ON (((declared_vars.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT columns_public.table_name,
            (((array_agg((columns_public.column_name)::text))[2] || ' '::text) || (array_agg((columns_public.data_type)::text))[2]) AS sp_param_direct
           FROM _columns_public columns_public
          GROUP BY columns_public.table_name) sp_param_direct ON (((sp_param_direct.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT t0_1.table_name,
            (array_to_string((array_agg(t0_1.insert_statement))[1:1], '; '::text) || ';'::text) AS insert_statement
           FROM in_join_table_columns_insert_statement t0_1
          GROUP BY t0_1.table_name) insert_statements ON (((insert_statements.table_name)::text = (join_tables.table_name)::text)))
     JOIN ( SELECT join_columns.table_name,
            create_insert((join_columns.table_name)::text, array_to_string(array_agg((join_columns.column_name)::text), ','::text), array_to_string(array_agg((join_columns.column_name)::text), ','::text)) AS insert_statement
           FROM _columns_join_tables join_columns
          GROUP BY join_columns.table_name) final_insert_statement ON (((final_insert_statement.table_name)::text = (join_tables.table_name)::text)));


ALTER TABLE in_join_table_sp_partial2_insert_function OWNER TO denevell;

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
    koans_id integer,
    tags_id integer
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
    tmp_multicolumn_id integer,
    koans_id integer
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
    ADD CONSTRAINT koans_tags_koan_id_fkey FOREIGN KEY (koans_id) REFERENCES koans(id) ON DELETE CASCADE;


--
-- Name: koans_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: denevell
--

ALTER TABLE ONLY koans_tags
    ADD CONSTRAINT koans_tags_tag_id_fkey FOREIGN KEY (tags_id) REFERENCES tags(id);


--
-- Name: tmp_multicolumn_tags_koan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: denevell
--

ALTER TABLE ONLY tmp_multicolumn_tags
    ADD CONSTRAINT tmp_multicolumn_tags_koan_id_fkey FOREIGN KEY (koans_id) REFERENCES koans(id);


--
-- Name: tmp_multicolumn_tags_multi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: denevell
--

ALTER TABLE ONLY tmp_multicolumn_tags
    ADD CONSTRAINT tmp_multicolumn_tags_multi_id_fkey FOREIGN KEY (tmp_multicolumn_id) REFERENCES tmp_multicolumn(id);


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

