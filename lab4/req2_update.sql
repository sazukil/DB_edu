-- 1. Обновить цену продукта
UPDATE Product 
SET Price = 3790 
WHERE id_product = 9;

-- 2. Изменить статус заказа
UPDATE `Order` 
SET Status = 'Доставлен' 
WHERE Order_numder = 202410203;

-- 3. Обновить дату окончания скидки
UPDATE Discount 
SET End_date = '2025-07-13' 
WHERE id_discount = 10;

-- 4. Изменить контактный email производителя
UPDATE Maker 
SET Email = 'support@hasbro.com' 
WHERE id_maker = 1;