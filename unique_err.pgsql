-- unique_error.pgsql

drop table if exists main_table;

create table main_table as select * from stage1;
create unique index xm on main_table(time,device_id);
SELECT create_hypertable('main_table', 'time', chunk_time_interval => interval '12 hour', migrate_data=>true);

ALTER TABLE main_table SET (
            timescaledb.compress,
            timescaledb.compress_segmentby = 'battery_temperature,bssid,cpu_avg_5min,device_id',
            timescaledb.compress_orderby = '')
;
select compress_chunk(show_chunks('main_table'));

insert into main_table select * from stage2;
select count(1) from main_table;

select 'unexpected unique failure during decompression';

select decompress_chunk(show_chunks('main_table'),true);

