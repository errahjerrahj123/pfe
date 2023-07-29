-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: localhost    Database: newdatabase
-- ------------------------------------------------------
-- Server version	8.0.32-0ubuntu0.22.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `batches`
--

DROP TABLE IF EXISTS `batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `batches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `course_id` int DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `is_deleted` tinyint(1) DEFAULT '0',
  `employee_id` varchar(255) DEFAULT NULL,
  `school_field_id` int DEFAULT NULL,
  `code_etude` varchar(32) DEFAULT NULL,
  `cycle_id` int DEFAULT NULL,
  `is_active_mobilitie` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_batches_on_is_deleted_and_is_active_and_course_id_and_name` (`is_deleted`,`is_active`,`course_id`,`name`),
  KEY `idx101` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9214 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `batches`
--

LOCK TABLES `batches` WRITE;
/*!40000 ALTER TABLE `batches` DISABLE KEYS */;
INSERT INTO `batches` VALUES (9202,'Master 1 ',271,'2023-09-01 00:00:00','2024-08-31 00:00:00',1,0,NULL,2277,NULL,NULL,NULL),(9203,'',272,'2023-03-30 00:00:00','2024-03-30 00:00:00',1,0,NULL,NULL,NULL,NULL,NULL),(9204,'',273,'2023-04-03 00:00:00','2024-04-03 00:00:00',1,0,NULL,2279,NULL,NULL,NULL),(9205,'Classe Paysage',273,'2023-04-03 00:00:00','2024-04-03 00:00:00',1,0,NULL,2279,NULL,NULL,NULL),(9207,'',274,'2023-04-04 00:00:00','2024-04-04 00:00:00',1,0,NULL,2274,NULL,NULL,NULL),(9208,'AnnÃ©e_Test',275,'2023-04-04 00:00:00','2024-04-04 00:00:00',1,0,'720',2274,NULL,NULL,NULL),(9210,'AnnÃ©e_Test',275,'2023-04-05 00:00:00','2024-04-05 00:00:00',1,0,NULL,2280,NULL,NULL,NULL),(9211,'',276,'2023-04-05 00:00:00','2024-04-05 00:00:00',1,0,NULL,NULL,NULL,NULL,NULL),(9212,'',277,'2023-04-26 00:00:00','2024-04-26 00:00:00',1,0,NULL,2282,NULL,NULL,NULL),(9213,'Classe 1 2022-2023',277,'2022-09-01 00:00:00','2024-04-26 00:00:00',1,0,NULL,2282,NULL,NULL,NULL);
/*!40000 ALTER TABLE `batches` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-09 13:26:42