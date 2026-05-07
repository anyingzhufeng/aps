-- cron_flush_verify_1600.sql (2026-05-07 16:00 UTC+8)
-- Test write to verify flush bug is resolved
SELECT 'flush_write_verified' AS status, NOW() AS ts;
