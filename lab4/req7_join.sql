-- 1. INNER JOIN продуктов с их категориями
SELECT p.Title AS Product, c.Title AS Category 
FROM Product p 
JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product 
JOIN Category c ON ptc.Category_id_category = c.id_category
ORDER BY Product ASC, Category ASC;

-- 2. LEFT JOIN покупателей с их избранными
SELECT b.Login, f.Count_products FROM Buyer b 
LEFT JOIN Favorites f ON b.Login = f.Buyer_Login;

-- 3. RIGHT JOIN скидок с продуктами
SELECT d.Title AS Discount, p.Title AS Product FROM Discount d 
RIGHT JOIN Product p ON d.id_discount = p.Discount_id_discount;

-- 4.Получить заказы с информацией о покупателе
SELECT o.Order_numder, CONCAT(b.Firstname, ' ', b.Lastname) AS Name FROM `Order` o 
JOIN Order_to_Product otp ON o.Order_numder = otp.Order_Order_numder 
JOIN Product p ON otp.Product_id_product = p.id_product 
JOIN Feedback f ON p.id_product = f.Product_id_product 
JOIN Buyer b ON f.Buyer_Login = b.Login
ORDER BY o.Order_numder ASC;

-- 5. Найти продукты без отзывов
SELECT p.Title 
FROM Product p 
LEFT JOIN Feedback f ON p.id_product = f.Product_id_product 
WHERE f.id_feedback IS NULL;

-- 6. Получить все возможные комбинации продуктов и категорий (CROSS JOIN)
SELECT p.Title AS Product, c.Title AS Category FROM Product p 
CROSS JOIN Category c;

-- 7. Получить заказы с платежами и возвратами
SELECT o.Order_numder, p.Status AS PaymentStatus, r.Status AS RefundStatus 
FROM `Order` o 
LEFT JOIN Payment p ON o.Order_numder = p.Order_Order_numder 
LEFT JOIN Refund r ON o.Order_numder = r.Order_Order_numder;

-- 8. Найти покупателей, которые оставили отзывы на продукты дороже 3000
SELECT DISTINCT b.Login, CONCAT(b.Firstname, ' ', b.Lastname) AS Name 
FROM Buyer b 
JOIN Feedback f ON b.Login = f.Buyer_Login 
JOIN Product p ON f.Product_id_product = p.id_product 
WHERE p.Price > 3000;

-- 9. Получить список продуктов с количеством отзывов
SELECT p.Title, COUNT(f.id_feedback) AS FeedbackCount 
FROM Product p 
LEFT JOIN Feedback f ON p.id_product = f.Product_id_product 
GROUP BY p.Title;

-- 10. Найти покупателей, которые заказывали конкретный продукт
SELECT DISTINCT b.Login, CONCAT(b.Firstname, ' ', b.Lastname) AS Name 
FROM Buyer b 
JOIN Feedback f ON b.Login = f.Buyer_Login 
JOIN Product p ON f.Product_id_product = p.id_product 
WHERE p.Title = 'Манчкин';

-- 11. Получить среднюю оценку по категориям
SELECT c.Title, AVG(f.Score) AS AvgScore 
FROM Category c 
JOIN Product_to_Category ptc ON c.id_category = ptc.Category_id_category 
JOIN Product p ON ptc.Product_id_product = p.id_product 
JOIN Feedback f ON p.id_product = f.Product_id_product 
GROUP BY c.Title;

-- 12. Найти продукты, которые есть в избранном у более чем одного покупателя
SELECT p.Title, COUNT(DISTINCT f.Buyer_Login) AS FavoriteCount 
FROM Product p 
JOIN Product_to_Favorites ptf ON p.id_product = ptf.Product_id_product 
JOIN Favorites f ON ptf.Favorites_id_favorites = f.id_favorites 
GROUP BY p.Title 
HAVING COUNT(DISTINCT f.Buyer_Login) > 1;

-- 13. Получить полную информацию о заказе
SELECT o.Order_numder, p.Title AS Product, otp.Count, 
       b.Firstname, b.Lastname, b.Patronymic, pay.Payment_method, pay.Status AS PaymentStatus
FROM `Order` o 
JOIN Order_to_Product otp ON o.Order_numder = otp.Order_Order_numder 
JOIN Product p ON otp.Product_id_product = p.id_product 
JOIN Feedback f ON p.id_product = f.Product_id_product 
JOIN Buyer b ON f.Buyer_Login = b.Login 
JOIN Payment pay ON o.Order_numder = pay.Order_Order_numder;

-- 14. Найти пересечение покупателей, которые и оставляли отзывы, и добавляли товары в избранное
SELECT DISTINCT b.Login, CONCAT(b.Firstname, ' ', b.Lastname) AS Name 
FROM Buyer b
JOIN Feedback f ON b.Login = f.Buyer_Login
JOIN Favorites fav ON b.Login = fav.Buyer_Login;

-- 15. Анализ возможных скидочных комбинаций
SELECT p.Title AS Product, d.Title AS Discount, 
       ROUND(p.Price * (100 - d.Discount_amount)/100) AS DiscountedPrice
FROM Product p
CROSS JOIN Discount d
WHERE d.Title != 'Нет скидки'
ORDER BY p.Title, d.Discount_amount DESC;