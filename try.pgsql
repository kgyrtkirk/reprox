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
   device_id,
   heartbeat_agg(time,time_bucket('5 min'::interval, time), '5 min','20s')  FILTER (WHERE (battery_level::integer % 2) = 0) as ha,
   heartbeat_agg(time,time_bucket('5 min'::interval, time), '5 min','20s') FILTER (WHERE (battery_level::integer % 2) = 1) as ha2,
   heartbeat_agg(time,time_bucket('5 min'::interval, time), '5 min','20s')  as ha3,
   count(1)  FILTER (WHERE (battery_level::integer % 2) = 0) as c1,
   count(1)  FILTER (WHERE (battery_level::integer % 2) = 1) as c2,
   count(1)  as c3,
   1
FROM readings
GROUP BY  bucket,device_id
;



select  bucket,uptime(ha),uptime(ha2),uptime(ha3),c1,c2,c3 from conditions_summary_daily_3 
where device_id='demo000000'
--group by bucket
limit 30;


-- explain (analyze, costs, buffers, verbose, summary, timing, settings)
-- select * from conditions_summary_daily_4 c1 join conditions_summary_daily_5 c2 on (c1.bucket=c2.bucket and c1.device_id=c2.device_id)
--where c1.cough=true and c2.cough=false
--order by c1.bucket,c1.device_id
;
