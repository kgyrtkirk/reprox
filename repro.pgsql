
INSERT INTO compressed SELECT t, (abs(timestamp_hash(t::timestamp)) % 10) + 1, random()*80
FROM generate_series('2018-01-01 1:00'::TIMESTAMPTZ, '2018-03-05 1:00', '1 minute') t;

INSERT INTO compressed SELECT t, (abs(timestamp_hash(t::timestamp)) % 10) + 1, random()*80
FROM generate_series('2018-02-01 1:00'::TIMESTAMPTZ, '2018-06-05 1:00', '1 minute') t;



select count(1) from compressed;


explain
select count(device), count(*)
 from compressed
where time > '2018-01-01 10:11:00'::timestamptz
and time<  '2018-03-11 10:11:00'::timestamptz
 and device != 1;



-- create extension pg_stat_statements;
-- create extension pg_auth_mon;
-- create extension timescaledb_cloudutils;

-- create extension auto_explain;
-- create extension tsdb_admin;
