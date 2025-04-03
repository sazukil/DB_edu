-- 1. Вывести список категорий для конкретного продукта (по имени)
SELECT c.Title AS Category FROM Product_to_Category ptc
JOIN Category c ON ptc.Category_id_category = c.id_category
JOIN Product p ON ptc.Product_id_product = p.id_product
WHERE p.Title = 'Каркассон';

-- 2. Вывести список заказов конкретного пользователя
SELECT 
    o.Order_numder AS 'Номер заказа',
    o.Order_date AS 'Дата заказа',
    o.Delivery_method AS 'Способ доставки',
    o.Status AS 'Статус',
    GROUP_CONCAT(
            CONCAT('* ', p.Title, ' - ', otp.Count, ' шт. (', p.Price, ' ₽/шт.)') 
            SEPARATOR '\n') AS 'Состав заказа',
	pm.Cost AS 'Итого',
    pm.Payment_method AS 'Способ оплаты',
    pm.Status AS 'Статус оплаты'
FROM `Order` o
JOIN `Order_to_Product` otp ON o.Order_numder = otp.Order_Order_numder
JOIN `Product` p ON otp.Product_id_product = p.id_product
LEFT JOIN `Payment` pm ON o.Order_numder = pm.Order_Order_numder
WHERE o.Buyer_Login = 'sazukil'
GROUP BY o.Order_numder, o.Order_date, o.Delivery_method, o.Status, pm.Payment_method, pm.Cost, pm.Status
ORDER BY o.Order_date ASC;

-- 3. Вывести список товаров, соответствующих определённым фильтрам (категория, возраст, количество игроков, …)
SELECT p.Title, p.Price, p.Difficult, p.Age_limit, p.Game_time, p.Number_of_players,
       m.Name AS Maker, GROUP_CONCAT(c.Title SEPARATOR ', ') AS Categories
FROM Product p
JOIN Maker m ON p.Maker_id_maker = m.id_maker
JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product
JOIN Category c ON ptc.Category_id_category = c.id_category
WHERE c.Title = 'Стратегии' 
  AND p.Age_limit <= 12 
  AND p.Number_of_players LIKE '2%' 
  AND p.Price BETWEEN 1000 AND 3000
GROUP BY p.id_product
ORDER BY p.Price;

-- 4. Вывести список акций, доступных в текущий момент
SELECT d.Title, d.Discount_amount, d.Start_date, d.End_date FROM Discount d
WHERE CURDATE() BETWEEN d.Start_date AND d.End_date
GROUP BY d.id_discount
ORDER BY d.Discount_amount ASC;

-- 5. Вывести список товаров, которые находятся в избранном у конкретного пользователя
SELECT p.Title, p.Price, p.Difficult, p.Age_limit, 
       m.Name AS Maker, ptf.Date_added
FROM Product p
JOIN Product_to_Favorites ptf ON p.id_product = ptf.Product_id_product
JOIN Favorites f ON ptf.Favorites_id_favorites = f.id_favorites
JOIN Maker m ON p.Maker_id_maker = m.id_maker
WHERE f.Buyer_Login = 'sazukil'
ORDER BY ptf.Date_added DESC;

-- 6. Вывести список товаров конкретного производителя
SELECT p.Title, p.Price, p.Difficult, p.Age_limit, 
       p.Game_time, p.Number_of_players,
       GROUP_CONCAT(c.Title SEPARATOR ', ') AS Categories
FROM Product p
JOIN Maker m ON p.Maker_id_maker = m.id_maker
JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product
JOIN Category c ON ptc.Category_id_category = c.id_category
WHERE m.Name = 'Hobby World'
GROUP BY p.id_product;

-- 7. Вывести количество пользователей, добавивших конкретный товар в избранное
SELECT p.Title, COUNT(DISTINCT f.Buyer_Login) AS FavoriteCount
FROM Product p
JOIN Product_to_Favorites ptf ON p.id_product = ptf.Product_id_product
JOIN Favorites f ON ptf.Favorites_id_favorites = f.id_favorites
WHERE p.Title = 'Серп'
GROUP BY p.Title;

-- 8. Вывести суммарный объём продаж за определённый период
SELECT 
    SUM(pay.Cost) AS TotalRevenue,
    COUNT(DISTINCT o.Order_numder) AS OrderCount,
    SUM(otp.Count) AS ProductCount
FROM `Order` o
JOIN Payment pay ON o.Order_numder = pay.Order_Order_numder
JOIN Order_to_Product otp ON o.Order_numder = otp.Order_Order_numder
WHERE o.Order_date BETWEEN '2024-01-01' AND '2025-01-01'
AND pay.Status = 'Оплачено';

-- 9. Вывести средний рейтинг конкретной настольной игры
SELECT p.Title, 
       AVG(f.Score) AS AvgRating,
       COUNT(f.id_feedback) AS ReviewCount
FROM Product p
JOIN Feedback f ON p.id_product = f.Product_id_product
WHERE p.Title = 'Манчкин'
GROUP BY p.Title;

-- 10. Вывести количество активных заказов (те, которые ещё не доставлены)
SELECT COUNT(*) AS ActiveOrdersCount FROM `Order`
WHERE Status NOT IN ('Доставлен', 'Отменен');

-- 11. Вывести среднюю стоимость заказа
SELECT 
    AVG(pay.Cost) AS AvgOrderCost,
    MIN(pay.Cost) AS MinOrderCost,
    MAX(pay.Cost) AS MaxOrderCost
FROM Payment pay
WHERE pay.Status = 'Оплачено';

-- 12. Вывести список игр, которые чаще всего возвращаются
SELECT p.Title, COUNT(r.id_refund) AS RefundCount FROM Product p
JOIN Order_to_Product otp ON p.id_product = otp.Product_id_product
JOIN `Order` o ON otp.Order_Order_numder = o.Order_numder
JOIN Refund r ON o.Order_numder = r.Order_Order_numder
GROUP BY p.Title
ORDER BY RefundCount DESC
LIMIT 3;

-- 13. Вывести список самых популярных настольных игр на платформе
SELECT 
    p.Title,
    COUNT(DISTINCT otp.Order_Order_numder) AS OrderCount,
    COUNT(DISTINCT ptf.Favorites_id_favorites) AS FavoriteCount,
    AVG(f.Score) AS AvgRating
FROM Product p
LEFT JOIN Order_to_Product otp ON p.id_product = otp.Product_id_product
LEFT JOIN Product_to_Favorites ptf ON p.id_product = ptf.Product_id_product
LEFT JOIN Feedback f ON p.id_product = f.Product_id_product
GROUP BY p.Title
ORDER BY OrderCount DESC, AvgRating DESC, FavoriteCount DESC
LIMIT 7;