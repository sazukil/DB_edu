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
-- Table structure for table `discount`
--

DROP TABLE IF EXISTS `discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount` (
  `id_discount` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(100) NOT NULL,
  `Discount_amount` tinyint unsigned NOT NULL,
  `Start_date` date NOT NULL,
  `End_date` date NOT NULL,
  PRIMARY KEY (`id_discount`),
  UNIQUE KEY `Title_UNIQUE` (`Title`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount`
--

LOCK TABLES `discount` WRITE;
/*!40000 ALTER TABLE `discount` DISABLE KEYS */;
INSERT INTO `discount` VALUES (1,'Нет скидки',0,'0001-01-01','9999-12-31'),(2,'Новогодняя распродажа 2023',20,'2023-12-20','2023-12-31'),(3,'Черная пятница 11.23',30,'2023-11-24','2023-11-26'),(4,'Весенние скидки 24',15,'2024-03-01','2024-03-15'),(5,'Летний фестиваль 42',10,'2024-06-01','2024-06-30'),(6,'Скидка на день рождения магазина',25,'2025-09-10','2025-09-12'),(7,'Осенние скидки 25',10,'2025-10-01','2025-10-15'),(8,'Скидка на стратегии',15,'2025-04-01','2025-04-07'),(9,'Скидка на детективные игры',10,'2025-05-01','2025-05-07'),(10,'Скидка на семейные игры 07.25',20,'2025-07-01','2025-07-07'),(11,'Скидка на семейные игры',20,'2023-07-11','2023-07-16'),(12,'Скидка на экономические игры',15,'2025-11-11','2025-11-19'),(13,'Хэллоуин 2024',15,'2024-09-28','2024-10-02'),(14,'Мегараспродажа',50,'2025-03-12','2025-03-14'),(15,'Скидка на экономические игры 2026',25,'2026-12-13','2026-12-23'),(16,'Хэллоуин 2025',10,'2025-10-12','2025-10-15'),(17,'День игр 2024',15,'2024-01-06','2024-01-10'),(18,'День защиты детей 2025',15,'2025-07-17','2025-07-22'),(19,'Скидка на стратегии игры',25,'2025-02-04','2025-02-07'),(20,'Геймерский фестиваль 2026',10,'2026-08-11','2025-08-15'),(21,'Скидка на фэнтези игры',20,'2023-05-07','2023-05-19'),(22,'Суперскидка',60,'2024-07-06','2024-07-08'),(23,'Мегараааспроооодажа',30,'2024-12-09','2024-12-11'),(24,'Геймерский фестиваль 2025',10,'2025-02-18','2025-02-21'),(25,'Акция выходного дня',30,'2025-09-17','2025-09-19'),(26,'Хэллоуин 2023',20,'2023-05-04','2023-05-05'),(27,'Рождественские скидки 2024',15,'2024-07-02','2024-07-07'),(28,'Осенние скидки 2024',20,'2024-11-07','2024-11-22'),(29,'Черная пятница 2024',35,'2024-11-26','2024-11-28'),(30,'Скидка на научная фантастика игры',25,'2024-04-08','2024-04-16'),(31,'Скидка на экономические игры 11.24',15,'2024-11-01','2024-11-12'),(32,'Осенние скидки 2026',10,'2026-10-03','2026-10-24'),(33,'Летние скидки 2026',15,'2026-08-10','2026-08-31'),(34,'День святого Валентина 2024',10,'2024-11-20','2024-11-25'),(35,'Скидка на карточные игры',20,'2026-03-08','2026-03-12'),(36,'День святого Валентина 2026',15,'2026-06-16','2026-06-17'),(37,'День защиты детей 26',15,'2026-01-03','2025-01-07'),(38,'Зимние скидки 02.02',15,'2026-02-02','2026-02-22'),(39,'Скидка на детективы игры',10,'2023-07-01','2023-07-06'),(40,'День рождения 2026',10,'2026-10-16','2026-10-21'),(41,'Скидка на головоломки игры',15,'2025-10-02','2025-10-16'),(42,'Закрытие сезона 23',40,'2023-06-16','2023-06-18'),(43,'Гигантские скидки',50,'2023-10-05','2023-10-06'),(44,'Осенние скидки',5,'2026-11-04','2026-11-21'),(45,'Скидка на экономические игры 24',20,'2024-06-15','2024-06-29'),(46,'Киберпонедельник 2024',20,'2024-11-29','2024-12-04'),(47,'Осенние скидки 09.26',15,'2026-09-02','2026-09-22'),(48,'Зимние скидки 2026',15,'2026-02-01','2026-02-27'),(49,'Закрытие сезона',40,'2026-12-01','2026-12-04'),(50,'Геймерский фестиваль 2023',20,'2023-12-11','2023-12-14'),(51,'Зимние скидки 02.03',10,'2026-02-03','2026-02-28'),(52,'Акция дней отдыха',30,'2023-02-05','2023-02-08'),(53,'Осенние скидки 23',5,'2023-11-05','2023-11-29'),(54,'Скидка на семейные игры 23',25,'2023-04-13','2023-04-24'),(55,'День святого Валентина 2025',20,'2025-01-12','2025-01-17'),(56,'Скидка на детективы игры 10.02',20,'2026-10-02','2026-10-14'),(57,'Гигантские скидки 2025',30,'2025-05-07','2025-05-10'),(58,'Скидка на детективы игры 23',25,'2023-12-03','2023-12-07'),(59,'Скидка на стратегии 2025',25,'2025-07-01','2025-07-15'),(60,'Осенние скидки 2023',5,'2023-10-02','2023-10-11'),(61,'Осенние скидки 24',10,'2024-09-01','2024-09-13'),(62,'Геймерский фестиваль 26',10,'2026-06-24','2026-06-25'),(63,'Скидка на карты',25,'2026-07-02','2026-07-13'),(64,'Летние скидки 2024',5,'2024-07-10','2024-07-31'),(65,'Летние скидки 2023',20,'2023-07-06','2023-07-18'),(66,'Скидка на научную фантастику',10,'2026-01-12','2026-01-24'),(67,'Весенние скидки 2023',20,'2023-05-01','2023-05-10'),(68,'Зимние скидки 2025',10,'2025-01-05','2025-01-22'),(69,'Летние скидки 08.23',5,'2023-08-02','2023-08-11'),(70,'Геймерский фестиваль 2.0.2.6',10,'2026-02-23','2026-02-25'),(71,'Скидка на карточные игры 2025',20,'2025-12-15','2025-12-26'),(72,'Скидка на науку',25,'2025-12-13','2025-12-19'),(73,'Закрытие сезона 24',30,'2024-03-13','2024-03-14'),(74,'Черная пятница!!!',35,'2024-11-26','2024-12-01'),(75,'Весенние скидки 2024',20,'2024-04-09','2024-04-27'),(76,'День игр 2026',20,'2026-08-09','2026-08-10'),(77,'Снегопад скидок',15,'2025-12-07','2025-12-19'),(78,'Хэллоуин 24',10,'2024-05-08','2024-05-12'),(79,'Скидка на детективы 26',10,'2026-05-15','2026-05-23'),(80,'Закрытие сезона март',50,'2025-03-10','2025-03-11'),(81,'Пляжные скидки',5,'2024-08-03','2024-08-19'),(82,'Фантастические скидки',20,'2025-06-09','2025-06-15'),(83,'Скидка для детективов',10,'2023-03-13','2023-03-25'),(84,'Геймерский фестиваль 2024',10,'2024-08-11','2024-08-15'),(85,'День защиты детей 2026',10,'2026-12-18','2026-12-23'),(86,'Осенние скидки 2.0.2.4',15,'2024-09-09','2024-09-18'),(87,'День защиты детей 2024',15,'2024-08-08','2024-08-09'),(88,'Карты в рукаве',25,'2023-05-09','2023-05-16'),(89,'Мегараспродажа 25',50,'2025-02-19','2025-02-22'),(90,'Безумная пятница 2.0.2.6',60,'2026-08-10','2026-08-13'),(91,'Осенние скидки 2025',10,'2025-09-06','2025-09-12'),(92,'Безумная пятница',40,'2025-03-02','2025-03-03'),(93,'Скидка для Шерлока',10,'2023-12-10','2023-12-14'),(94,'День рождения 2023',15,'2023-07-15','2023-07-16'),(95,'Безумная пятница 24',60,'2024-05-18','2024-05-20'),(96,'Мегараспродажа 2.0.2.3',50,'2023-08-12','2023-08-15'),(97,'Безумная пятница 2.0.2.3',30,'2023-09-08','2023-09-10'),(98,'Рождественские скидки 2025',10,'2025-07-02','2025-07-06'),(99,'Зимние скидки 26',5,'2026-02-04','2026-02-28'),(100,'Скидка для настольных детективов',10,'2025-06-02','2025-06-06');
/*!40000 ALTER TABLE `discount` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-26 14:09:44
