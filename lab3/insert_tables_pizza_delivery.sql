USE `Pizza delivery`;

-- Заполнение таблицы `client`
INSERT INTO client (id_client, Name, Phone)
VALUES
(1, 'Анастасия', '+79027845634');

-- Заполнение таблицы `courier`
INSERT INTO courier (id_courier, Name, Number_TS)
VALUES
(1, 'Сергей', 10452);

-- Заполнение таблицы `delivery`
INSERT INTO delivery (id_delivery, Delivery_method, Time, id_courier)
VALUES
(1, 'Курьер', '2025-03-15 10:00:00', 1);

-- Заполнение таблицы `feedback`
INSERT INTO feedback (id_feedback, Text_feedback, Raiting)
VALUES
(1, 'Быстро и вкусно!! Обязательно ещё закажу у них', 5);

-- Заполнение таблицы `ingredients`
INSERT INTO ingredients (id_ingridient, Name, Category)
VALUES
(1, 'Сыр', 'Начинка');

-- Заполнение таблицы `structure`
INSERT INTO structure (id_structure, quantity, id_ingridient)
VALUES
(1, 2, 1);

-- Заполнение таблицы `pizza`
INSERT INTO pizza (id_pizza, Name, Price, id_structure, id_ingridient)
VALUES
(1, 'Сырная', 990, 1, 1);

-- Заполнение таблицы `status`
INSERT INTO status (id_status, Description, Name)
VALUES
(1, 'Через 15 минут заказ будет у вас!', 'В пути');

-- Заполнение таблицы `payment`
INSERT INTO payment (id_payment, Payment_method, Cost)
VALUES
(1, 'Карта', 990);

-- Заполнение таблицы `order`
INSERT INTO `order` (id_order, Cost, Order_date, id_client, id_payment, id_delivery, id_status, id_feedback, id_pizza)
VALUES
(1, 990, '2025-03-15 9:20:23', 1, 1, 1, 1, 1, 1);