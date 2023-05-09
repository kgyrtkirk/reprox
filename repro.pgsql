SELECT add_compression_policy('conditions', INTERVAL '1 week');

SELECT * FROM timescaledb_information.jobs WHERE proc_name='policy_compression';
SELECT next_start FROM timescaledb_information.jobs WHERE proc_name='policy_compression';
select pg_sleep(1);
SELECT next_start FROM timescaledb_information.jobs WHERE proc_name='policy_compression';
select pg_sleep(60);
SELECT next_start FROM timescaledb_information.jobs WHERE proc_name='policy_compression';
