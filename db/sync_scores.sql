#!/usr/bin/mysql -uroot -p -Dqqq_production
UPDATE articles, scores SET articles.score = scores.score WHERE articles.id = scores.article_id AND scores.ts >= (NOW() - INTERVAL 1 HOUR);
