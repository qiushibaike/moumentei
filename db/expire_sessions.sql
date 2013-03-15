DELETE FROM sessions WHERE updated_at < NOW() - INTERVAL 1 HOUR;
-- ActiveRecord::SessionStore::Session
DELETE FROM notifications WHERE created_at < NOW() - INTERVAL 1 DAY AND `read` = '1';
