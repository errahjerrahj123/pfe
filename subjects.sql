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
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `batch_id` int DEFAULT NULL,
  `no_exams` tinyint(1) DEFAULT '0',
  `max_weekly_classes` int DEFAULT NULL,
  `elective_group_id` int DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `credit_hours` decimal(15,2) DEFAULT NULL,
  `prefer_consecutive` tinyint(1) DEFAULT '0',
  `amount` decimal(15,2) DEFAULT NULL,
  `school_module_id` int DEFAULT NULL,
  `subject_group_id` int DEFAULT NULL,
  `name_english` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `vhp_prepa` int DEFAULT NULL,
  `vhp_enca` int DEFAULT NULL,
  `vhp_eval` int DEFAULT NULL,
  `vhp_cours` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_subjects_on_batch_id_and_elective_group_id_and_is_deleted` (`batch_id`,`elective_group_id`,`is_deleted`),
  KEY `school_module_id` (`school_module_id`),
  KEY `idx102` (`subject_group_id`,`batch_id`),
  CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`school_module_id`) REFERENCES `school_modules` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101820 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES (101813,'Infographie','Infographie',9202,0,10,NULL,0,'2023-03-30 15:02:29','2023-03-30 15:02:29',60.00,0,NULL,NULL,48495,NULL,NULL,NULL,NULL,NULL),(101814,'LibellÃ©_JS','Abrv_JS',9202,0,10,NULL,0,'2023-03-30 15:02:29','2023-03-30 15:02:29',60.00,0,NULL,NULL,48493,NULL,NULL,NULL,NULL,NULL),(101815,'nom','code',9208,0,5,4,0,'2023-04-05 00:03:30','2023-04-05 00:03:30',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(101816,'Eng','Code',9208,0,3,NULL,0,'2023-04-05 00:07:28','2023-04-05 00:07:28',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(101819,'Eng','code',9210,0,5,NULL,0,'2023-04-05 00:24:31','2023-04-05 00:24:31',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-12 12:55:04
