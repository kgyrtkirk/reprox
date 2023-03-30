--insert into readings select * from readings;

DROP MATERIALIZED VIEW conditions_summary_daily_3;
DROP MATERIALIZED VIEW conditions_summary_daily_4;
DROP MATERIALIZED VIEW conditions_summary_daily_5;

CREATE MATERIALIZED VIEW conditions_summary_daily_3
WITH (timescaledb.continuous,timescaledb.materialized_only=true) AS
SELECT time_bucket(INTERVAL '5 min', time) AS bucket,
   AVG(cpu_avg_1min),
   MAX(cpu_avg_1min),
   MIN(cpu_avg_1min),
   heartbeat_agg(time,time_bucket('5 min'::interval, time), '5 min','1m') ha,
--   device_id,
   battery_level < 60 as cough
FROM readings
GROUP BY  bucket,cough
order by bucket
;

CREATE MATERIALIZED VIEW conditions_summary_daily_4
WITH (timescaledb.continuous,timescaledb.materialized_only=true) AS
SELECT time_bucket(INTERVAL '5 min', time) AS bucket,
   AVG(cpu_avg_1min),
   MAX(cpu_avg_1min),
   MIN(cpu_avg_1min),
   device_id,
   heartbeat_agg(time,time_bucket('5 min'::interval, time), '5min','1m') ha,
--   battery_level < 60 as cough
1
FROM readings
where battery_level < 60
GROUP BY  bucket,device_id
order by bucket,device_id
;


CREATE MATERIALIZED VIEW conditions_summary_daily_5
WITH (timescaledb.continuous,timescaledb.materialized_only=true) AS
SELECT time_bucket(INTERVAL '5 min', time) AS bucket,
    
   AVG(cpu_avg_1min),
   MAX(cpu_avg_1min),
   MIN(cpu_avg_1min),
   heartbeat_agg(time,time_bucket('5 min'::interval, time), '5min','1m') ha,
   device_id,
--   battery_level < 60 as cough
1
FROM readings
where battery_level >= 60
GROUP BY  bucket,device_id
order by bucket,device_id
;


select  * from conditions_summary_daily_3 
--where device_id='demo000000'
--group by bucket
limit 3;


explain (analyze, costs, buffers, verbose, summary, timing, settings)
select * from conditions_summary_daily_4 c1 join conditions_summary_daily_5 c2 on (c1.bucket=c2.bucket and c1.device_id=c2.device_id)
--where c1.cough=true and c2.cough=false
--order by c1.bucket,c1.device_id
;
