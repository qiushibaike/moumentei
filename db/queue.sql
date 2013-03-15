DELIMITER //
CREATE TRIGGER consult_trigger AFTER INSERT ON articles
  FOR EACH ROW BEGIN
    IF NEW.status = 'publish' AND NEW.group_id = 3 THEN
      INSERT INTO queue SET id = NEW.id;
    END IF;
  END;
//
CREATE TRIGGER consult_trigger2 AFTER UPDATE ON articles
  FOR EACH ROW BEGIN
    IF NEW.status = 'publish' AND NEW.group_id = 3 THEN
      INSERT INTO queue SET id = NEW.id;
    END IF;
  END;
//
DELIMITER ;


CREATE TABLE `queue` (
`id` INT NOT NULL ,
PRIMARY KEY ( `id` )
) ENGINE = MYISAM ;