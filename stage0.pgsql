
-- Start with old version of extension
DROP EXTENSION TIMESCALEDB;
\c
CREATE EXTENSION TIMESCALEDB VERSION "2.7.2";

-- Create schema
CREATE TABLE values (
  time       TIMESTAMPTZ NOT NULL,
  metric     INTEGER,
  device_id  TEXT NOT NULL,
  board_id    TEXT NOT NULL DEFAULT '',
  value      DOUBLE PRECISION NULL,
  UNIQUE (time, metric, device_id, board_id)
);
SELECT create_hypertable('values', 'time',
  chunk_time_interval => interval '1 day');
CREATE INDEX values_metric_device_time_idx ON values (metric, device_id, time DESC);

ALTER TABLE values SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'metric, device_id',
  timescaledb.compress_orderby = 'board_id, time desc'
);

-- insert test data

do $$
declare
  t timestamptz;
begin
   for d in 0..0 loop
    for h in 0..23 loop
        t := timestamp '2021-07-01 00:00:00Z' + interval '1 day' * d + interval '1 hour' * h;
        raise notice 'adding data for %', t;
        for m in 0..9 loop
            insert into values (time,metric,device_id,board_id,value)
                select t, m, 'D'||s1, 'D'||s2, random() from generate_series(1,100) s1, generate_series(1,100) s2;
        end loop;
    end loop;
   end loop;
end; $$
;

-- compress and analyze
select compress_chunk(s) from show_chunks('values') s;
vacuum (full,analyze) values;

