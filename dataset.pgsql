\set DATA_NODE_1 tsdb _1
\set DATA_NODE_2 tsdb _2
\set DATA_NODE_3 tsdb _3

-- ir include/remote_exec.sql
CREATE SCHEMA IF NOT EXISTS test;
GRANT USAGE ON SCHEMA test TO PUBLIC;

-- CREATE OR REPLACE FUNCTION test.remote_exec(srv_name name[], command text)
-- RETURNS VOID
-- AS :TSL_MODULE_PATHNAME, 'ts_remote_exec'
-- LANGUAGE C;

-- CREATE OR REPLACE FUNCTION test.remote_exec_get_result_strings(srv_name name[], command text)
-- RETURNS TABLE("table_record" CSTRING[])
-- AS :TSL_MODULE_PATHNAME, 'ts_remote_exec_get_result_strings'
-- LANGUAGE C;

-- \ir include/compression_utils.sql

SELECT node_name, database, node_created, database_created, extension_created
FROM (
  SELECT (add_data_node(name, host => 'localhost', DATABASE => name)).*
  FROM (VALUES (:'DATA_NODE_1'), (:'DATA_NODE_2'), (:'DATA_NODE_3')) v(name)
) a;

---

CREATE TABLE compressed(time timestamptz, device int, temp float);

-- Replicate twice to see that compress_chunk compresses all replica chunks
SELECT create_distributed_hypertable('compressed', 'time', 'device', replication_factor => 2);
INSERT INTO compressed SELECT t, (abs(timestamp_hash(t::timestamp)) % 10) + 1, random()*80
FROM generate_series('2018-03-02 1:00'::TIMESTAMPTZ, '2018-03-04 1:00', '1 seconds') t;
-- ALTER TABLE compressed SET (timescaledb.compress, timescaledb.compress_segmentby='device', timescaledb.compress_orderby = 'time DESC');

-- drop table if EXISTS c1;
-- drop table if EXISTS conditions;
-- CREATE TABLE conditions (
--     t timestamp with time ZONE NOT NULL,
--     temperature NUMERIC
-- );
-- INSERT INTO conditions (t, temperature)
-- SELECT
--     generate_series('2022-01-01 00:00:00-00'::timestamptz, '2022-01-31 23:59:59-00'::timestamptz, '1 hour'),
--     0.25;
-- create table c1 as select * from conditions where t BETWEEN '2022-01-04 1:00:00-00' and '2022-01-04 11:00:00-00';


CREATE MATERIALIZED VIEW hca_hourly WITH (timescaledb.continuous) AS
  SELECT
    device,
    time_bucket('1 hour', time) AS ts,
    SUM(temp) AS value
  FROM compressed
  GROUP BY 1, 2
;


CREATE MATERIALIZED VIEW hca_hourly2 WITH (timescaledb.continuous) AS
  SELECT
    device,
    time_bucket('1 hour', time) AS ts,
    SUM(temp) AS value
  FROM compressed
  GROUP BY 1, 2
;

