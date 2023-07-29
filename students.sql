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
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admission_no` varchar(255) DEFAULT NULL,
  `class_roll_no` varchar(255) DEFAULT NULL,
  `admission_date` date DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `middle_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `batch_id` int DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `blood_group` varchar(255) DEFAULT NULL,
  `birth_place` varchar(255) DEFAULT NULL,
  `nationality_id` int DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `religion` varchar(255) DEFAULT NULL,
  `student_category_id` int DEFAULT NULL,
  `address_line1` varchar(255) DEFAULT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `pin_code` varchar(255) DEFAULT NULL,
  `country_id` int DEFAULT NULL,
  `phone1` varchar(255) DEFAULT NULL,
  `phone2` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `immediate_contact_id` int DEFAULT NULL,
  `is_sms_enabled` tinyint(1) DEFAULT '1',
  `photo_file_name` varchar(255) DEFAULT NULL,
  `photo_content_type` varchar(255) DEFAULT NULL,
  `photo_data` mediumblob,
  `status_description` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `is_deleted` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `has_paid_fees` tinyint(1) DEFAULT '0',
  `photo_file_size` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `matricule` varchar(255) DEFAULT '',
  `type_concours` varchar(255) DEFAULT NULL,
  `rang_concours` varchar(255) DEFAULT NULL,
  `nom_ar` varchar(255) DEFAULT NULL,
  `prenom_ar` varchar(255) DEFAULT NULL,
  `cin` varchar(255) DEFAULT NULL,
  `cin_debut` date DEFAULT NULL,
  `cin_lieu` varchar(255) DEFAULT NULL,
  `num_baccalaureat` varchar(255) DEFAULT NULL,
  `lycee` varchar(255) DEFAULT NULL,
  `ville_bac` varchar(255) DEFAULT NULL,
  `pays_bac` varchar(255) DEFAULT NULL,
  `type_bac` varchar(255) DEFAULT NULL,
  `type_ens` varchar(255) DEFAULT NULL,
  `annee_bac` varchar(255) DEFAULT NULL,
  `mention_bac` varchar(255) DEFAULT NULL,
  `bourse` tinyint(1) DEFAULT NULL,
  `bourse_org` varchar(255) DEFAULT NULL,
  `contractuel` tinyint(1) DEFAULT NULL,
  `contrat_org` varchar(255) DEFAULT NULL,
  `num_bourse_contrat` varchar(255) DEFAULT NULL,
  `nbre_freres` int DEFAULT NULL,
  `prob_sante` varchar(255) DEFAULT NULL,
  `lieu_naissance_ar` varchar(255) DEFAULT NULL,
  `section` varchar(255) DEFAULT NULL,
  `filiere` int DEFAULT NULL,
  `ordre` int DEFAULT NULL,
  `group_lang` varchar(255) DEFAULT NULL,
  `group_td` varchar(255) DEFAULT NULL,
  `school_id` int DEFAULT NULL,
  `credits` decimal(7,2) DEFAULT '0.00',
  `resto_current_times` int DEFAULT NULL,
  `last_meal_time` date DEFAULT NULL,
  `current_rfid` varchar(255) DEFAULT NULL,
  `allowed_to_resto` tinyint(1) DEFAULT NULL,
  `nation` varchar(255) DEFAULT NULL,
  `nationalite` varchar(255) DEFAULT NULL,
  `rib` varchar(255) DEFAULT NULL,
  `co_amo` tinyint(1) DEFAULT NULL,
  `co_mut` tinyint(1) DEFAULT NULL,
  `email_inst` varchar(255) DEFAULT NULL,
  `cnss` tinyint(1) DEFAULT NULL,
  `assurance` tinyint(1) DEFAULT NULL,
  `father_full_name` varchar(255) DEFAULT NULL,
  `mother_full_name` varchar(255) DEFAULT NULL,
  `father_job` varchar(255) DEFAULT NULL,
  `father_cin` varchar(255) DEFAULT NULL,
  `mother_job` varchar(255) DEFAULT NULL,
  `mother_cin` varchar(255) DEFAULT NULL,
  `is_edited` tinyint(1) DEFAULT NULL,
  `resto_start_date` date DEFAULT NULL,
  `resto_end_date` date DEFAULT NULL,
  `type_registration` varchar(255) DEFAULT NULL,
  `code_massar` varchar(255) DEFAULT NULL,
  `COD_IND` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `note_so` int DEFAULT NULL,
  `note_pfa` int DEFAULT NULL,
  `note_pfe` int DEFAULT NULL,
  `apogee` varchar(20) DEFAULT NULL,
  `province_bac` varchar(100) DEFAULT NULL,
  `diplome_admission` varchar(100) DEFAULT NULL,
  `filiere_diplome` varchar(100) DEFAULT NULL,
  `code_cnc` varchar(100) DEFAULT NULL,
  `annee_diplome` varchar(100) DEFAULT NULL,
  `etablissement_dip` varchar(100) DEFAULT NULL,
  `ville_dip` varchar(100) DEFAULT NULL,
  `centre_dip` varchar(100) DEFAULT NULL,
  `type_enseignement` varchar(100) DEFAULT NULL,
  `pays_enseignement` varchar(100) DEFAULT NULL,
  `cv_content_type` mediumtext,
  `is_admission_valid` tinyint(1) DEFAULT NULL,
  `step_1` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_students_on_admission_no` (`admission_no`(10)),
  KEY `index_students_on_first_name_and_middle_name_and_last_name` (`first_name`(10),`middle_name`(10),`last_name`(10)),
  KEY `index_students_on_batch_id` (`batch_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29699 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-18 15:01:13
