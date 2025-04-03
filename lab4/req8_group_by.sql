-- 1. Количество продуктов каждого производителя
SELECT m.Name, COUNT(p.id_product) AS ProductCount FROM Maker m 
LEFT JOIN Product p ON m.id_maker = p.Maker_id_maker 
GROUP BY m.Name;

-- 2. Средняя цена по категориям
SELECT c.Title, AVG(p.Price) AS AvgPrice FROM Category c 
JOIN Product_to_Category ptc ON c.id_category = ptc.Category_id_category 
JOIN Product p ON ptc.Product_id_product = p.id_product 
GROUP BY c.Title;

-- 3. Количество отзывов по продуктам с сортировкой
SELECT p.Title, COUNT(f.id_feedback) AS FeedbackCount FROM Product p 
LEFT JOIN Feedback f ON p.id_product = f.Product_id_product 
GROUP BY p.Title 
ORDER BY FeedbackCount DESC;

-- 4. Сумма заказов по месяцам
SELECT MONTH(Order_date) AS Month, SUM(pay.Cost) AS Total 
FROM `Order` o 
JOIN Payment pay ON o.Order_numder = pay.Order_Order_numder 
GROUP BY MONTH(Order_date);

-- 5. Продукты с максимальной ценой в каждой категории
SELECT c.Title AS Category, p.Title AS Product, p.Price 
FROM Product p 
JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product 
JOIN Category c ON ptc.Category_id_category = c.id_category 
WHERE p.Price = (
    SELECT MAX(p2.Price) 
    FROM Product p2 
    JOIN Product_to_Category ptc2 ON p2.id_product = ptc2.Product_id_product 
    WHERE ptc2.Category_id_category = c.id_category
);

-- 6. Топ-5 продуктов по средней оценке
SELECT p.Title, AVG(f.Score) AS AvgScore 
FROM Product p 
JOIN Feedback f ON p.id_product = f.Product_id_product 
GROUP BY p.Title 
ORDER BY AvgScore DESC 
LIMIT 5;

-- 7. Количество заказов по способу доставки
SELECT Delivery_method, COUNT(*) AS OrderCount FROM `Order` 
GROUP BY Delivery_method;

-- 8. Производители с количеством продуктов более 1
SELECT m.Name, COUNT(p.id_product) AS ProductCount FROM Maker m 
JOIN Product p ON m.id_maker = p.Maker_id_maker 
GROUP BY m.Name 
HAVING COUNT(p.id_product) > 1;

-- 9. Среднее количество товаров в заказе (округление вверх)
SELECT CEIL(AVG(Count)) AS AvgProductsPerOrder 
FROM Order_to_Product;

-- 10. Распределение оценок по продуктам
SELECT 
    p.Title AS Product,
    SUM(CASE WHEN f.Score = 5 THEN 1 ELSE 0 END) AS '5 звёзд',
    SUM(CASE WHEN f.Score = 4 THEN 1 ELSE 0 END) AS '4 звезды',
    SUM(CASE WHEN f.Score = 3 THEN 1 ELSE 0 END) AS '3 звезды',
    SUM(CASE WHEN f.Score = 2 THEN 1 ELSE 0 END) AS '2 звезды',
    SUM(CASE WHEN f.Score = 1 THEN 1 ELSE 0 END) AS '1 звезда',
    COUNT(*) AS TotalReviews,
    AVG(f.Score) AS AvgRating
FROM Product p
LEFT JOIN Feedback f ON p.id_product = f.Product_id_product
GROUP BY p.Title
ORDER BY AvgRating DESC;

-- 11. Покупатели с наибольшим количеством отзывов
SELECT b.Login, b.Firstname, b.Lastname, COUNT(f.id_feedback) AS FeedbackCount 
FROM Buyer b 
JOIN Feedback f ON b.Login = f.Buyer_Login 
GROUP BY b.Login, b.Firstname, b.Lastname 
ORDER BY FeedbackCount DESC 
LIMIT 3;

-- 12. Продукты с количеством заказов
SELECT p.Title, COUNT(otp.Order_Order_numder) AS OrderCount FROM Product p 
LEFT JOIN Order_to_Product otp ON p.id_product = otp.Product_id_product 
GROUP BY p.Title 
ORDER BY OrderCount DESC;

-- 13. Самые активные покупатели (по количеству отзывов)
SELECT 
    b.Login,
    CONCAT(b.Firstname, ' ', b.Lastname) AS Customer,
    COUNT(f.id_feedback) AS ReviewCount
FROM Buyer b
LEFT JOIN Feedback f ON b.Login = f.Buyer_Login
GROUP BY b.Login, Customer
HAVING COUNT(f.id_feedback) > 0
ORDER BY ReviewCount DESC
LIMIT 10;

-- 14. Категории с наибольшим количеством продуктов
SELECT 
    c.Title AS Category,
    COUNT(ptc.Product_id_product) AS ProductCount
FROM Category c
LEFT JOIN Product_to_Category ptc ON c.id_category = ptc.Category_id_category
GROUP BY c.Title
HAVING COUNT(ptc.Product_id_product) > 0
ORDER BY ProductCount DESC
LIMIT 10;

-- 15. Средняя цена продуктов по производителям (только для производителей с более чем 1 продуктом)
SELECT 
    m.Name AS Maker,
    COUNT(p.id_product) AS ProductCount,
    AVG(p.Price) AS AvgPrice,
    MIN(p.Price) AS MinPrice,
    MAX(p.Price) AS MaxPrice
FROM Maker m
JOIN Product p ON m.id_maker = p.Maker_id_maker
GROUP BY m.Name
HAVING COUNT(p.id_product) > 1
ORDER BY AvgPrice DESC;
