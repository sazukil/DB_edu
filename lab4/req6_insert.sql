-- 1. Создать таблицу дорогих продуктов:
CREATE TABLE ExpensiveProducts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ProductTitle VARCHAR(100),
    ProductPrice MEDIUMINT UNSIGNED
);

INSERT INTO ExpensiveProducts (ProductTitle, ProductPrice)
SELECT Title, Price FROM Product
WHERE Price > 3000;

-- 2. Создать таблицу активных покупателей:
CREATE TABLE ActiveBuyers (
    Login VARCHAR(60) PRIMARY KEY,
    FullName VARCHAR(180),
    RegistrationDate DATE
);

INSERT INTO ActiveBuyers (Login, FullName, RegistrationDate)
SELECT Login, CONCAT(Lastname, ' ', Firstname), Registration_date FROM Buyer 
WHERE Login IN (SELECT DISTINCT Buyer_Login FROM Feedback);
