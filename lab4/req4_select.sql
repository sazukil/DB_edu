-- 1. Выбрать продукты с ценой от 2000 до 4000 рублей
SELECT Title, Price  FROM Product 
WHERE Price BETWEEN 2000 AND 4000;

-- 2. Найти покупателей с email на mail.ru
SELECT * FROM Buyer 
WHERE Email LIKE '%@mail.ru%';

-- 3. Получить продукты с возрастом от 10 лет и сложностью "Средняя"
SELECT Title, Age_limit, Difficult FROM Product 
WHERE Age_limit >= 10 AND Difficult = 'Средняя';

-- 4. Найти заказы за последний год
SELECT * FROM `Order` 
WHERE Order_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 YEAR) AND CURDATE();

-- 5. Выбрать производителей из России
SELECT * FROM Maker 
WHERE Country = 'Russia';

-- 6. Получить покупателей без отчества
SELECT * FROM Buyer 
WHERE Patronymic IS NULL;

-- 7. Получить скидки, действующие в декабре
SELECT * FROM Discount 
WHERE MONTH(Start_date) = 12 OR MONTH(End_date) = 12;

-- 8. Найти продукты с временем игры 60 минут и более
SELECT Title, Game_time FROM Product 
WHERE 
	CASE 
    WHEN Game_time LIKE '%-%' THEN 
      CAST(SUBSTRING_INDEX(Game_time, '-', 1) AS UNSIGNED)
    WHEN Game_time LIKE '%+%' THEN 
      CAST(SUBSTRING_INDEX(Game_time, '+', 1) AS UNSIGNED)
    ELSE 
      CAST(Game_time AS UNSIGNED)
  END >= 60
ORDER BY Title ASC;

-- 9. Выбрать покупателей старше 30 лет
SELECT Login, Firstname, Lastname, Birthday 
FROM Buyer 
WHERE Birthday < DATE_SUB(CURDATE(), INTERVAL 30 YEAR);

-- 10. Найти заказы с определенными статусами
SELECT * FROM `Order` 
WHERE Status IN ('В обработке', 'В пути');

-- 11. Получить продукты с максимальной ценой
SELECT Title, Price FROM Product 
WHERE Price = (SELECT MAX(Price) FROM Product);

-- 12. Выбрать отзывы за последнюю неделю
SELECT * FROM Feedback 
WHERE Date_of_feedback >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- 13. Найти продукты с ценой выше средней
SELECT Title, Price FROM Product 
WHERE Price > (SELECT AVG(Price) FROM Product)
ORDER BY Price ASC, Title ASC;

-- 14. Найти все отзывы с оценками 4 и 5
SELECT f.Text, f.Score, p.Title AS Product FROM Feedback f 
JOIN Product p ON f.Product_id_product = p.id_product 
WHERE f.Score IN (4, 5);

-- 15. Преобразование даты регистрации в другой формат
SELECT Login, 
       DATE_FORMAT(Registration_date, '%d.%m.%Y') AS FormattedDate,
       CONCAT(Lastname, ' ', Firstname) AS FullName
FROM Buyer
ORDER BY FormattedDate ASC;