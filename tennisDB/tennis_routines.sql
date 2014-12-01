CREATE DATABASE  IF NOT EXISTS `tennis` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `tennis`;
-- MySQL dump 10.13  Distrib 5.6.17, for Win32 (x86)
--
-- Host: 127.0.0.1    Database: tennis
-- ------------------------------------------------------
-- Server version	5.6.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'tennis'
--
/*!50003 DROP PROCEDURE IF EXISTS `summarizePlayerFullStats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `summarizePlayerFullStats`()
BEGIN
	DECLARE pname VARCHAR(45);
	DECLARE x INT;
	SET x = 1;
	WHILE(x<=(select max(id) from player_names)) DO
		select player_name from player_names where id = x into pname;
		insert into player_stats_full (
		select 
	x, stats.player, avg(100*(fsh/fst)) fsi, avg(100*(fsw/fsp)) fsw, avg(100*(ssw/ssp)) ssw, avg(100*(aces/sg)) apg, avg(100*(spw/spt)) sh,avg(100*(bps/bpt)) bps,
	avg(100*rpw) rpw
		from (
			select 
				playerA player, a_aces aces, a_double_faults dbf, a_first_serve_hits fsh, a_first_serve_total fst, a_first_serve_won fsw, 
				a_first_serve_played fsp, a_second_serve_won ssw, a_second_serve_played ssp, a_break_points_saved bps, a_break_points_total bpt,
				a_service_games sg, a_service_points_won spw, a_service_points_total spt, 
				((b_first_serve_played-b_first_serve_won)+(b_second_serve_played-b_second_serve_won))/b_first_serve_total rpw
			from match_stats_all_tournaments
			where playerA = pname and playerA <> 'N/A Bye'
			union
			select 
				playerB player, b_aces aces, b_double_faults dbf, b_first_serve_hits fsh, b_first_serve_total fst, b_first_serve_won fsw, 
				b_first_serve_played fsp, b_second_serve_won ssw, b_second_serve_played ssp, b_break_points_saved bps, b_break_points_total bpt, 
				b_service_games sg, b_service_points_won spw, b_service_points_total spt, 
				((a_first_serve_played-a_first_serve_won)+(a_second_serve_played-a_second_serve_won))/a_first_serve_total rpw
			from match_stats_all_tournaments
			where playerB = pname and playerB <> 'N/A Bye'
		) stats
	);
	SET x = x + 1;
	END WHILE;	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `summarizePlayerStats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `summarizePlayerStats`()
BEGIN
	DECLARE pname VARCHAR(45);
	DECLARE x INT;
	SET x = 1;
	WHILE(x<=(select max(id) from player_names)) DO
		select player_name from player_names where id = x into pname;
		insert into player_stats (
		select stats.player, sum(matches), sum(stats.fnl)/sum(matches), avg(fspw), avg(stats.fsp), avg(stats.fsw), avg(stats.ssp), avg(stats.ssw), sum(stats.ace)/sum(matches), sum(stats.dbf)/sum(matches), sum(stats.wnr)/sum(matches), sum(stats.ufe)/sum(matches), sum(stats.bpc)/sum(matches), sum(stats.bpw)/sum(matches), sum(stats.npa)/sum(matches), sum(stats.npw)/sum(matches), sum(stats.tpw)/sum(matches), sum(stats.st1)/sum(matches), sum(stats.st2)/sum(matches), sum(stats.st3)/sum(matches), sum(stats.st4)/sum(matches), sum(stats.st5)/sum(matches)
		from (
			select count(match_id) matches, player1 as player, sum(fnl1) as fnl, avg(fsw1/(fsp1/100)) as fspw, avg(fsp1) as fsp, avg(fsw1) as fsw, avg(ssp1) as ssp, avg(ssw1) as ssw, sum(ace1) as ace, sum(dbf1) as dbf, sum(wnr1) as wnr, sum(ufe1) as ufe, sum(bpc1) as bpc, sum(bpw1) as bpw, sum(npa1) as npa, sum(npw1) as npw, sum(tpw1) as tpw, sum(st11) as st1, sum(st21) as st2, sum(st31) as st3, sum(st41) as st4, sum(st51) as st5 
			from raw_stats
			where player1 = pname
			union
			select count(match_id) matches, player2 as player, sum(fnl2) as fnl, avg(fsw1/(fsp1/100)) as fspw, avg(fsp2) as fsp, avg(fsw2) as fsw, avg(ssp2) as ssp, avg(ssw2) as ssw, sum(ace2) as ace, sum(dbf2) as dbf, sum(wnr2) as wnr, sum(ufe2) as ufe, sum(bpc2) as bpc, sum(bpw2) as bpw, sum(npa2) as npa, sum(npw2) as npw, sum(tpw2) as tpw, sum(st12) as st1, sum(st22) as st2, sum(st32) as st3, sum(st42) as st4, sum(st52) as st5 
			from raw_stats 
			where player2 = pname
		) stats where stats.player is not null
	);
	SET x = x + 1;
	END WHILE;	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `summarizePlayerStatsAlt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `summarizePlayerStatsAlt`()
BEGIN
	DECLARE pname VARCHAR(45);
	DECLARE x INT;
	SET x = 1;
	WHILE(x<=(select max(id) from player_names)) DO
		select player_name from player_names where id = x into pname;
		insert into player_stats_alt (
		select stats.player, sum(matches), sum(stats.fnl)/sum(matches), avg(stats.fsp), avg(stats.fsw), avg(stats.ssp), avg(stats.ssw), avg(stats.wnrufe), sum(stats.ace)/sum(matches), sum(stats.dbf)/sum(matches), sum(stats.wnr)/sum(matches), sum(stats.ufe)/sum(matches), sum(stats.bpc)/sum(matches), sum(stats.bpw)/sum(matches), sum(stats.npa)/sum(matches), sum(stats.npw)/sum(matches), sum(stats.tpw)/sum(matches), sum(stats.st1)/sum(matches), sum(stats.st2)/sum(matches), sum(stats.st3)/sum(matches), sum(stats.st4)/sum(matches), sum(stats.st5)/sum(matches)
		from (
			select count(match_id) matches, player1 as player, sum(fnl1) as fnl, avg(fsp1) as fsp, avg(fsw1/((fsp1/100)*tpw1))*100 as fsw, avg(ssp1) as ssp, avg(ssw1/(tpw1-((fsp1/100)*tpw1)))*100 as ssw, avg(wnr1/ufe1) as wnrufe, sum(ace1) as ace, sum(dbf1) as dbf, sum(wnr1) as wnr, sum(ufe1) as ufe, sum(bpc1) as bpc, sum(bpw1) as bpw, sum(npa1) as npa, sum(npw1) as npw, sum(tpw1) as tpw, sum(st11) as st1, sum(st21) as st2, sum(st31) as st3, sum(st41) as st4, sum(st51) as st5 
			from raw_stats
			where player1 = pname
			union
			select count(match_id) matches, player2 as player, sum(fnl2) as fnl, avg(fsp2) as fsp, avg(fsw2/((fsp2/100)*tpw2))*100 as fsw, avg(ssp2) as ssp, avg(ssw2/(tpw2-((fsp2/100)*tpw2)))*100 as ssw, avg(wnr2/ufe2) as wnrufe, sum(ace2) as ace, sum(dbf2) as dbf, sum(wnr2) as wnr, sum(ufe2) as ufe, sum(bpc2) as bpc, sum(bpw2) as bpw, sum(npa2) as npa, sum(npw2) as npw, sum(tpw2) as tpw, sum(st12) as st1, sum(st22) as st2, sum(st32) as st3, sum(st42) as st4, sum(st52) as st5 
			from raw_stats 
			where player2 = pname
		) stats where stats.player is not null
	);
	SET x = x + 1;
	END WHILE;	
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

-- Dump completed on 2014-11-25 11:33:52
