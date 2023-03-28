INSERT INTO meter(id, date_install, serial_number)
SELECT 
    CAST(gs.id AS TEXT) AS id, 
    '2022-01-01'::TIMESTAMP + (floor(random() * 364) || ' DAYS')::INTERVAL AS date_install,
    floor(random() * 10000000 + 1000000) AS serial_number
FROM (SELECT generate_series(1000000,2999999) AS id) gs;

CALL load_measures(gs_start => 1000000, gs_end => 2999999);