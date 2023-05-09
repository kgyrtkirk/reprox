
\d _timescaledb_internal.compress_hyper_2_2_chunk

-- Execution with Timescale 2.7.2: BitmapAnd with both indices are used
EXPLAIN analyze SELECT  device_id,board_id,sum(value) AS value
FROM values
WHERE time >= '2021-07-01 00:00:00Z'::TIMESTAMPTZ
AND time < '2021-07-02 00:00:00Z'::TIMESTAMPTZ
AND   device_id = ANY(ARRAY['D47'])
AND metric = 6
GROUP BY device_id, board_id;

-- Execution with Timescale 2.7.2: BitmapAnd with both indices are used
EXPLAIN analyze SELECT  device_id,board_id,sum(value) AS value
FROM values
WHERE time >= '2021-07-01 00:00:00Z'::TIMESTAMPTZ
AND time < '2021-07-02 00:00:00Z'::TIMESTAMPTZ
AND   device_id = ANY(ARRAY['D47'])
AND metric = 6
GROUP BY device_id, board_id;

-- Execution with Timescale 2.7.2: BitmapAnd with both indices are used
EXPLAIN analyze SELECT  device_id,board_id,sum(value) AS value
FROM values
WHERE time >= '2021-07-01 00:00:00Z'::TIMESTAMPTZ
AND time < '2021-07-02 00:00:00Z'::TIMESTAMPTZ
AND   device_id = ANY(ARRAY['D47'])
AND metric = 6
GROUP BY device_id, board_id;
