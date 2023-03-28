-- DO
-- $BODY$
--     DECLARE
--         job_id  INT;
--     BEGIN
--         SELECT job.id INTO job_id
--         FROM _timescaledb_config.bgw_job job
--         INNER JOIN _timescaledb_catalog.hypertable hypertable ON hypertable.id = job.hypertable_id
--         WHERE hypertable.table_name = 'measures';

--         PERFORM alter_job(job_id, next_start=> current_timestamp);
--     END;
-- $BODY$;

call _timescaledb_internal.policy_compression(1000::integer,'{"hypertable_id": 1, "compress_after": "14 days"}'::jsonb);
