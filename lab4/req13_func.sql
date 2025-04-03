-- 1. Форматирование даты регистрации покупателей
SELECT Login, DATE_FORMAT(Registration_date, '%d.%m.%Y') AS FormattedRegDate 
FROM Buyer;

-- 2. Вычисление возраста покупателей
SELECT Login, Birthday, TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) AS Age 
FROM Buyer;

-- 3. Извлечение домена из email покупателей
SELECT Email, SUBSTRING(Email, LOCATE('@', Email) + 1) AS Domain 
FROM Buyer 
WHERE Email IS NOT NULL;

-- 4. Цена со скидкой для продуктов
SELECT 
    p.Title, 
    p.Price, 
    d.Discount_amount, 
    ROUND(p.Price * (1 - d.Discount_amount/100)) AS DiscountedPrice 
FROM Product p 
JOIN Discount d ON p.Discount_id_discount = d.id_discount;

-- 5. Длина описания продукта в символах и словах
SELECT 
    Title, 
    LENGTH(Description) AS CharsCount,
    LENGTH(Description) - LENGTH(REPLACE(Description, ' ', '')) + 1 AS WordsCount 
FROM Product 
WHERE Description IS NOT NULL;

-- 6. Разница между датой заказа и текущей датой
SELECT 
    Order_numder, 
    Order_date, 
    DATEDIFF(CURDATE(), Order_date) AS DaysSinceOrder 
FROM `Order`;

-- 7. Получить список продуктов с текущими скидками
SELECT p.Title, d.Title AS Discount, d.Discount_amount 
FROM Product p 
JOIN Discount d ON p.Discount_id_discount = d.id_discount 
WHERE CURDATE() BETWEEN d.Start_date AND d.End_date;

-- 8. Количество дней до окончания акции
SELECT Title, Discount_amount, Start_date, End_date, DATEDIFF(End_date, CURDATE()) AS DaysLeft
FROM Discount
WHERE Title != 'Нет скидки' AND CURDATE() BETWEEN Start_date AND End_date;