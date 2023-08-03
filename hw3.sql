CREATE DATABASE sql_hw2;
use sql_hw2;


CREATE TABLE staff(
	id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(45) NOT NULL,
    lastname VARCHAR(45) NOT NULL,
    post VARCHAR(45) NOT NULL,
    seniority INT,
    salary INT,
    age INT
);

INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
('Вася', 'Петров', 'Начальник', 40, 100000, 60),
('Петр', 'Власов', 'Начальник', 8, 70000, 30),
('Катя', 'Катина', 'Инженер', 2, 70000, 25),
('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
('Иван', 'Иванов', 'Рабочий', 40, 30000, 59),
('Петр', 'Петров', 'Рабочий', 20, 25000, 40),
('Сидр', 'Сидров', 'Рабочий', 10, 20000, 35),
('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
('Максим', 'Максимов', 'Рабочий', 2, 11000, 22),
('Юрий', 'Галкин', 'Рабочий', 3, 12000, 24),
('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);


-- Отсортируйте данные по полю заработная плата (salary) в порядке убывания
SELECT *
FROM staff
ORDER BY salary DESC;

-- Отсортируйте данные по полю заработная плата (salary) в порядке возрастания
SELECT *
FROM staff
ORDER BY salary ;

-- Выведите 5 максимальных заработаных плат (salary)
SELECT *
FROM staff
ORDER BY salary DESC
LIMIT 5;

-- Подсчитайте суммарную зарплату (salary) по каждой специальности (post)
SELECT post, SUM(salary) as sum_salary
FROM staff
GROUP BY post;

-- Найдите количество сотрудников с специальностью (post) 'Рабочий' в возрасте от 24 до 49 лет включительно
SELECT COUNT(*) count_workers
FROM staff
WHERE post = 'Рабочий' AND age BETWEEN 24 AND 49;

-- Найдите количество специальностей
SELECT COUNT(DISTINCT post) as amount_posts
FROM staff;

-- Выведите специальности, у которых средний возраст сотрудников меньше 30 лет
SELECT post, AVG(age) as avg_age
FROM staff
GROUP BY post
HAVING avg_age < 30;