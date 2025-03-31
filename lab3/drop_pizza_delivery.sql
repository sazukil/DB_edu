USE `Pizza delivery`;

-- Отключение проверки внешних ключей
SET FOREIGN_KEY_CHECKS = 0;

-- Удаление всех таблиц
DROP table client;
DROP table courier;
DROP table delivery;
DROP table feedback;
DROP table ingredient;
DROP table `order`;
DROP table payment;
DROP table pizza;
DROP table status;
DROP table structure;

-- Удаление БД
DROP database `Pizza delivery`;

-- Включение проверки внешних ключей
SET FOREIGN_KEY_CHECKS = 1;