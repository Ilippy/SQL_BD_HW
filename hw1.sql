CREATE SCHEMA sql_HW1;
use sql_HW1;
# Создайте таблицу с мобильными телефонами (mobile_phones), используя графический интерфейс.
# Заполникте БД данными.
CREATE TABLE `sql_hw1`.`mobile_phones` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(45) NULL,
  `manufacturer` VARCHAR(45) NULL,
  `product_count` INT NULL,
  `price` DECIMAL(10,2) NULL,
  PRIMARY KEY (`id`));

INSERT INTO mobile_phones(product_name, manufacturer, product_count, price)
VALUES 
("IPhone X", "Apple", 3, 76000),
("IPhone 8", "Apple", 2, 51000),
("Galaxy S9", "Samsung", 2, 56000),
("Galaxy S8", "Samsung", 1, 41000),
("P20 Pro", "Huawei", 5, 36000);

# Выведите название, производителя и цену для товаров, количество для которых превышает 2
SELECT product_name "Название", manufacturer "Производитель", price "Цена"
FROM mobile_phones
WHERE product_count > 2;

# Выведите весь ассортимент товаров марки "Samsung"
SELECT * FROM mobile_phones
WHERE manufacturer = "Samsung";

# С помощью регулярных выражений найти:
# Товары, в которых есть упоминание "IPhone"
SELECT * FROM mobile_phones
WHERE product_name LIKE "%IPhone%" OR manufacturer LIKE "%IPhone%";

# Товары, в которых есть упоминание "Samsung"
SELECT * FROM mobile_phones
WHERE product_name LIKE "%Samsung%" OR manufacturer LIKE "%Samsung%";

# Товары, в которых есть ЦИФРЫ
SELECT * FROM mobile_phones
WHERE product_name RLIKE "[0-9]";

# Товары, в которых есть цифра 8
SELECT * FROM mobile_phones
WHERE product_name LIKE "%8%";