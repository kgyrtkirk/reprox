
drop table if exists q;
create table q (t1 float,l text);
insert into q values (.25,'asd'),(.5,'xxx');


\d conditions
--explain analyze select * from conditions limit 1;

explain analyze select * from conditions limit 1;


explain select distinct l from q join conditions on (temperature=t1);

set enable_mergejoin =true;

explain analyze select distinct time_bucket('01:00:00'::interval, t),l from q join conditions on (temperature=t1) 
where t BETWEEN '2022-01-01 06:04:00' AND '2023-01-01 07:04:00'
order by 1
    ;

set enable_mergejoin =false;

explain analyze
with a1 as (
    select time_bucket('01:00:00'::interval, t),
                last(temperature,t) as lt from conditions -- join q on (temperature=t1) 
--    where t BETWEEN '2022-01-01 06:04:00' AND '2023-01-01 07:04:00'
    group by 1
order by 1
) 
select distinct lt from a1
where lt>.1;

explain analyze select distinct time_bucket('01:00:00'::interval, t),l from q join conditions on (temperature=t1) 
where t BETWEEN '2022-01-01 06:04:00' AND '2023-01-01 07:04:00'
order by 1
    ;


--    where t > '2022-01-01';
-- sd;