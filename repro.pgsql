
VACUUM FULL VERBOSE ANALYZE conditions;
select decompress_chunk(show_chunks('conditions'));

update conditions set temperature = 2.0 where 
t between '2022-01-01 22:00:00-00'::timestamptz and '2022-01-02 01:59:59-00'::timestamptz
;
select compress_chunk(show_chunks('conditions'));
VACUUM FULL VERBOSE ANALYZE conditions;
