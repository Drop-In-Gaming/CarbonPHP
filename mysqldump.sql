-- MySQL dump 10.13  Distrib 8.0.16, for osx10.14 (x86_64)
--
-- Host: 127.0.0.1    Database: CarbonPHP
-- ------------------------------------------------------
-- Server version	8.0.16

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `carbon_comments`
--

DROP TABLE IF EXISTS `carbon_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `carbon_comments` (
  `parent_id` binary(16) NOT NULL,
  `comment_id` binary(16) NOT NULL,
  `user_id` binary(16) NOT NULL,
  `comment` blob NOT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `entity_comments_entity_parent_pk_fk` (`parent_id`),
  KEY `entity_comments_entity_user_pk_fk` (`user_id`),
  CONSTRAINT `entity_comments_entity_entity_pk_fk` FOREIGN KEY (`comment_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `entity_comments_entity_parent_pk_fk` FOREIGN KEY (`parent_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `entity_comments_entity_user_pk_fk` FOREIGN KEY (`user_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_comments_a_i` AFTER INSERT ON `carbon_comments` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"parent_id":"', HEX(NEW.parent_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"comment_id":"', HEX(NEW.comment_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(NEW.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"comment":"', COALESCE(NEW.comment,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO creation_logs (`uuid`, `resource_type`, `resource_uuid`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_comments', NEW.comment_id);
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_comments', NEW.comment_id , 'POST', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_comments_a_u` AFTER UPDATE ON `carbon_comments` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"parent_id":"', HEX(NEW.parent_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"comment_id":"', HEX(NEW.comment_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(NEW.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"comment":"', COALESCE(NEW.comment,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_comments', NEW.comment_id , 'PUT', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_comments_b_d` BEFORE DELETE ON `carbon_comments` FOR EACH ROW BEGIN
DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"parent_id":"', HEX(OLD.parent_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"comment_id":"', HEX(OLD.comment_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(OLD.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"comment":"', COALESCE(OLD.comment,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_comments', OLD.comment_id , 'DELETE', json);
      


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `carbon_locations`
--

DROP TABLE IF EXISTS `carbon_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `carbon_locations` (
  `entity_id` binary(16) NOT NULL,
  `latitude` varchar(225) DEFAULT NULL,
  `longitude` varchar(225) DEFAULT NULL,
  `street` text,
  `city` varchar(40) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `elevation` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`entity_id`),
  UNIQUE KEY `entity_location_entity_id_uindex` (`entity_id`),
  CONSTRAINT `entity_location_entity_entity_pk_fk` FOREIGN KEY (`entity_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_locations_a_i` AFTER INSERT ON `carbon_locations` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"entity_id":"', HEX(NEW.entity_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"latitude":"', COALESCE(NEW.latitude,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"longitude":"', COALESCE(NEW.longitude,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"street":"', COALESCE(NEW.street,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"city":"', COALESCE(NEW.city,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"state":"', COALESCE(NEW.state,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"elevation":"', COALESCE(NEW.elevation,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO creation_logs (`uuid`, `resource_type`, `resource_uuid`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_locations', NEW.entity_id);
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_locations', NEW.entity_id , 'POST', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_locations_a_u` AFTER UPDATE ON `carbon_locations` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"entity_id":"', HEX(NEW.entity_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"latitude":"', COALESCE(NEW.latitude,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"longitude":"', COALESCE(NEW.longitude,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"street":"', COALESCE(NEW.street,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"city":"', COALESCE(NEW.city,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"state":"', COALESCE(NEW.state,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"elevation":"', COALESCE(NEW.elevation,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_locations', NEW.entity_id , 'PUT', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_locations_b_d` BEFORE DELETE ON `carbon_locations` FOR EACH ROW BEGIN
DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"entity_id":"', HEX(OLD.entity_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"latitude":"', COALESCE(OLD.latitude,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"longitude":"', COALESCE(OLD.longitude,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"street":"', COALESCE(OLD.street,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"city":"', COALESCE(OLD.city,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"state":"', COALESCE(OLD.state,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"elevation":"', COALESCE(OLD.elevation,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_locations', OLD.entity_id , 'DELETE', json);
      


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `carbon_photos`
--

DROP TABLE IF EXISTS `carbon_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `carbon_photos` (
  `parent_id` binary(16) NOT NULL,
  `photo_id` binary(16) NOT NULL,
  `user_id` binary(16) NOT NULL,
  `photo_path` varchar(225) NOT NULL,
  `photo_description` text,
  PRIMARY KEY (`parent_id`),
  UNIQUE KEY `entity_photos_photo_id_uindex` (`photo_id`),
  KEY `photos_entity_user_pk_fk` (`user_id`),
  CONSTRAINT `entity_photos_entity_entity_pk_fk` FOREIGN KEY (`photo_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `photos_entity_entity_pk_fk` FOREIGN KEY (`parent_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `photos_entity_user_pk_fk` FOREIGN KEY (`user_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_photos_a_i` AFTER INSERT ON `carbon_photos` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"parent_id":"', HEX(NEW.parent_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"photo_id":"', HEX(NEW.photo_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(NEW.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"photo_path":"', COALESCE(NEW.photo_path,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"photo_description":"', COALESCE(NEW.photo_description,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO creation_logs (`uuid`, `resource_type`, `resource_uuid`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_photos', NEW.parent_id);
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_photos', NEW.parent_id , 'POST', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_photos_a_u` AFTER UPDATE ON `carbon_photos` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"parent_id":"', HEX(NEW.parent_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"photo_id":"', HEX(NEW.photo_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(NEW.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"photo_path":"', COALESCE(NEW.photo_path,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"photo_description":"', COALESCE(NEW.photo_description,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_photos', NEW.parent_id , 'PUT', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_photos_b_d` BEFORE DELETE ON `carbon_photos` FOR EACH ROW BEGIN
DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"parent_id":"', HEX(OLD.parent_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"photo_id":"', HEX(OLD.photo_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(OLD.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"photo_path":"', COALESCE(OLD.photo_path,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"photo_description":"', COALESCE(OLD.photo_description,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_photos', OLD.parent_id , 'DELETE', json);
      


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `carbon_reports`
--

DROP TABLE IF EXISTS `carbon_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `carbon_reports` (
  `log_level` varchar(20) DEFAULT NULL,
  `report` text,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `call_trace` text NOT NULL,
  UNIQUE KEY `carbon_reports_date_uindex` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `carbon_tag`
--

DROP TABLE IF EXISTS `carbon_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `carbon_tag` (
  `entity_id` binary(16) NOT NULL,
  `tag_id` varchar(80) NOT NULL,
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `entity_tag_entity_entity_pk_fk` (`entity_id`),
  KEY `entity_tag_tag_tag_id_fk` (`tag_id`),
  CONSTRAINT `carbon_tag_tags_tag_id_fk` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`tag_id`),
  CONSTRAINT `entity_tag_entity_entity_pk_fk` FOREIGN KEY (`entity_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `carbon_user_followers`
--

DROP TABLE IF EXISTS `carbon_user_followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `carbon_user_followers` (
  `follower_table_id` binary(16) NOT NULL,
  `follows_user_id` binary(16) NOT NULL,
  `user_id` binary(16) NOT NULL,
  PRIMARY KEY (`follower_table_id`),
  KEY `followers_entity_entity_pk_fk` (`follows_user_id`),
  KEY `followers_entity_entity_followers_pk_fk` (`user_id`),
  CONSTRAINT `carbon_user_followers_carbons_entity_pk_fk` FOREIGN KEY (`follower_table_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `followers_entity_entity_follows_pk_fk` FOREIGN KEY (`follows_user_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `followers_entity_followers_pk_fk` FOREIGN KEY (`user_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_user_followers_a_i` AFTER INSERT ON `carbon_user_followers` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"follower_table_id":"', HEX(NEW.follower_table_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"follows_user_id":"', HEX(NEW.follows_user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(NEW.user_id), '"');SET json = CONCAT(json, '}');
      
INSERT INTO creation_logs (`uuid`, `resource_type`, `resource_uuid`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_followers', NEW.follower_table_id);
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_followers', NEW.follower_table_id , 'POST', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_user_followers_a_u` AFTER UPDATE ON `carbon_user_followers` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"follower_table_id":"', HEX(NEW.follower_table_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"follows_user_id":"', HEX(NEW.follows_user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(NEW.user_id), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_followers', NEW.follower_table_id , 'PUT', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_user_followers_b_d` BEFORE DELETE ON `carbon_user_followers` FOR EACH ROW BEGIN
DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"follower_table_id":"', HEX(OLD.follower_table_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"follows_user_id":"', HEX(OLD.follows_user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(OLD.user_id), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_followers', OLD.follower_table_id , 'DELETE', json);
      


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `carbon_user_messages`
--

DROP TABLE IF EXISTS `carbon_user_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `carbon_user_messages` (
  `message_id` binary(16) NOT NULL,
  `from_user_id` binary(16) NOT NULL,
  `to_user_id` binary(16) NOT NULL,
  `message` text NOT NULL,
  `message_read` tinyint(1) DEFAULT '0',
  `creation_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`),
  KEY `messages_entity_entity_pk_fk` (`message_id`),
  KEY `messages_entity_user_from_pk_fk` (`to_user_id`),
  KEY `carbon_user_messages_carbon_entity_pk_fk` (`from_user_id`),
  CONSTRAINT `carbon_user_messages_carbon_entity_pk_fk` FOREIGN KEY (`from_user_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `messages_entity_entity_pk_fk` FOREIGN KEY (`message_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `messages_entity_user_from_pk_fk` FOREIGN KEY (`to_user_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_user_messages_a_i` AFTER INSERT ON `carbon_user_messages` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"message_id":"', HEX(NEW.message_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"from_user_id":"', HEX(NEW.from_user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"to_user_id":"', HEX(NEW.to_user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"message":"', COALESCE(NEW.message,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"message_read":"', COALESCE(NEW.message_read,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"creation_date":"', COALESCE(NEW.creation_date,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO creation_logs (`uuid`, `resource_type`, `resource_uuid`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_messages', NEW.message_id);
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_messages', NEW.message_id , 'POST', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_user_messages_a_u` AFTER UPDATE ON `carbon_user_messages` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"message_id":"', HEX(NEW.message_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"from_user_id":"', HEX(NEW.from_user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"to_user_id":"', HEX(NEW.to_user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"message":"', COALESCE(NEW.message,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"message_read":"', COALESCE(NEW.message_read,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"creation_date":"', COALESCE(NEW.creation_date,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_messages', NEW.message_id , 'PUT', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_user_messages_b_d` BEFORE DELETE ON `carbon_user_messages` FOR EACH ROW BEGIN
DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"message_id":"', HEX(OLD.message_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"from_user_id":"', HEX(OLD.from_user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"to_user_id":"', HEX(OLD.to_user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"message":"', COALESCE(OLD.message,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"message_read":"', COALESCE(OLD.message_read,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"creation_date":"', COALESCE(OLD.creation_date,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_messages', OLD.message_id , 'DELETE', json);
      


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `carbon_user_sessions`
--

DROP TABLE IF EXISTS `carbon_user_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `carbon_user_sessions` (
  `user_id` binary(16) NOT NULL,
  `user_ip` binary(16) DEFAULT NULL,
  `session_id` varchar(255) NOT NULL,
  `session_expires` datetime NOT NULL,
  `session_data` text,
  `user_online_status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `carbon_user_tasks`
--

DROP TABLE IF EXISTS `carbon_user_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `carbon_user_tasks` (
  `task_id` binary(16) NOT NULL,
  `user_id` binary(16) NOT NULL COMMENT 'This is the user the task is being assigned to',
  `from_id` binary(16) DEFAULT NULL COMMENT 'Keeping this colum so forgen key will remove task if user deleted',
  `task_name` varchar(40) NOT NULL,
  `task_description` varchar(225) DEFAULT NULL,
  `percent_complete` int(11) DEFAULT '0',
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `user_tasks_entity_entity_pk_fk` (`from_id`),
  KEY `user_tasks_entity_task_pk_fk` (`task_id`),
  CONSTRAINT `tasks_entity_entity_pk_fk` FOREIGN KEY (`task_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_tasks_entity_entity_pk_fk` FOREIGN KEY (`from_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_tasks_entity_user_pk_fk` FOREIGN KEY (`user_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_user_tasks_a_i` AFTER INSERT ON `carbon_user_tasks` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"task_id":"', HEX(NEW.task_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(NEW.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"from_id":"', HEX(NEW.from_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"task_name":"', COALESCE(NEW.task_name,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"task_description":"', COALESCE(NEW.task_description,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"percent_complete":"', COALESCE(NEW.percent_complete,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"start_date":"', COALESCE(NEW.start_date,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"end_date":"', COALESCE(NEW.end_date,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO creation_logs (`uuid`, `resource_type`, `resource_uuid`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_tasks', NEW.user_id);
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_tasks', NEW.user_id , 'POST', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_user_tasks_a_u` AFTER UPDATE ON `carbon_user_tasks` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"task_id":"', HEX(NEW.task_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(NEW.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"from_id":"', HEX(NEW.from_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"task_name":"', COALESCE(NEW.task_name,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"task_description":"', COALESCE(NEW.task_description,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"percent_complete":"', COALESCE(NEW.percent_complete,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"start_date":"', COALESCE(NEW.start_date,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"end_date":"', COALESCE(NEW.end_date,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_tasks', NEW.user_id , 'PUT', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_user_tasks_b_d` BEFORE DELETE ON `carbon_user_tasks` FOR EACH ROW BEGIN
DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"task_id":"', HEX(OLD.task_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(OLD.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"from_id":"', HEX(OLD.from_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"task_name":"', COALESCE(OLD.task_name,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"task_description":"', COALESCE(OLD.task_description,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"percent_complete":"', COALESCE(OLD.percent_complete,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"start_date":"', COALESCE(OLD.start_date,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"end_date":"', COALESCE(OLD.end_date,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_user_tasks', OLD.user_id , 'DELETE', json);
      


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `carbon_users`
--

DROP TABLE IF EXISTS `carbon_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `carbon_users` (
  `user_username` varchar(25) NOT NULL,
  `user_password` varchar(225) NOT NULL,
  `user_id` binary(16) NOT NULL,
  `user_type` varchar(20) NOT NULL DEFAULT 'Athlete',
  `user_sport` varchar(20) DEFAULT 'GOLF',
  `user_session_id` varchar(225) DEFAULT NULL,
  `user_facebook_id` varchar(225) DEFAULT NULL,
  `user_first_name` varchar(25) NOT NULL,
  `user_last_name` varchar(25) NOT NULL,
  `user_profile_pic` varchar(225) DEFAULT NULL,
  `user_profile_uri` varchar(225) DEFAULT NULL,
  `user_cover_photo` varchar(225) DEFAULT NULL,
  `user_birthday` varchar(9) DEFAULT NULL,
  `user_gender` varchar(25) NOT NULL,
  `user_about_me` varchar(225) DEFAULT NULL,
  `user_rank` int(8) DEFAULT '0',
  `user_email` varchar(50) NOT NULL,
  `user_email_code` varchar(225) DEFAULT NULL,
  `user_email_confirmed` varchar(20) NOT NULL DEFAULT '0',
  `user_generated_string` varchar(200) DEFAULT NULL,
  `user_membership` int(10) DEFAULT '0',
  `user_deactivated` tinyint(1) DEFAULT '0',
  `user_last_login` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_ip` varchar(20) NOT NULL,
  `user_education_history` varchar(200) DEFAULT NULL,
  `user_location` varchar(20) DEFAULT NULL,
  `user_creation_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `carbon_users_user_username_uindex` (`user_username`),
  UNIQUE KEY `user_user_profile_uri_uindex` (`user_profile_uri`),
  UNIQUE KEY `carbon_users_user_facebook_id_uindex` (`user_facebook_id`),
  CONSTRAINT `user_entity_entity_pk_fk` FOREIGN KEY (`user_id`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_users_a_i` AFTER INSERT ON `carbon_users` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"user_username":"', COALESCE(NEW.user_username,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_password":"', COALESCE(NEW.user_password,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(NEW.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_type":"', COALESCE(NEW.user_type,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_sport":"', COALESCE(NEW.user_sport,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_session_id":"', COALESCE(NEW.user_session_id,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_facebook_id":"', COALESCE(NEW.user_facebook_id,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_first_name":"', COALESCE(NEW.user_first_name,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_last_name":"', COALESCE(NEW.user_last_name,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_profile_pic":"', COALESCE(NEW.user_profile_pic,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_profile_uri":"', COALESCE(NEW.user_profile_uri,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_cover_photo":"', COALESCE(NEW.user_cover_photo,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_birthday":"', COALESCE(NEW.user_birthday,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_gender":"', COALESCE(NEW.user_gender,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_about_me":"', COALESCE(NEW.user_about_me,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_rank":"', COALESCE(NEW.user_rank,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_email":"', COALESCE(NEW.user_email,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_email_code":"', COALESCE(NEW.user_email_code,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_email_confirmed":"', COALESCE(NEW.user_email_confirmed,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_generated_string":"', COALESCE(NEW.user_generated_string,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_membership":"', COALESCE(NEW.user_membership,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_deactivated":"', COALESCE(NEW.user_deactivated,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_last_login":"', COALESCE(NEW.user_last_login,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_ip":"', COALESCE(NEW.user_ip,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_education_history":"', COALESCE(NEW.user_education_history,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_location":"', COALESCE(NEW.user_location,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_creation_date":"', COALESCE(NEW.user_creation_date,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO creation_logs (`uuid`, `resource_type`, `resource_uuid`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_users', NEW.user_id);
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_users', NEW.user_id , 'POST', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_users_a_u` AFTER UPDATE ON `carbon_users` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"user_username":"', COALESCE(NEW.user_username,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_password":"', COALESCE(NEW.user_password,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(NEW.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_type":"', COALESCE(NEW.user_type,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_sport":"', COALESCE(NEW.user_sport,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_session_id":"', COALESCE(NEW.user_session_id,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_facebook_id":"', COALESCE(NEW.user_facebook_id,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_first_name":"', COALESCE(NEW.user_first_name,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_last_name":"', COALESCE(NEW.user_last_name,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_profile_pic":"', COALESCE(NEW.user_profile_pic,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_profile_uri":"', COALESCE(NEW.user_profile_uri,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_cover_photo":"', COALESCE(NEW.user_cover_photo,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_birthday":"', COALESCE(NEW.user_birthday,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_gender":"', COALESCE(NEW.user_gender,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_about_me":"', COALESCE(NEW.user_about_me,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_rank":"', COALESCE(NEW.user_rank,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_email":"', COALESCE(NEW.user_email,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_email_code":"', COALESCE(NEW.user_email_code,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_email_confirmed":"', COALESCE(NEW.user_email_confirmed,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_generated_string":"', COALESCE(NEW.user_generated_string,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_membership":"', COALESCE(NEW.user_membership,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_deactivated":"', COALESCE(NEW.user_deactivated,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_last_login":"', COALESCE(NEW.user_last_login,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_ip":"', COALESCE(NEW.user_ip,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_education_history":"', COALESCE(NEW.user_education_history,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_location":"', COALESCE(NEW.user_location,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_creation_date":"', COALESCE(NEW.user_creation_date,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_users', NEW.user_id , 'PUT', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbon_users_b_d` BEFORE DELETE ON `carbon_users` FOR EACH ROW BEGIN
DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"user_username":"', COALESCE(OLD.user_username,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_password":"', COALESCE(OLD.user_password,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_id":"', HEX(OLD.user_id), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_type":"', COALESCE(OLD.user_type,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_sport":"', COALESCE(OLD.user_sport,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_session_id":"', COALESCE(OLD.user_session_id,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_facebook_id":"', COALESCE(OLD.user_facebook_id,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_first_name":"', COALESCE(OLD.user_first_name,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_last_name":"', COALESCE(OLD.user_last_name,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_profile_pic":"', COALESCE(OLD.user_profile_pic,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_profile_uri":"', COALESCE(OLD.user_profile_uri,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_cover_photo":"', COALESCE(OLD.user_cover_photo,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_birthday":"', COALESCE(OLD.user_birthday,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_gender":"', COALESCE(OLD.user_gender,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_about_me":"', COALESCE(OLD.user_about_me,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_rank":"', COALESCE(OLD.user_rank,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_email":"', COALESCE(OLD.user_email,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_email_code":"', COALESCE(OLD.user_email_code,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_email_confirmed":"', COALESCE(OLD.user_email_confirmed,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_generated_string":"', COALESCE(OLD.user_generated_string,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_membership":"', COALESCE(OLD.user_membership,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_deactivated":"', COALESCE(OLD.user_deactivated,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_last_login":"', COALESCE(OLD.user_last_login,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_ip":"', COALESCE(OLD.user_ip,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_education_history":"', COALESCE(OLD.user_education_history,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_location":"', COALESCE(OLD.user_location,''), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"user_creation_date":"', COALESCE(OLD.user_creation_date,''), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbon_users', OLD.user_id , 'DELETE', json);
      


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `carbons`
--

DROP TABLE IF EXISTS `carbons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `carbons` (
  `entity_pk` binary(16) NOT NULL,
  `entity_fk` binary(16) DEFAULT NULL,
  PRIMARY KEY (`entity_pk`),
  UNIQUE KEY `entity_entity_pk_uindex` (`entity_pk`),
  KEY `entity_entity_entity_pk_fk` (`entity_fk`),
  CONSTRAINT `entity_entity_entity_pk_fk` FOREIGN KEY (`entity_fk`) REFERENCES `carbons` (`entity_pk`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbons_a_i` AFTER INSERT ON `carbons` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"entity_pk":"', HEX(NEW.entity_pk), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"entity_fk":"', HEX(NEW.entity_fk), '"');SET json = CONCAT(json, '}');
      
INSERT INTO creation_logs (`uuid`, `resource_type`, `resource_uuid`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbons', NEW.entity_pk);
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbons', NEW.entity_pk , 'POST', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbons_a_u` AFTER UPDATE ON `carbons` FOR EACH ROW BEGIN

DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"entity_pk":"', HEX(NEW.entity_pk), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"entity_fk":"', HEX(NEW.entity_fk), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbons', NEW.entity_pk , 'PUT', json);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trigger_carbons_b_d` BEFORE DELETE ON `carbons` FOR EACH ROW BEGIN
DECLARE json text;
 SET json = '{';
SET json = CONCAT(json,'"entity_pk":"', HEX(OLD.entity_pk), '"');
SET json = CONCAT(json, ',');
SET json = CONCAT(json,'"entity_fk":"', HEX(OLD.entity_fk), '"');SET json = CONCAT(json, '}');
      
INSERT INTO history_logs (`uuid`, `resource_type`, `resource_uuid`, `operation_type`, `data`)
            VALUES (UNHEX(REPLACE(UUID() COLLATE utf8_unicode_ci,'-','')), 'carbons', OLD.entity_pk , 'DELETE', json);
      
DELETE FROM carbon_comments WHERE comment_id = OLD.entity_pk;
DELETE FROM carbon_comments WHERE parent_id = OLD.entity_pk;
DELETE FROM carbon_comments WHERE user_id = OLD.entity_pk;
DELETE FROM carbon_locations WHERE entity_id = OLD.entity_pk;
DELETE FROM carbon_photos WHERE photo_id = OLD.entity_pk;
DELETE FROM carbon_photos WHERE parent_id = OLD.entity_pk;
DELETE FROM carbon_photos WHERE user_id = OLD.entity_pk;
DELETE FROM carbon_tag WHERE entity_id = OLD.entity_pk;
DELETE FROM carbon_user_followers WHERE follower_table_id = OLD.entity_pk;
DELETE FROM carbon_user_followers WHERE follows_user_id = OLD.entity_pk;
DELETE FROM carbon_user_followers WHERE user_id = OLD.entity_pk;
DELETE FROM carbon_user_messages WHERE from_user_id = OLD.entity_pk;
DELETE FROM carbon_user_messages WHERE message_id = OLD.entity_pk;
DELETE FROM carbon_user_messages WHERE to_user_id = OLD.entity_pk;
DELETE FROM carbon_user_tasks WHERE task_id = OLD.entity_pk;
DELETE FROM carbon_user_tasks WHERE from_id = OLD.entity_pk;
DELETE FROM carbon_user_tasks WHERE user_id = OLD.entity_pk;
DELETE FROM carbon_users WHERE user_id = OLD.entity_pk;
DELETE FROM carbons WHERE entity_fk = OLD.entity_pk;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `creation_logs`
--

DROP TABLE IF EXISTS `creation_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `creation_logs` (
  `uuid` binary(16) DEFAULT NULL COMMENT 'not a relation to carbons',
  `resource_type` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `resource_uuid` binary(16) DEFAULT NULL COMMENT 'Was a carbons ref, but no longer'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `history_logs`
--

DROP TABLE IF EXISTS `history_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `history_logs` (
  `uuid` binary(16) NOT NULL,
  `resource_type` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `resource_uuid` binary(16) DEFAULT NULL,
  `operation_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data` json DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `sessions` (
  `user_id` binary(16) NOT NULL,
  `user_ip` varchar(20) DEFAULT NULL,
  `session_id` varchar(255) NOT NULL,
  `session_expires` datetime NOT NULL,
  `session_data` text,
  `user_online_status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `tags` (
  `tag_id` varchar(80) NOT NULL,
  `tag_description` text NOT NULL,
  `tag_name` text,
  UNIQUE KEY `tag_tag_id_uindex` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-07-03 22:32:28