-- unique_error.pgsql

drop table if exists main_table;

create table main_table as select * from stage1 s where md5(s||'xaaa') < '8';
create unique index xm on main_table(time,device_id);
SELECT create_hypertable('main_table', 'time', chunk_time_interval => interval '12 hour', migrate_data=>true);

ALTER TABLE main_table SET (
            timescaledb.compress,
            timescaledb.compress_segmentby = 'battery_temperature,bssid,cpu_avg_5min,device_id',
            timescaledb.compress_orderby = '')
;
select compress_chunk(show_chunks('main_table'));


-- detected correctly when only 1 row is inserted
\set ON_ERROR_STOP 0
insert into main_table select * from stage2 s
     where md5(s||'xaaa') < '22'  and md5(s||'xaaa') > '21' limit 1 offset 3;
\set ON_ERROR_STOP 1

insert into main_table select * from stage2 s
     where md5(s||'xaaa') < '22'  and md5(s||'xaaa') > '21';-- limit 1 offset 3;
select count(1) from main_table;

select 'unexpected unique failure during decompression';

select decompress_chunk(show_chunks('main_table'),true);

