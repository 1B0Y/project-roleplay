-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Oct 26, 2014 at 09:46 PM
-- Server version: 5.6.20
-- PHP Version: 5.5.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mta`
--

-- --------------------------------------------------------

--
-- Table structure for table `accountdata`
--

CREATE TABLE IF NOT EXISTS `accountdata` (
`id` int(11) NOT NULL COMMENT 'Unique ID',
  `username` varchar(255) NOT NULL COMMENT 'Player''s account ID',
  `name` tinytext NOT NULL COMMENT 'Key name',
  `value` text NOT NULL COMMENT 'Key value'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
`id` int(11) NOT NULL COMMENT 'Player''s unique account ID',
  `username` varchar(255) NOT NULL COMMENT 'Player''s username',
  `password` char(64) NOT NULL COMMENT 'Player''s password (encrypted)',
  `email` tinytext COMMENT 'Player''s email',
  `serial` char(32) DEFAULT NULL COMMENT 'Player''s serial.',
  `banned` tinyint(1) DEFAULT '0' NOT NULL COMMENT 'Is the player''s account banned?',
  `lastlogin` datetime NOT NULL COMMENT 'Player''s last login date'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accountdata`
--
ALTER TABLE `accountdata`
 ADD PRIMARY KEY (`id`);

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
 ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accountdata`
--
ALTER TABLE `accountdata`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID';
--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Player''s unique account ID';
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
