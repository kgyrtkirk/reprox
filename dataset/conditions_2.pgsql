-- ~40M rows
-- 3.6G
-- 365 chunks   ~86400
-- 3 chunk      ~1M rows
-- 1 chunk      ~8.6M rows
--

CREATE TABLE conditions (
    t timestamp with time ZONE NOT NULL,
    temperature NUMERIC
);

SELECT create_hypertable('conditions', 't', chunk_time_interval => INTERVAL '1 days');

INSERT INTO conditions (t, temperature)
SELECT
    generate_series('2022-01-01 00:00:00-00'::timestamptz, '2022-12-31 23:59:59-00'::timestamptz, '1 second'),
    0.25;

INSERT INTO conditions (t, temperature)
SELECT
    generate_series('2022-01-01 00:00:00-00'::timestamptz, '2022-01-31 23:59:59-00'::timestamptz, '100 ms'),
    0.25;

INSERT INTO conditions (t, temperature)
SELECT
    generate_series('2022-01-01 00:00:00-00'::timestamptz, '2022-01-03 23:59:59-00'::timestamptz, '10 ms'),
    0.25;

ALTER TABLE conditions SET (timescaledb.compress);
select compress_chunk( show_chunks('conditions'),true);