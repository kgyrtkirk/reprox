-- unique_error.pgsql

drop table if exists main_table;

create table main_table as select * from stage1 s where md5(s||'xaaa') < '8';
create unique index xm on main_table(time,device_id);
SELECT create_hypertable('main_table', 'time', chunk_time_interval => interval '12 hour', migrate_data=>true);

ALTER TABLE main_table SET (
            timescaledb.compress,
            timescaledb.compress_segmentby = 'device_id',
            timescaledb.compress_orderby = '')
;
select compress_chunk(show_chunks('main_table'));


-- detected correctly when only 1 row is inserted
\set ON_ERROR_STOP 0
insert into main_table select * from stage2 s
     where md5(s||'xaaa') < '22'  and md5(s||'xaaa') > '21' limit 1 offset 3;
\set ON_ERROR_STOP 1

explain insert into main_table select * from stage2 s
     where md5(s||'xaaa') < '22'  and md5(s||'xaaa') > '21';-- limit 1 offset 3;

-- but with the right company - it can get in !
insert into main_table select * from stage2 s
     where md5(s||'xaaa') < '22'  and md5(s||'xaaa') > '21';-- limit 1 offset 3;
select count(1) from main_table;


select time,device_id,tableoid::regclass::text,count(1) from main_table where
     time='2016-11-23 11:29:30.000006+00'
    and device_id='demo000113'
      group by time,device_id,tableoid::regclass::text;
 

select tableoid::regclass::text as chunk from main_table where
     time='2016-11-23 11:29:30.000006+00'
    and device_id='demo000113'
      group by time,device_id,tableoid::regclass::text \gset

select :'chunk';
select * from _timescaledb_catalog.chunk where schema_name ||'.'||table_name = :'chunk';
-- compress_hyper_285_5719_chunk
select cc.table_name as c_chunk
    from _timescaledb_catalog.chunk c
    join _timescaledb_catalog.chunk cc on (cc.id=c.compressed_chunk_id)
    where c.schema_name ||'.'||c.table_name = :'chunk' \gset

set search_path = public, _timescaledb_internal;


-- we have 2 records
select * from :chunk where device_id = 'demo000113';
-- 1 lives in compressed; see _ts_meta_max1
select * from only :c_chunk where device_id = 'demo000113';
-- 1 in decompressed form
select * from only :chunk where device_id = 'demo000113';

select 'unexpected unique failure during decompression';

select decompress_chunk(show_chunks('main_table'),true);
