USE semimar_4;

-- 1. Подсчитать общее количество лайков, которые получили пользователи
-- младше 12 лет.
SELECT COUNT(*) AS likes
FROM likes AS l
JOIN media m ON l.media_id = m.id
WHERE m.user_id IN 
    (SELECT user_id FROM profiles WHERE DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), birthday)), '%Y') < 12);

-- 2. Определить кто больше поставил лайков (всего): мужчины или
-- женщины.
SELECT  
IF(
    (SELECT COUNT(*) FROM likes AS l
    JOIN profiles AS p ON l.user_id = p.user_id
    WHERE p.gender = 'm') >
    (SELECT COUNT(*) FROM likes AS l
    JOIN profiles AS p ON l.user_id = p.user_id
    WHERE p.gender = 'f'),
    "MALE WIN", "FEMALE WIN") AS WINNER


-- 3. Вывести всех пользователей, которые не отправляли сообщения.
SELECT u.firstname, u.lastname 
FROM users AS u 
WHERE u.id NOT IN 
    (SELECT DISTINCT m.from_user_id FROM messages AS m);

-- 4. (по желанию)* Пусть задан некоторый пользователь. Из всех друзей
-- этого пользователя найдите человека, который больше всех написал
-- ему сообщений.
SELECT u.firstname, u.lastname, count(m.id) AS msg
FROM messages AS m
JOIN users AS u ON m.from_user_id = u.id
WHERE m.to_user_id = 1 AND
m.from_user_id IN
	(SELECT IF(fr.initiator_user_id = m.to_user_id, fr.target_user_id, fr.initiator_user_id) 
    FROM friend_requests AS fr 
    WHERE (fr.initiator_user_id = m.to_user_id OR fr.target_user_id = m.to_user_id) AND fr.status = 'approved')
GROUP BY m.from_user_id
ORDER BY msg DESC
LIMIT 1;