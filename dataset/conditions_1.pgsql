-- ~4M rows
-- 360M
-- 365 chunks   ~8640
-- 3 chunk      ~100k rows
-- 1 chunk      ~860k rows
--

CREATE TABLE conditions (
    t timestamp with time ZONE NOT NULL,
    temperature NUMERIC
);

SELECT create_hypertable('conditions', 't', chunk_time_interval => INTERVAL '1 days');

INSERT INTO conditions (t, temperature)
SELECT
    generate_series('2022-01-01 00:00:00-00'::timestamptz, '2022-01-31 23:59:59-00'::timestamptz, '1000 ms'),
    0.25
limit 0;

INSERT INTO conditions (t, temperature)
SELECT
    generate_series('2022-01-01 00:00:00-00'::timestamptz, '2022-01-03 23:59:59-00'::timestamptz, '100 ms'),
    0.25;

ALTER TABLE conditions SET (timescaledb.compress);
select compress_chunk( show_chunks('conditions'),true);
