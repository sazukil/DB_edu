-- 1. Продукты с ценой выше средней по категории
SELECT p.Title, p.Price, c.Title AS Category 
FROM Product p 
JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product 
JOIN Category c ON ptc.Category_id_category = c.id_category 
WHERE p.Price > (
    SELECT AVG(p2.Price) 
    FROM Product p2 
    JOIN Product_to_Category ptc2 ON p2.id_product = ptc2.Product_id_product 
    WHERE ptc2.Category_id_category = c.id_category
);

-- 2. Покупатели, которые купили все продукты определенного производителя
SELECT b.Login, CONCAT(b.Firstname, ' ', b.Lastname) AS Name 
FROM Buyer b
WHERE NOT EXISTS (
    SELECT p.id_product
    FROM Product p
    WHERE p.Maker_id_maker = 3
    AND NOT EXISTS (
        SELECT 1
        FROM Feedback f
        JOIN Order_to_Product otp ON f.Product_id_product = otp.Product_id_product
        WHERE f.Buyer_Login = b.Login
        AND otp.Product_id_product = p.id_product
    )
);

-- 3. Продукты, которые ни разу не заказывали
SELECT p.Title 
FROM Product p 
WHERE p.id_product NOT IN (
    SELECT DISTINCT Product_id_product 
    FROM Order_to_Product
);

-- 4. Покупатели, которые оценили все свои покупки на 5
SELECT b.Login, CONCAT(b.Firstname, ' ', b.Lastname) AS Name 
FROM Buyer b 
WHERE NOT EXISTS (
    SELECT 1 
    FROM Feedback f 
    WHERE f.Buyer_Login = b.Login 
    AND f.Score < 5
);
