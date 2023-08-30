use semimar_4;

-- Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с
-- помощью которой можно переместить любого (одного) пользователя из таблицы
-- users в таблицу users_old. (использование транзакции с выбором commit или rollback
-- — обязательно).
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);

DROP PROCEDURE IF EXISTS transfer_user;
DELIMITER //
CREATE PROCEDURE transfer_user(userID INT)
BEGIN
	DECLARE C INT;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- rollback any error in the transaction
        IF (C = 0) THEN
			SELECT "Пользователь не найден" AS result;
		ELSE
			SELECT CONCAT('Почта ', email, ' уже существует') AS result FROM users WHERE id = userID;
		END IF;
    END;
    
	START TRANSACTION;
		SELECT COUNT(*) INTO C FROM users WHERE id = userID;
        IF (C != 1) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Custom error'; -- error for ROLLBACK
		END IF;
		INSERT INTO users_old (firstname, lastname, email)
		SELECT firstname, lastname, email 
		FROM users
		WHERE id = userID;

		SELECT * FROM users WHERE id = userID;
	COMMIT;
END //

DELIMITER ;
    
CALL transfer_user(FLOOR(1 + RAND() * (SELECT COUNT(*) FROM users))); -- ошибка только на 11 пользователе(его нет) или такая почта уже существует
CALL transfer_user(15);  -- нет такого пользователя

SELECT * FROM users_old;

-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в
-- зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать
-- фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый
-- день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
DROP FUNCTION IF EXISTS hello;
DELIMITER //

CREATE FUNCTION hello()
RETURNS VARCHAR(20) READS SQL DATA
BEGIN
	DECLARE hour_now INT;
	DECLARE greetings VARCHAR(20);
    
    SELECT HOUR(CURRENT_TIME()) INTO hour_now;
	SELECT 
		CASE
			WHEN hour_now BETWEEN 0 AND 5 -- '00:00:00' AND '05:59:59'
				THEN "Доброй ночи"
			WHEN hour_now BETWEEN 6 AND 11 -- '06:00:00' AND '11:59:59'
				THEN "Доброе утро"
			WHEN hour_now BETWEEN 12 AND 17 -- '12:00:00' AND '17:59:59'
				THEN "Добрый день"
			WHEN hour_now BETWEEN 18 AND 23 -- '18:00:00' AND '23:59:59'
				THEN "Добрый вечер" 
			ELSE CONCAT("Ошибка: Время ", CURRENT_TIME())
		END
        INTO greetings;
	
	RETURN greetings;
END //

DELIMITER ;

SELECT hello();

-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи
-- в таблицах users, communities и messages в таблицу logs помещается время и дата
-- создания записи, название таблицы, идентификатор первичного ключа.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs(
	id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(20),
    table_id INT,
    created_at DATETIME DEFAULT NOW()
);

DROP TRIGGER IF EXISTS tr_ins_user_log;
CREATE TRIGGER tr_ins_user_log
AFTER INSERT ON users
FOR EACH ROW
INSERT INTO logs(table_name, table_id)
VALUES ('users', NEW.id);


DELETE FROM users WHERE (firstname, lastname, email) = ('Vasya', 'Pupkin', 'example@mail.ru');
INSERT INTO users (firstname, lastname, email) VALUES 
('Vasya', 'Pupkin', 'example@mail.ru');

DROP TRIGGER IF EXISTS tr_ins_com_log;
CREATE TRIGGER tr_ins_com_log
AFTER INSERT ON communities
FOR EACH ROW
INSERT INTO logs(table_name, table_id)
VALUES ('communities', NEW.id);

DELETE FROM communities WHERE name = 'test';
INSERT INTO communities(name) VALUES ('test');

DROP TRIGGER IF EXISTS tr_ins_mes_log;
CREATE TRIGGER tr_ins_mes_log
AFTER INSERT ON messages
FOR EACH ROW
INSERT INTO logs(table_name, table_id)
VALUES ('messages', NEW.id);

DELETE FROM messages WHERE (from_user_id, to_user_id, body) = (1, 2, 'TEST TEST TEST');
INSERT INTO messages(from_user_id, to_user_id, body)
VALUES (1, 2, 'TEST TEST TEST');
SELECT * FROM logs;