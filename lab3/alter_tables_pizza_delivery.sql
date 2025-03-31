USE `Pizza delivery`;

-- 1. Изменение столбца Name таблицы status (уменьшение количества символов)
ALTER table status MODIFY Name varchar(20);

-- 2. Добавление поля type в таблицу courier
ALTER table `courier` ADD type varchar(20) not null;

-- 3. Переименование поля Description таблицы status
ALTER table status RENAME column Description to Comment;

-- 4. Переименование таблицы ingredients
ALTER table ingredients RENAME to ingredient;

-- 5. Добавление ограничения уникальности полю Name в таблице pizza 
ALTER table pizza ADD constraint Name_uniq unique(Name);

-- 6. Удаление ограничения not null у поля Text_feedback в таблице feedback
ALTER table feedback MODIFY Text_feedback text;

-- 7 Удаление внешнего ключа у таблицы delivery
ALTER table delivery DROP constraint delivery_ibfk_1, DROP index id_courier;
-- 8 Удаление первичного ключа в таблице courier
ALTER table courier DROP column id_courier;

-- 9. Добавление первичного ключа в таблицу courier
ALTER table courier ADD primary key (Number_TS);

-- 10. Добавление столбца Number_TS в таблицу delivery
ALTER table delivery ADD Number_TS int;

-- 11. Удаление поля id_courier в таблице delivery
ALTER table delivery DROP column id_courier;

-- 12. Добавление внешнего ключа в таблицу delivery
ALTER table delivery ADD foreign key (Number_TS) references courier(Number_TS);