-- phpMyAdmin SQL Dump
-- version 3.5.8.2
-- http://www.phpmyadmin.net
--
-- Host: mysqlsvr34.world4you.com
-- Erstellungszeit: 18. Dez 2013 um 22:18
-- Server Version: 5.5.32
-- PHP-Version: 5.3.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `2919695db1`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `skeletons`
--

CREATE TABLE IF NOT EXISTS `skeletons` (
  `client_ID` int(11) NOT NULL,
  `skeleton_ID` int(11) NOT NULL,
  `xPos` float NOT NULL,
  `zPos` float NOT NULL,
  `orientation` float NOT NULL,
  `tstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Daten für Tabelle `skeletons`
--

INSERT INTO `skeletons` (`client_ID`, `skeleton_ID`, `xPos`, `zPos`, `orientation`, `tstamp`) VALUES
(2, 42, -0.5, -0.24, 23, '2013-12-18 16:01:02'),
(2, 1, 0.6, 0.45, 30, '2013-12-18 16:00:05'),
(1, 24, 0, 0, 150.954, '2013-12-18 17:20:48');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
