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
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES (1,'Afghanistan','E'),(2,'Albania','E'),(3,'Algeria','E'),(4,'Andorra','E'),(5,'Angola','E'),(6,'Antigua & Deps','E'),(7,'Argentina','E'),(8,'Armenia','E'),(9,'Australia','E'),(10,'Austria','E'),(11,'Azerbaijan','E'),(12,'Bahamas','E'),(13,'Bahrain','E'),(14,'Bangladesh','E'),(15,'Barbados','E'),(16,'Belarus','E'),(17,'Belgium','E'),(18,'Belize','E'),(19,'Benin','E'),(20,'Bhutan','E'),(21,'Bolivia','E'),(22,'Bosnia Herzegovina','E'),(23,'Botswana','E'),(24,'Brazil','E'),(25,'Brunei','E'),(26,'Bulgaria','E'),(27,'Burkina','E'),(28,'Burundi','E'),(29,'Cambodia','E'),(30,'Cameroon','E'),(31,'Canada','E'),(32,'Cape Verde','E'),(33,'Central African Rep','E'),(34,'Chad','E'),(35,'Chile','E'),(36,'China','E'),(37,'Colombia','E'),(38,'Comoros','E'),(39,'Congo','E'),(40,'Congo {Democratic Rep}','E'),(41,'Costa Rica','E'),(42,'Croatia','E'),(43,'Cuba','E'),(44,'Cyprus','E'),(45,'Czech Republic','E'),(46,'Denmark','E'),(47,'Djibouti','E'),(48,'Dominica','E'),(49,'Dominican Republic','E'),(50,'East Timor','E'),(51,'Ecuador','E'),(52,'Egypt','E'),(53,'El Salvador','E'),(54,'Equatorial Guinea','E'),(55,'Eritrea','E'),(56,'Estonia','E'),(57,'Ethiopia','E'),(58,'Fiji','E'),(59,'Finland','E'),(60,'France','E'),(61,'Gabon','E'),(62,'Gambia','E'),(63,'Georgia','E'),(64,'Germany','E'),(65,'Ghana','E'),(66,'Greece','E'),(67,'Grenada','E'),(68,'Guatemala','E'),(69,'Guinea','E'),(70,'Guinea-Bissau','E'),(71,'Guyana','E'),(72,'Haiti','E'),(73,'Honduras','E'),(74,'Hungary','E'),(75,'Iceland','E'),(76,'India','E'),(77,'Indonesia','E'),(78,'Iran','E'),(79,'Iraq','E'),(80,'Ireland {Republic}','E'),(81,'Israel','E'),(82,'Italy','E'),(83,'Ivory Coast','E'),(84,'Jamaica','E'),(85,'Japan','E'),(86,'Jordan','E'),(87,'Kazakhstan','E'),(88,'Kenya','E'),(89,'Kiribati','E'),(90,'Korea North','E'),(91,'Korea South','E'),(92,'Kosovo','E'),(93,'Kuwait','E'),(94,'Kyrgyzstan','E'),(95,'Laos','E'),(96,'Latvia','E'),(97,'Lebanon','E'),(98,'Lesotho','E'),(99,'Liberia','E'),(100,'Libya','E'),(101,'Liechtenstein','E'),(102,'Lithuania','E'),(103,'Luxembourg','E'),(104,'Macedonia','E'),(105,'Madagascar','E'),(106,'Malawi','E'),(107,'Malaysia','E'),(108,'Maldives','E'),(109,'Mali','E'),(110,'Malta','E'),(111,'Montenegro','E'),(112,'Marshall Islands','E'),(113,'Mauritania','E'),(114,'Mauritius','E'),(115,'Mexico','E'),(116,'Micronesia','E'),(117,'Moldova','E'),(118,'Monaco','E'),(119,'Mongolia','E'),(120,'Morocco','M'),(121,'Mozambique','E'),(122,'Myanmar, {Burma}','E'),(123,'Namibia','E'),(124,'Nauru','E'),(125,'Nepal','E'),(126,'Netherlands','E'),(127,'New Zealand','E'),(128,'Nicaragua','E'),(129,'Niger','E'),(130,'Nigeria','E'),(131,'Norway','E'),(132,'Oman','E'),(133,'Pakistan','E'),(134,'Palau','E'),(135,'Panama','E'),(136,'Papua New Guinea','E'),(137,'Paraguay','E'),(138,'Peru','E'),(139,'Philippines','E'),(140,'Poland','E'),(141,'Portugal','E'),(142,'Qatar','E'),(143,'Romania','E'),(144,'Russian Federation','E'),(145,'Rwanda','E'),(146,'St Kitts & Nevis','E'),(147,'St Lucia','E'),(148,'Saint Vincent & the Grenadines','E'),(149,'Samoa','E'),(150,'San Marino','E'),(151,'Sao Tome & Principe','E'),(152,'Saudi Arabia','E'),(153,'Senegal','E'),(154,'Serbia','E'),(155,'Seychelles','E'),(156,'Sierra Leone','E'),(157,'Singapore','E'),(158,'Slovakia','E'),(159,'Slovenia','E'),(160,'Solomon Islands','E'),(161,'Somalia','E'),(162,'South Africa','E'),(163,'Spain','E'),(164,'Sri Lanka','E'),(165,'Sudan','E'),(166,'Suriname','E'),(167,'Swaziland','E'),(168,'Sweden','E'),(169,'Switzerland','E'),(170,'Syria','E'),(171,'Taiwan','E'),(172,'Tajikistan','E'),(173,'Tanzania','E'),(174,'Thailand','E'),(175,'Togo','E'),(176,'Tonga','E'),(177,'Trinidad & Tobago','E'),(178,'Tunisia','E'),(179,'Turkey','E'),(180,'Turkmenistan','E'),(181,'Tuvalu','E'),(182,'Uganda','E'),(183,'Ukraine','E'),(184,'United Arab Emirates','E'),(185,'United Kingdom','E'),(186,'United States','E'),(187,'Uruguay','E'),(188,'Uzbekistan','E'),(189,'Vanuatu','E'),(190,'Vatican City','E'),(191,'Venezuea','E'),(192,'Vietnam','E'),(193,'Yemen','E'),(194,'Zambia','E'),(195,'Zimbabwe','E');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-08 20:21:06
