CREATE DATABASE sql_hw2;
use sql_hw2;

-- Используя операторы языка SQL, создайте табличку “sales”. Заполните ее данными 
CREATE TABLE sales(
	id INT PRIMARY KEY AUTO_INCREMENT,
	order_date DATE NOT NULL,
	count_product INT NOT NULL
);

INSERT INTO sales(order_date, count_product) 
VALUES
('2022-01-01', 156),
('2022-01-02', 180),
('2022-01-03', 21),
('2022-01-04', 124),
('2022-01-05', 341);

-- Сгруппируйте значений количества в 3 сегмента — меньше 100, 100-300 и больше 300.
SELECT
id AS "id заказа",
IF(count_product < 100,"Маленький заказ",
	IF(count_product BETWEEN 100 AND 299, "Средний заказ", "Большой заказ"))
AS "Тип заказа"
FROM sales;	

-- Создайте таблицу “orders”, заполните ее значениями. Покажите “полный” статус заказа, используя оператор CASE
CREATE TABLE orders(
	id INT PRIMARY KEY AUTO_INCREMENT,
	empoyee_id VARCHAR(10) NOT NULL,
	amount DECIMAL(10,2) NOT NULL,
    order_status VARCHAR(20) NOT NULL
);

INSERT INTO orders(empoyee_id, amount, order_status)
VALUES
("eo3", 15, "OPEN"),
("eo1", 25.5, "OPEN"),
("eo5", 100.7, "CLOSED"),
("eo2", 22.18, "OPEN"),
("eo4", 9.5, "CANCELLED");

SELECT o.*,
CASE
	WHEN order_status = "OPEN"
		THEN "Order is in open state"
	WHEN order_status = "CLOSED"
		THEN "Order is closed"
	WHEN order_status = "CANCELLED"
		THEN "Order is cancelled"
END AS "Статус заказа"
FROM orders as o;