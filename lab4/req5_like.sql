-- 1. Найти производителей с российскими номерами телефонов
SELECT * FROM Maker 
WHERE Phone LIKE '+7%' OR Phone LIKE '8%';

-- 2. Получить производителей с названием из 6 букв
SELECT * FROM Maker 
WHERE Name LIKE '______';

-- 3. Найти отзывы, содержащие слова "классика" или "интересная"
SELECT p.Title, f.Text, f.Score FROM Feedback f
JOIN Product p on p.id_product = f.Product_id_product
WHERE f.Text LIKE '%классика%' OR f.Text LIKE '%интересная%';

-- 4. Выбрать продукты с названием, заканчивающимся на "н"
SELECT * FROM Product 
WHERE Title LIKE '%н';

-- 5. Найти адреса доставки на определенной улице
SELECT Order_numder, Adress FROM `Order` 
WHERE Adress LIKE '%Ленин%';

-- 6. Форматирование цен со скидкой
SELECT 
    p.Title,
    p.Price AS OriginalPrice,
    d.Discount_amount AS DiscountPercent,
    CONCAT(
        p.Price * (100 - d.Discount_amount) / 100, 
        ' руб. (экономия ', 
        p.Price * d.Discount_amount / 100, 
        ' руб.)'
    ) AS DiscountedPrice
FROM Product p
JOIN Discount d ON p.Discount_id_discount = d.id_discount
WHERE d.Discount_amount > 0;