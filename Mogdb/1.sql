-- search static info
SELECT 
    schemaname, 
    relname, 
    n_live_tup, 
    n_dead_tup, 
    last_vacuum, 
    last_analyze
FROM 
    pg_catalog.pg_stat_all_tables
WHERE 
    schemaname = 'dsdata' 
    AND relname = 'tt654078_xccz_tmp';

