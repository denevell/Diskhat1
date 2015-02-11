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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

--COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

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
-- Name: koans_id_seq; Type: SEQUENCE; Schema: public; Owner: denevell
--

CREATE SEQUENCE koans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE koans_id_seq OWNER TO denevell;

SET default_tablespace = '';

SET default_with_oids = false;

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
-- Name: test; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--
-- Name: koans_pkey; Type: CONSTRAINT; Schema: public; Owner: denevell; Tablespace: 
--

ALTER TABLE ONLY koans
    ADD CONSTRAINT koans_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: denevell; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: unique_tag; Type: CONSTRAINT; Schema: public; Owner: denevell; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT unique_tag UNIQUE (tag);


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
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

-- Name: test; Type: ACL; Schema: public; Owner: postgres
--

-- PostgreSQL database dump complete
