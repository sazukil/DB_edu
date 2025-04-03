-- 1. Топ-3 категории по выручке
SELECT 
    c.Title AS Category, 
    SUM(otp.Count * p.Price) AS TotalRevenue 
FROM Category c 
JOIN Product_to_Category ptc ON c.id_category = ptc.Category_id_category 
JOIN Product p ON ptc.Product_id_product = p.id_product 
JOIN Order_to_Product otp ON p.id_product = otp.Product_id_product 
JOIN `Order` o ON otp.Order_Order_numder = o.Order_numder 
JOIN Payment pay ON o.Order_numder = pay.Order_Order_numder 
WHERE pay.Status = 'Оплачено'
GROUP BY c.Title 
ORDER BY TotalRevenue DESC 
LIMIT 3;

-- 2. Полная информация о покупателях, которые потратили больше всего денег, с их активностью
SELECT 
    b.Login,
    CONCAT(b.Lastname, ' ', b.Firstname, 
           IFNULL(CONCAT(' ', b.Patronymic), '')) AS FullName,
    b.Email,
    b.Phone,
    b.Birthday,
    TIMESTAMPDIFF(YEAR, b.Birthday, CURDATE()) AS Age,
    b.Registration_date,
    DATEDIFF(CURDATE(), b.Registration_date) AS DaysRegistered,
    
    -- Статистика по заказам
    (SELECT COUNT(*) FROM `Order` o 
     JOIN Order_to_Product otp ON o.Order_numder = otp.Order_Order_numder
     JOIN Feedback f ON otp.Product_id_product = f.Product_id_product
     WHERE f.Buyer_Login = b.Login) AS TotalOrders,
    
    (SELECT IFNULL(SUM(pay.Cost), 0) FROM Payment pay
     JOIN `Order` o ON pay.Order_Order_numder = o.Order_numder
     JOIN Order_to_Product otp ON o.Order_numder = otp.Order_Order_numder
     JOIN Feedback f ON otp.Product_id_product = f.Product_id_product
     WHERE f.Buyer_Login = b.Login) AS TotalSpent,
    
    -- Статистика по возвратам
    (SELECT COUNT(*) FROM Refund r
     JOIN `Order` o ON r.Order_Order_numder = o.Order_numder
     JOIN Order_to_Product otp ON o.Order_numder = otp.Order_Order_numder
     JOIN Feedback f ON otp.Product_id_product = f.Product_id_product
     WHERE f.Buyer_Login = b.Login) AS TotalRefunds
    
FROM Buyer b
ORDER BY TotalSpent DESC
LIMIT 5;

-- 3. Продукты с их рейтингом и количеством заказов
SELECT 
    p.Title,
    m.Name AS Maker,
    AVG(f.Score) AS AvgRating,
    COUNT(DISTINCT f.id_feedback) AS FeedbackCount,
    COUNT(DISTINCT otp.Order_Order_numder) AS OrderCount,
    SUM(otp.Count) AS TotalOrdered
FROM Product p 
JOIN Maker m ON p.Maker_id_maker = m.id_maker 
LEFT JOIN Feedback f ON p.id_product = f.Product_id_product 
LEFT JOIN Order_to_Product otp ON p.id_product = otp.Product_id_product 
LEFT JOIN `Order` o ON otp.Order_Order_numder = o.Order_numder 
LEFT JOIN Payment pay ON o.Order_numder = pay.Order_Order_numder 
WHERE pay.Status = 'Оплачено' OR pay.Status IS NULL
GROUP BY p.Title, m.Name
ORDER BY AvgRating DESC, OrderCount DESC;

-- 4. Анализ возвратов
SELECT 
    p.Title AS Product,
    COUNT(r.id_refund) AS RefundCount,
    GROUP_CONCAT(DISTINCT r.Reason SEPARATOR '; ') AS Reasons,
    SUM(pay.Cost) AS RefundedAmount,
    COUNT(DISTINCT o.Order_numder) AS TotalOrders,
    ROUND(COUNT(r.id_refund) * 100.0 / COUNT(DISTINCT o.Order_numder), 2) AS RefundRate
