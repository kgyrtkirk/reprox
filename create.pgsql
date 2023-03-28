CREATE TABLE public.measures (
    measure_date TIMESTAMP NOT NULL,
    received_date TIMESTAMP NOT NULL,
    value DOUBLE PRECISION,
    meter_id TEXT NOT NULL,
    source SMALLINT NOT NULL,
    device_type SMALLINT NULL,
    device_id TEXT NULL
);
SELECT create_hypertable('measures', 'measure_date', chunk_time_interval => INTERVAL '5 DAYS', create_default_indexes => false);
ALTER TABLE measures SET (
    timescaledb.compress,
    timescaledb.compress_segmentby = 'meter_id'
);
SELECT add_compression_policy(hypertable => 'measures', compress_after => INTERVAL '14 DAYS', if_not_exists => true);
CREATE INDEX ix_measures_meter_id_measure_date_received_date ON public.measures (meter_id, measure_date DESC, received_date DESC);
CREATE TABLE IF NOT EXISTS public.meter(
    id TEXT,
    date_install TIMESTAMP,
    serial_number TEXT,
    PRIMARY KEY(id)
);

CREATE OR REPLACE PROCEDURE public.load_measures (IN gs_start INTEGER, IN gs_end INTEGER) AS
$BODY$
BEGIN
    WITH RECURSIVE some_days AS (
        SELECT '2023-01-01'::TIMESTAMP AS rdate 
        UNION ALL 
        SELECT rdate + INTERVAL '1 DAY'
        FROM some_days
        WHERE extract(YEAR FROM rdate + INTERVAL '1 DAY') = 2023 AND extract(MONTH FROM rdate + INTERVAL '1 DAY') <= 2
    )
    INSERT INTO measures(measure_date, received_date, value, meter_id, source, device_type, device_id)
    SELECT
        d.rdate + (floor(random() * 23) || ' HOURS')::INTERVAL AS measure_date, 
        current_timestamp::TIMESTAMP AS received_date, 
        floor(random() * 10000 + 1000) AS value, 
        CAST(gs.id as TEXT) AS meter_id, 
        5 AS source, 42 AS device_type, 'ABCDEF' AS device_id
    FROM (SELECT generate_series(gs_start, gs_end) AS id) gs
    INNER JOIN lateral (SELECT * FROM some_days) d ON true;
END;
$BODY$ 
LANGUAGE PLPGSQL;
