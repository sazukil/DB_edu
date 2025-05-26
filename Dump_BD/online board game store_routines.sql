-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: online board game store
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `productcatalog`
--

DROP TABLE IF EXISTS `productcatalog`;
/*!50001 DROP VIEW IF EXISTS `productcatalog`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `productcatalog` AS SELECT 
 1 AS `ID`,
 1 AS `ProductName`,
 1 AS `Price`,
 1 AS `AgeLimit`,
 1 AS `Manufacturer`,
 1 AS `Categories`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `activeusersstats`
--

DROP TABLE IF EXISTS `activeusersstats`;
/*!50001 DROP VIEW IF EXISTS `activeusersstats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `activeusersstats` AS SELECT 
 1 AS `Login`,
 1 AS `FullName`,
 1 AS `OrderCount`,
 1 AS `TotalSpent`,
 1 AS `FeedbackCount`,
 1 AS `FavoritesCount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `popularproducts`
--

DROP TABLE IF EXISTS `popularproducts`;
/*!50001 DROP VIEW IF EXISTS `popularproducts`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `popularproducts` AS SELECT 
 1 AS `ProductID`,
 1 AS `ProductName`,
 1 AS `Price`,
 1 AS `AvgRating`,
 1 AS `ReviewCount`,
 1 AS `OrderCount`,
 1 AS `FavoriteCount`,
 1 AS `PopularityScore`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `activeorders`
--

DROP TABLE IF EXISTS `activeorders`;
/*!50001 DROP VIEW IF EXISTS `activeorders`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `activeorders` AS SELECT 
 1 AS `OrderID`,
 1 AS `OrderDate`,
 1 AS `Buyer`,
 1 AS `DeliveryMethod`,
 1 AS `OrderStatus`,
 1 AS `ProductCount`,
 1 AS `TotalAmount`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `productcatalog`
--

/*!50001 DROP VIEW IF EXISTS `productcatalog`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `productcatalog` AS select `p`.`id_product` AS `ID`,`p`.`Title` AS `ProductName`,`p`.`Price` AS `Price`,`p`.`Age_limit` AS `AgeLimit`,`m`.`Name` AS `Manufacturer`,group_concat(distinct `c`.`Title` separator ', ') AS `Categories` from (((`product` `p` join `maker` `m` on((`p`.`Maker_id_maker` = `m`.`id_maker`))) left join `product_to_category` `ptc` on((`p`.`id_product` = `ptc`.`Product_id_product`))) left join `category` `c` on((`ptc`.`Category_id_category` = `c`.`id_category`))) group by `p`.`id_product`,`p`.`Title`,`p`.`Price`,`p`.`Age_limit`,`m`.`Name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `activeusersstats`
--

/*!50001 DROP VIEW IF EXISTS `activeusersstats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `activeusersstats` AS select `b`.`Login` AS `Login`,concat(`b`.`Firstname`,' ',`b`.`Lastname`) AS `FullName`,count(distinct `o`.`Order_numder`) AS `OrderCount`,sum(`pay`.`Cost`) AS `TotalSpent`,count(distinct `f`.`id_feedback`) AS `FeedbackCount`,count(distinct `fav`.`id_favorites`) AS `FavoritesCount` from ((((`buyer` `b` left join `order` `o` on((`b`.`Login` = `o`.`Buyer_Login`))) left join `payment` `pay` on(((`o`.`Order_numder` = `pay`.`Order_Order_numder`) and (`pay`.`Status` = 'Оплачено')))) left join `feedback` `f` on((`b`.`Login` = `f`.`Buyer_Login`))) left join `favorites` `fav` on((`b`.`Login` = `fav`.`Buyer_Login`))) group by `b`.`Login`,`FullName` having ((`OrderCount` > 0) or (`FeedbackCount` > 0) or (`FavoritesCount` > 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `popularproducts`
--

/*!50001 DROP VIEW IF EXISTS `popularproducts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `popularproducts` AS select `p`.`id_product` AS `ProductID`,`p`.`Title` AS `ProductName`,`p`.`Price` AS `Price`,avg(`f`.`Score`) AS `AvgRating`,count(distinct `f`.`id_feedback`) AS `ReviewCount`,count(distinct `otp`.`Order_Order_numder`) AS `OrderCount`,count(distinct `ptf`.`Favorites_id_favorites`) AS `FavoriteCount`,(((count(distinct `otp`.`Order_Order_numder`) * 2) + count(distinct `ptf`.`Favorites_id_favorites`)) + count(distinct `f`.`id_feedback`)) AS `PopularityScore` from (((`product` `p` left join `feedback` `f` on((`p`.`id_product` = `f`.`Product_id_product`))) left join `order_to_product` `otp` on((`p`.`id_product` = `otp`.`Product_id_product`))) left join `product_to_favorites` `ptf` on((`p`.`id_product` = `ptf`.`Product_id_product`))) group by `p`.`id_product`,`p`.`Title`,`p`.`Price` having ((`ReviewCount` > 0) or (`OrderCount` > 0) or (`FavoriteCount` > 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `activeorders`
--

/*!50001 DROP VIEW IF EXISTS `activeorders`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `activeorders` AS select `o`.`Order_numder` AS `OrderID`,`o`.`Order_date` AS `OrderDate`,concat(`b`.`Lastname`,' ',`b`.`Firstname`) AS `Buyer`,`o`.`Delivery_method` AS `DeliveryMethod`,`o`.`Status` AS `OrderStatus`,count(`otp`.`Product_id_product`) AS `ProductCount`,sum((`p`.`Price` * `otp`.`Count`)) AS `TotalAmount` from (((`order` `o` join `buyer` `b` on((`o`.`Buyer_Login` = `b`.`Login`))) join `order_to_product` `otp` on((`o`.`Order_numder` = `otp`.`Order_Order_numder`))) join `product` `p` on((`otp`.`Product_id_product` = `p`.`id_product`))) where (`o`.`Status` not in ('Доставлен','Отменен')) group by `o`.`Order_numder`,`o`.`Order_date`,`b`.`Lastname`,`b`.`Firstname`,`o`.`Delivery_method`,`o`.`Status` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Dumping routines for database 'online board game store'
--
/*!50003 DROP FUNCTION IF EXISTS `CalculateCustomerDiscount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `CalculateCustomerDiscount`(p_buyer_login VARCHAR(60)) RETURNS decimal(5,2)
    DETERMINISTIC
BEGIN
    DECLARE total_orders INT;
    DECLARE total_spent DECIMAL(10,2);
    DECLARE feedback_count INT;
    DECLARE discount DECIMAL(5,2) DEFAULT 0;
    
    -- Получаем статистику покупателя
    SELECT 
        COUNT(DISTINCT o.Order_number),
        IFNULL(SUM(pay.Cost), 0),
        COUNT(f.id_feedback)
    INTO 
        total_orders,
        total_spent,
        feedback_count
    FROM Buyer b
    LEFT JOIN `Order` o ON b.Login = o.Buyer_Login
    LEFT JOIN Payment pay ON o.Order_number = pay.Order_Order_number AND pay.Status = 'Оплачено'
    LEFT JOIN Feedback f ON b.Login = f.Buyer_Login
    WHERE b.Login = p_buyer_login;
    
    -- Рассчитываем скидку по правилам
    IF total_spent > 10000 THEN
        SET discount = 15.00;
    ELSEIF total_spent > 5000 THEN
        SET discount = 10.00;
    ELSEIF total_orders > 3 THEN
        SET discount = 5.00;
    END IF;
    
    -- Дополнительная скидка за отзывы
    IF feedback_count >= 5 THEN
        SET discount = discount + 2.00;
    ELSEIF feedback_count >= 3 THEN
        SET discount = discount + 1.00;
    END IF;
    
    -- Максимальная скидка 20%
    IF discount > 20 THEN
        SET discount = 20.00;
    END IF;
    
    RETURN discount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `CalculateUserDiscount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `CalculateUserDiscount`(user_login VARCHAR(60)) RETURNS int
    DETERMINISTIC
BEGIN
    DECLARE order_count INT;
    DECLARE total_spent DECIMAL(10,2);
    DECLARE discount INT DEFAULT 0;
    
    -- Получаем статистику пользователя
    SELECT COUNT(*), SUM(pay.Cost) INTO order_count, total_spent
    FROM `Order` o
    JOIN Payment pay ON o.Order_number = pay.Order_Order_number
    WHERE o.Buyer_Login = user_login AND pay.Status = 'Оплачено';
    
    -- Определяем скидку на основе активности
    IF total_spent > 10000 THEN
        SET discount = 15;
    ELSEIF total_spent > 5000 THEN
        SET discount = 10;
    ELSEIF order_count > 3 THEN
        SET discount = 5;
    END IF;
    
    RETURN discount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `CheckAgeLimit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `CheckAgeLimit`(
    p_product_id INT,
    p_buyer_login VARCHAR(60)
) RETURNS varchar(50) CHARSET utf8mb3
    READS SQL DATA
BEGIN
    DECLARE v_buyer_age INT;
    DECLARE v_age_limit INT;
    DECLARE v_result VARCHAR(50);
    
    -- Получаем возраст покупателя
    SELECT TIMESTAMPDIFF(YEAR, Birthday, CURDATE())
    INTO v_buyer_age
    FROM Buyer
    WHERE Login = p_buyer_login;
    
    -- Получаем возрастное ограничение продукта
    SELECT Age_limit
    INTO v_age_limit
    FROM Product
    WHERE id_product = p_product_id;
    
    -- Проверяем данные
    IF v_buyer_age IS NULL THEN
        SET v_result = 'Покупатель не найден';
    ELSEIF v_age_limit IS NULL THEN
        SET v_result = 'Продукт не найден';
    ELSEIF v_buyer_age >= v_age_limit THEN
        SET v_result = 'Доступ разрешен';
    ELSE
        SET v_result = CONCAT('Доступ запрещен. Возрастное ограничение: ', v_age_limit, '+');
    END IF;
    
    RETURN v_result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetDiscountedPrice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetDiscountedPrice`(
    p_product_id INT
) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE v_price MEDIUMINT;
    DECLARE v_discount_amount DECIMAL(5,2);
    DECLARE v_discounted_price DECIMAL(10,2);
    
    -- Получаем цену и размер скидки
    SELECT p.Price, IFNULL(d.Discount_amount, 0)
    INTO v_price, v_discount_amount
    FROM Product p
    LEFT JOIN Discount d ON p.Discount_id_discount = d.id_discount
    WHERE p.id_product = p_product_id;
    
    -- Рассчитываем цену со скидкой
    IF v_price IS NULL THEN
        RETURN NULL;
    ELSE
        SET v_discounted_price = v_price * (1 - v_discount_amount / 100);
        RETURN ROUND(v_discounted_price, 2);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetProductRating` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetProductRating`(
    p_product_id INT
) RETURNS decimal(3,2)
    READS SQL DATA
BEGIN
    DECLARE v_avg_rating DECIMAL(3,2);
    DECLARE v_review_count INT;
    
    -- Получаем среднюю оценку и количество отзывов
    SELECT AVG(Score), COUNT(*)
    INTO v_avg_rating, v_review_count
    FROM Feedback
    WHERE Product_id_product = p_product_id;
    
    -- Обрабатываем случай, когда отзывов нет
    IF v_review_count = 0 THEN
        RETURN NULL;
    ELSE
        RETURN ROUND(v_avg_rating, 2);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateProductPrice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateProductPrice`(
    IN p_product_title VARCHAR(100),
    IN p_new_price MEDIUMINT,
    OUT p_status VARCHAR(100)
)
BEGIN
    DECLARE current_price MEDIUMINT;
    DECLARE price_change_percent DECIMAL(5,2);
    
    -- Получаем текущую цену продукта
    SELECT Price INTO current_price FROM Product WHERE Title = p_product_title;
    
    -- Проверяем существует ли продукт
    IF current_price IS NULL THEN
        SET p_status = 'Ошибка: Продукт не найден';
    ELSE
        -- Рассчитываем процент изменения цены
        SET price_change_percent = ABS((p_new_price - current_price) / current_price) * 100;
        
        -- Проверяем допустимость изменения цены (не более 30%)
        IF price_change_percent > 30 THEN
            SET p_status = CONCAT('Ошибка: Изменение цены на ', price_change_percent, '% превышает допустимые 30%');
        ELSE
            -- Обновляем цену
            UPDATE Product SET Price = p_new_price WHERE Title = p_product_title;
            SET p_status = CONCAT('Цена успешно обновлена с ', current_price, ' до ', p_new_price);
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-26 14:09:44
