ALTER TABLE ratings DROP COLUMN created_at;
delimiter //
CREATE PROCEDURE mergeratings()
BEGIN
    DECLARE done int default 0;
    DECLARE _article_id int;
    DECLARE _sum int default 0;
    DECLARE cur1 CURSOR FOR SELECT id FROM articles;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    open cur1;
    repeat
        fetch cur1 into _article_id;
        IF NOT done THEN 
            SELECT @count:=count(*), SUM(score) INTO _sum FROM ratings 
                WHERE article_id = _article_id
                    AND user_id = 0 AND score > 0 LIMIT 1;
            IF @count > 1 THEN
                DELETE FROM ratings 
                    WHERE article_id = _article_id
                        AND user_id = 0 AND score > 0;
                INSERT INTO ratings (user_id, article_id, score)
                    VALUES (0, _article_id, _sum);
            END IF;
            SELECT @count:=count(*), SUM(score) INTO _sum FROM ratings
                WHERE article_id = _article_id AND user_id = 0 AND score < 0;
            IF @count > 1 THEN
                DELETE FROM ratings
                    WHERE article_id = _article_id AND user_id = 0 AND score < 0;
                INSERT INTO ratings (user_id, article_id, score)
                    VALUES(0, _article_id, _sum);
            END IF;
        END IF;
    until done end repeat;
    close cur1;
end
//
delimiter ;
call mergeratings();

ALTER TABLE ratings ENGINE=InnoDB;