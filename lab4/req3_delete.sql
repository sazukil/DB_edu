-- 1. Удалить категории с пустым описанием
DELETE FROM Category
WHERE Description IS NULL OR Description = '';

-- 2. Удалить устаревшие скидки
DELETE FROM Discount 
WHERE End_date < CURDATE();

-- 3. Удалить пустые избранные списки
DELETE FROM Favorites 
WHERE Count_products = 0;