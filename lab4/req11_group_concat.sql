-- 1. Список категорий для каждого продукта в одной строке
SELECT p.Title, GROUP_CONCAT(c.Title SEPARATOR ', ') AS Categories 
FROM Product p 
JOIN Product_to_Category ptc ON p.id_product = ptc.Product_id_product 
JOIN Category c ON ptc.Category_id_category = c.id_category 
GROUP BY p.Title;

-- 2. Список покупателей, которые оставили отзывы на продукт
SELECT p.Title, GROUP_CONCAT(CONCAT(b.Firstname, ' ', b.Lastname)) AS Reviewers
FROM Product p 
JOIN Feedback f ON p.id_product = f.Product_id_product 
JOIN Buyer b ON f.Buyer_Login = b.Login 
GROUP BY p.Title;

-- 3. Количество дней действия каждой скидки
SELECT Title, DATEDIFF(End_date, Start_date) AS DaysActive 
FROM Discount
WHERE Title != 'Нет скидки';
