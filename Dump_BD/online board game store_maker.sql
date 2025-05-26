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
-- Table structure for table `maker`
--

DROP TABLE IF EXISTS `maker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maker` (
  `id_maker` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Country` varchar(45) NOT NULL,
  `Email` varchar(256) NOT NULL,
  `Phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id_maker`),
  UNIQUE KEY `Name_UNIQUE` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maker`
--

LOCK TABLES `maker` WRITE;
/*!40000 ALTER TABLE `maker` DISABLE KEYS */;
INSERT INTO `maker` VALUES (1,'Hasbro','USA','info@hasbro.com','+1234567890'),(2,'Ravensburger','Germany','support@ravensburger.de','+4987654321'),(3,'Fantasy Flight Games','USA','contact@fantasyflight.com','+1987654321'),(4,'Zvezda','Russia','sales@zvezda.ru','+74951234567'),(5,'Days of Wonder','France','info@daysofwonder.com','+33123456789'),(6,'Stonemaier Games','USA','support@stonemaier.com','+15551234567'),(7,'Hobby World','Russia','info@hobbyworld.ru','+74959876543'),(8,'Asmodee','France','contact@asmodee.com','+33198765432'),(9,'Catan Studio','Germany','info@catan.com','+49123456789'),(10,'CMON','USA','support@cmon.com','+18881234567'),(11,'Pegasus Spiele','Germany','info@pegasus.de','+496543218790'),(12,'Lautapelit.fi','Finland','contact@lautapelit.fi','+358401234567'),(13,'Portal Games','Poland','office@portalgames.pl','+48221234567'),(14,'Matagot','France','contact@matagot.com','+33123459876'),(15,'Repos Production','Belgium','info@reposprod.com','+3223456789'),(16,'Czech Games Edition','Czech Republic','support@czechgames.com','+420234567890'),(17,'IELLO','France','contact@iello.fr','+33198761234'),(18,'Alderac Entertainment Group','USA','info@alderac.com','+18181234567'),(19,'Rio Grande Games','USA','support@riograndegames.com','+15051234567'),(20,'Queen Games','Germany','info@queen-games.de','+492345678901'),(21,'Libellud','France','contact@libellud.com','+33187654321'),(22,'Mindok','Czech Republic','info@mindok.cz','+420123456789'),(23,'Ludonova','Spain','support@ludonova.com','+34911234567'),(24,'Red Raven Games','USA','contact@redravengames.com','+12081234567'),(25,'North Star Games','USA','info@northstargames.com','+18001234567'),(26,'Kosmos','Germany','support@kosmos.de','+496789012345'),(27,'Gamewright','USA','info@gamewright.com','+16171234567'),(28,'Gigamic','France','contact@gigamic.com','+33123450987'),(29,'Ludicreations','Greece','info@ludicreations.com','+302101234567'),(30,'Moaideas Game Design','China','support@moaideas.com','+8610123456789');
/*!40000 ALTER TABLE `maker` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-26 14:09:40
