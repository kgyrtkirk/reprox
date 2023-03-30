
create or replace procedure wait_autovac() language plpgsql as
$$
    DECLARE
        n  INT;
        wait int;
    BEGIN
        wait=15;
        loop
            select count(1) into n from pg_stat_activity where backend_type = 'autovacuum worker';
            rollback;
            if n > 0 then
                wait=5;
                RAISE NOTICE 'wait_autovac: % running',n;
            else
                RAISE NOTICE 'wait_autovac: idle_wait:%',wait;
                wait=wait-1;
                if wait <= 0 then
                    exit;
                end if;
            end if;
            perform pg_sleep(1);
        end loop;
    END;
$$;
