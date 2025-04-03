-- 1. Рейтинг продуктов с использованием CTE
WITH ProductRatings AS (
    SELECT p.id_product, p.Title, AVG(f.Score) AS AvgRating 
    FROM Product p 
    LEFT JOIN Feedback f ON p.id_product = f.Product_id_product 
    GROUP BY p.id_product, p.Title
)
SELECT Title, AvgRating 
FROM ProductRatings 
ORDER BY AvgRating DESC;

-- 2. Ежемесячная статистика заказов
WITH MonthlyOrders AS (
    SELECT 
        YEAR(Order_date) AS Year,
        MONTH(Order_date) AS Month,
        COUNT(*) AS OrderCount,
        SUM(pay.Cost) AS TotalRevenue
    FROM `Order` o 
    JOIN Payment pay ON o.Order_numder = pay.Order_Order_numder
    GROUP BY YEAR(Order_date), MONTH(Order_date)
)
SELECT 
    CONCAT(Year, '-', LPAD(Month, 2, '0')) AS YearMonth,
    OrderCount,
    TotalRevenue
FROM MonthlyOrders
ORDER BY Year, Month;
