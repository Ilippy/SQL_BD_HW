-- Для решения задач используйте базу данных lesson_4
-- (скрипт создания, прикреплен к 4 семинару).
USE semimar_4;

-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия,
-- город и пол), которые не старше 20 лет.
CREATE OR REPLACE VIEW young AS
SELECT u.firstname, u.lastname, p.hometown, p.gender
FROM users AS u
JOIN profiles AS p ON u.id = p.user_id
WHERE DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), birthday)), '%Y') < 20;

-- 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите
-- ранжированный список пользователей, указав имя и фамилию пользователя, количество
-- отправленных сообщений и место в рейтинге (первое место у пользователя с максимальным
-- количеством сообщений) . (используйте DENSE_RANK)
WITH CTE_count_msgs_by_user AS
	(SELECT
		u.firstname,
		u.lastname,
		COUNT(*) AS msg_count    
	FROM messages AS m
	JOIN users as u on u.id = m.from_user_id
	GROUP BY m.from_user_id)
SELECT 
	firstname, 
    lastname, 
    msg_count,
    DENSE_RANK() OVER (ORDER BY msg_count DESC) AS msg_rank
FROM CTE_Count_msgs_by_user
ORDER BY msg_rank;

-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления
-- (created_at) и найдите разницу дат отправления между соседними сообщениями, получившегося
-- списка. (используйте LEAD или LAG)
SELECT
	body,
    created_at,
    TIMEDIFF(created_at, Lag(created_at) OVER (ORDER BY created_at)) as dif
FROM messages AS m
ORDER BY created_at;