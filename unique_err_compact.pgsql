-- unique_error.pgsql

set search_path = public, _timescaledb_internal;

drop table if exists main_table;
drop table if exists iii;

create table main_table as
    select '2011-11-11 11:11:11'::timestamptz as time,'foo' as device_id;

create unique index xm on main_table(time,device_id);

SELECT create_hypertable('main_table', 'time', chunk_time_interval => interval '12 hour', migrate_data=>true);

ALTER TABLE main_table SET (
            timescaledb.compress,
            timescaledb.compress_segmentby = 'device_id',
            timescaledb.compress_orderby = '')
;

select compress_chunk(show_chunks('main_table'));

-- insert rejected
\set ON_ERROR_STOP 0
insert into main_table values 
    ('2011-11-11 11:11:11','foo');
\set ON_ERROR_STOP 1

-- insert allowed
insert into main_table values 
    ('2011-11-11 11:12:11','bar'),
    ('2011-11-11 11:11:11','foo');

-- unique check failure during decompression
select decompress_chunk(show_chunks('main_table'),true);

