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
-- Table structure for table `requestdoc_students`
--

DROP TABLE IF EXISTS `requestdoc_students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requestdoc_students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `requestdoc_id` int DEFAULT NULL,
  `statut` int DEFAULT NULL,
  `recovery_date` date DEFAULT NULL,
  `reject_cause` text,
  `observation` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `school_year` int DEFAULT NULL,
  `school_field_id` int DEFAULT NULL,
  `batch_id` int DEFAULT NULL,
  `last_print_date` datetime DEFAULT NULL,
  `delib_date` date DEFAULT NULL,
  `batch_ids` varchar(255) DEFAULT NULL,
  `bourse_mt` float DEFAULT NULL,
  `rdv_doc` varchar(255) DEFAULT NULL,
  `date_rdv_p` datetime DEFAULT NULL,
  `edited_by` int DEFAULT NULL,
  `doc_specification` varchar(255) DEFAULT NULL,
  `details` text,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `signed` tinyint(1) DEFAULT NULL,
  `motif` text,
  `validated_by` int DEFAULT NULL,
  `file_hex` varchar(255) DEFAULT NULL,
  `code_hex` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requestdoc_students`
--

LOCK TABLES `requestdoc_students` WRITE;
/*!40000 ALTER TABLE `requestdoc_students` DISABLE KEYS */;
INSERT INTO `requestdoc_students` VALUES (1,11191,2,NULL,NULL,NULL,NULL,'2020-10-26 20:19:07','2022-11-17 10:15:20',2020,187,2155,'2022-11-17 08:25:54',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'RRRR',NULL,'76e4413c07790b513d1e0c6a2403071e','ba6b159a3f52fd5652214531490fb9af'),(2,11191,1,1,'2020-11-02',NULL,'','2020-10-29 13:42:39','2022-10-25 15:18:39',2018,187,NULL,'2022-10-25 15:18:39',NULL,'60,59',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'GGGG',NULL,'8b0a5a7c0d07146a317440707fcae9b6','dee7d6135dd8aa1339cd4a658bf98558'),(3,11191,1,1,'2021-01-29',NULL,'','2020-10-29 13:42:39','2021-02-19 17:24:20',2017,187,NULL,'2021-02-19 16:42:55',NULL,'106,105',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'GGGG',NULL,'af11aeb47bf7f1a0b2aac9763f174e65','1060e2d55cddfa8d100bee345a1b6393'),(4,11191,1,1,'2021-01-29',NULL,'','2020-10-29 13:42:39','2021-06-22 14:26:41',2016,187,NULL,'2021-06-22 14:26:40',NULL,'191,106',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'GGGG',NULL,'37425ebd4a424c7777468ffcaa8ad051','45b9464fd20d12eb352158ddf400d997'),(5,11191,1,1,'2021-01-29',NULL,'','2020-10-29 13:42:39','2021-02-19 16:41:00',2016,187,NULL,'2021-02-19 15:40:28',NULL,'192,191',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'GGGG',NULL,'87d47d79668f6250d84f77b2981a909a','f5bb9d99f48da75edce01105b14ee97f'),(6,11191,1,1,'2021-01-29',NULL,'','2020-10-29 13:42:39','2021-01-29 10:10:31',2019,187,NULL,'2021-01-29 10:10:31',NULL,'2020,1972',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'GGGG',NULL,NULL,NULL),(7,11191,1,1,'2021-01-29',NULL,'','2020-10-29 13:42:40','2021-01-29 10:10:31',2019,187,NULL,'2021-01-29 10:10:31',NULL,'2021,2020',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'GGGG',NULL,NULL,NULL),(8,12374,2,NULL,NULL,NULL,NULL,'2020-11-04 09:34:56','2021-02-04 10:51:11',2020,10,2117,'2021-02-04 10:51:10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'2fc539fe8cc3dd9070611ec4668b169f','403589212596a68a3a6fb40aa77ca7ff'),(9,12152,3,1,'2021-01-27',NULL,'','2021-01-27 15:10:42','2021-09-07 13:36:41',2020,152,2208,'2021-09-07 13:36:38',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'test2',NULL,'62fb6bffdfa5afd7885117b94c7075ee','4d6f1346047c658761bfbecd548ccc67'),(10,12152,1,1,'2021-01-27',NULL,'','2021-01-27 15:13:05','2021-02-22 11:25:19',2020,152,NULL,'2021-02-22 10:00:01',NULL,'2208,2121',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'ae65767f37e88e141982ecc6c9609b17','6f1d36a99cf2feb100645f90342c3585'),(11,6581,2,1,'2021-01-27',NULL,'','2021-01-27 16:15:05','2021-01-29 15:26:37',2010,152,756,'2021-01-29 15:26:36',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'33c9970d7cff370bbe96e69eccc21f9f','fe8c872ce9cb0a9f46bde7abe85f6649'),(12,6581,2,1,'2021-01-27',NULL,'','2021-01-27 16:15:05','2023-02-10 09:15:37',2010,152,756,'2023-02-10 09:15:36',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'5d92592da1d81d6a2e93c6d342950e1b','d171573985eb61e43ddc32cd0b528d90'),(13,12152,3,1,'2021-01-27',NULL,'','2021-01-27 20:55:47','2021-01-29 10:45:45',2020,152,2208,'2021-01-29 10:32:16',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'e64feeecc1da863610938bd6091fae8d','20bc3c005582e60c937ea556592365d7'),(14,12152,2,1,'2021-01-27',NULL,'','2021-01-27 20:56:25','2021-01-28 14:46:55',2020,152,2208,'2021-01-28 14:46:52',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'8f0abc393475631c9fdb2fc5657605ab','f70f1f2809e47f6a83d46ccf67135679'),(15,12152,3,1,'2021-01-27',NULL,'','2021-01-27 21:03:10','2021-01-29 16:50:11',2020,152,2208,'2021-01-29 16:50:11',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(16,12152,2,1,'2021-01-27',NULL,'','2021-01-27 21:21:52','2021-01-28 11:21:04',2020,152,2208,'2021-01-28 11:21:01',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'fc373396d4762928184ca29701dd47e8','8708a5b9b071bffc539f9c28cf60c697'),(17,12152,2,1,'2021-01-27',NULL,'','2021-01-27 21:25:08','2021-01-27 21:25:36',2020,152,2208,'2021-01-27 21:25:36',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(18,12152,3,1,'2021-01-27',NULL,'','2021-01-27 21:34:23','2021-01-29 16:50:03',2020,152,2208,'2021-01-29 16:50:02',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'19caa873f64e7785209ff5f0e6665b32','5711a69a96ee930cbdd0b4a1891b4f6a'),(19,12152,2,1,'2021-01-27',NULL,'','2021-01-27 21:41:10','2022-11-16 14:35:14',2020,152,2208,'2022-11-16 14:35:14',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'843ce7a0f5245ecaa44d7d9406d56da6','f380e1992bf4e8b7ce591487c6ae735a'),(20,12152,3,1,'2021-01-27',NULL,'','2021-01-27 21:41:33','2021-01-27 21:48:17',2020,152,2208,'2021-01-27 21:48:17',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(21,12152,3,1,'2021-01-27',NULL,'','2021-01-27 21:51:20','2021-01-27 21:51:54',2020,152,2208,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(22,12152,3,1,'2021-01-27',NULL,'','2021-01-27 21:54:12','2021-01-27 21:56:22',2020,152,2208,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(23,12152,2,1,'2021-01-27',NULL,'','2021-01-27 22:01:07','2021-01-27 22:01:35',2020,152,2208,'2021-01-27 22:01:34',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'d602e9502314faf8f2282d1916dd78a2','768a2fbdb6787986b5aa8a7e1215da66'),(24,12152,2,1,'2021-01-27',NULL,'','2021-01-27 22:03:43','2021-01-27 22:04:10',2020,152,2208,'2021-01-27 22:04:10',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(25,12152,2,1,'2021-01-27',NULL,'','2021-01-27 22:06:02','2021-01-28 13:38:28',2020,152,2208,'2021-01-28 13:38:24',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'4240eb1407af46051f2565ace1ba09f0','0f2995e6662323b211ace312ca899975'),(26,12152,3,1,'2021-01-27',NULL,'','2021-01-27 22:09:27','2021-01-27 22:09:48',2020,152,2208,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(27,12152,3,1,'2021-01-27',NULL,'','2021-01-27 22:22:43','2021-01-27 22:23:01',2020,152,2208,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(28,12152,2,1,'2021-01-27',NULL,'','2021-01-27 22:26:06','2021-01-27 22:26:22',2020,152,2208,'2021-01-27 22:26:21',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'5ec1fd45ca1a9bf22ec70f656f990917','631f478963ad546559024fdbc2d5922b'),(29,12152,3,1,'2021-01-27',NULL,'','2021-01-27 22:31:59','2021-01-27 22:32:27',2020,152,2208,'2021-01-27 22:32:26',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'122f02248d8d5a236c238a211228b0b4','d6f64d05c25cd04e6395d5ed5fe88ea0'),(30,12152,2,1,'2021-01-28',NULL,'','2021-01-28 10:24:53','2021-01-28 10:29:57',2020,152,2208,'2021-01-28 10:29:51',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'cb8e99c0c6d6480a463a5727fd390653','2baacf5a8b658bd7da15fb05e6de66d4'),(31,12152,2,1,'2021-01-28',NULL,'','2021-01-28 11:28:49','2021-01-28 11:29:49',2020,152,2208,'2021-01-28 11:29:49',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'1618647fe1190d8d3691409182544a44','e4d0f728b245cfa8e26f71c251f55f00'),(32,12152,2,1,'2021-01-28',NULL,'','2021-01-28 12:59:56','2021-01-28 13:20:43',2020,152,2208,'2021-01-28 13:20:42',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'0c64edc6f4617d425ffdec847491971b','3d4f5cca240c6f6948a01c7ced581a24'),(33,12152,3,0,NULL,'','','2021-01-28 13:44:08','2021-04-05 10:39:21',2020,152,2208,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(34,12152,3,1,'2021-01-28',NULL,'','2021-01-28 13:44:08','2021-01-28 14:59:48',2020,152,2208,'2021-01-28 14:59:43',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'d999bc7f76ee56067f22b9c5dd0e3967','b2d86b5573d2983fe5ebdf3ec124889b'),(35,12152,2,1,'2021-02-04',NULL,'','2021-02-04 19:45:07','2021-02-04 19:45:49',2020,152,2208,'2021-02-04 19:45:49',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(36,12152,2,1,'2021-02-09',NULL,'','2021-02-09 15:43:24','2021-02-09 16:05:24',2020,152,2208,'2021-02-09 16:05:23',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'e76091bf417a84ec58249d6f8ddb4273','5b273aa0aa15e121dd0acc889ce5c1a1'),(37,12152,3,NULL,NULL,NULL,'test','2021-02-12 10:06:26','2021-09-07 13:37:13',2020,152,2208,'2021-09-07 13:37:05',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'12b57b2c4fa054931ce1a8febd7ff8b0','541a1c642b88b721761d89daaeeecf0c'),(38,11191,1,NULL,NULL,NULL,NULL,'2021-02-19 15:29:16','2022-10-25 15:18:05',2018,187,NULL,'2022-10-25 15:18:05',NULL,'60,59',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,'77d26713b4691b0147561ce09cdaf4d1','933e19bf1adfbeab56b55ee1ecd2913c'),(39,12152,2,1,'2021-04-05',NULL,'','2021-04-05 10:35:39','2021-04-05 10:36:23',2020,152,2208,'2021-04-05 10:36:19',NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'',NULL,'52582f512e2c4c36963cb65490041cb3','3db2a08695496ca822f6b1299037697b'),(40,12505,1,NULL,NULL,NULL,NULL,'2022-03-30 11:22:47','2022-03-30 11:22:47',2020,152,NULL,NULL,NULL,'2211,2117',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(41,14122,1,NULL,NULL,NULL,NULL,'2022-04-01 16:21:56','2022-04-01 16:21:56',2021,10,NULL,NULL,NULL,'2394,2272',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(42,12505,1,NULL,NULL,NULL,NULL,'2022-04-01 16:24:23','2022-04-01 16:24:23',2020,152,NULL,NULL,NULL,'2211,2117',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL),(43,24739,1,NULL,NULL,NULL,NULL,'2022-10-25 13:52:53','2022-10-25 13:52:53',2020,1695,NULL,NULL,NULL,'6656,4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'tesstee',NULL,NULL,NULL),(44,24739,2,NULL,NULL,NULL,NULL,'2022-10-25 13:53:15','2022-10-25 13:53:15',2019,1695,6696,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'gdgdgdgdg',NULL,NULL,NULL),(45,24739,3,NULL,NULL,NULL,'testtt','2022-10-25 13:54:20','2022-10-25 15:19:33',2019,1695,6696,'2022-10-25 15:19:33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'ttetst',NULL,NULL,NULL),(48,25764,1,NULL,NULL,NULL,NULL,'2023-01-16 20:46:29','2023-01-16 20:46:29',2021,1449,NULL,NULL,NULL,'7561,4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'test',NULL,NULL,NULL),(58,24554,1,NULL,NULL,NULL,NULL,'2023-01-26 15:32:20','2023-01-26 15:32:20',2019,1706,NULL,NULL,NULL,'7917,4',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'test',NULL,NULL,NULL),(70,19470,1,NULL,NULL,NULL,NULL,'2023-01-27 19:04:22','2023-01-27 19:04:22',2019,1697,NULL,NULL,NULL,'6956',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1A s1  ',NULL,NULL,NULL),(71,19470,1,1,'2023-01-31',NULL,'test signer','2023-01-27 19:04:46','2023-01-31 09:43:40',2020,1697,NULL,'2023-01-31 09:43:40',NULL,'7081',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,'2A S4 2020',NULL,NULL,NULL),(72,19470,1,NULL,NULL,NULL,NULL,'2023-01-31 16:37:38','2023-01-31 16:37:38',2019,1697,NULL,NULL,NULL,'6964',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'1A S2 2019',NULL,NULL,NULL),(73,19470,1,NULL,NULL,NULL,NULL,'2023-01-31 16:42:54','2023-01-31 16:42:54',2020,1697,NULL,NULL,NULL,'6975',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2A S3 2020 ',NULL,NULL,NULL),(74,29692,2,NULL,NULL,NULL,NULL,'2023-04-04 23:29:50','2023-04-04 23:29:50',2023,2277,9202,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'test',NULL,NULL,NULL);
/*!40000 ALTER TABLE `requestdoc_students` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-11 11:18:42
