do $$

declare r record;
declare params text[];
declare param text;
declare paramIterator int;
declare finalStatement text;

begin
        for r in select * from in_all_columns_with_foreign_key_table_and_column_as_array order by table_name loop
            begin
                finalStatement = 'insert into ' || cast(r.table_name as text) || ' (';
                paramIterator = 0;
                foreach param in array r."columns" loop
                begin
                    paramIterator = paramIterator + 1;
                    finalStatement = finalStatement || param;
                    if paramIterator != array_length(r."columns", 1) then
                        finalStatement = finalStatement || ',';
                    end if;
                end;
                end loop;
                finalStatement = finalStatement || ') values(';

                paramIterator = 0;
                foreach param in array r."columns" loop
                begin
                    paramIterator = paramIterator + 1;
                    finalStatement = finalStatement || '_' || param;
                    if paramIterator != array_length(r."columns", 1) then
                        finalStatement = finalStatement || ',';
                    end if;
                end;
                end loop;

                finalStatement = finalStatement || ');';
                raise notice '%', finalStatement;
            end;
        end loop;
end;
$$;




do $YOYOYO$

declare r record;
declare params text[];
declare param text;
declare paramIterator int;
declare finalStatement text;

begin
        for r in select * from in_all_columns_with_foreign_key_table_and_column_as_array order by table_name loop
            begin

                finalStatement = 'create or replace function ' || r."table_name" || '_insert (';

                paramIterator = 0;
                foreach param in array r."columns" loop
                begin
                    paramIterator = paramIterator + 1;
                    finalStatement = finalStatement || '_' || param || ' ' || r."column_types"[paramIterator];
                    if paramIterator != array_length(r."columns", 1) then
                        finalStatement = finalStatement || ',';
                    end if;
                end;
                end loop;

                finalStatement = finalStatement || ') returns void language sql as $$';

                finalStatement = finalStatement || 'insert into ' || cast(r.table_name as text) || ' (';
                paramIterator = 0;
                foreach param in array r."columns" loop
                begin
                    paramIterator = paramIterator + 1;
                    finalStatement = finalStatement || param;
                    if paramIterator != array_length(r."columns", 1) then
                        finalStatement = finalStatement || ',';
                    end if;
                end;
                end loop;
                finalStatement = finalStatement || ') values(';

                paramIterator = 0;
                foreach param in array r."columns" loop
                begin
                    paramIterator = paramIterator + 1;
                    finalStatement = finalStatement || '_' || param;
                    if paramIterator != array_length(r."columns", 1) then
                        finalStatement = finalStatement || ',';
                    end if;
                end;
                end loop;

                finalStatement = finalStatement || ');';
                finalStatement = finalStatement || ' $$;';
                raise notice '%', finalStatement;

            end;
        end loop;
end;
$YOYOYO$;





CREATE OR REPLACE FUNCTION public.generate_simple_inserts(_ignoregenerated boolean)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

declare r record;
declare params text[];
declare param text;
declare paramIterator int;
declare finalStatement text;

begin
        for r in select * from in_all_columns_with_foreign_key_table_and_column_as_array order by table_name loop
            begin

                if _ignoregenerated = true then
                    finalStatement = 'create or replace function autogen.insert_ignore_generated_' || r."table_name" || '(';
                end if;
                if _ignoregenerated = false then
                    finalStatement = 'create or replace function autogen.insert_' || r."table_name" || '(';
                end if;

                paramIterator = 0;
                foreach param in array r."columns" loop
                begin
                    paramIterator = paramIterator + 1;
                    continue when _ignoregenerated is true and r."column_default"[paramIterator]::text is not null;
                    finalStatement = finalStatement || '_' || param || ' ' || r."column_types"[paramIterator];
                    if paramIterator != array_length(r."columns", 1) then finalStatement = finalStatement || ','; end if;
                end;
                end loop;

                finalStatement = finalStatement || ') returns void language sql as $$';
                finalStatement = finalStatement || 'insert into ' || cast(r.table_name as text) || ' (';
                paramIterator = 0;
                foreach param in array r."columns" loop
                begin
                    paramIterator = paramIterator + 1;
                    continue when _ignoregenerated is true and r."column_default"[paramIterator]::text is not null;
                    finalStatement = finalStatement || param;
                    if paramIterator != array_length(r."columns", 1) then finalStatement = finalStatement || ','; end if;
                end;
                end loop;
                finalStatement = finalStatement || ') values(';

                paramIterator = 0;
                foreach param in array r."columns" loop
                begin
                    paramIterator = paramIterator + 1;
                    continue when _ignoregenerated is true and r."column_default"[paramIterator]::text is not null;
                    finalStatement = finalStatement || '_' || param;
                    if paramIterator != array_length(r."columns", 1) then finalStatement = finalStatement || ','; end if;
                end;
                end loop;

                finalStatement = finalStatement || ');';

                finalStatement = finalStatement || ' $$;';
                raise notice '%', finalStatement;
                execute finalStatement;

            end;
        end loop;
end;
$function$

