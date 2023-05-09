ALTER EXTENSION timescaledb UPDATE TO "2.10.3";
\c

-- Execution with Timescale 2.10.3: Only one of the indices is used. With real database this is leading to 20x query execution time: from 0.5sec to 10sec
EXPLAIN  analyze SELECT  device_id,board_id,sum(value) AS value
FROM values
WHERE time >= '2021-07-01 00:00:00Z'::TIMESTAMPTZ
AND time < '2021-07-02 00:00:00Z'::TIMESTAMPTZ
AND   device_id = ANY(ARRAY['D47'])
AND metric = 6
GROUP BY device_id, board_id;