FROM Product p 
JOIN Order_to_Product otp ON p.id_product = otp.Product_id_product 
JOIN `Order` o ON otp.Order_Order_numder = o.Order_numder 
LEFT JOIN Refund r ON o.Order_numder = r.Order_Order_numder 
LEFT JOIN Payment pay ON o.Order_numder = pay.Order_Order_numder 
GROUP BY p.Title
HAVING RefundCount > 0
ORDER BY RefundRate DESC;

-- 5. Динамика продаж по месяцам с сравнением с предыдущим месяцем
WITH MonthlySales AS (
    SELECT 
        YEAR(o.Order_date) AS Year,
        MONTH(o.Order_date) AS Month,
        SUM(pay.Cost) AS TotalRevenue,
        COUNT(DISTINCT o.Order_numder) AS OrderCount,
        SUM(otp.Count) AS ProductCount
    FROM `Order` o 
    JOIN Payment pay ON o.Order_numder = pay.Order_Order_numder 
    JOIN Order_to_Product otp ON o.Order_numder = otp.Order_Order_numder 
    WHERE pay.Status = 'Оплачено'
    GROUP BY YEAR(o.Order_date), MONTH(o.Order_date)
)
SELECT 
    m1.Year,
    m1.Month,
    m1.TotalRevenue,
    m1.OrderCount,
    m1.ProductCount,
    m2.TotalRevenue AS PrevMonthRevenue,
    ROUND((m1.TotalRevenue - m2.TotalRevenue) * 100.0 / m2.TotalRevenue, 2) AS RevenueGrowthPercent
FROM MonthlySales m1 
LEFT JOIN MonthlySales m2 ON 
    (m1.Year = m2.Year AND m1.Month = m2.Month + 1) OR
    (m1.Year = m2.Year + 1 AND m1.Month = 1 AND m2.Month = 12)
ORDER BY m1.Year, m1.Month;

-- 6. Анализ воронки продаж: от избранного к покупке
WITH FavoritesStats AS (
    SELECT 
        p.id_product,
        p.Title,
        COUNT(ptf.Favorites_id_favorites) AS AddedToFavorites,
        COUNT(DISTINCT CASE WHEN o.Order_numder IS NOT NULL THEN ptf.Favorites_id_favorites END) AS ConvertedToOrder,
        ROUND(COUNT(DISTINCT CASE WHEN o.Order_numder IS NOT NULL THEN ptf.Favorites_id_favorites END) * 100.0 / 
             NULLIF(COUNT(ptf.Favorites_id_favorites), 0), 2) AS ConversionRate
    FROM Product p
    LEFT JOIN Product_to_Favorites ptf ON p.id_product = ptf.Product_id_product
    LEFT JOIN Favorites fav ON ptf.Favorites_id_favorites = fav.id_favorites
    LEFT JOIN `Order` o ON EXISTS (
        SELECT 1 FROM Order_to_Product otp 
        WHERE otp.Product_id_product = p.id_product
        AND otp.Order_Order_numder IN (
            SELECT o2.Order_numder FROM `Order` o2
            JOIN Feedback f ON EXISTS (
                SELECT 1 FROM Order_to_Product otp2
                WHERE otp2.Order_Order_numder = o2.Order_numder
                AND otp2.Product_id_product = f.Product_id_product
            )
            WHERE f.Buyer_Login = fav.Buyer_Login
        )
    )
    GROUP BY p.id_product, p.Title
)
SELECT 
    Title,
    AddedToFavorites,
    ConvertedToOrder,
    ConversionRate,
    CASE
        WHEN AddedToFavorites = 0 THEN 'Нет данных'
        WHEN ConversionRate > 30 THEN 'Высокая конверсия'
        WHEN ConversionRate > 15 THEN 'Средняя конверсия'
        ELSE 'Низкая конверсия'
    END AS ConversionLevel
FROM FavoritesStats
ORDER BY ConversionRate DESC
LIMIT 10;