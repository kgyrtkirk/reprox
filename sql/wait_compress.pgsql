create or replace procedure wait_compress() language plpgsql as
$$
    DECLARE
        n  INT;
        wait int;
    BEGIN
        wait=30;
        loop
            select count(1) into n from pg_stat_activity where application_name like 'Comp%' ;
            rollback;
            if n > 0 then
                wait=30;
                RAISE NOTICE 'wait_compress: % running',n;
            else
                RAISE NOTICE 'wait_compress: idle_wait:%',wait;
                wait=wait-1;
                if wait <= 0 then
                    exit;
                end if;
            end if;
            perform pg_sleep(1);
        end loop;
    END;
$$;

