-- 1. Объединение покупателей и производителей с email
SELECT 'Buyer' AS Type, CONCAT(Firstname, ' ', Lastname) AS Name, Email 
FROM Buyer
UNION
SELECT 'Maker' AS Type, Name, Email 
FROM Maker;

-- 2. Производители, чьи продукты никогда не возвращали (аналог EXCEPT)
SELECT m.Name
FROM Maker m
WHERE m.id_maker NOT IN (
    SELECT DISTINCT p.Maker_id_maker
    FROM Product p
    JOIN Order_to_Product otp ON p.id_product = otp.Product_id_product
    JOIN Refund r ON otp.Order_Order_numder = r.Order_Order_numder
);

-- 3. Покупатели, которые и оставляли отзывы, и добавляли товары в избранное (аналог INTERSECT)
SELECT DISTINCT b.Login, CONCAT(b.Firstname, ' ', b.Lastname) AS Name 
FROM Buyer b
JOIN Feedback f ON b.Login = f.Buyer_Login
JOIN Favorites fav ON b.Login = fav.Buyer_Login;

-- 4. Все действия покупателей (отзывы + добавление в избранное)
SELECT b.Login, f.Date_of_feedback AS ActivityDate, 'Feedback' AS ActivityType
FROM Buyer b
JOIN Feedback f ON b.Login = f.Buyer_Login
UNION ALL
SELECT b.Login, ptf.Date_added AS ActivityDate, 'Favorite' AS ActivityType
FROM Buyer b
JOIN Favorites fav ON b.Login = fav.Buyer_Login
JOIN Product_to_Favorites ptf ON fav.id_favorites = ptf.Favorites_id_favorites
ORDER BY ActivityDate DESC;

-- 5. Все активные покупатели, кроме тех, кто возвращал товары (UNION + EXCEPT)
SELECT DISTINCT active.Login
FROM (
    SELECT DISTINCT b.Login FROM Buyer b
    JOIN Feedback f ON b.Login = f.Buyer_Login
    
    UNION
    
    SELECT DISTINCT b.Login FROM Buyer b
    JOIN Favorites fav ON b.Login = fav.Buyer_Login
) active
WHERE active.Login NOT IN (
    SELECT DISTINCT b.Login FROM Buyer b
    JOIN Refund r ON EXISTS (
        SELECT 1 FROM Feedback f
        JOIN Order_to_Product otp ON f.Product_id_product = otp.Product_id_product
        WHERE f.Buyer_Login = b.Login
        AND otp.Order_Order_numder = r.Order_Order_numder
    )
);