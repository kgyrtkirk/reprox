--insert into readings select * from readings;

DROP MATERIALIZED VIEW conditions_summary_daily_3;
DROP MATERIALIZED VIEW conditions_summary_daily_4;
DROP MATERIALIZED VIEW conditions_summary_daily_5;

CREATE MATERIALIZED VIEW conditions_summary_daily_3
WITH (timescaledb.continuous,timescaledb.materialized_only=true) AS
SELECT time_bucket(INTERVAL '1 hour', time) AS bucket,
   AVG(cpu_avg_1min),
   MAX(cpu_avg_1min),
   MIN(cpu_avg_1min),
   heartbeat_agg(time,time_bucket('1 hour'::interval, time), '1h','15m') ha,
--   device_id,
   battery_level < 60 as cough
FROM readings
GROUP BY  bucket,cough
order by bucket
;

CREATE MATERIALIZED VIEW conditions_summary_daily_4
WITH (timescaledb.continuous,timescaledb.materialized_only=true) AS
SELECT time_bucket(INTERVAL '1 hour', time) AS bucket,
   AVG(cpu_avg_1min),
   MAX(cpu_avg_1min),
   MIN(cpu_avg_1min),
   heartbeat_agg(time,time_bucket('1 hour'::interval, time), '1h','15m') ha,
--   device_id,
--   battery_level < 60 as cough
1
FROM readings
where battery_level < 60
GROUP BY  bucket
order by bucket
;


CREATE MATERIALIZED VIEW conditions_summary_daily_5
WITH (timescaledb.continuous,timescaledb.materialized_only=true) AS
SELECT time_bucket(INTERVAL '1 hour', time) AS bucket,
    
   AVG(cpu_avg_1min),
   MAX(cpu_avg_1min),
   MIN(cpu_avg_1min),
   heartbeat_agg(time,time_bucket('1 hour'::interval, time), '1h','15m') ha,
--   device_id,
--   battery_level < 60 as cough
1
FROM readings
where battery_level >= 60
GROUP BY  bucket
order by bucket
;


select  * from conditions_summary_daily_3 
--where device_id='demo000000'
--group by bucket
limit 100;


explain (analyze, costs, buffers, verbose, summary, timing, settings)
select * from conditions_summary_daily_4 c1 join conditions_summary_daily_5 c2 on (c1.bucket=c2.bucket)
--where c1.cough=true and c2.cough=false
order by c1.bucket
;
