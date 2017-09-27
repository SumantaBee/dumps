-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 27, 2017 at 01:13 PM
-- Server version: 10.1.25-MariaDB
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aadarsh2`
--

DELIMITER $$
--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `getAdvRatingFromId` (`eid` INTEGER) RETURNS DECIMAL(3,2) BEGIN
	DECLARE e_rating DECIMAL(3,2);
    select calculated_rating into e_rating from employee_adv_rating where employee_id=eid and year=extract(year from current_date) and month=extract(month from current_date);
RETURN e_rating;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getAssignmentTitleFromId` (`aid` INT) RETURNS VARCHAR(80) CHARSET utf8 NO SQL
BEGIN
	DECLARE assignment_title varchar(80);
    select title into assignment_title from field_assignments where id=aid;
RETURN assignment_title;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getEIdFromAssignmentId` (`aid` INTEGER) RETURNS INT(11) BEGIN
	DECLARE eid INT;
    select employeeid into eid from field_assignments where id=aid;
RETURN eid;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getENameFromAid` (`aid` INTEGER) RETURNS VARCHAR(80) CHARSET utf8 BEGIN
	DECLARE ename varchar(80);
    select display_name into ename from employees where attendance_id=aid;
RETURN ename;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getNameFromId` (`eid` INTEGER) RETURNS VARCHAR(80) CHARSET utf8 BEGIN
	DECLARE displayname varchar(80);
    select display_name into displayname from employees where id=eid;
RETURN displayname;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getProjectNameFromId` (`pid` INTEGER) RETURNS VARCHAR(80) CHARSET utf8 BEGIN
	DECLARE projname varchar(80);
    select project_name into projname from projects where id=pid;
RETURN projname;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getProjectTypeFromId` (`pid` INT) RETURNS VARCHAR(80) CHARSET latin1 NO SQL
BEGIN
	DECLARE projtype varchar(80);
    select type into projtype from projects where id=pid;
RETURN projtype;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getRatingFromId` (`eid` INT) RETURNS INT(11) NO SQL
BEGIN
	DECLARE e_rating INTEGER;
    select rating into e_rating from employee_rating where employee_id=eid and year=extract(year from current_date) and month=extract(month from current_date);
RETURN e_rating;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getStatusCode` (`status_id` INTEGER) RETURNS VARCHAR(45) CHARSET utf8 BEGIN
	DECLARE status_code varchar(45);
    select status into status_code from project_allocation_status_cd where id=status_id;
RETURN status_code;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `getVehicleStatus` (`v_id` INT) RETURNS INT(11) NO SQL
BEGIN
	DECLARE expired_items INTEGER;
    select count(*) INTO expired_items from vehicle_attr where vehicle_id=v_id and end_on is null and expiry_dt is not null and expiry_dt <> '0000-00-00' and expiry_dt<current_date();
RETURN expired_items;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_supervisor` (`employee` INTEGER) RETURNS INT(11) BEGIN
	DECLARE SupervisorId INTEGER;
	SELECT 
    supervisor_id
INTO SupervisorId FROM
    employees
WHERE
    id = employee;
RETURN SupervisorId;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `isPLDaysValid` (`eid` INTEGER, `days` DOUBLE) RETURNS INT(11) BEGIN
	DECLARE balance double;
    DECLARE valid boolean;
    SET valid=false;
    SELECT pl_balance into balance from leave_balance where employee_id=eid;
    IF balance>=days then
		SET valid=true;
	END IF;
RETURN valid;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `isSLDaysValid` (`eid` INTEGER, `days` DOUBLE) RETURNS INT(11) BEGIN
	DECLARE balance double;
    DECLARE valid boolean;
    SET valid=false;
    SELECT sl_balance into balance from leave_balance where employee_id=eid;
    IF balance>=days then
		SET valid=true;
	END IF;
RETURN valid;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `new_function` (`employee` INTEGER) RETURNS INT(11) BEGIN
	DECLARE SupervisorId INTEGER;
	SELECT 
    supervisor_id
INTO SupervisorId FROM
    employees
WHERE
    id = employee;
RETURN SupervisorId;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `employeeid` int(11) NOT NULL,
  `shift` varchar(5) DEFAULT NULL,
  `in_time` time DEFAULT NULL,
  `out_time` time DEFAULT NULL,
  `work_dur` time DEFAULT NULL,
  `over_time` time DEFAULT NULL,
  `total_time` time DEFAULT NULL,
  `status` char(1) DEFAULT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`id`, `employeeid`, `shift`, `in_time`, `out_time`, `work_dur`, `over_time`, `total_time`, `status`, `date`) VALUES
(1, 16, NULL, '23:42:21', NULL, NULL, NULL, NULL, 'P', '0000-00-00'),
(2, 72, NULL, '00:31:55', NULL, NULL, NULL, NULL, 'P', '0000-00-00'),
(3, 8, NULL, '22:32:47', NULL, NULL, NULL, NULL, 'P', '0000-00-00'),
(4, 14, NULL, '20:48:35', NULL, NULL, NULL, NULL, 'P', '0000-00-00');

-- --------------------------------------------------------

--
-- Table structure for table `cdattributetp`
--

CREATE TABLE `cdattributetp` (
  `id` int(11) NOT NULL,
  `attribute_tp_cd` int(11) DEFAULT NULL,
  `description` varchar(80) DEFAULT NULL,
  `attribute_type` varchar(20) DEFAULT 'text',
  `group_name` varchar(20) DEFAULT 'basic'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `cdattributetp`
--

INSERT INTO `cdattributetp` (`id`, `attribute_tp_cd`, `description`, `attribute_type`, `group_name`) VALUES
(1, 100, 'Driver Phone Number', 'text', 'basic'),
(2, 101, 'Driving License No', 'text', 'basic'),
(3, 102, 'Helper Name', 'text', 'basic'),
(4, 103, 'Helper Number', 'text', 'basic'),
(5, 104, 'Registration Certificate', 'file', 'basic'),
(6, 105, 'Pollution Under Control Certificate (PUC)', 'file', 'basic'),
(7, 106, 'Tax Token', 'file', 'basic'),
(8, 107, 'National Permit', 'file', 'basic'),
(9, 108, 'PV Certificate', 'file', 'basic'),
(10, 109, 'Basic Good Permit', 'file', 'basic'),
(11, 110, 'Insurence', 'file', 'basic'),
(12, 111, 'Fitness Certificate', 'file', 'basic'),
(13, 112, 'Battery', 'file', 'basic'),
(14, 113, 'Fuel Tank', 'text', 'basic'),
(15, 114, 'Cabin Cleanliness', 'file', 'basic'),
(16, 115, 'Tyre L1', 'text', 'tyre'),
(17, 116, 'Tyre L2', 'text', 'tyre'),
(18, 117, 'Tyre L3', 'text', 'tyre'),
(19, 118, 'Tyre L4', 'text', 'tyre'),
(20, 119, 'Tyre L5', 'text', 'tyre'),
(21, 120, 'Tyre L6', 'text', 'tyre'),
(22, 121, 'Tyre L7', 'text', 'tyre'),
(23, 122, 'Tyre R1', 'text', 'tyre'),
(24, 123, 'Tyre R2', 'text', 'tyre'),
(25, 124, 'Tyre R3', 'text', 'tyre'),
(26, 125, 'Tyre R4', 'text', 'tyre'),
(27, 126, 'Tyre R5', 'text', 'tyre'),
(28, 127, 'Tyre R6', 'text', 'tyre'),
(29, 128, 'Tyre R7', 'text', 'tyre'),
(30, 129, 'Stepney Tyre', 'text', 'tyre'),
(31, 130, 'Driver License Photo[File]', 'file', 'basic'),
(32, 131, 'Form 47', 'file', 'basic');

-- --------------------------------------------------------

--
-- Table structure for table `challans`
--

CREATE TABLE `challans` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `assignment_id` int(11) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `data` text,
  `submitted_on` timestamp NULL DEFAULT NULL,
  `submitted_from` varchar(255) DEFAULT NULL,
  `challan_no` varchar(30) DEFAULT NULL,
  `challan_date` date DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `comment` text,
  `file_path` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `challans`
--

INSERT INTO `challans` (`id`, `project_id`, `assignment_id`, `type`, `data`, `submitted_on`, `submitted_from`, `challan_no`, `challan_date`, `approved_by`, `comment`, `file_path`) VALUES
(1, 3, 1, '', '[{\"field_name\":\"Vehicle No.\",\"value\":\"2585258\"},{\"field_name\":\"Goods Description\",\"value\":\"sand\"},{\"field_name\":\"Party Name\",\"value\":\"demo data\"}]', NULL, 'Kolkata', '12345678', '2017-04-15', 15, 'Approved', NULL),
(2, 1, 2, '', 'Hello sir testing', NULL, 'Kolkata', '8182872', '2017-04-15', 15, 'HELLO TESING', NULL),
(3, 1, 3, '', 'Hello world 1234567800', NULL, 'Kolkata', '6151819', '2017-04-15', 15, 'Submitted', '72704440e917fb4c03ebf30f21ac33df.jpg'),
(4, 1, 4, '', '[{\"field_name\":\"Vehicle No.\",\"value\":\"6565\"},{\"field_name\":\"Goods Description\",\"value\":\"gifuigh\"},{\"field_name\":\"Party Name\",\"value\":\"gghjh\"}]', NULL, 'Kolkata', 'ghfuut', '2017-04-17', 15, 'test', NULL),
(5, 1, 5, '', '[{\"field_name\":\"Vehicle No.\",\"value\":\"8769\"},{\"field_name\":\"Goods Description\",\"value\":\"flyash\"},{\"field_name\":\"Party Name\",\"value\":\"shayam steel\"}]', NULL, 'Kolkata', '67882827', '2017-04-16', 15, '', NULL),
(6, 1, 6, '', NULL, NULL, NULL, NULL, NULL, 15, '', NULL),
(7, 1, 7, '', '[{\"field_name\":\"Vehicle No.\",\"value\":\"8686\"},{\"field_name\":\"Goods Description\",\"value\":\"sand\"},{\"field_name\":\"Party Name\",\"value\":\"gggaa\"}]', NULL, 'Kolkata', '7838373', '2017-04-16', 16, '', NULL),
(8, 1, 8, '', '[{\"field_name\":\"Vehicle No.\",\"value\":\"8456\"},{\"field_name\":\"Goods Description\",\"value\":\"test\"},{\"field_name\":\"Party Name\",\"value\":\"airport city\"}]', NULL, 'Kolkata', '8363738', '2017-04-16', 15, '', NULL),
(9, 1, 9, '', '[{\"field_name\":\"Vehicle No.\",\"value\":\"8669\"},{\"field_name\":\"Goods Description\",\"value\":\"sand\"},{\"field_name\":\"Party Name\",\"value\":\"test\"}]', NULL, 'Kolkata', '92992', '2017-04-17', 15, '', NULL),
(10, 1, 10, '', '[{\"field_name\":\"Vehicle No.\",\"value\":\"6564\"},{\"field_name\":\"Goods Description\",\"value\":\"sand\"},{\"field_name\":\"Party Name\",\"value\":\"hihigigu\"}]', NULL, 'Kolkata', 'h78y68h', '2017-04-17', 16, 'test', NULL),
(11, 1, 11, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(12, 1, 12, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(13, 3, 13, 'Fly Ash', NULL, NULL, NULL, NULL, '2017-04-23', 16, '', NULL),
(14, 1, 14, '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(15, 1, 15, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(16, 1, 16, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(17, 1, 17, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(18, 1, 18, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(19, 1, 19, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(20, 1, 20, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(21, 1, 21, 'Fly Ash', '[{\"field_name\":\"Vehicle No.\",\"value\":\"WB20E4747\"},{\"field_name\":\"Goods Description\",\"value\":\"flyash\"},{\"field_name\":\"Party Name\",\"value\":\"test\"},{\"field_name\":\"Amount\",\"value\":\"65\"}]', NULL, 'Kolkata', '828891', '2017-04-24', 15, '', NULL),
(22, 1, 22, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(23, 1, 23, 'Fly Ash', '[{\"field_name\":\"Vehicle No.\",\"value\":\"wb20e4747\"},{\"field_name\":\"Goods Description\",\"value\":\"sand\"},{\"field_name\":\"Party Name\",\"value\":\"test party\"},{\"field_name\":\"Amount\",\"value\":\"65.96\"}]', NULL, 'Kolkata', 'wb9288t55', '2017-04-25', 15, '', NULL),
(24, 1, 24, 'Fly Ash', '[{\"field_name\":\"Vehicle No.\",\"value\":\"wb20e4747\"},{\"field_name\":\"Goods Description\",\"value\":\"sand\"},{\"field_name\":\"Party Name\",\"value\":\"test\"},{\"field_name\":\"Amount\",\"value\":\"68\"}]', NULL, 'Kolkata', '288382828', '2017-05-01', 15, '', 'uploads/04262017205348_500px-icon.png'),
(25, 1, 25, 'Fly Ash', '[{\"field_name\":\"Vehicle No.\",\"value\":\"wb20e4747\"},{\"field_name\":\"Goods Description\",\"value\":\"sand\"},{\"field_name\":\"Party Name\",\"value\":\"test\"},{\"field_name\":\"Amount\",\"value\":\"59\"}]', NULL, 'Kolkata', '188281', '2017-05-01', 15, '', NULL),
(26, 1, 26, 'Fly Ash', '[{\"field_name\":\"Vehicle No.\",\"value\":\"nn\"},{\"field_name\":\"Goods Description\",\"value\":\"bb\"},{\"field_name\":\"Party Name\",\"value\":\"mm\"},{\"field_name\":\"Amount\",\"value\":\"99\"}]', NULL, '1cb155321e74b923a972e1c8322d4827.jpg', 'mm', '2017-05-06', 15, 'ok', NULL),
(27, 1, 27, 'Fly Ash', '[{\"field_name\":\"Vehicle No.\",\"value\":\"ggg\"},{\"field_name\":\"Goods Description\",\"value\":\"ggg\"},{\"field_name\":\"Party Name\",\"value\":\"udifu\"},{\"field_name\":\"Amount\",\"value\":\"88\"}]', NULL, '4bd279f6abed33481ce69893118e6e55.jpg', 'yhrdhh', '2017-05-06', 15, '', NULL),
(28, 1, 28, 'Fly Ash', '[{\"field_name\":\"Vehicle No.\",\"value\":\"wb306t5657\"},{\"field_name\":\"Goods Description\",\"value\":\"flyash\"},{\"field_name\":\"Party Name\",\"value\":\"test\"},{\"field_name\":\"Amount\",\"value\":\"58\"}]', NULL, '495d150fb7d8ca4404ce1cd9ed1ce8d8.jpg', '7377rt5', '2017-05-08', 15, '', NULL),
(29, 1, 29, 'Fly Ash', '[{\"field_name\":\"Vehicle No.\",\"value\":\"wb382828t5\"},{\"field_name\":\"Goods Description\",\"value\":\"flyash\"},{\"field_name\":\"Party Name\",\"value\":\"bulker\"},{\"field_name\":\"Amount\",\"value\":\"68\"}]', NULL, '19e9e5eeae8b1b94c42ff64e933f4694.jpg', '82838w8w', '2017-05-08', 15, '', NULL),
(30, 1, 30, 'Fly Ash', '[{\"field_name\":\"Vehicle No.\",\"value\":\"wb29jdhy6\"},{\"field_name\":\"Goods Description\",\"value\":\"flyash\"},{\"field_name\":\"Party Name\",\"value\":\"test\"},{\"field_name\":\"Amount\",\"value\":\"68.9\"}]', NULL, '52441dcacd9a41604bd5bd2d3169c1c1.jpg', '172772727', '2017-05-28', 15, '', NULL),
(31, 1, 31, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32, 1, 32, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(33, 1, 33, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(34, 1, 34, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(35, 1, 35, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(36, 1, 36, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(37, 1, 37, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(38, 1, 38, 'Fly Ash', 'Hello test 22072017', NULL, NULL, NULL, NULL, 15, 'working', '8a76f59355cf04b6d44ad824a014bdbd.jpg'),
(39, 1, 39, 'Fly Ash', 'test test', NULL, NULL, NULL, NULL, 15, 'Done', '25daf0a94ffcf4e31945acc7673a12c4.jpg'),
(40, 1, 1, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(41, 1, 2, 'Fly Ash', 'Hello sir testing', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 1, 3, 'Fly Ash', 'Hello world 1234567800', NULL, NULL, NULL, NULL, NULL, NULL, '72704440e917fb4c03ebf30f21ac33df.jpg'),
(43, 1, 4, 'Fly Ash', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `first_name` varchar(80) NOT NULL,
  `last_name` varchar(80) NOT NULL,
  `employeeid` varchar(15) NOT NULL,
  `password` varchar(255) NOT NULL,
  `address` text,
  `emailid` varchar(150) DEFAULT NULL,
  `phone` varchar(15) NOT NULL,
  `phone1` varchar(15) DEFAULT NULL,
  `joinedon` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pan_card` varchar(45) DEFAULT NULL,
  `adhaar_card` varchar(45) DEFAULT NULL,
  `dob` date NOT NULL,
  `active` int(1) NOT NULL DEFAULT '1',
  `level` int(11) NOT NULL,
  `supervisor_id` int(11) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `blood_group` varchar(5) DEFAULT NULL,
  `fathers_name` varchar(100) DEFAULT NULL,
  `mothers_name` varchar(100) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `first_login` int(1) DEFAULT '1',
  `attendance_id` int(11) DEFAULT NULL,
  `addr_line_1` varchar(255) DEFAULT NULL,
  `addr_line_2` varchar(255) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `pincode` varchar(7) DEFAULT NULL,
  `country` varchar(15) DEFAULT NULL,
  `marital_status` varchar(25) DEFAULT NULL,
  `driving_license` varchar(45) DEFAULT NULL,
  `passport` varchar(45) DEFAULT NULL,
  `designation` varchar(30) DEFAULT NULL,
  `company` varchar(80) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `lat` varchar(45) DEFAULT NULL,
  `lng` varchar(45) DEFAULT NULL,
  `profile_pic` varchar(255) NOT NULL,
  `cv` varchar(255) NOT NULL,
  `token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `first_name`, `last_name`, `employeeid`, `password`, `address`, `emailid`, `phone`, `phone1`, `joinedon`, `pan_card`, `adhaar_card`, `dob`, `active`, `level`, `supervisor_id`, `display_name`, `blood_group`, `fathers_name`, `mothers_name`, `gender`, `first_login`, `attendance_id`, `addr_line_1`, `addr_line_2`, `city`, `pincode`, `country`, `marital_status`, `driving_license`, `passport`, `designation`, `company`, `project_id`, `lat`, `lng`, `profile_pic`, `cv`, `token`) VALUES
(12, 'KAILASH', 'AGARWAL', '1000005', '54321', NULL, 'kailash.agarwal@aadarshgroup.org', '8420116633', '8420116633', '2011-01-01 00:00:00', 'ACYPA1901E', '', '1962-01-07', 1, 1, 16, 'KAILASH AGARWAL', '', 'KANHAIYA LAL AGARWAL', '', 'M', 1, 17, '41 G.T.ROAD 29', '', 'HOWRAH', '711101', 'India', 'MARRIED', '', '', 'MARKETING EXECUTIVE', 'ATPL', 9, '', '', '', '', NULL),
(13, 'AKASH KUMAR', 'MISHRA', '1000004', '12345', NULL, 'akashm.mishra1@gmail.com', '9831172845', '9163311306', '2009-11-17 00:00:00', '', '751386648540', '1990-10-30', 1, 1, 16, 'AKASH KUMAR MISHRA', 'A+', 'RAJ NARAYAN MISHRA', '', 'M', 1, 26, '55/1,DHARMATALA ROAD', '', 'HOWRAH', '711106', 'India', 'MARRIED', '', '', 'SUPPORT-BILLING', 'ATPL', 6, '', '', '', '', NULL),
(14, 'VIKASH', 'PANDEY', '1000003', '12345', NULL, 'vikash.pandey@aadarshgroup.org', '7059783832', '7059783832', '2009-09-01 00:00:00', 'BENPP6985H', '', '1990-10-30', 1, 0, 16, 'VIKASH PANDEY', 'A+', 'ARVIND PANDEY', '', 'M', 1, 0, '43/4 NS ROAD ,RISHRA', '', 'HOOGHLY', '712248', 'India', 'UNMARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', '8de91a6d-a66b-43a4-9956-612bd1684d2a'),
(15, 'Mohit', 'Dokania', 'MOHITD', 'Mohit@123', NULL, 'mohitdokania@gmail.com', '9999', '000', '2017-03-12 00:00:00', '', '', '2017-03-12', 1, 4, NULL, 'Mohit Dokania', '', '', '', NULL, 1, 41, 'saltlake', '', 'kolkata', '000000', 'india', 'Maried', '', '', 'Director', NULL, NULL, '', '', '', '', 'ee318b7d-a259-40d1-9fd9-9ee8e5f83212'),
(16, 'Binata', 'Koruri', '1000020', 'Bin@ta', NULL, 'trishafz4u@gmail.com', '9874842480', '9831907858', '2015-10-05 00:00:00', '', '', '1986-12-05', 1, 3, 15, 'Binata Koruri', 'O+ve', 'Rajat Koruri', 'Mahamaya Koruri', 'F', 1, 20, '16, Rasick Mitra Lane, ', '', 'Kolkata', '700003', 'India', 'Single', '', '', 'HR - Head', '2Coms Consulting', 7, '', '', '', '', '47979fcf-4c3e-42c5-89ca-73befcd8a4db'),
(17, 'DIPAK', 'SHARMA', '1000001', '12345', NULL, 'deep0424@gmail.com', '9830604253', '9163311301', '2007-01-05 00:00:00', 'BQUPS5275C', '', '1984-07-24', 1, 1, 16, 'DIPAK SHARMA', '', 'ASHOK SHARMA', '', 'M', 1, 1, '152, Dharmutalla Road,Salkia', '', 'HOWRAH', '711106', 'India', 'UNMARRIED', '', '', 'HEAD OF BANKING & CASH', 'ATPL', NULL, '', '', '', '', NULL),
(18, 'RADHE KRISHNA', ' JILOKA', '1000002', '12345', NULL, 'radhekrishna.juluka@aadarshgroup.org', '9163311302', '9163311302', '2007-02-15 00:00:00', '', '', '1952-06-06', 1, 1, 16, 'RADHE KRISHNA  JULUKA', 'B+', '', '', 'M', 1, 13, '68,JESSORE ROAD DIAMOND CITY NORTH', '', 'KOLKATA', '700055', 'India', 'MARRIED', '', '', 'MAINTENANCE-ADMIN', 'ATPL', NULL, '', '', '', '', NULL),
(19, 'PINTU', 'KANTI', '1000009', '12345', NULL, 'pintukanti002@gmail.com', '8820883496', '8479908399', '2014-06-01 00:00:00', 'BJVPK488F', '858400686373', '1985-01-12', 1, 1, 16, 'PINTU KANTI', 'AB+', 'BAHURAN KANTI', '', 'M', 1, 40, '311/A SHYAM NAGAR ROAD OPP SHELLY CINEMA', '', 'DUMDUM', '700055', 'India', 'MARRIED', '', '', 'INCHARGE SITE', 'ATPL', 6, '', '', '', '', NULL),
(20, 'ASHOK KUMAR', 'TIWARI', '1000008', '12345', NULL, 'ashok.tiwari@aadarshgroup.org', '9163311305', '9163311305', '2013-10-01 00:00:00', '', '', '1965-01-22', 1, 1, 16, 'ASHOK KUMAR TIWARI', 'A+', 'LATE RAJENDRA TIWARY', '', 'M', 1, 0, 'Vill:Karath,PO:Karath,PS:Tarari,Dist:Bhojpur', 'BIHAR', 'BHOJPUR', '802205', 'India', 'WIDOWER', '', '', 'MANAGER-TRASPORT', 'ATPL', NULL, '', '', '', '', NULL),
(21, 'DIPANTI', 'SHAW', '1000010', '12345', NULL, 'sdipanti@gmail.com', '9038583358', '9007011325', '2014-07-01 00:00:00', 'CIAPS0644C', '', '1986-10-21', 1, 1, 16, 'DIPANTI SHAW', 'AB+', 'SURESH SHAW', '', 'F', 1, 19, 'P/56 CIT ROAD KMC ENTALLY', '', 'KOLKATA', '700014', 'India', 'UNMARRIED', '', '', 'EXECUTIVE-ACCOUNTANT', 'ATPL', 3, '', '', '', '', NULL),
(22, 'RATAN', 'GHOSH', '1000012', '12345', NULL, 'ratan.ghosh@aadarshgroup.org', '9088036356', '7044033576', '2014-09-19 00:00:00', '', '', '1962-01-09', 1, 1, 16, 'RATAN GHOSH', 'O+', 'LATE TARAPADA GHOSH', '', 'M', 1, 0, 'BOREHAT KALITALA,GOLEPUKUR', '', 'BURDWAN', '713102', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', 2, '', '', '', '', NULL),
(23, 'SANISH KUMAR', 'PANDEY', '1000015', '12345', NULL, 'sanishpandey5@gmail.com', '8276864025', '9163311386', '2015-03-16 00:00:00', 'CPQPP8638N', '', '1992-10-17', 1, 1, 16, 'SANISH KUMAR PANDEY', '', 'BAID KISHORE PANDEY', '', 'M', 1, 2, '24 NETAJI SUBHASH ROAD,RISHRA,HOOGHLY', '', 'RISHRA', '712248', 'India', 'UNMARRIED', '', '', 'OFFICE STAFF', 'ATPL', NULL, '', '', '', '', NULL),
(24, 'DIVAKAR', 'UPADHYAY', '1000031', '12345', NULL, 'divakarupadhyay1995@gmail.com', '9062362529', '7563963824', '2015-03-31 00:00:00', '', '', '1995-11-10', 1, 1, 16, 'DIVAKAR UPADHYAY', '', 'HARE KRISHNA UPADHYAY', 'MADHURI DEVI', 'M', 1, 0, 'DAMARUAN,PO:WAYNA,jAMUNIPUR,PS AGIAONBAZAR.DIST: BHOJPUR', '', 'ARAH', '802155', 'India', 'UNMARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(25, 'DONA', 'KHAITAN', '1000016', '12345', NULL, 'dona.khaitan@aadarshgroup.org', '8334040339', '9007011327', '2015-04-27 00:00:00', 'CODPK4081A', '', '1992-07-20', 1, 1, 16, 'DONA KHAITAN', 'AB+', 'RAMESH KHAITAN', '', 'F', 1, 10, '309/1SAHID HEMANTA KUMAR BOSE SARANI', '', 'KOLKATA', '700074', 'India', 'UNMARRIED', '', '', 'JUNIOR ACCOUNTANT', 'ATPL', NULL, '', '', '', '', NULL),
(26, 'VISHAL ', 'SHARMA', '1000018', '12345', NULL, 'vishal.sharma@aadarshgroup.org', '9874799167', '9163311390', '2015-05-04 00:00:00', 'BMWPS4932A', '', '1982-05-18', 1, 1, 16, 'VISHAL  SHARMA', '', 'SAMPAT SHARMA', '', 'M', 1, 0, '506,G.T. ROAD', '', 'HOWRAH', '711101', 'India', 'MARRIED', '', '', 'EXECUTIVE-MARKETING', 'ATPL', 7, '', '', '', '', NULL),
(27, 'PIYALI', 'SHAW', '1000019', '12345', NULL, 'ghoshtiyasha20@gmail.com', '9836392572', '7003724215', '2015-03-15 00:00:00', '', '492182261858', '1987-07-16', 0, 1, 16, 'PIYALI SHAW', '', 'RAKESH SHAW', '', 'F', 1, 0, 'NICHUPALLY,MAJHERGHAT RASTA,HOOGHLY', '', 'CHANDANNAGAR', '712136', 'India', 'MARRIED', '', '', 'FRONT OFFICE', 'ATPL', NULL, '', '', 'cf5bea1e87dfeac06cdbc4af05439d4a.png', '94d36fb124a4ea6c3d6bcc821d2dfd47.pdf', NULL),
(28, 'NEHA', 'AGARWAL', '1000023', '12345', NULL, 'neha.agarwal@aadarshgroup.org', '9007483708', '9163311387', '2016-01-18 00:00:00', 'AUFPA3409E', '', '1987-10-31', 0, 1, 16, 'NEHA AGARWAL', 'O+', 'KAMAL AGARWAL', '', 'F', 1, 0, '31,G.T. ROAD,HOWRAH MUNICIPALITY CORPORATION,GOLABARI', '', 'HOWRAH', '711101', 'India', 'UNMARRIED', '', '', 'SENIOR ACCOUNTANT', 'ATPL', NULL, '', '', '', '', NULL),
(29, 'SUKUMAR', 'JANA', '1000024', '12345', NULL, 'sukumar.jana@aadarshgroup.org', '8479908405', '8479908405', '2015-04-01 00:00:00', 'AWZPJ0878J', '', '1983-11-16', 0, 1, 16, 'SUKUMAR JANA', 'A+', 'ANANDA JANA', '', 'M', 1, 0, 'DAKSHIN NANDABHANGA NARAYANPUR KAKDWIP', 'SOUTH 24 PARAGANA', 'KAKDWIP', '743357', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(30, 'SURAJ', 'SHARMA', '1000025', '12345', NULL, 'suraj.sharma@aadarshgroup.org', '9163311307', '9163311307', '2013-01-01 00:00:00', 'EWDPS9375B', '', '1982-07-12', 1, 1, 16, 'SURAJ SHARMA', '', 'ASHOK SHARMA', '', 'M', 1, 0, '152, Dharmutalla Road,Salkia', '', 'HOWRAH', '711106', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(31, 'SUVANKAR', 'HAZRA', '1000026', '12345', NULL, 'suvankar.hazra@aadarshtradlink.org', '9163311303', '9163311303', '2015-05-08 00:00:00', '', '', '1994-03-30', 1, 1, 16, 'SUVANKAR HAZRA', '', 'DIBAKAR HAZRA', '', 'M', 1, 0, 'BETAI CHANDITALA,BETAI,AMTA', '', 'HOWRAH', '711401', 'India', 'UNMARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(32, 'ALOK ', 'TIWARI', '1000028', '12345', NULL, 'alokkr15@rediffmail.com', '7324011912', '9163311310', '2015-06-15 00:00:00', '', '', '1991-01-15', 0, 1, 16, 'ALOK  TIWARI', '', 'DHIRENDRA NATH TIWARI', '', 'M', 1, 0, 'VILL+POST+P.S:KORAN SARAL,BUXAR', '', 'BIHAR', '802126', 'India', 'UNMARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(33, 'AJAY', 'SHAW', '1000032', '12345', NULL, 'ajay.shaw@aadarshgroup.org', '8653593232', '9163311389', '2016-09-01 00:00:00', 'BNTPS7279A', '', '1977-10-13', 1, 1, 16, 'AJAY SHAW', '', 'SIPAHI SHAW', '', 'M', 1, 0, 'SUKCHAR RAJA BASTI CLUB,PO:SUKCHAR,PS:KHARDAH', '', 'NORTH 24 PARAGANA', '700115', 'India', 'MARRIED', '', '', 'STORE INCHARGE', 'ATPL', NULL, '', '', '', '', NULL),
(34, 'SUJAN ', 'GHOSH', '1000033', '12345', NULL, 'sujan.ghosh@aadarshgroup.org', '7044033574', '7044033574', '2015-09-08 00:00:00', 'BNSPG3689M', '', '1995-09-19', 0, 2, NULL, 'SUJAN  GHOSH', '', 'SANTINATH GHOSH', '', 'M', 1, 0, 'VILL:JARA,PO:JARA,PS:CHANDRAKONA', '', 'PASCHIM MIDNAPUR', '721232', 'India', 'UNMARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(35, 'MUKESH', 'TIWARI', '1000034', '12345', NULL, 'mukesh.tiwari@aadarshgroup.org', '9062006686', '9570919290', '2015-12-15 00:00:00', 'ATAPT2843H', '', '1992-02-05', 1, 1, 16, 'MUKESH TIWARI', '', 'RAM NARAYAN TIWARI', '', 'M', 1, 0, 'VILL+PO+PS:KHURANSARAI,BUXAR', '', 'BIHAR', '802126', 'India', 'UNMARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(36, 'SHUKLA', 'SAHA', '1000035', '12345', NULL, 'shukla.saha@aadarshgroup.org', '7688045305', '7688045305', '2015-05-02 00:00:00', 'GOZPS1087C', '945181966130', '1982-08-14', 1, 1, 16, 'SHUKLA SAHA', '', 'BIBHUTI BHUSHAN RAY', '', 'F', 1, 14, '9 KGRS PATH 1 NO BANGASHRI PALLY,CHAMPDANI ANGUS,HOOGHLY', '', 'HOOGHLY', '712221', 'India', 'WIDOW', '', '', 'HOUSE KEEPING', 'ATPL', NULL, '', '', '', '', NULL),
(37, 'BAPI', 'ROY', '1000037', '12345', NULL, 'roybapimd@gmail.com', '7908467792', '7908467792', '2016-02-03 00:00:00', 'CBIPR6828Q', '', '1989-02-05', 1, 1, 16, 'BAPI ROY', '', 'NABAKANTA ROY', '', 'M', 1, 0, 'BAJRAPUKUR(MADHYA) , BAJRAPUKUR TAPAN,DAKSHIN DINAJPUR', '', 'DAKSHIN DINAJPUR', '733142', 'India', 'UNMARRIED', '', '', 'QA/QC', 'ATPL', NULL, '', '', '', '', NULL),
(38, 'ARUN', 'KUMAR', '1000038', '12345', NULL, 'arunkumar424@yahoo.com', '9163792468', '9163311399', '2016-03-01 00:00:00', '', '', '1977-02-09', 0, 1, 16, 'ARUN KUMAR', '', 'RANJAN KUMAR NAYAK', '', 'M', 1, 0, 'KIRIBABU,MAIN MARKET COMPLEX,DIST.W.SINGHBHUM,JHARKHAND', '', 'JHARKHAND', '768202', 'India', 'MARRIED', '', '', 'HR-COORDINATOR', 'ATPL', NULL, '', '', '', '', NULL),
(39, 'BIDYUT', 'UKIL', '1000040', '12345', NULL, 'bidyutkumarukil@rediffmail.com', '9903544317', '9831598005', '2015-12-16 00:00:00', '', '504950704581', '1966-12-04', 0, 1, 16, 'BIDYUT UKIL', '', 'MR UKIL', '', 'M', 1, 0, 'PLOT NO.29,EAST SANTOSHPUR,HOUSING CO-OP SOCIETY,1815 MUKUNDAPUR,SOUTH 24 PARAGANA', '', 'S 24 PARAGANA', '700099', 'India', 'MARRIED', '', '', 'HEAD CIVIL', 'ANISH', NULL, '', '', '', '', NULL),
(40, 'SADHANA ', 'JAISWAL', '1000041', '12345', NULL, 'sadhana.jaiswal29@gmail.com', '9903891118', '9903891118', '2015-12-16 00:00:00', 'AIUPJ5669C', '', '1985-04-29', 1, 1, 16, 'SADHANA  JAISWAL', '', 'RAMDHARI JAISWAL', '', 'F', 1, 5, '4B RAJENDRA DEB ROAD ', '', 'KOLKATA', '700007', 'India', 'MARRIED', '', '', 'SR ACCOUNTANT', 'ATPL', 4, '', '', '', '', NULL),
(41, 'ANIL', 'SHAW', '1000042', '12345', NULL, 'anils2413@gmail.com', '9143735316', '7044751103', '2016-05-23 00:00:00', 'BPOPS6003R', '', '1982-02-10', 0, 1, NULL, 'ANIL SHAW', '', 'BALDEO PRASAD SHAW', '', 'M', 1, 0, '30BHAGABAN MONDAL STREET 8,ARIADAHA BELGHARIA NORTH 24 PARAGANA', '', 'N 24 PARAGANA', '700057', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(43, 'AMAR ', 'SHAW', '1000043', '12345', NULL, 'amarshaw91@gmail.com', '9874824724', '8274001020', '2016-11-07 00:00:00', 'DDFPS7943F', '', '1990-01-01', 0, 1, 16, 'AMAR  SHAW', '', 'PANNALAL SHAW', '', 'M', 1, 0, 'KUMARDINGI PANCHANANTALA,RISHRA,PO-MOREPUKUR', '', 'RISHRA', '712250', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(44, 'SANKET', 'TULSHYAN', '1000045', '12345', NULL, 'tsanket27@gmail.com', '9038155997', '9007011328', '2016-06-09 00:00:00', 'AJZPT6054B', '', '1989-07-27', 1, 1, 16, 'SANKET TULSHYAN', 'O+', 'SUBHASH TULSHYAN', '', 'M', 1, 32, 'GOODS SED PARA KULTI BURDWAN', '', 'BURDWAN', '713324', 'India', 'UNMARRIED', '', '', 'OPERATIONS-ADMIN', 'ATPL', NULL, '', '', '', '', NULL),
(45, 'UMESH ', 'YADAV', '1000013', '12345', NULL, 'umesh.yadav@aadarshgroup.org', '8145984920', '8479908397', '2014-10-01 00:00:00', 'AMCPY5148F', '', '1995-12-20', 1, 1, 16, 'UMESH  YADAV', '', 'RAMBRIKSH RAY', '', 'M', 1, 0, 'TURKAUFIYA,VILL-BALUA,ANCHAL-DHAKA,DIST-EAST CHAMPARAN', '', 'EAST CHAMPARAN', '845418', 'India', 'UNMARRIED', '', '', 'SUPERVISOR', 'ATPL', 3, '', '', '', '', NULL),
(46, 'SONU', 'GUPTA', '1000047', '12345', NULL, 'meetsonukumar37@gmail.com', '7050886294', '7044033573', '2016-01-08 00:00:00', '', '835169555138', '1990-11-15', 0, 1, 16, 'SONU GUPTA', '', 'CHITTARANJAN PRASAD GUPTA', '', 'M', 1, 0, 'VILL+PO-HIRANPUR,DIST-PAKUR', '', 'JHARKHAND', '816104', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(47, 'SARVJIT', 'SINGH', '1000048', '12345', NULL, 'sarvjit1975@gmail.com', '8442957741', '7044033579', '2016-08-19 00:00:00', 'DAPPS7855M', '', '1975-04-12', 1, 1, 16, 'SARVJIT SINGH', '', 'KAMTA PRASAD SINGH', '', 'M', 1, 0, 'ABHATPRA,PO-SANDESH,DIST-BHOJPUR(ARA) BIHAR', '', 'BIHAR', '802164', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(48, 'CHANDRADEV', 'YADAV', '1000046', '12345', NULL, 'chandradev.yadav@aadarshgroup.org', '9903970724', '8479908404', '2016-07-20 00:00:00', '', '', '1983-01-01', 1, 1, 16, 'CHANDRADEV YADAV', '', 'LAKHKHAN YADAV', '', 'M', 1, 0, '154,Gaon-Laudhiya Ghasita,Town/Vill-Basamata,Anchal-Belhar,Dist-Banka,PO- Basamata', '', 'Basamata', '813202', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(49, 'TUHIN', 'HAZRA', '1000049', '12345', NULL, 'tuhin.hazra@aadarshgroup.org', '9932813045', '9932813045', '2016-09-01 00:00:00', 'AGVPH4307E', '965680396259', '1989-05-04', 1, 1, 16, 'TUHIN HAZRA', '', 'AJIT HAZRA', '', 'M', 1, 34, 'HARIHAR,DEBKHANDA HOOGHLY', '', 'HOOGHLY', '712614', 'India', 'UNMARRIED', '', '', 'OFFICE STAFF', 'ATPL', NULL, '', '', '', '', NULL),
(50, 'SUMAN', 'MALIK', '1000050', '12345', NULL, 'suman.malik@aadarshgroup.org', '7872939972', '7872939972', '2016-09-15 00:00:00', 'BXLPM3342J', '533308474007', '1993-08-05', 0, 1, 16, 'SUMAN MALIK', '', 'MADHUSUDAN MALIK', '', 'M', 1, 0, 'GOPALPUR,JANGIPARA,HOOGHLY', '', 'HOOGHLY', '712403', 'India', 'UNMARRIED', '', '', 'SURVEYOR', 'ATPL', NULL, '', '', '', '', NULL),
(51, 'GOPAL ', 'CHAKRABORTY', '1000053', '12345', NULL, 'gc.chakraborty@yahoo.com', '9836581144', '9836581144', '2016-12-05 00:00:00', 'AEFPC4196J', '371431789351', '1964-10-13', 0, 1, 16, 'GOPAL  CHAKRABORTY', 'O+', 'AMIYA CHAKRABORTY', '', 'M', 1, 0, '2/36B,BIJOYGARH,JADAVPUR', '', 'KOLKATA', '700032', 'India', 'MARRIED', '', '', 'MARKETING EXECUTIVE', 'ATPL', NULL, '', '', '', '', NULL),
(52, 'DHARAM PAL', 'SINHA', '1000054', '12345', NULL, 'dpsinha1961@gmail.com', '9062006690', '9007011326', '2016-09-15 00:00:00', 'BRAPS1571A', '682948836563', '1961-01-21', 1, 1, 16, 'DHARAM PAL SINHA', '', 'RAM KISHOR CHOUDHARY', '', 'M', 1, 0, 'VILL+PO-KOKILA,JAGDISHPUR BHOJPUR,BIHAR', '', 'BIHAR', '802158', 'India', 'MARRIED', '', '', 'SR CIVIL ENGINEER', 'ATPL', NULL, '', '', '', '', NULL),
(53, 'ABHIJIT', 'DAS', '1000055', '12345', NULL, 'dasabhi196@gmail.com', '9439879539', '9439879539', '2016-10-03 00:00:00', 'AEGPD8630K', '978902448613', '1964-05-01', 0, 1, 16, 'ABHIJIT DAS', '', 'LATE GORA CHAND DAS', '', 'M', 1, 0, 'SASTITALA, KUMAR PARA GHAT LANE,KRISHNA NAGAR', '', 'KRISHNA NAGAR', '741101', 'India', 'MARRIED', '', '', 'SR CIVIL ENGINEER', 'ATPL', NULL, '', '', '', '', NULL),
(54, 'KAILASH', 'SHARMA', '1000056', '12345', NULL, 'kailash.sharma@aadarshgroup.org', '9051636925', '9051636925', '2016-10-17 00:00:00', '', '210375253354', '1957-01-01', 1, 1, 16, 'KAILASH SHARMA', '', 'RAMPRATAP SHARMA', '', 'M', 1, 35, '132,DESHABNDHU ROAD,BARANAGAR,NORTH 24 PARAGANA', '', 'NORTH 24 PARAGANA', '700035', 'India', 'MARRIED', '', '', 'OFFICE STAFF', 'ATPL', NULL, '', '', '', '', NULL),
(55, 'PRITAM ', 'GHOSH', '1000044', '12345', NULL, 'pritam.ghosh36011@gmail.com', '8016030837', '8016030837', '2016-05-18 00:00:00', '', '', '1995-02-04', 0, 1, 16, 'PRITAM  GHOSH', '', 'ACHINYA GHOSH', '', 'M', 1, 0, 'VILL-LAKSHANPUR,PO-LAKSHANPUR,PS-GHATAL,DIST-PASCHIM MEDINIPUR', '', 'PASCHIM MEDINIPUR', '721222', 'India', 'UNMARRIED', '', '', 'SURVEYOR', 'ATPL', NULL, '', '', '', '', NULL),
(56, 'SOUMEN', 'KARMAKAR', '1000057', '12345', NULL, 'soumen.karmakar@aadarshgroup.org', '9836051641', '7044033577', '2016-10-17 00:00:00', 'BNVPK3694M', '343137743047', '1983-11-18', 1, 1, 16, 'SOUMEN KARMAKAR', '', 'BHOLA NATH KARMAKAR', '', 'M', 1, 36, 'NANGI STATION PALLY,7 GREEN PARK,MAHESHTALA(M)SOUTH 24 PARAGANAS,BATANAGAR', '', 'SOUTH 24 PARAGANA', '700140', 'India', 'MARRIED', '', '', 'PEON', '', NULL, '', '', '', '', NULL),
(57, 'ASIM', 'DAS', '1000036', '12345', NULL, 'asim.das@aadarshgroup.org', '8420636029', '9163311385', '2015-03-01 00:00:00', 'CKMPD7219Q', '', '1974-01-10', 1, 1, 16, 'ASIM DAS', '', 'LATE DHIREN DAS', '', 'M', 1, 0, '39/H/8 SATIN SEN SARANI,MANIKTOLA', '', 'KOLKATA', '700006', 'India', 'MARRIED', '', '', 'PEON', 'ATPL', NULL, '', '', '', '', NULL),
(58, 'SAROJ KUMAR', 'GUPTA', '1000058', '12345', NULL, 'sarojkg.gupta@gmail.com', '9830255207', '9563552091', '2016-10-24 00:00:00', 'ATKPG2256R', '', '1983-12-15', 0, 1, 16, 'SAROJ KUMAR GUPTA', '', 'RAJKUMAR GUPTA', '', 'M', 1, 0, 'KATOWA ROAD,SUBHAS PALLY,BAJEPROTAPPUR,BURDWAN', '', 'BURDWAN', '713101', 'India', 'MARRIED', 'WB-4120140', '', 'JR.ACCOUNTANT', 'ATPL', NULL, '', '', '', '', NULL),
(59, 'AVINAVA', 'CHATTERJEE', '1000059', '12345', NULL, 'avinava.chatterjee@gmail.com', '8013691497', '8013691497', '2016-11-01 00:00:00', 'ANGPC4712L', '566005113733', '1990-02-24', 0, 1, 16, 'AVINAVA CHATTERJEE', '', 'ASHOK CHATTERJEE', '', 'M', 1, 4, 'A-40,RABINDRA PALLY,USHOSHI APARTMENT,BRAHMAPUR,BADAMTALA', '', 'KOLKATA', '700096', 'India', 'MARRIED', '', '', 'SR.ACCOUNTANT', 'ATPL', NULL, '', '', '', '', NULL),
(60, 'CHANDAN', 'PANDEY', '1000060', '12345', NULL, 'chandan.pandey2407@gmail.com', '8479908401', '7278227213', '2017-01-15 00:00:00', 'BENPP6986E', '588034349087', '1991-07-24', 1, 1, 16, 'CHANDAN PANDEY', '', 'ARBIND PANDEY', '', 'M', 1, 0, '51/73 NS ROAD ,RISHRA RAILWAY STATION,BANGUR PARK, HOOGHLY', '', 'HOOGHLY', '712248', 'India', 'UNMARRIED', '', '', 'OFFICE STAFF', 'ATPL', NULL, '', '', '', '', NULL),
(61, 'SUMIT KUMAR', 'CHOUBEY', '1000017', '12345', NULL, 'sumitchoubey2020@gmail.com', '8961393932', '8961393932', '2016-05-01 00:00:00', 'AROPC8175F', '575563867195', '1987-10-10', 1, 1, 16, 'SUMIT KUMAR CHOUBEY', '', 'SUNIL CHOUBEY', '', 'M', 1, 31, 'GRAM-GOSAINDASPUR,PO-CHAMPANAGAR,VILL-GOSAINDASPUR,DIST-BHAGALPUR,NATHNAGAR,BIHAR', '', 'BIHAR', '812006', 'India', 'UNMARRIED', '', '', 'ACCOUNTS EXECUTIVE', 'ATPL', NULL, '', '', '', '', NULL),
(62, 'GUDDU', 'KUMAR', '1000014', '12345', NULL, 'guddu.prasad@aadarshgroup.org', '9163311304', '9163311304', '2016-04-11 00:00:00', 'CFIPK0567H', '', '1990-05-12', 1, 1, 16, 'GUDDU KUMAR', '', 'KAPILDEO PRASAD', '', 'M', 1, 0, '55/2 DHARMATALA ROAD,HOWRAH MUNICIPAL CORP,MALIPANCHGHARA', '', 'HOWRAH', '711106', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(63, 'MANISH KUMAR', 'GUPTA', '1000007', '12345', NULL, 'manishji251193@gmail.com', '7044751104', '7044751104', '2016-07-06 00:00:00', '', '638235841539', '1993-01-01', 1, 1, 16, 'MANISH KUMAR GUPTA', '', 'JANGI LAL GUPTA', '', 'M', 1, 0, 'VILL-UPADHYAY KA PURA,PO-RAMNAGAR,UNCHDIH,ALLAHABAD,UP', '', 'ALLAHABAD', '212305', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(64, 'SOURAV ', 'PANJA', '1000051', '12345', NULL, 'sourav.panja@aadarshgrou.org', '8620881849', '8620881849', '2016-09-15 00:00:00', 'CITPP5810Q', '702858943875', '1995-01-01', 0, 1, 16, 'SOURAV  PANJA', '', 'SAMIR KUMAR PANJA', '', 'M', 1, 0, 'SHASHPUR,BANKI,BANKURA', '', 'BANKURA', '722205', 'India', 'UNMARRIED', '', '', 'SURVEYOR', 'ATPL', NULL, '', '', '', '', NULL),
(65, 'SHAILENDRA KUMAR', 'MISHRA', '1000011', '12345', NULL, 'shailendra.mishra@aadarshgroup.org', '7044751101', '7044751101', '2016-07-06 00:00:00', 'AZSPM5566A', '', '1967-01-07', 1, 1, 16, 'SHAILENDRA KUMAR MISHRA', '', 'DEVTADIN MISHRA', '', 'M', 1, 0, '49 BHIKHARI RAMPUR,BHIKHARIPUR,SURIYAWAN,BHADOHI,SANT RAVIDAS NAGAR,UP', '', 'UP', '221404', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(66, 'DHARMENDRA', 'KUMAR', '1000006', '12345', NULL, 'dharmendrajangir139@gmail.com', '7044751102', '7044751102', '2016-07-06 00:00:00', '', '', '1994-06-08', 0, 1, 16, 'DHARMENDRA KUMAR', '', 'JAGDISH PRASAD', '', 'M', 1, 0, 'BHAWANIPUR,BUHANA,JHUNJHUNU', '', 'RAJASTAN', '	333502', 'India', 'UNMARRIED', 'RJ18201500', '', 'SUPERVISOR', 'ATPL', NULL, '', '', '', '', NULL),
(67, 'JADAV', 'BARMAN', '1000021', '12345', NULL, 'jadav.burman@aadarshgroup.org', '8420116630', '8697182981', '2015-05-01 00:00:00', '', '', '1975-08-07', 1, 1, 16, 'JADAV BARMAN', '', '', 'GURUDASI BARMAN', 'M', 1, 0, 'RAJARHAT GOPALPUR,RAMNAGAR BERABERI,AIRPORT,NORTH 24 PARAGANAS', '', 'NORTH 24 PARAGANA', '700136', 'India', 'MARRIED', '', '', 'DRIVER', 'ATPL', NULL, '', '', '', '', NULL),
(68, 'BIKASH', 'PANDIT', '1000022', '12345', NULL, 'bikash.pandit@aadarshgroup.org', '9073432942', '9073432942', '2016-11-18 00:00:00', 'CXXPP8358N', '668697561463', '1996-03-05', 0, 1, 16, 'BIKASH PANDIT', '', 'CHIGAR PANDIT', '', 'M', 1, 0, 'SONARPUR(M),SOUTH 24 PARAGANAS', '', 'SOUTH 24 PARAGANA', '700152', 'India', 'UNMARRIED', '', '', 'DRIVER', 'ATPL', NULL, '', '', '', '', NULL),
(69, 'SATYARANJAN ', 'PANDA', '1000052', '12345', NULL, 'spanda288@gmail.com', '8479955659', '8457834616', '2016-09-15 00:00:00', 'CYKPP1698K', '634793858430', '1994-06-05', 0, 2, 16, 'SATYARANJAN  PANDA', '', 'BICHITRA PANDA', '', 'M', 1, 0, 'KESPUR,BHADRAK', '', 'ORISSA', '756128', 'India', 'MARRIED', '', '', 'OPERATOR', 'ATPL', NULL, '', '', '', '', NULL),
(70, 'Nitesh', 'Himatsingka', 'NITESHD', '2244', NULL, 'nkhimat@gmail.com', '9999999999', '9999999999', '2017-03-31 00:00:00', '', '', '1975-01-01', 1, 4, NULL, 'Nitesh Himatsingka', '', '', '', 'M', 1, 6, 'Kolkata', '', 'KOLKATA', '700001', 'India', 'Married', '', '', 'Director', 'Aadarsh', 9, '', '', '', '', NULL),
(71, 'Jhone', 'Smith', '333', '123456', NULL, 'jhon@gmail.com', '9999999999', '8888888888', '2017-04-06 00:00:00', '0000000000', '0000000000000000', '2017-04-06', 1, 0, 16, 'Jhone Smith', 'AB+', 'Jack Smith', 'Rita Smith', 'M', 1, 333, 'KOLKATA', 'Baguiati', 'KOLKATA', '700102', 'India', 'Married', '0000000000', '000000000', 'Ground Staff', 'Aadarsh', NULL, '', '', '', '', ''),
(72, 'Level', 'Zero', '12345678', '123456', NULL, 'jhon@gmail.com', '0000000000', '0000000000', '2017-04-15 00:00:00', '0000000000', '1234567890', '2017-04-15', 1, 0, 16, 'Level Zero', 'O+', 'Jack', 'Rita', 'M', 1, 128, 'test', 'test', 'KOLKATA', '700101', 'India', 'Single', '1234567890', '000000000', 'Field employee', 'Aadarsh', 6, '', '', '', '', 'ee318b7d-a259-40d1-9fd9-9ee8e5f83212'),
(73, 'Shyamlal', 'Sharma', '500001', '1234', NULL, 'shyamlal@gmail.com', '1234', '1234', '2017-04-24 00:00:00', '', '', '1980-04-01', 1, 0, 16, 'Shyamlal Sharma', '', '', '', 'M', 1, 0, 'Kolkata', '', 'Kolkata', '700101', 'India', 'Single', '', '', 'Field Associate', '', NULL, NULL, NULL, '', '', NULL),
(74, 'SUCHANDRA ', 'SAHA', '1000061', '12345', NULL, 'suchandrasaha21@gmail.com', '8013988216', '8013988216', '2017-04-10 00:00:00', 'EJYPS1281J', '', '1989-05-21', 1, 1, NULL, 'SUCHANDRA  SAHA', '', 'SOMESH SAHA', 'binata koruri', 'F', 1, 3, 'Vill.Sripur,P.O. Sripur Bazar,Dist.Hooghly Pin:712514', '41/4A Bagbazar Street,', 'kolkata', '700003', 'India', 'SINGLE', '', '', 'FRONT OFFICE', 'ATPL', NULL, NULL, NULL, '', '', NULL),
(75, 'KABITA ', 'PASWAN', '1000062', '12345', NULL, 'kabita.paswan66@gmail.com', '09874661764', '09830390846', '2017-03-09 00:00:00', 'ZZC0185983', '269278828645', '1989-10-02', 1, 1, 16, 'KABITA  PASWAN', '', 'MR.RAM CH. PASWAN', '', 'F', 1, 4, '3/4A ARABINDA NAGAR ', '', 'KOLKATA', '700040', 'India', 'SINGLE', '', '', 'EXECUTIVE ACCOUNTANT', 'ATPL', NULL, NULL, NULL, '', '', NULL),
(76, 'RAKESH ', 'KUMAR', '1000063', '12345', NULL, 'XXXXXXXXXXXXXXXXXXXXXXXXXXX@XXXXXXX', '9088194421', '9088194421', '2017-04-17 00:00:00', '', '', '1986-05-13', 1, 1, 16, 'RAKESH  KUMAR', 'O+', 'KISHUN SINGH', '', 'M', 1, 0, 'VILL MISHVAWALIYA PO&PS KARAKAT DISTT ROHTAS', '', 'BIHAR', '000000', 'India', 'MARRIED', 'BR24200900', '29395', 'DRIVER', 'ATPL', NULL, NULL, NULL, 'f63575fb79539ce32a47cc54111c732a.jpg', '013a920d0ed86f5e9482cce564b895d0.jpg', NULL),
(77, 'KAMAL', 'MAJUMDER', '1000064', '12345', NULL, 'kamal.majumder@aadarshgroup.org', '8628856796', '9831590734', '2017-05-02 00:00:00', '', '789528858545', '1975-01-03', 1, 1, 16, 'KAMAL MAJUMDER', '', 'HARAMOHAN MAJUMDER', '', 'M', 1, 0, 'Vill:Santoshpur(Duttapara),PO:Barajaguli,', '', 'Kalyani', '741221', 'India', 'MARRIED', '', '', 'BACK OFFICE EXECUTIVE', 'ATPL', NULL, NULL, NULL, 'a26d4487286afec4ca8bcf00c80aa4c7.jpg', '649785a7b3bd6590d642d0ad8d3374de.pdf', NULL),
(78, 'CHITTARANJAN', 'PRADHAN', '1000065', '12345', NULL, 'XXXXXXXXXXXXX@XXXXXX', '9563924035', '9563924035', '2017-06-01 00:00:00', '', '947828598014', '1972-01-12', 1, 1, 16, 'CHITTARANJAN PRADHAN', '', 'LATE BISWANATH PRADHAN', 'LATE SASHI PRADHAN', 'M', 1, 0, 'Vill:Fulia Colony,PO:Fulia Colony,PS:Santipur,Dist:Nadia', '', 'Nadia', '741402', 'India', 'MARRIED', '', '', 'OFFICE STAFF', 'ATPL', NULL, NULL, NULL, '02997457a31186d7d825da1d0c6a178c.jpg', '515b854a1d0a5e69311b676c09a4e11f.pdf', NULL),
(79, 'NISHA ', 'AGARWAL', '1000066', '12345', NULL, 'nisha.aca@gmail.com', '8420998191', '8420998191', '2017-05-15 00:00:00', 'AFCPA2756C', '670597824854', '1977-10-01', 1, 2, 16, 'NISHA  AGARWAL', '', 'VIKASH AGARWAL', '', 'F', 1, 0, 'Flat No.2A,Draffodil Blooms,F/F 12 Hatiara Road,Jyangra,Baguihati', '', 'Kolkata', '700059', 'India', 'MARRIED', '', '', 'Sr.Accountant', 'ATPL', NULL, NULL, NULL, '1ad8c2108691c36ea019ad6308fd3e74.pdf', 'de33bc07f08ca099a62462662d6d0259.pdf', NULL),
(80, 'SURAJ BHAN', 'BALMIKI', '1000067', '12345', NULL, 'XXXXXXXXXXXXXXXXXXXXXXXXXXX@XXXXXXX', '8100681385', '8100681385', '2017-05-18 00:00:00', 'ASSPB2557M', '572266893306', '1981-01-01', 1, 1, 16, 'SURAJ BHAN BALMIKI', '', 'JAGDISH  PRAKASH BALMIKI', '', 'M', 1, 0, '26/59 ,DUM DUM ROAD', '', 'KOLKATA', '700002', 'India', 'MARRIED', '', '', 'OFFICE', '', NULL, NULL, NULL, 'b74f5f428c27afd3e2bfd5195d780567.jpg', '7992819f4f33c95ad25531f3fa3a0c6c.pdf', NULL),
(81, 'ABHISHEK', 'BHOWMICK', '1000068', '12345', NULL, 'abhowmick106.ab@gmail.com', '07685826056', '08583854091', '2017-06-12 00:00:00', 'BUXPB4709B', '', '1993-03-15', 0, 1, 16, 'ABHISHEK BHOWMICK', '', 'RANJAN BHOWMICK', '', 'M', 1, 0, '6 Rasik Lal Banerjee Lane ', '', 'HOWRAH', '711102', 'India', 'SINGLE', '', '', 'SUPERVISOR', 'ATPL', NULL, NULL, NULL, 'da1dc25fa249f3d0f08eafc8bc646587.jpg', 'ff294d961db53f1ef0e3c5d51d9cdc1a.pdf', NULL),
(82, 'PRITHWISH', 'BANAERJEE', '1000069', '12345', NULL, 'prithwishbanerjee3@gmail.com', '9062856330', '9062856330', '2017-06-08 00:00:00', 'AXXPB7002R', '848774891125', '1986-02-19', 1, 1, 16, 'PRITHWISH BANAERJEE', '', 'DURGADAS BANERJEE', '', 'M', 1, 0, '10/1 Mukta Ram Deb Nath Lane', '', 'Howrah', '711104', 'India', 'SINGLE', '', '', 'SUPERVISOR', 'ATPL', NULL, NULL, NULL, '9e0cd11db0731a4e6bab663033c594fd.jpg', 'ddac8b4bb63e7636234096b6afe9a854.pdf', NULL),
(84, 'GOVIND', 'CHOWDHURY', 'GOVINDCHD', 'pRITI@1502', NULL, 'govindchowdhury@aadarshgroup.org', '0000000000', '0000000000', '2017-06-27 00:00:00', '', '', '1985-03-01', 1, 4, 15, 'GOVIND CHOWDHURY', '', '', '', 'M', 1, 25, 'central avn', 'kolkata', 'kolkata', '700069', 'India', 'Maried', '', '', 'Director', '', NULL, NULL, NULL, '', '', NULL),
(85, 'LEVEL', 'ZERO1', '654321', '123456', NULL, 'example@gmail.com', '0000000000', '0000000000', '2017-06-08 00:00:00', '', '', '2017-06-06', 1, 0, 15, 'LEVEL ZERO1', 'A', '', '', 'M', 1, 0, 'kolkata', 'kolkata', 'KOLKATA', '700101', 'India', 'Maried', '', '', 'Field Employee', '', 6, NULL, NULL, 'a3325d57a046549fb40dae916a68da05.png', '95d4784935237e9b2cd81eafb395a723.png', 'ecbcbdf6-6bed-46ed-b615-8d45bcf777f5'),
(86, 'SUNIRMAL', 'ROY', '1000070', '12345', NULL, 'royenggncompany@gmail.com', '8697327203', '8777537732', '0000-00-00 00:00:00', 'AGLPR5997E', '923381377982', '1963-01-03', 0, 1, 16, 'SUNIRMAL ROY', '', 'PARESH CHANDRA ROY', '', 'M', 1, 0, '257,NANDAN NAGAR,PO:NANDAN NAGAR,PS-BELGHARIA,DIST:NORTH 24 PARAGANAS', '', 'KOLKATA', '700083', 'India', 'MARRIED', '', '', 'SENIOR ENGINEER', 'ATPL', NULL, NULL, NULL, '0e9a765dfbe304852460490f533a35b4.jpg', '', NULL),
(87, 'PARTHA', 'GOSWAMI', '1000071', '12345', NULL, 'parthagoswami.bqa@gmail.com', '7797778461', '7797778461', '0000-00-00 00:00:00', 'BRDPG1897A', '426375795996', '1993-03-26', 0, 1, NULL, 'PARTHA GOSWAMI', '', 'UTPAL GOSWAMI', '', 'M', 1, 0, 'VILL+POST:KHALAGRAM,PS:TALDANGA,BANKURA', '', 'BANKURA', '722152', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, NULL, NULL, '18744c6b15f0ba75440f40e45a7fcd23.jpg', '', NULL),
(88, 'RAJA', 'DAS', '1000072', '12345', NULL, 'rajrock04041994@gmail.com', '9474719527', '9474719527', '0000-00-00 00:00:00', '', '', '1994-04-04', 0, 1, 16, 'RAJA DAS', '', 'MAHADEB DAS', '', 'M', 1, 0, 'vill-Sendra,PO-Sendra,PS-Bankura,', '', 'BANKURA', '722155', 'India', 'SINGLE', '', '', 'SUPERVISOR', 'ATPL', NULL, NULL, NULL, '67c2448e2d976d0b38fdbed8d135eaf7.jpg', '', NULL),
(89, 'CHANDAN KUMAR', 'PRADHAN', '1000074', '12345', NULL, 'XXXXXXXXXX@GMAIL.COM', '9732504718', '7604020732', '0000-00-00 00:00:00', '', '986273796725', '1998-10-19', 1, 1, 16, 'CHANDAN KUMAR PRADHAN', 'A+', 'LT.ASHOK PRADHAN', '', 'M', 1, 0, 'Vill:Durgachak Colony D-74/A Block', 'PS&PO-Durgachak', 'East Midnapore', '721602', 'India', 'SINGLE', '', '', 'SUPERVISOR', 'ATPL', NULL, NULL, NULL, 'f856ba68ebe0e7cc6fdd04dd4d92ffae.jpg', 'eeabfd5f865b0def962c70fae9ac0774.pdf', NULL),
(90, 'MANESH ', 'GORAI', '1000073', '12345', NULL, 'manesh.gorai159@gmail.com', '8167239020', '8436374709', '0000-00-00 00:00:00', 'AUGPG4298L', '476117155985', '1992-04-05', 1, 1, 16, 'MANESH  GORAI', '', 'LALMOHAN GORAI', '', 'M', 1, 0, 'PANKTORE,GANGA JALGHATI,', '', 'BANKURA', '722133', 'India', 'SINGLE', '', '', 'SUPERVISOR', 'ATPL', NULL, NULL, NULL, '56346bc69b441141da6ad98f91e508d9.jpg', '', NULL),
(92, 'DEEPAK', 'KUMAR', '1000076', '12345', NULL, 'XXXXXXXXXXXXXXXXXXXXXXXXXXX@XXXXXXX', '8521584290', '8084134110', '2017-07-17 00:00:00', 'EUFPK5471N', '343411243364', '1989-10-05', 1, 1, 16, 'DEEPAK KUMAR', '', 'KEDAR SAH', '', 'M', 1, 0, 'NEW BUS STAND,BETHIA,BALKRISHNA COLONY', '', 'BIHAR', '845438', 'India', 'MARRIED', '', '', 'SUPERVISOR', 'ATPL', NULL, NULL, NULL, '', 'ec420cc2555ebeffd8ed52b20b37d698.jpg', NULL),
(93, 'PRITAM', 'SAHU', '1000333', '12345', NULL, 'pritamsahu016@gmail.com', '8697729082', '9038949537', '2017-08-02 00:00:00', 'ABCD1234', 'ABCD4444', '1993-07-01', 1, 2, 16, 'PRITAM SAHU', 'AB+', 'ABHAY SAHU', 'UMA SAHU', 'M', 1, 333, 'KESTOPUR', 'KOLKATA', 'KOLKATA', '700101', 'India', 'SINGLE', 'ABCD3333', 'ABCD5555', 'MANAGER', 'AADARSH', NULL, NULL, NULL, '8604b81def5b48aeca8ee40374d5e22f.png', 'b75bcb219f087e1cd4eaac7a5285aa39.pdf', NULL),
(94, 'DIBEYENDU', 'BHUNIA', '1000078', '12345', NULL, 'XXXXXXXXXXXX@GMAIL.COM', '8768446731', '8768446731', '0000-00-00 00:00:00', 'BHFPB9025D', '521395968094', '0000-00-00', 1, 1, 16, 'DIBEYENDU BHUNIA', '', 'BIMAL KUMAR BHUNIA', '', 'M', 1, 0, 'BHEKUTIA NONDIGRAM', '', 'PURBA MIDNAPUR', '721656', 'India', 'SINGLE', '', '', 'CIVIL SUPERVISOR', 'ATPL', NULL, NULL, NULL, '', 'ba27cdb03906e062714002884c8cd369.pdf', NULL);

--
-- Triggers `employees`
--
DELIMITER $$
CREATE TRIGGER `employees_AFTER_INSERT` AFTER INSERT ON `employees` FOR EACH ROW BEGIN
	INSERT INTO notifications (message, module, url, target_id) values('Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', NEW.id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `employees_BEFORE_INSERT` BEFORE INSERT ON `employees` FOR EACH ROW BEGIN
	SET NEW.display_name=CONCAT(NEW.first_name,' ',NEW.last_name);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_adv_rating`
--

CREATE TABLE `employee_adv_rating` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `job_knowledge` int(11) DEFAULT '0',
  `quality` int(11) DEFAULT '0',
  `productivity` int(11) DEFAULT '0',
  `initiative` int(11) DEFAULT '0',
  `punctuality` int(11) DEFAULT '0',
  `attendance` int(11) DEFAULT '0',
  `attitude` int(11) DEFAULT '0',
  `work_relation` int(11) DEFAULT '0',
  `communication` int(11) DEFAULT '0',
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `comment` varchar(255) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `calculated_rating` decimal(3,2) AS (
5*(((job_knowledge +quality)*0.3) + ((productivity+(initiative/2))*0.2) + ((attitude+work_relation+communication)*0.15) + ((attendance+punctuality)*0.1))/7.75) VIRTUAL,
  `year` int(4) DEFAULT NULL,
  `month` int(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `employee_adv_rating`
--

INSERT INTO `employee_adv_rating` (`id`, `employee_id`, `job_knowledge`, `quality`, `productivity`, `initiative`, `punctuality`, `attendance`, `attitude`, `work_relation`, `communication`, `created_on`, `comment`, `created_by`, `calculated_rating`, `year`, `month`) VALUES
(1, 12, 4, 4, 3, 2, 5, 5, 4, 4, 4, '2017-06-24 11:28:18', NULL, NULL, '3.87', 2017, 6);

-- --------------------------------------------------------

--
-- Table structure for table `employee_rating`
--

CREATE TABLE `employee_rating` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `rating` double DEFAULT '0',
  `month` int(2) DEFAULT NULL,
  `year` int(4) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `employee_rating`
--

INSERT INTO `employee_rating` (`id`, `employee_id`, `rating`, `month`, `year`, `comment`) VALUES
(1, 12, 5, 6, 2017, 'good');

-- --------------------------------------------------------

--
-- Table structure for table `employee_task_rating`
--

CREATE TABLE `employee_task_rating` (
  `id` int(11) NOT NULL,
  `rating` int(11) NOT NULL,
  `date` date NOT NULL,
  `employeeid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `employee_task_rating`
--

INSERT INTO `employee_task_rating` (`id`, `rating`, `date`, `employeeid`) VALUES
(0, 87, '2017-09-08', 70);

-- --------------------------------------------------------

--
-- Table structure for table `field_assignments`
--

CREATE TABLE `field_assignments` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `details` text,
  `owner` int(11) DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `supervisor` int(11) DEFAULT NULL,
  `employeeid` int(11) DEFAULT NULL,
  `lat` decimal(10,7) DEFAULT NULL,
  `lng` decimal(10,7) DEFAULT NULL,
  `address` text,
  `timeline` int(11) DEFAULT NULL,
  `remarks` text,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `file` varchar(255) DEFAULT NULL,
  `status` varchar(45) DEFAULT NULL,
  `project_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `field_assignments`
--

INSERT INTO `field_assignments` (`id`, `title`, `details`, `owner`, `createdBy`, `supervisor`, `employeeid`, `lat`, `lng`, `address`, `timeline`, `remarks`, `createdAt`, `file`, `status`, `project_id`) VALUES
(2, 'TEST26-8-2017', 'TESTING', NULL, 15, 15, 72, '22.5968502', '88.4176978', 'BF Block, Sector 1, Salt Lake City, Kolkata, West Bengal 700064, India', NULL, NULL, '2017-08-26 18:17:31', NULL, 'ASSIGNED', 1),
(3, 'TEST1 26-82-017', 'TESTING FILE AND OFFMODE', NULL, 15, 15, 72, '22.5830002', '88.3372909', 'Howrah Railway Station, Howrah, West Bengal, India', NULL, NULL, '2017-08-26 18:23:40', NULL, 'COMPLETED', 1),
(4, 'Demo Assignment 27/8/2017', 'Test Assignment Details', NULL, 15, 15, 14, '22.6296270', '88.4345550', 'Kaikhali', NULL, NULL, '2017-08-27 14:45:28', NULL, 'ASSIGNED', 1);

--
-- Triggers `field_assignments`
--
DELIMITER $$
CREATE TRIGGER `field_assignments_AFTER_INSERT` AFTER INSERT ON `field_assignments` FOR EACH ROW BEGIN
	INSERT INTO field_assignment_updates (status, assignment_id) values('Assignment Created', NEW.id);
    INSERT INTO challans (project_id, assignment_id, type) values(NEW.project_id, NEW.id, getProjectTypeFromId(NEW.project_id));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `field_assignments_AFTER_UPDATE` AFTER UPDATE ON `field_assignments` FOR EACH ROW BEGIN
	if NEW.status='ASSIGNED' THEN
		insert into field_assignment_updates (status, assignment_id) values(concat('Assigned to ', getNameFromId(NEW.employeeid)), NEW.id);
	elseif NEW.status = 'REACHED' THEN
		insert into field_assignment_updates (status, assignment_id) values('Employee has reached the destination', NEW.id);
    elseif NEW.status = 'UPLOADED' THEN
		insert into field_assignment_updates (status, assignment_id) values('Challan has been uploaded', NEW.id);
	elseif NEW.status = 'COMPLETED' THEN
		insert into field_assignment_updates (status, assignment_id) values('Assignment Completed', NEW.id);            
    end if;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `field_assignments_BEFORE_UPDATE` BEFORE UPDATE ON `field_assignments` FOR EACH ROW BEGIN
if NEW.status='RELEASED' THEN
		insert into field_assignment_updates (status, assignment_id) values(concat('Released employee ', getNameFromId(OLD.employeeid)), NEW.id);
end if;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `field_assignment_updates`
--

CREATE TABLE `field_assignment_updates` (
  `id` int(11) NOT NULL,
  `status` varchar(255) NOT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `assignment_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `field_assignment_updates`
--

INSERT INTO `field_assignment_updates` (`id`, `status`, `createdAt`, `assignment_id`) VALUES
(1, 'Assignment Created', '2017-04-15 09:04:12', 1),
(2, 'Assigned to Level Zero', '2017-04-15 09:04:41', 1),
(3, 'Assignment Completed', '2017-04-15 09:06:48', 1),
(4, 'Assignment Created', '2017-04-15 20:08:41', 2),
(5, 'Assignment Created', '2017-04-15 20:09:50', 3),
(6, 'Assignment Created', '2017-04-15 20:10:26', 4),
(7, 'Assigned to Level Zero', '2017-04-15 20:11:54', 2),
(8, 'Assignment Completed', '2017-04-15 20:14:17', 2),
(9, 'Assigned to Level Zero', '2017-04-15 20:14:38', 3),
(10, 'Assignment Completed', '2017-04-15 20:18:15', 3),
(11, 'Assignment Created', '2017-04-16 07:44:26', 5),
(12, 'Assigned to Level Zero', '2017-04-16 07:45:42', 5),
(13, 'Released employee Level Zero', '2017-04-16 07:46:59', 5),
(14, 'Assignment Completed', '2017-04-16 07:48:50', 5),
(15, 'Assignment Created', '2017-04-16 07:51:57', 6),
(16, 'Assignment Created', '2017-04-16 07:55:40', 7),
(17, 'Assigned to Level Zero', '2017-04-16 07:56:38', 7),
(18, 'Assignment Completed', '2017-04-16 07:58:56', 7),
(19, 'Assignment Completed', '2017-04-16 07:59:27', 6),
(20, 'Assignment Created', '2017-04-16 11:59:45', 8),
(21, 'Assigned to Level Zero', '2017-04-16 12:00:21', 8),
(22, 'Assignment Completed', '2017-04-16 12:02:21', 8),
(23, 'Assignment Created', '2017-04-17 20:06:42', 9),
(24, 'Assigned to Level Zero', '2017-04-17 20:07:39', 9),
(25, 'Released employee Level Zero', '2017-04-17 20:32:14', 9),
(26, 'Assignment Completed', '2017-04-17 20:33:01', 9),
(27, 'Assigned to Level Zero', '2017-04-17 20:38:54', 4),
(28, 'Assignment Completed', '2017-04-17 20:44:44', 4),
(29, 'Assignment Created', '2017-04-17 20:50:49', 10),
(30, 'Assigned to Level Zero', '2017-04-17 20:52:41', 10),
(31, 'Assignment Completed', '2017-04-17 20:54:10', 10),
(32, 'Assignment Created', '2017-04-23 08:31:56', 11),
(33, 'Assignment Created', '2017-04-23 08:32:48', 12),
(34, 'Assignment Created', '2017-04-23 09:31:46', 13),
(35, 'Assigned to Level Zero', '2017-04-23 09:32:04', 13),
(36, 'Assignment Created', '2017-04-23 09:48:27', 14),
(37, 'Assigned to Jhone Smith', '2017-04-23 09:50:55', 14),
(38, 'Assignment Completed', '2017-04-23 10:00:22', 14),
(39, 'Assignment Created', '2017-04-23 10:02:26', 15),
(40, 'Assignment Created', '2017-04-23 10:05:16', 16),
(41, 'Assignment Created', '2017-04-23 10:05:32', 17),
(42, 'Assignment Created', '2017-04-23 10:05:52', 18),
(43, 'Assignment Created', '2017-04-23 10:08:02', 19),
(44, 'Assignment Completed', '2017-04-23 13:33:54', 13),
(45, 'Assignment Created', '2017-04-24 18:24:25', 20),
(46, 'Assignment Created', '2017-04-24 18:26:28', 21),
(47, 'Assigned to Level Zero', '2017-04-24 18:27:10', 21),
(48, 'Assignment Completed', '2017-04-24 18:29:19', 21),
(49, 'Assignment Created', '2017-04-25 21:50:41', 22),
(50, 'Assignment Created', '2017-04-25 21:51:24', 23),
(51, 'Assigned to Level Zero', '2017-04-25 21:51:47', 23),
(52, 'Assignment Completed', '2017-04-25 21:55:10', 23),
(53, 'Assignment Created', '2017-04-26 18:21:36', 24),
(54, 'Assigned to Level Zero', '2017-04-26 18:35:01', 24),
(55, 'Assigned to Level Zero', '2017-04-26 18:48:54', 24),
(56, 'Assigned to Level Zero', '2017-04-26 19:01:15', 24),
(57, 'Assigned to Level Zero', '2017-04-27 03:23:23', 24),
(58, 'Assigned to Level Zero', '2017-04-27 03:26:00', 24),
(59, 'Assigned to Level Zero', '2017-04-27 03:29:52', 24),
(60, 'Assigned to Level Zero', '2017-04-27 03:46:48', 24),
(61, 'Assignment Created', '2017-05-01 11:06:38', 25),
(62, 'Assignment Completed', '2017-05-01 11:08:09', 24),
(63, 'Assigned to Level Zero', '2017-05-01 11:08:27', 25),
(64, 'Assignment Completed', '2017-05-01 11:09:33', 25),
(65, 'Assignment Created', '2017-05-01 13:11:31', 26),
(66, 'Assigned to Level Zero', '2017-05-01 13:13:05', 26),
(67, 'Assignment Completed', '2017-05-01 13:16:12', 26),
(68, 'Assigned to Level Zero', '2017-05-06 03:57:28', 26),
(69, 'Assigned to Level Zero', '2017-05-06 04:04:45', 26),
(70, 'Assigned to Level Zero', '2017-05-06 04:08:03', 26),
(71, 'Assigned to Level Zero', '2017-05-06 05:03:08', 26),
(72, 'Assigned to Level Zero', '2017-05-06 05:07:30', 26),
(73, 'Assignment Completed', '2017-05-06 06:24:40', 26),
(74, 'Assignment Created', '2017-05-06 06:25:58', 27),
(75, 'Assigned to Level Zero', '2017-05-06 06:26:18', 27),
(76, 'Assignment Completed', '2017-05-06 09:33:09', 27),
(77, 'Assignment Created', '2017-05-08 11:04:44', 28),
(78, 'Assigned to Level Zero', '2017-05-08 11:06:26', 28),
(79, 'Assignment Completed', '2017-05-08 11:10:42', 28),
(80, 'Assignment Created', '2017-05-08 12:04:50', 29),
(81, 'Assigned to Level Zero', '2017-05-08 12:06:57', 29),
(82, 'Assignment Completed', '2017-05-08 12:09:17', 29),
(83, 'Assignment Created', '2017-05-28 06:26:07', 30),
(84, 'Assigned to Level Zero', '2017-05-28 06:26:31', 30),
(85, 'Assignment Completed', '2017-05-28 06:33:22', 30),
(86, 'Assignment Created', '2017-05-28 06:58:04', 31),
(87, 'Assigned to Level Zero', '2017-05-28 06:58:54', 31),
(88, 'Assignment Created', '2017-06-03 14:45:44', 32),
(89, 'Assignment Created', '2017-06-03 14:46:23', 33),
(90, 'Assigned to Jhone Smith', '2017-06-03 14:46:54', 33),
(91, 'Released employee Jhone Smith', '2017-08-03 06:30:44', 33),
(92, 'Assigned to Jhone Smith', '2017-08-03 06:30:51', 33),
(93, 'Assignment Created', '2017-08-20 14:50:13', 34),
(94, 'Assigned to LEVEL ZERO1', '2017-08-20 14:50:52', 34),
(95, 'Assignment Created', '2017-08-20 18:58:39', 35),
(96, 'Released employee LEVEL ZERO1', '2017-08-20 18:59:52', 34),
(97, 'Assigned to Shyamlal Sharma', '2017-08-20 19:00:07', 34),
(98, 'Assigned to LEVEL ZERO1', '2017-08-20 19:00:29', 35),
(99, 'Released employee LEVEL ZERO1', '2017-08-20 19:01:50', 35),
(100, 'Assigned to LEVEL ZERO1', '2017-08-20 19:02:30', 35),
(101, 'Assignment Created', '2017-08-21 19:01:09', 36),
(102, 'Assignment Completed', '2017-08-21 19:02:58', 1),
(103, 'Assignment Completed', '2017-08-21 19:02:58', 2),
(104, 'Assignment Completed', '2017-08-21 19:02:58', 3),
(105, 'Assignment Completed', '2017-08-21 19:02:58', 4),
(106, 'Assignment Completed', '2017-08-21 19:02:58', 5),
(107, 'Assignment Completed', '2017-08-21 19:02:58', 6),
(108, 'Assignment Completed', '2017-08-21 19:02:58', 7),
(109, 'Assignment Completed', '2017-08-21 19:02:58', 8),
(110, 'Assignment Completed', '2017-08-21 19:02:58', 9),
(111, 'Assignment Completed', '2017-08-21 19:02:58', 10),
(112, 'Assignment Completed', '2017-08-21 19:02:58', 11),
(113, 'Assignment Completed', '2017-08-21 19:02:58', 12),
(114, 'Assignment Completed', '2017-08-21 19:02:58', 13),
(115, 'Assignment Completed', '2017-08-21 19:02:58', 14),
(116, 'Assignment Completed', '2017-08-21 19:02:58', 15),
(117, 'Assignment Completed', '2017-08-21 19:02:58', 16),
(118, 'Assignment Completed', '2017-08-21 19:02:58', 17),
(119, 'Assignment Completed', '2017-08-21 19:02:58', 18),
(120, 'Assignment Completed', '2017-08-21 19:02:58', 19),
(121, 'Assignment Completed', '2017-08-21 19:02:58', 20),
(122, 'Assignment Completed', '2017-08-21 19:02:58', 21),
(123, 'Assignment Completed', '2017-08-21 19:02:58', 22),
(124, 'Assignment Completed', '2017-08-21 19:02:58', 23),
(125, 'Assignment Completed', '2017-08-21 19:02:58', 24),
(126, 'Assignment Completed', '2017-08-21 19:02:58', 25),
(127, 'Assignment Completed', '2017-08-21 19:02:58', 26),
(128, 'Assignment Completed', '2017-08-21 19:02:58', 27),
(129, 'Assignment Completed', '2017-08-21 19:02:58', 28),
(130, 'Assignment Completed', '2017-08-21 19:02:58', 29),
(131, 'Assignment Completed', '2017-08-21 19:02:58', 30),
(132, 'Assignment Completed', '2017-08-21 19:02:58', 31),
(133, 'Assignment Completed', '2017-08-21 19:02:58', 32),
(134, 'Assignment Completed', '2017-08-21 19:02:58', 33),
(135, 'Assignment Completed', '2017-08-21 19:02:58', 34),
(136, 'Assignment Completed', '2017-08-21 19:02:58', 35),
(137, 'Assignment Completed', '2017-08-21 19:02:58', 36),
(138, 'Assignment Created', '2017-08-22 03:30:53', 37),
(139, 'Assigned to Level Zero', '2017-08-22 03:31:12', 37),
(140, 'Assignment Completed', '2017-08-22 03:42:55', 1),
(141, 'Assignment Completed', '2017-08-22 03:42:55', 2),
(142, 'Assignment Completed', '2017-08-22 03:42:55', 3),
(143, 'Assignment Completed', '2017-08-22 03:42:55', 4),
(144, 'Assignment Completed', '2017-08-22 03:42:55', 5),
(145, 'Assignment Completed', '2017-08-22 03:42:55', 6),
(146, 'Assignment Completed', '2017-08-22 03:42:55', 7),
(147, 'Assignment Completed', '2017-08-22 03:42:55', 8),
(148, 'Assignment Completed', '2017-08-22 03:42:55', 9),
(149, 'Assignment Completed', '2017-08-22 03:42:55', 10),
(150, 'Assignment Completed', '2017-08-22 03:42:55', 11),
(151, 'Assignment Completed', '2017-08-22 03:42:55', 12),
(152, 'Assignment Completed', '2017-08-22 03:42:55', 13),
(153, 'Assignment Completed', '2017-08-22 03:42:55', 14),
(154, 'Assignment Completed', '2017-08-22 03:42:55', 15),
(155, 'Assignment Completed', '2017-08-22 03:42:55', 16),
(156, 'Assignment Completed', '2017-08-22 03:42:55', 17),
(157, 'Assignment Completed', '2017-08-22 03:42:55', 18),
(158, 'Assignment Completed', '2017-08-22 03:42:55', 19),
(159, 'Assignment Completed', '2017-08-22 03:42:55', 20),
(160, 'Assignment Completed', '2017-08-22 03:42:55', 21),
(161, 'Assignment Completed', '2017-08-22 03:42:55', 22),
(162, 'Assignment Completed', '2017-08-22 03:42:55', 23),
(163, 'Assignment Completed', '2017-08-22 03:42:55', 24),
(164, 'Assignment Completed', '2017-08-22 03:42:55', 25),
(165, 'Assignment Completed', '2017-08-22 03:42:55', 26),
(166, 'Assignment Completed', '2017-08-22 03:42:55', 27),
(167, 'Assignment Completed', '2017-08-22 03:42:55', 28),
(168, 'Assignment Completed', '2017-08-22 03:42:55', 29),
(169, 'Assignment Completed', '2017-08-22 03:42:55', 30),
(170, 'Assignment Completed', '2017-08-22 03:42:55', 31),
(171, 'Assignment Completed', '2017-08-22 03:42:55', 32),
(172, 'Assignment Completed', '2017-08-22 03:42:55', 33),
(173, 'Assignment Completed', '2017-08-22 03:42:55', 34),
(174, 'Assignment Completed', '2017-08-22 03:42:55', 35),
(175, 'Assignment Completed', '2017-08-22 03:42:55', 36),
(176, 'Assignment Completed', '2017-08-22 03:42:55', 37),
(177, 'Assignment Created', '2017-08-22 03:47:38', 38),
(178, 'Assigned to Level Zero', '2017-08-22 03:48:05', 38),
(179, 'Assignment Completed', '2017-08-22 03:52:59', 38),
(180, 'Assignment Created', '2017-08-24 04:45:46', 39),
(181, 'Assigned to Level Zero', '2017-08-24 04:45:59', 39),
(182, 'Assignment Completed', '2017-08-24 04:47:19', 39),
(183, 'Assignment Created', '2017-08-26 18:04:45', 1),
(184, 'Assigned to Level Zero', '2017-08-26 18:05:17', 1),
(185, 'Assignment Created', '2017-08-26 18:17:31', 2),
(186, 'Assigned to Level Zero', '2017-08-26 18:17:55', 2),
(187, 'Assignment Completed', '2017-08-26 18:20:42', 2),
(188, 'Assignment Created', '2017-08-26 18:23:40', 3),
(189, 'Assigned to Level Zero', '2017-08-26 18:24:00', 3),
(190, 'Assignment Completed', '2017-08-26 18:26:44', 3),
(191, 'Assignment Created', '2017-08-27 14:45:28', 4),
(192, 'Assigned to Level Zero', '2017-08-27 14:45:45', 4),
(193, 'Released employee Level Zero', '2017-08-27 14:46:18', 4),
(194, 'Assigned to Level Zero', '2017-08-27 14:46:25', 4),
(195, 'Released employee Level Zero', '2017-08-27 14:46:41', 4),
(200, 'Released employee Level Zero', '2017-08-27 14:48:59', 3),
(201, 'Assigned to Jhone Smith', '2017-08-27 14:49:04', 3),
(202, 'Released employee Jhone Smith', '2017-08-27 14:49:09', 3),
(203, 'Assigned to Level Zero', '2017-08-27 14:51:18', 3),
(204, 'Released employee Level Zero', '2017-08-27 14:51:45', 3),
(205, 'Assigned to Level Zero', '2017-08-27 14:51:52', 3),
(206, 'Released employee Level Zero', '2017-08-27 14:51:58', 3),
(207, 'Assigned to Level Zero', '2017-08-27 14:53:35', 3),
(208, 'Released employee Level Zero', '2017-08-27 14:54:00', 3),
(209, 'Assigned to Level Zero', '2017-08-27 14:54:10', 3),
(210, 'Released employee Level Zero', '2017-08-27 14:54:38', 3),
(211, 'Assigned to Level Zero', '2017-08-27 14:55:43', 3),
(212, 'Released employee Level Zero', '2017-08-27 14:56:22', 3),
(213, 'Assigned to Level Zero', '2017-08-27 14:56:31', 3),
(214, 'Assignment Completed', '2017-08-27 14:59:24', 3),
(215, 'Assigned to VIKASH PANDEY', '2017-08-27 15:10:23', 4),
(216, 'Released employee VIKASH PANDEY', '2017-08-27 15:11:50', 4),
(217, 'Assigned to Level Zero', '2017-08-27 15:12:05', 4),
(218, 'Released employee Level Zero', '2017-08-27 15:15:24', 4),
(219, 'Assigned to VIKASH PANDEY', '2017-08-27 15:17:15', 4),
(220, 'Assigned to Level Zero', '2017-09-09 14:47:54', 2);

-- --------------------------------------------------------

--
-- Table structure for table `hierarchy`
--

CREATE TABLE `hierarchy` (
  `id` int(11) NOT NULL,
  `position_name` varchar(45) NOT NULL,
  `level` int(11) NOT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'dflt'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `hierarchy`
--

INSERT INTO `hierarchy` (`id`, `position_name`, `level`, `role`) VALUES
(1, 'Associate (Level 1)', 1, 'dflt'),
(2, 'Supervisor (Level 2)', 2, 'dflt'),
(3, 'HR (Level 3)', 3, 'dflt'),
(4, 'Director (Level 4)', 4, 'dflt'),
(5, 'Field Employee (Level 5)', 0, 'dflt');

-- --------------------------------------------------------

--
-- Table structure for table `leaves`
--

CREATE TABLE `leaves` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `reason` text,
  `leave_type` varchar(45) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `count` decimal(10,1) DEFAULT NULL,
  `partial_date` int(1) DEFAULT NULL,
  `approved` int(11) DEFAULT '0',
  `approved_by` int(11) DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(1) DEFAULT 'A',
  `cancelled_by` int(11) DEFAULT NULL,
  `verified_by` int(11) DEFAULT NULL,
  `pending_to` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `leaves`
--

INSERT INTO `leaves` (`id`, `employee_id`, `reason`, `leave_type`, `start_date`, `end_date`, `count`, `partial_date`, `approved`, `approved_by`, `createdAt`, `status`, `cancelled_by`, `verified_by`, `pending_to`) VALUES
(1, 12, 'Personal', 'PL', '2017-03-26', '2017-03-26', '1.0', 0, 1, 15, '2017-03-26 07:47:59', 'A', NULL, NULL, 15),
(2, 12, 'Sick', 'SL', '2017-03-28', '2017-03-29', '1.5', 2, 0, NULL, '2017-03-26 07:51:37', 'I', 16, NULL, 16),
(3, 69, 'Personal', 'PL', '2017-03-27', '2017-03-27', '0.5', 1, 0, NULL, '2017-03-27 13:13:06', 'I', 15, NULL, 15),
(4, 21, 'pesonal', 'PL', '2017-05-08', '2017-05-08', '1.0', 0, 0, NULL, '2017-05-08 11:54:30', 'I', 21, NULL, 16),
(5, 17, 'HOLIDAY', 'PL', '2017-08-12', '2017-08-20', '8.5', 1, 0, NULL, '2017-05-08 11:57:16', 'I', 17, NULL, 16),
(6, 40, 'Doctors visit', 'PL', '2017-05-11', '2017-05-11', '1.0', 0, 1, 15, '2017-05-10 07:28:49', 'A', NULL, NULL, 15),
(7, 40, 'Sick', 'SL', '2017-05-11', '2017-05-12', '1.5', 1, 1, 15, '2017-05-10 07:37:12', 'A', NULL, NULL, 15),
(8, 40, 'ill', 'PL', '2017-05-11', '2017-05-25', '7.5', 3, 0, NULL, '2017-05-10 07:40:40', 'I', 40, NULL, 15),
(9, 40, 'Going to Shirdi ', 'PL', '2017-07-20', '2017-07-25', '6.0', 0, 1, 15, '2017-06-20 11:20:58', 'A', NULL, NULL, 15),
(10, 44, 'sick', 'SL', '2017-06-28', '2017-06-29', '2.0', 0, 0, NULL, '2017-06-28 12:53:51', 'A', NULL, NULL, 16),
(11, 13, 'my sister ring ceremony will leave by 2 pm ', 'PL', '2017-07-22', '2017-07-22', '0.5', 2, 1, 15, '2017-07-20 13:53:31', 'A', NULL, NULL, 15),
(12, 75, 'Dear Binata\r\nThis is to inform you that I will not be able to come office on 24th july 2017 due to going Tarkeshwar Dham.\r\nSo, I request you to kindly consider my application and grant me the leave on 24th july 2017.\r\nThanking you,\r\nYours Sincerely\r\nKabita Paswan', 'PL', '2017-07-24', '2024-01-24', '2375.5', 1, 0, NULL, '2017-07-22 10:40:39', 'I', 16, NULL, 16),
(13, 75, 'Dear Binata\r\nThis is to inform you that I will not be able to come office on Monday 24th July 2017 due to going Tarkeshwar Dham.\r\nSo I request you to kindly consider my application and grant me the leave on 24th July 2017.\r\nThanking You\r\nYours Sincerely\r\nKabita Paswan', 'PL', '2017-07-24', '2017-07-24', '1.0', 0, 0, NULL, '2017-07-22 10:45:45', 'I', 15, NULL, 15),
(14, NULL, 'for going my home.(bhagalpur)', 'PL', '2017-10-02', '2017-10-05', '4.0', 0, 0, NULL, '2017-08-01 12:36:00', 'A', NULL, NULL, NULL),
(15, 40, 'RAKHI OCCASSION', 'PL', '2017-08-07', '2017-08-07', '1.0', 0, 0, NULL, '2017-08-04 12:35:53', 'I', 15, 16, 15),
(16, 13, 'GOING TO VILLAGE ', 'PL', '2017-08-06', '2017-08-07', '1.0', 0, 0, NULL, '2017-08-04 13:21:56', 'I', 13, NULL, 16),
(17, 13, 'GOING TO VELLAGE ', 'PL', '2017-08-06', '2017-08-07', '2.0', 0, 0, NULL, '2017-08-04 14:13:40', 'I', 13, 16, 15),
(18, 61, 'due to going home town.during puja ', 'PL', '2017-10-03', '2017-10-05', '3.0', 0, 0, NULL, '2017-08-28 04:18:21', 'A', NULL, 16, 15);

--
-- Triggers `leaves`
--
DELIMITER $$
CREATE TRIGGER `leaves_AFTER_INSERT` AFTER INSERT ON `leaves` FOR EACH ROW BEGIN
	INSERT INTO leaves_approval (leave_id, employee_id, supervisor_id) values (NEW.id, NEW.employee_id, get_supervisor(NEW.employee_id));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `leaves_AFTER_UPDATE` AFTER UPDATE ON `leaves` FOR EACH ROW BEGIN
	IF NEW.approved=1 OR NEW.status='I' THEN
		UPDATE leaves_approval SET status='I' where leave_id=NEW.id;
        INSERT INTO leaves_taken (employee_id, from_date, to_date, approved_by, type) values(NEW.employee_id, NEW.start_date, NEW.end_date, NEW.approved_by, NEW.leave_type);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `leaves_BEFORE_INSERT` BEFORE INSERT ON `leaves` FOR EACH ROW BEGIN
	SET NEW.pending_to=get_supervisor(NEW.employee_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `leaves_approval`
--

CREATE TABLE `leaves_approval` (
  `id` int(11) NOT NULL,
  `leave_id` int(11) DEFAULT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `supervisor_id` int(11) DEFAULT NULL,
  `status` char(1) DEFAULT 'A'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `leaves_approval`
--

INSERT INTO `leaves_approval` (`id`, `leave_id`, `employee_id`, `supervisor_id`, `status`) VALUES
(1, 1, 12, 16, 'I'),
(2, 2, 12, 16, 'I'),
(3, 3, 69, 16, 'I'),
(4, 4, 21, 16, 'I'),
(5, 5, 17, 16, 'I'),
(6, 6, 40, 16, 'I'),
(7, 7, 40, 16, 'I'),
(8, 8, 40, 16, 'I'),
(9, 9, 40, 16, 'I'),
(10, 10, 44, 16, 'A'),
(11, 11, 13, 16, 'I'),
(12, 12, 75, 16, 'I'),
(13, 13, 75, 16, 'I'),
(14, 14, NULL, NULL, 'A'),
(15, 15, 40, 16, 'I'),
(16, 16, 13, 16, 'I'),
(17, 17, 13, 16, 'I'),
(18, 18, 61, 16, 'A');

--
-- Triggers `leaves_approval`
--
DELIMITER $$
CREATE TRIGGER `leaves_approval_AFTER_INSERT` AFTER INSERT ON `leaves_approval` FOR EACH ROW BEGIN
	INSERT INTO notifications (message, module, url, target_id) values ('Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', NEW.employee_id);
    INSERT INTO notifications (message, module, url, target_id) values ('Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', NEW.supervisor_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `leaves_taken`
--

CREATE TABLE `leaves_taken` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `type` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `leaves_taken`
--

INSERT INTO `leaves_taken` (`id`, `employee_id`, `from_date`, `to_date`, `approved_by`, `type`) VALUES
(1, 12, '2017-03-26', '2017-03-26', 15, 'PL'),
(2, 12, '2017-03-28', '2017-03-29', NULL, 'SL'),
(3, 69, '2017-03-27', '2017-03-27', NULL, 'PL'),
(4, 21, '2017-05-08', '2017-05-08', NULL, 'PL'),
(5, 17, '2017-08-12', '2017-08-20', NULL, 'PL'),
(6, 40, '2017-05-11', '2017-05-11', 15, 'PL'),
(7, 40, '2017-05-11', '2017-05-12', 15, 'SL'),
(8, 40, '2017-05-11', '2017-05-25', NULL, 'PL'),
(9, 40, '2017-05-11', '2017-05-25', NULL, 'PL'),
(10, 40, '2017-07-20', '2017-07-25', 15, 'PL'),
(11, 75, '2017-07-24', '2024-01-24', NULL, 'PL'),
(12, 13, '2017-07-22', '2017-07-22', 15, 'PL'),
(13, 75, '2017-07-24', '2017-07-24', NULL, 'PL'),
(14, 13, '2017-08-06', '2017-08-07', NULL, 'PL'),
(15, 13, '2017-08-06', '2017-08-07', NULL, 'PL'),
(16, 40, '2017-08-07', '2017-08-07', NULL, 'PL');

-- --------------------------------------------------------

--
-- Table structure for table `leave_audit`
--

CREATE TABLE `leave_audit` (
  `id` int(11) NOT NULL,
  `old_sl` int(11) DEFAULT NULL,
  `new_sl` int(11) DEFAULT NULL,
  `old_pl` int(11) DEFAULT NULL,
  `new_pl` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `leave_balance`
--

CREATE TABLE `leave_balance` (
  `id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `pl_balance` double DEFAULT '0',
  `sl_balance` double DEFAULT '0',
  `pl_total` double DEFAULT '10',
  `sl_total` double DEFAULT '10'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Triggers `leave_balance`
--
DELIMITER $$
CREATE TRIGGER `leave_balance_AFTER_UPDATE` AFTER UPDATE ON `leave_balance` FOR EACH ROW BEGIN
	insert into leave_audit (old_sl, new_sl, old_pl, new_pl) values(OLD.sl_balance, NEW.sl_balance, OLD.pl_balance, NEW.pl_balance);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `id` int(11) NOT NULL,
  `location_name` varchar(80) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`id`, `location_name`) VALUES
(1, 'DPL(DURGAPUR)'),
(2, 'ANDAL(DURGAPUR)'),
(11, 'MEJIA(DURGAPUR)'),
(12, 'ULTRATECH(DURGAPUR)'),
(13, 'ULTRATECH(DANKUNI)'),
(14, 'ULTRATECH(PATNA)'),
(15, 'EMAMI(PANAGHAR)'),
(16, 'BIRLA-CORP(DURGAPUR)'),
(17, 'AMBUJA(SAKREL)'),
(18, 'SRI CIMENT(PATNA)'),
(19, 'L&T(HATISALA)'),
(20, 'RDC(KONA)'),
(21, 'AFCON(SHALIMAR)');

-- --------------------------------------------------------

--
-- Table structure for table `modules`
--

CREATE TABLE `modules` (
  `id` int(11) NOT NULL,
  `name` varchar(80) NOT NULL,
  `code` varchar(45) NOT NULL,
  `url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `modules`
--

INSERT INTO `modules` (`id`, `name`, `code`, `url`) VALUES
(1, 'View Employees', 'VIEWEMP', NULL),
(2, 'View All Employees', 'VIEWALLEMP', NULL),
(3, 'Add Employee', 'ADDEMP', NULL),
(4, 'Edit Employee', 'EDITEMP', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `module` varchar(80) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `viewed` int(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `message`, `module`, `url`, `target_id`, `viewed`, `created_at`) VALUES
(147, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 15, 0, '2017-03-12 09:39:38'),
(150, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 16, 0, '2017-03-13 03:41:26'),
(151, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 17, 0, '2017-03-13 03:51:30'),
(152, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 18, 0, '2017-03-13 03:51:30'),
(153, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 14, 0, '2017-03-13 03:51:30'),
(154, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 13, 0, '2017-03-13 03:52:57'),
(155, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 12, 0, '2017-03-13 03:52:57'),
(156, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 19, 0, '2017-03-13 03:52:57'),
(157, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 20, 0, '2017-03-13 03:52:57'),
(158, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 21, 0, '2017-03-13 03:52:57'),
(159, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 22, 0, '2017-03-13 03:52:57'),
(160, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 23, 0, '2017-03-13 03:52:57'),
(161, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 24, 0, '2017-03-13 03:52:57'),
(162, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 25, 0, '2017-03-13 03:52:57'),
(163, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 26, 0, '2017-03-13 03:52:57'),
(164, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 27, 0, '2017-03-13 03:52:57'),
(165, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 28, 0, '2017-03-13 03:52:57'),
(166, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 29, 0, '2017-03-13 03:52:57'),
(167, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 30, 0, '2017-03-13 03:52:57'),
(168, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 31, 0, '2017-03-13 03:52:57'),
(169, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 32, 0, '2017-03-13 03:52:57'),
(170, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 33, 0, '2017-03-13 03:52:57'),
(171, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 34, 0, '2017-03-13 03:52:57'),
(172, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 35, 0, '2017-03-13 03:52:57'),
(173, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 36, 0, '2017-03-13 03:52:57'),
(174, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 37, 0, '2017-03-13 03:52:57'),
(175, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 38, 0, '2017-03-13 03:52:57'),
(176, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 39, 0, '2017-03-13 03:52:57'),
(177, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 40, 0, '2017-03-13 03:52:57'),
(178, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 41, 0, '2017-03-13 03:52:57'),
(179, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 43, 0, '2017-03-13 03:52:57'),
(180, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 44, 0, '2017-03-13 03:52:57'),
(181, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 45, 0, '2017-03-13 03:52:57'),
(182, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 46, 0, '2017-03-13 03:52:57'),
(183, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 47, 0, '2017-03-13 03:52:57'),
(184, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 48, 0, '2017-03-13 03:52:57'),
(185, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 49, 0, '2017-03-13 03:52:57'),
(186, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 50, 0, '2017-03-13 03:52:57'),
(187, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 51, 0, '2017-03-13 03:52:57'),
(188, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 52, 0, '2017-03-13 03:52:57'),
(189, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 53, 0, '2017-03-13 03:52:57'),
(190, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 54, 0, '2017-03-13 03:52:57'),
(191, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 55, 0, '2017-03-13 03:52:57'),
(192, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 56, 0, '2017-03-13 03:52:57'),
(193, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 57, 0, '2017-03-13 03:52:57'),
(194, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 58, 0, '2017-03-13 03:52:57'),
(195, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 59, 0, '2017-03-13 03:52:57'),
(196, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 60, 0, '2017-03-13 03:52:57'),
(197, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 61, 0, '2017-03-13 03:52:57'),
(198, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 62, 0, '2017-03-13 03:52:57'),
(199, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 63, 0, '2017-03-13 03:52:57'),
(200, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 64, 0, '2017-03-13 03:52:57'),
(201, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 65, 0, '2017-03-13 03:52:57'),
(202, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 66, 0, '2017-03-13 03:52:57'),
(203, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 67, 0, '2017-03-13 03:52:57'),
(204, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 68, 0, '2017-03-13 03:52:57'),
(205, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 69, 0, '2017-03-13 03:52:57'),
(206, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/1', 15, 0, '2017-03-15 11:58:00'),
(207, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/1', 15, 0, '2017-03-15 11:58:00'),
(208, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-03-15 11:58:00'),
(209, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-03-15 11:58:00'),
(210, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 12, 0, '2017-03-26 07:47:59'),
(211, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-03-26 07:47:59'),
(212, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 12, 0, '2017-03-26 07:51:37'),
(213, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-03-26 07:51:37'),
(214, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 16, 0, '2017-03-27 12:53:18'),
(215, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 15, 0, '2017-03-27 12:53:18'),
(216, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-03-27 12:53:18'),
(217, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-03-27 12:53:18'),
(218, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 16, 0, '2017-03-27 12:57:41'),
(219, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 15, 0, '2017-03-27 12:57:41'),
(220, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 16, 0, '2017-03-27 12:59:12'),
(221, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 15, 0, '2017-03-27 12:59:12'),
(222, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 16, 0, '2017-03-27 13:00:08'),
(223, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 15, 0, '2017-03-27 13:00:08'),
(224, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 16, 0, '2017-03-27 13:01:03'),
(225, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 15, 0, '2017-03-27 13:01:03'),
(226, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 16, 0, '2017-03-27 13:01:05'),
(227, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 15, 0, '2017-03-27 13:01:05'),
(228, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 16, 0, '2017-03-27 13:01:09'),
(229, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 15, 0, '2017-03-27 13:01:09'),
(230, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 16, 0, '2017-03-27 13:02:20'),
(231, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 15, 0, '2017-03-27 13:02:20'),
(232, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 16, 0, '2017-03-27 13:02:26'),
(233, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 15, 0, '2017-03-27 13:02:26'),
(234, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/3', 16, 0, '2017-03-27 13:05:22'),
(235, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/3', 16, 0, '2017-03-27 13:05:22'),
(236, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-03-27 13:05:22'),
(237, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-03-27 13:05:22'),
(238, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 69, 0, '2017-03-27 13:13:06'),
(239, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-03-27 13:13:06'),
(240, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/4', 16, 0, '2017-03-28 08:55:08'),
(241, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/4', 16, 0, '2017-03-28 08:55:08'),
(242, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-03-28 08:55:08'),
(243, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-03-28 08:55:08'),
(244, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/4', 16, 0, '2017-03-28 08:55:46'),
(245, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/4', 16, 0, '2017-03-28 08:55:46'),
(246, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/5', 12, 0, '2017-03-28 08:57:21'),
(247, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/5', 16, 0, '2017-03-28 08:57:21'),
(248, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 12, 0, '2017-03-28 08:57:21'),
(249, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-03-28 08:57:21'),
(250, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 16, 0, '2017-03-28 09:23:49'),
(251, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 15, 0, '2017-03-28 09:23:49'),
(252, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-03-28 09:23:49'),
(253, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-03-28 09:23:49'),
(254, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/7', 19, 0, '2017-03-28 09:24:52'),
(255, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/7', 15, 0, '2017-03-28 09:24:52'),
(256, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 19, 0, '2017-03-28 09:24:52'),
(257, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-03-28 09:24:52'),
(258, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 16, 0, '2017-03-28 09:25:26'),
(259, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/2', 15, 0, '2017-03-28 09:25:26'),
(260, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/8', 16, 0, '2017-03-28 09:26:18'),
(261, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/8', 16, 0, '2017-03-28 09:26:18'),
(262, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-03-28 09:26:18'),
(263, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-03-28 09:26:18'),
(264, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/9', 51, 0, '2017-03-28 09:26:29'),
(265, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/9', 15, 0, '2017-03-28 09:26:29'),
(266, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 51, 0, '2017-03-28 09:26:29'),
(267, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-03-28 09:26:29'),
(268, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/10', 15, 0, '2017-03-28 09:27:21'),
(269, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/10', 15, 0, '2017-03-28 09:27:21'),
(270, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-03-28 09:27:21'),
(271, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-03-28 09:27:21'),
(272, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/11', 16, 0, '2017-03-28 09:28:09'),
(273, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/11', 15, 0, '2017-03-28 09:28:09'),
(274, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-03-28 09:28:09'),
(275, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-03-28 09:28:09'),
(276, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 21, 0, '2017-03-28 09:29:16'),
(277, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 15, 0, '2017-03-28 09:29:16'),
(278, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-03-28 09:29:16'),
(279, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-03-28 09:29:16'),
(280, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 16, 0, '2017-03-28 09:29:21'),
(281, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 15, 0, '2017-03-28 09:29:21'),
(282, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/13', 51, 0, '2017-03-28 09:30:18'),
(283, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/13', 15, 0, '2017-03-28 09:30:18'),
(284, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 51, 0, '2017-03-28 09:30:18'),
(285, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-03-28 09:30:18'),
(286, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/14', 18, 0, '2017-03-28 09:30:59'),
(287, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/14', 15, 0, '2017-03-28 09:30:59'),
(288, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 18, 0, '2017-03-28 09:30:59'),
(289, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-03-28 09:30:59'),
(290, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/4', 16, 0, '2017-03-30 09:20:27'),
(291, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/4', 16, 0, '2017-03-30 09:20:27'),
(292, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 70, 0, '2017-03-31 18:10:32'),
(293, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 71, 0, '2017-04-05 19:05:24'),
(294, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/15', 16, 0, '2017-04-07 11:43:56'),
(295, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/15', 16, 0, '2017-04-07 11:43:56'),
(296, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-04-07 11:43:56'),
(297, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-04-07 11:43:56'),
(298, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/16', 16, 0, '2017-04-07 11:45:23'),
(299, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/16', 16, 0, '2017-04-07 11:45:23'),
(300, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-04-07 11:45:23'),
(301, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-04-07 11:45:23'),
(302, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-04-07 11:46:07'),
(303, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-04-07 11:46:07'),
(304, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-04-07 11:46:07'),
(305, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-04-07 11:46:07'),
(306, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 16, 0, '2017-04-07 11:52:14'),
(307, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 15, 0, '2017-04-07 11:52:14'),
(308, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 16, 0, '2017-04-07 12:01:17'),
(309, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 15, 0, '2017-04-07 12:01:17'),
(310, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 16, 0, '2017-04-07 12:01:59'),
(311, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 15, 0, '2017-04-07 12:01:59'),
(312, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 16, 0, '2017-04-07 12:42:48'),
(313, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 15, 0, '2017-04-07 12:42:48'),
(314, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 16, 0, '2017-04-07 12:43:11'),
(315, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 15, 0, '2017-04-07 12:43:11'),
(316, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 16, 0, '2017-04-07 12:43:32'),
(317, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/6', 15, 0, '2017-04-07 12:43:32'),
(318, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/8', 16, 0, '2017-04-07 12:44:23'),
(319, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/8', 16, 0, '2017-04-07 12:44:23'),
(320, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/16', 16, 0, '2017-04-07 12:47:03'),
(321, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/16', 16, 0, '2017-04-07 12:47:03'),
(322, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/18', 16, 0, '2017-04-07 12:48:44'),
(323, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/18', 16, 0, '2017-04-07 12:48:44'),
(324, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-04-07 12:48:44'),
(325, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-04-07 12:48:44'),
(326, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-04-07 12:50:30'),
(327, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-04-07 12:50:30'),
(328, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-04-07 12:53:48'),
(329, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-04-07 12:53:48'),
(330, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-04-07 12:54:41'),
(331, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-04-07 12:54:41'),
(332, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/18', 16, 0, '2017-04-07 12:55:37'),
(333, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/18', 16, 0, '2017-04-07 12:55:37'),
(334, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/18', 16, 0, '2017-04-07 12:56:05'),
(335, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/18', 16, 0, '2017-04-07 12:56:05'),
(336, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/19', 26, 0, '2017-04-07 12:58:06'),
(337, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/19', 16, 0, '2017-04-07 12:58:06'),
(338, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 26, 0, '2017-04-07 12:58:06'),
(339, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-04-07 12:58:06'),
(340, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/3', 16, 0, '2017-04-07 13:01:08'),
(341, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/3', 16, 0, '2017-04-07 13:01:08'),
(342, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 72, 0, '2017-04-15 06:59:30'),
(343, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 73, 0, '2017-04-24 17:22:20'),
(344, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/3', 16, 0, '2017-05-08 11:23:15'),
(345, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/3', 16, 0, '2017-05-08 11:23:15'),
(346, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 21, 0, '2017-05-08 11:45:31'),
(347, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 15, 0, '2017-05-08 11:45:31'),
(348, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-05-08 11:45:31'),
(349, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-05-08 11:45:31'),
(350, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 21, 0, '2017-05-08 11:47:06'),
(351, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 15, 0, '2017-05-08 11:47:06'),
(352, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 21, 0, '2017-05-08 11:48:20'),
(353, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 15, 0, '2017-05-08 11:48:20'),
(354, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 21, 0, '2017-05-08 11:48:20'),
(355, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 15, 0, '2017-05-08 11:48:20'),
(356, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 21, 0, '2017-05-08 11:48:25'),
(357, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 15, 0, '2017-05-08 11:48:25'),
(358, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 21, 0, '2017-05-08 11:48:25'),
(359, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 15, 0, '2017-05-08 11:48:25'),
(360, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 21, 0, '2017-05-08 11:48:53'),
(361, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/20', 15, 0, '2017-05-08 11:48:53'),
(362, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/21', 21, 0, '2017-05-08 11:52:54'),
(363, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/21', 21, 0, '2017-05-08 11:52:54'),
(364, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-05-08 11:52:54'),
(365, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 21, 0, '2017-05-08 11:52:54'),
(366, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/22', 17, 0, '2017-05-08 11:54:01'),
(367, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/22', 17, 0, '2017-05-08 11:54:01'),
(368, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 17, 0, '2017-05-08 11:54:01'),
(369, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 17, 0, '2017-05-08 11:54:01'),
(370, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 21, 0, '2017-05-08 11:54:30'),
(371, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-05-08 11:54:30'),
(372, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/22', 17, 0, '2017-05-08 11:55:00'),
(373, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/22', 17, 0, '2017-05-08 11:55:00'),
(374, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/22', 17, 0, '2017-05-08 11:55:00'),
(375, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/22', 17, 0, '2017-05-08 11:55:00'),
(376, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 17, 0, '2017-05-08 11:57:16'),
(377, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-05-08 11:57:16'),
(378, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 74, 0, '2017-05-08 13:25:35'),
(379, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/23', 21, 0, '2017-05-09 11:03:22'),
(380, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/23', 21, 0, '2017-05-09 11:03:22'),
(381, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-05-09 11:03:22'),
(382, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 21, 0, '2017-05-09 11:03:22'),
(383, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/21', 21, 0, '2017-05-09 11:04:06'),
(384, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/21', 21, 0, '2017-05-09 11:04:06'),
(385, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/21', 21, 0, '2017-05-09 11:04:06'),
(386, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/21', 21, 0, '2017-05-09 11:04:06'),
(387, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 21, 0, '2017-05-09 11:07:44'),
(388, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 15, 0, '2017-05-09 11:07:44'),
(389, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/24', 40, 0, '2017-05-10 06:16:37'),
(390, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/24', 40, 0, '2017-05-10 06:16:37'),
(391, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-05-10 06:16:37'),
(392, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 40, 0, '2017-05-10 06:16:37'),
(393, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/25', 40, 0, '2017-05-10 06:20:12'),
(394, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/25', 40, 0, '2017-05-10 06:20:12'),
(395, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-05-10 06:20:12'),
(396, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 40, 0, '2017-05-10 06:20:12'),
(397, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/26', 21, 0, '2017-05-10 06:56:31'),
(398, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/26', 21, 0, '2017-05-10 06:56:31'),
(399, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-05-10 06:56:31'),
(400, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 21, 0, '2017-05-10 06:56:31'),
(401, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 40, 0, '2017-05-10 07:28:49'),
(402, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-05-10 07:28:49'),
(403, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 40, 0, '2017-05-10 07:37:12'),
(404, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-05-10 07:37:12'),
(405, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 40, 0, '2017-05-10 07:40:40'),
(406, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-05-10 07:40:40'),
(407, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/27', 12, 0, '2017-05-10 07:53:17'),
(408, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/27', 16, 0, '2017-05-10 07:53:17'),
(409, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 12, 0, '2017-05-10 07:53:17'),
(410, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-05-10 07:53:17'),
(411, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/27', 12, 0, '2017-05-10 07:54:27'),
(412, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/27', 16, 0, '2017-05-10 07:54:27'),
(413, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/27', 12, 0, '2017-05-10 07:54:46'),
(414, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/27', 16, 0, '2017-05-10 07:54:46'),
(415, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/28', 16, 0, '2017-05-10 07:56:25'),
(416, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/28', 15, 0, '2017-05-10 07:56:25'),
(417, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-05-10 07:56:25'),
(418, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-05-10 07:56:25'),
(419, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/28', 16, 0, '2017-05-10 07:58:06'),
(420, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/28', 15, 0, '2017-05-10 07:58:06'),
(421, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/29', 40, 0, '2017-05-10 09:21:54'),
(422, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/29', 40, 0, '2017-05-10 09:21:54'),
(423, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-05-10 09:21:54'),
(424, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 40, 0, '2017-05-10 09:21:54'),
(425, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/30', 40, 0, '2017-05-10 09:22:30'),
(426, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/30', 40, 0, '2017-05-10 09:22:30'),
(427, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-05-10 09:22:30'),
(428, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 40, 0, '2017-05-10 09:22:30'),
(429, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/31', 61, 0, '2017-05-10 11:16:58'),
(430, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/31', 61, 0, '2017-05-10 11:16:58'),
(431, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 61, 0, '2017-05-10 11:16:58'),
(432, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 61, 0, '2017-05-10 11:16:58'),
(433, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/32', 58, 0, '2017-05-11 03:47:28'),
(434, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/32', 58, 0, '2017-05-11 03:47:28'),
(435, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 58, 0, '2017-05-11 03:47:28'),
(436, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 58, 0, '2017-05-11 03:47:28'),
(437, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/32', 58, 0, '2017-05-11 04:01:44'),
(438, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/32', 58, 0, '2017-05-11 04:01:44'),
(439, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/32', 58, 0, '2017-05-11 04:01:44'),
(440, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/32', 58, 0, '2017-05-11 04:01:44'),
(441, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/33', 58, 0, '2017-05-11 04:24:09'),
(442, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/33', 58, 0, '2017-05-11 04:24:09'),
(443, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 58, 0, '2017-05-11 04:24:09'),
(444, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 58, 0, '2017-05-11 04:24:09'),
(445, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/33', 58, 0, '2017-05-11 04:24:37'),
(446, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/33', 58, 0, '2017-05-11 04:24:37'),
(447, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/33', 58, 0, '2017-05-11 04:24:37'),
(448, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/33', 58, 0, '2017-05-11 04:24:37'),
(449, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/34', 40, 0, '2017-05-11 05:51:03'),
(450, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/34', 40, 0, '2017-05-11 05:51:03'),
(451, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-05-11 05:51:03'),
(452, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 40, 0, '2017-05-11 05:51:03'),
(453, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/24', 40, 0, '2017-05-11 05:51:35'),
(454, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/24', 40, 0, '2017-05-11 05:51:35'),
(455, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/24', 40, 0, '2017-05-11 05:51:35'),
(456, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/24', 40, 0, '2017-05-11 05:51:35'),
(457, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/35', 40, 0, '2017-05-11 08:14:50'),
(458, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/35', 40, 0, '2017-05-11 08:14:50'),
(459, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-05-11 08:14:50'),
(460, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 40, 0, '2017-05-11 08:14:50'),
(461, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/36', 40, 0, '2017-05-11 09:54:34'),
(462, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/36', 40, 0, '2017-05-11 09:54:34'),
(463, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-05-11 09:54:34'),
(464, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 40, 0, '2017-05-11 09:54:34'),
(465, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/25', 40, 0, '2017-05-11 09:54:57'),
(466, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/25', 40, 0, '2017-05-11 09:54:57'),
(467, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/25', 40, 0, '2017-05-11 09:54:57'),
(468, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/25', 40, 0, '2017-05-11 09:54:57'),
(469, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/29', 40, 0, '2017-05-11 09:55:43'),
(470, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/29', 40, 0, '2017-05-11 09:55:43'),
(471, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/34', 40, 0, '2017-05-11 09:56:17'),
(472, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/34', 40, 0, '2017-05-11 09:56:17'),
(473, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/34', 40, 0, '2017-05-11 09:56:17'),
(474, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/34', 40, 0, '2017-05-11 09:56:17'),
(475, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/35', 40, 0, '2017-05-11 09:56:34'),
(476, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/35', 40, 0, '2017-05-11 09:56:34'),
(477, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/35', 40, 0, '2017-05-11 09:56:34'),
(478, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/35', 40, 0, '2017-05-11 09:56:34'),
(479, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/36', 40, 0, '2017-05-11 12:25:19'),
(480, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/36', 40, 0, '2017-05-11 12:25:19'),
(481, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/36', 40, 0, '2017-05-11 12:25:30'),
(482, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/36', 40, 0, '2017-05-11 12:25:30'),
(483, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/36', 40, 0, '2017-05-11 12:25:30'),
(484, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/36', 40, 0, '2017-05-11 12:25:30'),
(485, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/37', 40, 0, '2017-05-12 05:32:02'),
(486, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/37', 40, 0, '2017-05-12 05:32:02'),
(487, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-05-12 05:32:02'),
(488, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 40, 0, '2017-05-12 05:32:02'),
(489, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/37', 40, 0, '2017-05-12 07:17:38'),
(490, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/37', 40, 0, '2017-05-12 07:17:38'),
(491, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/37', 40, 0, '2017-05-12 07:17:38'),
(492, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/37', 40, 0, '2017-05-12 07:17:38'),
(493, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/38', 40, 0, '2017-05-12 07:20:12'),
(494, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/38', 40, 0, '2017-05-12 07:20:12'),
(495, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-05-12 07:20:12'),
(496, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 40, 0, '2017-05-12 07:20:12'),
(497, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/39', 40, 0, '2017-05-12 07:21:32'),
(498, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/39', 40, 0, '2017-05-12 07:21:32'),
(499, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-05-12 07:21:32'),
(500, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 40, 0, '2017-05-12 07:21:32'),
(501, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/40', 40, 0, '2017-05-12 11:29:09'),
(502, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/40', 40, 0, '2017-05-12 11:29:09'),
(503, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-05-12 11:29:09'),
(504, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 40, 0, '2017-05-12 11:29:09'),
(505, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/40', 40, 0, '2017-05-12 11:29:36'),
(506, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/40', 40, 0, '2017-05-12 11:29:36'),
(507, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/40', 40, 0, '2017-05-12 11:29:36'),
(508, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/40', 40, 0, '2017-05-12 11:29:36'),
(509, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/39', 40, 0, '2017-05-12 11:29:55'),
(510, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/39', 40, 0, '2017-05-12 11:29:55'),
(511, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/39', 40, 0, '2017-05-12 11:29:55'),
(512, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/39', 40, 0, '2017-05-12 11:29:55'),
(513, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 75, 0, '2017-05-12 12:13:47'),
(514, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/41', 44, 0, '2017-05-16 10:53:52'),
(515, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/41', 44, 0, '2017-05-16 10:53:52'),
(516, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-05-16 10:53:52'),
(517, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-05-16 10:53:52'),
(518, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/41', 44, 0, '2017-05-16 10:54:18'),
(519, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/41', 44, 0, '2017-05-16 10:54:18'),
(520, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/41', 44, 0, '2017-05-16 10:54:34'),
(521, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/41', 44, 0, '2017-05-16 10:54:34'),
(522, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/41', 44, 0, '2017-05-16 10:54:34'),
(523, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/41', 44, 0, '2017-05-16 10:54:34'),
(524, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/42', 12, 0, '2017-05-27 09:47:37'),
(525, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/42', 15, 0, '2017-05-27 09:47:37'),
(526, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 12, 0, '2017-05-27 09:47:37'),
(527, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-05-27 09:47:37'),
(528, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/42', 12, 0, '2017-05-27 09:49:10'),
(529, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/42', 15, 0, '2017-05-27 09:49:10'),
(530, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/42', 12, 0, '2017-05-27 09:49:33'),
(531, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/42', 15, 0, '2017-05-27 09:49:33'),
(532, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/42', 12, 0, '2017-05-27 09:49:48'),
(533, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/42', 15, 0, '2017-05-27 09:49:48'),
(534, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/43', 21, 0, '2017-05-27 11:32:25'),
(535, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/43', 70, 0, '2017-05-27 11:32:25'),
(536, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-05-27 11:32:25'),
(537, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 70, 0, '2017-05-27 11:32:25'),
(538, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/44', 21, 0, '2017-05-27 13:30:41'),
(539, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/44', 21, 0, '2017-05-27 13:30:41'),
(540, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-05-27 13:30:41'),
(541, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 21, 0, '2017-05-27 13:30:41'),
(542, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/45', 21, 0, '2017-05-27 13:56:13'),
(543, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/45', 21, 0, '2017-05-27 13:56:13'),
(544, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-05-27 13:56:13'),
(545, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 21, 0, '2017-05-27 13:56:13'),
(546, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/46', 75, 0, '2017-05-29 05:39:20'),
(547, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/46', 75, 0, '2017-05-29 05:39:20'),
(548, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-05-29 05:39:20'),
(549, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-05-29 05:39:20'),
(550, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/46', 75, 0, '2017-05-29 05:40:25'),
(551, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/46', 75, 0, '2017-05-29 05:40:25'),
(552, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/46', 75, 0, '2017-05-29 05:40:25'),
(553, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/46', 75, 0, '2017-05-29 05:40:25'),
(554, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/47', 75, 0, '2017-05-29 05:45:12'),
(555, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/47', 75, 0, '2017-05-29 05:45:12'),
(556, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-05-29 05:45:12'),
(557, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-05-29 05:45:12'),
(558, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/47', 75, 0, '2017-05-29 05:45:44'),
(559, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/47', 75, 0, '2017-05-29 05:45:44'),
(560, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/47', 75, 0, '2017-05-29 05:45:44'),
(561, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/47', 75, 0, '2017-05-29 05:45:44'),
(562, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/47', 75, 0, '2017-05-29 05:45:45'),
(563, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/47', 75, 0, '2017-05-29 05:45:45'),
(564, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/47', 75, 0, '2017-05-29 05:45:45'),
(565, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/47', 75, 0, '2017-05-29 05:45:45'),
(566, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/48', 75, 0, '2017-05-29 06:13:29'),
(567, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/48', 75, 0, '2017-05-29 06:13:29'),
(568, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-05-29 06:13:29'),
(569, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-05-29 06:13:29'),
(570, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/49', 75, 0, '2017-05-29 07:46:49'),
(571, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/49', 75, 0, '2017-05-29 07:46:49'),
(572, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-05-29 07:46:49'),
(573, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-05-29 07:46:49'),
(574, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/50', 75, 0, '2017-05-29 11:23:07'),
(575, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/50', 75, 0, '2017-05-29 11:23:07'),
(576, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-05-29 11:23:07'),
(577, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-05-29 11:23:07'),
(578, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/51', 75, 0, '2017-05-29 13:34:48'),
(579, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/51', 75, 0, '2017-05-29 13:34:48'),
(580, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-05-29 13:34:48'),
(581, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-05-29 13:34:48');
INSERT INTO `notifications` (`id`, `message`, `module`, `url`, `target_id`, `viewed`, `created_at`) VALUES
(582, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/9', 51, 0, '2017-05-30 11:15:15'),
(583, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/9', 15, 0, '2017-05-30 11:15:15'),
(584, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/13', 51, 0, '2017-05-30 11:16:07'),
(585, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/13', 15, 0, '2017-05-30 11:16:07'),
(586, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/52', 21, 0, '2017-06-01 08:54:09'),
(587, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/52', 15, 0, '2017-06-01 08:54:09'),
(588, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-06-01 08:54:09'),
(589, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-06-01 08:54:09'),
(590, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/11', 16, 0, '2017-06-01 08:54:56'),
(591, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/11', 15, 0, '2017-06-01 08:54:56'),
(592, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/53', 12, 0, '2017-06-03 11:04:16'),
(593, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/53', 15, 0, '2017-06-03 11:04:16'),
(594, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 12, 0, '2017-06-03 11:04:16'),
(595, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-06-03 11:04:16'),
(596, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/53', 12, 0, '2017-06-03 11:05:00'),
(597, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/53', 15, 0, '2017-06-03 11:05:00'),
(598, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/52', 21, 0, '2017-06-03 11:05:42'),
(599, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/52', 15, 0, '2017-06-03 11:05:42'),
(600, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 76, 0, '2017-06-05 13:25:16'),
(601, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 77, 0, '2017-06-06 10:21:20'),
(602, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 78, 0, '2017-06-06 10:51:13'),
(603, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 79, 0, '2017-06-06 11:30:10'),
(604, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 80, 0, '2017-06-07 10:41:56'),
(605, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/54', 21, 0, '2017-06-10 10:56:44'),
(606, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/54', 21, 0, '2017-06-10 10:56:44'),
(607, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-06-10 10:56:44'),
(608, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 21, 0, '2017-06-10 10:56:44'),
(609, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/55', 15, 0, '2017-06-12 07:06:32'),
(610, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/55', 15, 0, '2017-06-12 07:06:32'),
(611, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-06-12 07:06:32'),
(612, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-06-12 07:06:32'),
(613, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 81, 0, '2017-06-12 09:52:58'),
(614, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 82, 0, '2017-06-12 10:02:13'),
(615, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/56', 15, 0, '2017-06-14 05:50:35'),
(616, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/56', 15, 0, '2017-06-14 05:50:35'),
(617, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-06-14 05:50:35'),
(618, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-06-14 05:50:35'),
(619, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/57', 15, 0, '2017-06-14 05:51:01'),
(620, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/57', 15, 0, '2017-06-14 05:51:01'),
(621, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-06-14 05:51:01'),
(622, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-06-14 05:51:01'),
(623, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/58', 15, 0, '2017-06-14 05:51:50'),
(624, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/58', 15, 0, '2017-06-14 05:51:50'),
(625, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-06-14 05:51:50'),
(626, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-06-14 05:51:50'),
(627, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/59', 12, 0, '2017-06-14 05:52:14'),
(628, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/59', 15, 0, '2017-06-14 05:52:14'),
(629, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 12, 0, '2017-06-14 05:52:14'),
(630, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-06-14 05:52:14'),
(631, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/60', 12, 0, '2017-06-14 05:52:38'),
(632, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/60', 15, 0, '2017-06-14 05:52:38'),
(633, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 12, 0, '2017-06-14 05:52:38'),
(634, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-06-14 05:52:38'),
(635, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/61', 15, 0, '2017-06-14 05:53:23'),
(636, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/61', 15, 0, '2017-06-14 05:53:23'),
(637, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-06-14 05:53:23'),
(638, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-06-14 05:53:23'),
(639, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 40, 0, '2017-06-20 11:20:58'),
(640, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-06-20 11:20:58'),
(641, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/62', 12, 0, '2017-06-21 06:11:20'),
(642, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/62', 79, 0, '2017-06-21 06:11:20'),
(643, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 12, 0, '2017-06-21 06:11:20'),
(644, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 79, 0, '2017-06-21 06:11:20'),
(645, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/62', 12, 0, '2017-06-21 06:12:29'),
(646, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/62', 79, 0, '2017-06-21 06:12:29'),
(647, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 84, 0, '2017-06-27 10:21:41'),
(648, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/63', 26, 0, '2017-06-27 13:30:09'),
(649, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/63', 84, 0, '2017-06-27 13:30:09'),
(650, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 26, 0, '2017-06-27 13:30:09'),
(651, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 84, 0, '2017-06-27 13:30:09'),
(652, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 85, 0, '2017-06-28 11:39:33'),
(653, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 44, 0, '2017-06-28 12:53:51'),
(654, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-06-28 12:53:51'),
(655, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/64', 15, 0, '2017-07-04 09:52:41'),
(656, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/64', 15, 0, '2017-07-04 09:52:41'),
(657, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-04 09:52:41'),
(658, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-04 09:52:41'),
(659, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/65', 40, 0, '2017-07-04 10:53:07'),
(660, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/65', 15, 0, '2017-07-04 10:53:07'),
(661, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 40, 0, '2017-07-04 10:53:07'),
(662, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-04 10:53:07'),
(663, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 86, 0, '2017-07-05 09:32:44'),
(664, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 87, 0, '2017-07-05 12:05:11'),
(665, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 88, 0, '2017-07-07 07:35:28'),
(666, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 89, 0, '2017-07-07 07:45:11'),
(667, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 90, 0, '2017-07-07 08:05:09'),
(668, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/66', 15, 0, '2017-07-17 03:12:23'),
(669, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/66', 15, 0, '2017-07-17 03:12:23'),
(670, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-17 03:12:23'),
(671, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-17 03:12:23'),
(672, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/67', 15, 0, '2017-07-17 03:15:24'),
(673, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/67', 15, 0, '2017-07-17 03:15:24'),
(674, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-17 03:15:24'),
(675, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-17 03:15:24'),
(676, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/68', 15, 0, '2017-07-17 04:19:14'),
(677, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/68', 15, 0, '2017-07-17 04:19:14'),
(678, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-17 04:19:14'),
(679, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-17 04:19:14'),
(680, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/66', 15, 0, '2017-07-17 12:15:10'),
(681, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/66', 15, 0, '2017-07-17 12:15:10'),
(682, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/69', 15, 0, '2017-07-18 15:22:10'),
(683, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/69', 15, 0, '2017-07-18 15:22:10'),
(684, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-18 15:22:10'),
(685, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-18 15:22:10'),
(686, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/70', 15, 0, '2017-07-18 15:24:52'),
(687, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/70', 15, 0, '2017-07-18 15:24:52'),
(688, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-18 15:24:52'),
(689, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-18 15:24:52'),
(690, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/71', 15, 0, '2017-07-18 15:26:47'),
(691, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/71', 15, 0, '2017-07-18 15:26:47'),
(692, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-18 15:26:47'),
(693, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-18 15:26:47'),
(694, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/72', 15, 0, '2017-07-18 15:28:51'),
(695, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/72', 15, 0, '2017-07-18 15:28:51'),
(696, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-18 15:28:51'),
(697, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-18 15:28:51'),
(698, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 13, 0, '2017-07-20 13:53:31'),
(699, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-07-20 13:53:31'),
(700, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/68', 15, 0, '2017-07-21 04:56:13'),
(701, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/68', 15, 0, '2017-07-21 04:56:13'),
(702, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/71', 15, 0, '2017-07-21 19:53:12'),
(703, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/71', 15, 0, '2017-07-21 19:53:12'),
(704, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/72', 15, 0, '2017-07-21 19:56:05'),
(705, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/72', 15, 0, '2017-07-21 19:56:05'),
(706, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/70', 15, 0, '2017-07-21 19:57:27'),
(707, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/70', 15, 0, '2017-07-21 19:57:27'),
(708, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/59', 12, 0, '2017-07-21 19:59:47'),
(709, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/59', 15, 0, '2017-07-21 19:59:47'),
(710, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 75, 0, '2017-07-22 10:40:39'),
(711, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-07-22 10:40:39'),
(712, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 75, 0, '2017-07-22 10:45:45'),
(713, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-07-22 10:45:45'),
(714, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/73', 75, 0, '2017-07-22 11:01:00'),
(715, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/73', 75, 0, '2017-07-22 11:01:00'),
(716, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-07-22 11:01:00'),
(717, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-07-22 11:01:00'),
(718, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/74', 75, 0, '2017-07-22 11:01:47'),
(719, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/74', 75, 0, '2017-07-22 11:01:47'),
(720, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-07-22 11:01:47'),
(721, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-07-22 11:01:47'),
(722, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/75', 75, 0, '2017-07-22 11:06:57'),
(723, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/75', 75, 0, '2017-07-22 11:06:57'),
(724, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-07-22 11:06:57'),
(725, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-07-22 11:06:57'),
(726, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/76', 75, 0, '2017-07-22 13:17:42'),
(727, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/76', 75, 0, '2017-07-22 13:17:42'),
(728, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-07-22 13:17:42'),
(729, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-07-22 13:17:42'),
(730, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/69', 15, 0, '2017-07-24 13:10:48'),
(731, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/69', 15, 0, '2017-07-24 13:10:48'),
(732, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/69', 15, 0, '2017-07-24 13:12:26'),
(733, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/69', 15, 0, '2017-07-24 13:12:26'),
(734, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/77', 21, 0, '2017-07-24 13:15:05'),
(735, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/77', 15, 0, '2017-07-24 13:15:05'),
(736, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-07-24 13:15:05'),
(737, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-24 13:15:05'),
(738, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/78', 13, 0, '2017-07-24 16:45:47'),
(739, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/78', 15, 0, '2017-07-24 16:45:47'),
(740, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 13, 0, '2017-07-24 16:45:47'),
(741, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-24 16:45:47'),
(742, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 21, 0, '2017-07-26 05:17:14'),
(743, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 15, 0, '2017-07-26 05:17:14'),
(744, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 21, 0, '2017-07-26 05:17:37'),
(745, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 15, 0, '2017-07-26 05:17:37'),
(746, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 21, 0, '2017-07-26 05:17:37'),
(747, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 15, 0, '2017-07-26 05:17:37'),
(748, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 21, 0, '2017-07-26 05:17:39'),
(749, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 15, 0, '2017-07-26 05:17:39'),
(750, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 21, 0, '2017-07-26 05:17:39'),
(751, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/12', 15, 0, '2017-07-26 05:17:39'),
(752, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/45', 21, 0, '2017-07-26 05:19:04'),
(753, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/45', 21, 0, '2017-07-26 05:19:04'),
(754, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/45', 21, 0, '2017-07-26 05:19:04'),
(755, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/45', 21, 0, '2017-07-26 05:19:04'),
(756, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/79', 16, 0, '2017-07-26 06:33:40'),
(757, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/79', 16, 0, '2017-07-26 06:33:40'),
(758, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-07-26 06:33:40'),
(759, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-07-26 06:33:40'),
(760, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/80', 21, 0, '2017-07-27 13:47:27'),
(761, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/80', 21, 0, '2017-07-27 13:47:27'),
(762, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 21, 0, '2017-07-27 13:47:27'),
(763, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 21, 0, '2017-07-27 13:47:27'),
(764, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/81', 15, 0, '2017-07-28 08:25:42'),
(765, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/81', 15, 0, '2017-07-28 08:25:42'),
(766, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-28 08:25:42'),
(767, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 08:25:42'),
(768, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/82', 84, 0, '2017-07-28 08:45:06'),
(769, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/82', 15, 0, '2017-07-28 08:45:06'),
(770, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 84, 0, '2017-07-28 08:45:06'),
(771, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 08:45:06'),
(772, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/83', 84, 0, '2017-07-28 08:45:32'),
(773, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/83', 15, 0, '2017-07-28 08:45:32'),
(774, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 84, 0, '2017-07-28 08:45:32'),
(775, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 08:45:32'),
(776, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/84', 84, 0, '2017-07-28 08:46:08'),
(777, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/84', 15, 0, '2017-07-28 08:46:08'),
(778, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 84, 0, '2017-07-28 08:46:08'),
(779, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 08:46:08'),
(780, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/85', 15, 0, '2017-07-28 08:51:34'),
(781, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/85', 15, 0, '2017-07-28 08:51:34'),
(782, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-28 08:51:34'),
(783, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 08:51:34'),
(784, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/86', 44, 0, '2017-07-28 08:55:33'),
(785, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/86', 15, 0, '2017-07-28 08:55:33'),
(786, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-07-28 08:55:33'),
(787, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 08:55:33'),
(788, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/87', 70, 0, '2017-07-28 08:56:02'),
(789, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/87', 15, 0, '2017-07-28 08:56:02'),
(790, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 70, 0, '2017-07-28 08:56:02'),
(791, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 08:56:02'),
(792, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/88', 70, 0, '2017-07-28 08:57:09'),
(793, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/88', 15, 0, '2017-07-28 08:57:09'),
(794, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 70, 0, '2017-07-28 08:57:09'),
(795, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 08:57:09'),
(796, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/89', 70, 0, '2017-07-28 08:57:39'),
(797, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/89', 15, 0, '2017-07-28 08:57:39'),
(798, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 70, 0, '2017-07-28 08:57:39'),
(799, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 08:57:39'),
(800, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/90', 70, 0, '2017-07-28 08:58:02'),
(801, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/90', 15, 0, '2017-07-28 08:58:02'),
(802, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 70, 0, '2017-07-28 08:58:02'),
(803, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 08:58:02'),
(804, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/91', 15, 0, '2017-07-28 09:01:10'),
(805, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/91', 15, 0, '2017-07-28 09:01:10'),
(806, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-28 09:01:10'),
(807, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 09:01:10'),
(808, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/92', 13, 0, '2017-07-28 09:45:36'),
(809, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/92', 15, 0, '2017-07-28 09:45:36'),
(810, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 13, 0, '2017-07-28 09:45:36'),
(811, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 09:45:36'),
(812, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/93', 15, 0, '2017-07-28 09:46:58'),
(813, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/93', 15, 0, '2017-07-28 09:46:58'),
(814, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-28 09:46:58'),
(815, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 09:46:58'),
(816, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/94', 15, 0, '2017-07-28 09:47:35'),
(817, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/94', 15, 0, '2017-07-28 09:47:35'),
(818, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-28 09:47:35'),
(819, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 09:47:35'),
(820, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/95', 70, 0, '2017-07-28 10:00:56'),
(821, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/95', 15, 0, '2017-07-28 10:00:56'),
(822, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 70, 0, '2017-07-28 10:00:56'),
(823, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 10:00:56'),
(824, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/96', 38, 0, '2017-07-28 10:01:11'),
(825, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/96', 15, 0, '2017-07-28 10:01:11'),
(826, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 38, 0, '2017-07-28 10:01:11'),
(827, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-28 10:01:11'),
(829, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/84', 84, 0, '2017-07-29 11:18:30'),
(830, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/84', 15, 0, '2017-07-29 11:18:30'),
(831, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/82', 84, 0, '2017-07-29 11:21:10'),
(832, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/82', 15, 0, '2017-07-29 11:21:10'),
(833, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/97', 15, 0, '2017-07-29 15:29:19'),
(834, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/97', 15, 0, '2017-07-29 15:29:19'),
(835, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-07-29 15:29:19'),
(836, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-07-29 15:29:19'),
(837, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/90', 70, 0, '2017-07-31 04:52:42'),
(838, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/90', 15, 0, '2017-07-31 04:52:42'),
(839, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/98', 16, 0, '2017-07-31 07:29:00'),
(840, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/98', 16, 0, '2017-07-31 07:29:00'),
(841, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-07-31 07:29:00'),
(842, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-07-31 07:29:00'),
(843, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/99', 16, 0, '2017-07-31 07:29:56'),
(844, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/99', 16, 0, '2017-07-31 07:29:56'),
(845, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-07-31 07:29:56'),
(846, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-07-31 07:29:56'),
(847, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/19', 26, 0, '2017-07-31 07:30:22'),
(848, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/19', 16, 0, '2017-07-31 07:30:22'),
(849, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/99', 16, 0, '2017-07-31 07:31:31'),
(850, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/99', 16, 0, '2017-07-31 07:31:31'),
(851, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/100', 16, 0, '2017-07-31 07:34:22'),
(852, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/100', 16, 0, '2017-07-31 07:34:22'),
(853, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-07-31 07:34:22'),
(854, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-07-31 07:34:22'),
(855, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/101', 16, 0, '2017-07-31 07:37:45'),
(856, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/101', 16, 0, '2017-07-31 07:37:45'),
(857, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-07-31 07:37:45'),
(858, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-07-31 07:37:45'),
(859, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/18', 16, 0, '2017-07-31 07:38:13'),
(860, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/18', 16, 0, '2017-07-31 07:38:13'),
(861, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-07-31 07:38:44'),
(862, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-07-31 07:38:44'),
(863, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-07-31 07:38:51'),
(864, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/17', 16, 0, '2017-07-31 07:38:51'),
(865, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/102', 16, 0, '2017-07-31 07:40:07'),
(866, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/102', 16, 0, '2017-07-31 07:40:07'),
(867, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-07-31 07:40:07'),
(868, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-07-31 07:40:07'),
(869, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/102', 16, 0, '2017-07-31 07:58:28'),
(870, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/102', 16, 0, '2017-07-31 07:58:28'),
(871, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/81', 15, 0, '2017-07-31 14:59:03'),
(872, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/81', 15, 0, '2017-07-31 14:59:03'),
(873, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/81', 15, 0, '2017-07-31 14:59:11'),
(874, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/81', 15, 0, '2017-07-31 14:59:11'),
(875, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/81', 15, 0, '2017-07-31 14:59:38'),
(876, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/81', 15, 0, '2017-07-31 14:59:38'),
(877, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/81', 15, 0, '2017-07-31 14:59:41'),
(878, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/81', 15, 0, '2017-07-31 14:59:41'),
(879, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/103', 74, 0, '2017-08-01 04:35:28'),
(880, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/103', 74, 0, '2017-08-01 04:35:28'),
(881, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 74, 0, '2017-08-01 04:35:28'),
(882, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 74, 0, '2017-08-01 04:35:28'),
(883, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/102', 16, 0, '2017-08-01 05:10:33'),
(884, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/102', 16, 0, '2017-08-01 05:10:33'),
(885, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/102', 16, 0, '2017-08-01 05:10:59'),
(886, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/102', 16, 0, '2017-08-01 05:10:59'),
(887, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/98', 16, 0, '2017-08-01 05:12:35'),
(888, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/98', 16, 0, '2017-08-01 05:12:35'),
(889, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/104', 16, 0, '2017-08-01 05:14:49'),
(890, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/104', 16, 0, '2017-08-01 05:14:49'),
(891, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-08-01 05:14:49'),
(892, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-08-01 05:14:49'),
(893, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/104', 16, 0, '2017-08-01 05:15:51'),
(894, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/104', 16, 0, '2017-08-01 05:15:51'),
(895, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/100', 16, 0, '2017-08-01 05:17:02'),
(896, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/100', 16, 0, '2017-08-01 05:17:02'),
(897, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/105', 16, 0, '2017-08-01 05:19:22'),
(898, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/105', 16, 0, '2017-08-01 05:19:22'),
(899, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-08-01 05:19:22'),
(900, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-08-01 05:19:22'),
(901, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/106', 16, 0, '2017-08-01 05:20:36'),
(902, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/106', 16, 0, '2017-08-01 05:20:36'),
(903, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-08-01 05:20:36'),
(904, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-08-01 05:20:36'),
(905, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/14', 18, 0, '2017-08-01 08:38:47'),
(906, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/14', 15, 0, '2017-08-01 08:38:47'),
(907, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/107', 44, 0, '2017-08-01 10:32:25'),
(908, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/107', 44, 0, '2017-08-01 10:32:25'),
(909, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:32:25'),
(910, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:32:25'),
(911, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/108', 44, 0, '2017-08-01 10:46:25'),
(912, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/108', 44, 0, '2017-08-01 10:46:25'),
(913, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:46:25'),
(914, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:46:25'),
(915, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/109', 44, 0, '2017-08-01 10:47:11'),
(916, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/109', 44, 0, '2017-08-01 10:47:11'),
(917, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:47:11'),
(918, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:47:11'),
(919, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/110', 44, 0, '2017-08-01 10:47:50'),
(920, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/110', 44, 0, '2017-08-01 10:47:50'),
(921, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:47:50'),
(922, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:47:50'),
(923, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/111', 44, 0, '2017-08-01 10:48:44'),
(924, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/111', 44, 0, '2017-08-01 10:48:44'),
(925, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:48:44'),
(926, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:48:44'),
(927, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/112', 44, 0, '2017-08-01 10:49:19'),
(928, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/112', 44, 0, '2017-08-01 10:49:19'),
(929, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:49:19'),
(930, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:49:19'),
(931, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/113', 44, 0, '2017-08-01 10:49:57'),
(932, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/113', 44, 0, '2017-08-01 10:49:57'),
(933, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:49:57'),
(934, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:49:57'),
(935, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/114', 44, 0, '2017-08-01 10:50:42'),
(936, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/114', 44, 0, '2017-08-01 10:50:42'),
(937, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:50:42'),
(938, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:50:42'),
(939, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/115', 44, 0, '2017-08-01 10:51:17'),
(940, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/115', 44, 0, '2017-08-01 10:51:17'),
(941, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:51:17'),
(942, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:51:17'),
(943, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/116', 44, 0, '2017-08-01 10:51:49'),
(944, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/116', 44, 0, '2017-08-01 10:51:49'),
(945, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:51:49'),
(946, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:51:49'),
(947, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/117', 44, 0, '2017-08-01 10:52:15'),
(948, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/117', 44, 0, '2017-08-01 10:52:15'),
(949, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:52:15'),
(950, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:52:15'),
(951, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/118', 44, 0, '2017-08-01 10:52:49'),
(952, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/118', 44, 0, '2017-08-01 10:52:49'),
(953, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:52:49'),
(954, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:52:49'),
(955, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/119', 44, 0, '2017-08-01 10:53:22'),
(956, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/119', 44, 0, '2017-08-01 10:53:22'),
(957, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:53:22'),
(958, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:53:22'),
(959, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/120', 44, 0, '2017-08-01 10:54:00'),
(960, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/120', 44, 0, '2017-08-01 10:54:00'),
(961, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:54:00'),
(962, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:54:00'),
(963, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/121', 44, 0, '2017-08-01 10:54:31'),
(964, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/121', 44, 0, '2017-08-01 10:54:31'),
(965, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:54:31'),
(966, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:54:31'),
(967, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/122', 44, 0, '2017-08-01 10:56:52'),
(968, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/122', 44, 0, '2017-08-01 10:56:52'),
(969, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:56:52'),
(970, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:56:52'),
(971, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/123', 44, 0, '2017-08-01 10:58:04'),
(972, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/123', 44, 0, '2017-08-01 10:58:04'),
(973, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:58:04'),
(974, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:58:04'),
(975, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/124', 44, 0, '2017-08-01 10:59:32'),
(976, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/124', 44, 0, '2017-08-01 10:59:32'),
(977, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 10:59:32'),
(978, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 10:59:32'),
(979, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/125', 44, 0, '2017-08-01 11:02:11'),
(980, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/125', 44, 0, '2017-08-01 11:02:11'),
(981, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 11:02:11'),
(982, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 11:02:11'),
(983, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/126', 44, 0, '2017-08-01 11:02:37'),
(984, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/126', 44, 0, '2017-08-01 11:02:37'),
(985, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 44, 0, '2017-08-01 11:02:37'),
(986, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 44, 0, '2017-08-01 11:02:37'),
(987, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/125', 44, 0, '2017-08-01 11:03:58'),
(988, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/125', 44, 0, '2017-08-01 11:03:58'),
(989, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/117', 44, 0, '2017-08-01 11:35:38'),
(990, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/117', 44, 0, '2017-08-01 11:35:38'),
(991, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 92, 0, '2017-08-01 12:15:59'),
(992, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', NULL, 0, '2017-08-01 12:36:00'),
(993, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', NULL, 0, '2017-08-01 12:36:00'),
(994, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/127', 75, 0, '2017-08-01 12:39:55'),
(995, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/127', 75, 0, '2017-08-01 12:39:55'),
(996, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-01 12:39:55'),
(997, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-01 12:39:55'),
(998, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/128', 75, 0, '2017-08-01 12:41:06'),
(999, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/128', 75, 0, '2017-08-01 12:41:06'),
(1000, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-01 12:41:06'),
(1001, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-01 12:41:06'),
(1002, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/129', 15, 0, '2017-08-02 05:00:26'),
(1003, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/129', 15, 0, '2017-08-02 05:00:26'),
(1004, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 15, 0, '2017-08-02 05:00:26'),
(1005, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-08-02 05:00:26'),
(1006, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/129', 15, 0, '2017-08-02 09:14:15'),
(1007, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/129', 15, 0, '2017-08-02 09:14:15'),
(1008, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/129', 15, 0, '2017-08-02 09:14:34'),
(1009, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/129', 15, 0, '2017-08-02 09:14:34'),
(1010, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/129', 15, 0, '2017-08-02 09:14:45'),
(1011, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/129', 15, 0, '2017-08-02 09:14:45'),
(1012, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/96', 38, 0, '2017-08-02 09:19:29'),
(1013, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/96', 15, 0, '2017-08-02 09:19:29'),
(1014, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/88', 70, 0, '2017-08-02 09:52:37'),
(1015, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/88', 15, 0, '2017-08-02 09:52:37');
INSERT INTO `notifications` (`id`, `message`, `module`, `url`, `target_id`, `viewed`, `created_at`) VALUES
(1016, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/130', 70, 0, '2017-08-02 10:08:25'),
(1017, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/130', 15, 0, '2017-08-02 10:08:25'),
(1018, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 70, 0, '2017-08-02 10:08:25'),
(1019, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 15, 0, '2017-08-02 10:08:25'),
(1020, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/131', 16, 0, '2017-08-02 10:45:01'),
(1021, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/131', 16, 0, '2017-08-02 10:45:01'),
(1022, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-08-02 10:45:01'),
(1023, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-08-02 10:45:01'),
(1024, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/132', 16, 0, '2017-08-02 10:46:50'),
(1025, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/132', 16, 0, '2017-08-02 10:46:50'),
(1026, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-08-02 10:46:50'),
(1027, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-08-02 10:46:50'),
(1028, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/132', 16, 0, '2017-08-02 10:47:23'),
(1029, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/132', 16, 0, '2017-08-02 10:47:23'),
(1030, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/133', 16, 0, '2017-08-02 10:48:41'),
(1031, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/133', 16, 0, '2017-08-02 10:48:41'),
(1032, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-08-02 10:48:41'),
(1033, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-08-02 10:48:41'),
(1034, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/99', 16, 0, '2017-08-02 10:49:37'),
(1035, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/99', 16, 0, '2017-08-02 10:49:37'),
(1036, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/134', 16, 0, '2017-08-02 10:53:23'),
(1037, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/134', 16, 0, '2017-08-02 10:53:23'),
(1038, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 16, 0, '2017-08-02 10:53:23'),
(1039, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 16, 0, '2017-08-02 10:53:23'),
(1040, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/105', 16, 0, '2017-08-02 10:57:43'),
(1041, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/105', 16, 0, '2017-08-02 10:57:43'),
(1042, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/79', 16, 0, '2017-08-02 11:04:30'),
(1043, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/79', 16, 0, '2017-08-02 11:04:30'),
(1044, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/79', 16, 0, '2017-08-02 11:04:32'),
(1045, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/79', 16, 0, '2017-08-02 11:04:32'),
(1046, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/79', 16, 0, '2017-08-02 11:11:13'),
(1047, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/79', 16, 0, '2017-08-02 11:11:13'),
(1048, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/135', 75, 0, '2017-08-02 12:50:51'),
(1049, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/135', 75, 0, '2017-08-02 12:50:51'),
(1050, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-02 12:50:51'),
(1051, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-02 12:50:51'),
(1052, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/136', 75, 0, '2017-08-02 12:51:35'),
(1053, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/136', 75, 0, '2017-08-02 12:51:35'),
(1054, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-02 12:51:35'),
(1055, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-02 12:51:35'),
(1056, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/137', 75, 0, '2017-08-02 12:52:27'),
(1057, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/137', 75, 0, '2017-08-02 12:52:27'),
(1058, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-02 12:52:27'),
(1059, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-02 12:52:27'),
(1060, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 93, 0, '2017-08-02 15:35:44'),
(1061, 'Your Profile has been created. Please Review it!', 'MyProfile', 'myprofile', 94, 0, '2017-08-03 08:08:29'),
(1062, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/134', 16, 0, '2017-08-03 08:19:00'),
(1063, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/134', 16, 0, '2017-08-03 08:19:00'),
(1064, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/101', 16, 0, '2017-08-03 08:19:50'),
(1065, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/101', 16, 0, '2017-08-03 08:19:50'),
(1066, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/101', 16, 0, '2017-08-03 08:21:03'),
(1067, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/101', 16, 0, '2017-08-03 08:21:03'),
(1068, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/101', 16, 0, '2017-08-03 08:21:06'),
(1069, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/101', 16, 0, '2017-08-03 08:21:06'),
(1070, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/138', 75, 0, '2017-08-03 12:02:07'),
(1071, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/138', 75, 0, '2017-08-03 12:02:07'),
(1072, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-03 12:02:07'),
(1073, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-03 12:02:07'),
(1074, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/139', 75, 0, '2017-08-03 12:05:49'),
(1075, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/139', 75, 0, '2017-08-03 12:05:49'),
(1076, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-03 12:05:49'),
(1077, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-03 12:05:49'),
(1078, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/140', 75, 0, '2017-08-03 12:10:13'),
(1079, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/140', 75, 0, '2017-08-03 12:10:13'),
(1080, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-03 12:10:13'),
(1081, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-03 12:10:13'),
(1082, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/141', 75, 0, '2017-08-04 06:22:45'),
(1083, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/141', 75, 0, '2017-08-04 06:22:45'),
(1084, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-04 06:22:45'),
(1085, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-04 06:22:45'),
(1086, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 40, 0, '2017-08-04 12:35:53'),
(1087, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-08-04 12:35:53'),
(1088, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/142', 75, 0, '2017-08-04 13:09:13'),
(1089, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/142', 75, 0, '2017-08-04 13:09:13'),
(1090, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-04 13:09:13'),
(1091, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-04 13:09:13'),
(1092, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/143', 75, 0, '2017-08-04 13:11:20'),
(1093, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/143', 75, 0, '2017-08-04 13:11:20'),
(1094, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-04 13:11:20'),
(1095, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-04 13:11:20'),
(1096, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 13, 0, '2017-08-04 13:21:56'),
(1097, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-08-04 13:21:56'),
(1098, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 13, 0, '2017-08-04 14:13:40'),
(1099, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-08-04 14:13:40'),
(1100, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/144', 75, 0, '2017-08-05 12:31:29'),
(1101, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/144', 75, 0, '2017-08-05 12:31:29'),
(1102, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-05 12:31:29'),
(1103, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-05 12:31:29'),
(1104, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/145', 75, 0, '2017-08-05 12:33:18'),
(1105, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/145', 75, 0, '2017-08-05 12:33:18'),
(1106, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-05 12:33:18'),
(1107, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-05 12:33:18'),
(1108, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/146', 75, 0, '2017-08-05 12:34:49'),
(1109, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/146', 75, 0, '2017-08-05 12:34:49'),
(1110, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-05 12:34:49'),
(1111, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-05 12:34:49'),
(1112, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/147', 75, 0, '2017-08-05 12:36:47'),
(1113, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/147', 75, 0, '2017-08-05 12:36:47'),
(1114, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-05 12:36:47'),
(1115, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-05 12:36:47'),
(1116, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/148', 75, 0, '2017-08-07 10:22:18'),
(1117, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/148', 75, 0, '2017-08-07 10:22:18'),
(1118, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-07 10:22:18'),
(1119, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-07 10:22:18'),
(1120, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/134', 16, 0, '2017-08-09 04:37:45'),
(1121, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/134', 16, 0, '2017-08-09 04:37:45'),
(1122, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/132', 16, 0, '2017-08-09 04:38:43'),
(1123, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/132', 16, 0, '2017-08-09 04:38:43'),
(1124, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/149', 75, 0, '2017-08-10 13:13:43'),
(1125, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/149', 75, 0, '2017-08-10 13:13:43'),
(1126, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-10 13:13:43'),
(1127, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-10 13:13:43'),
(1128, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/150', 75, 0, '2017-08-10 13:15:10'),
(1129, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/150', 75, 0, '2017-08-10 13:15:10'),
(1130, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-10 13:15:10'),
(1131, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-10 13:15:10'),
(1132, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/151', 75, 0, '2017-08-10 13:17:26'),
(1133, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/151', 75, 0, '2017-08-10 13:17:26'),
(1134, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-10 13:17:26'),
(1135, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-10 13:17:26'),
(1136, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/152', 75, 0, '2017-08-12 12:35:45'),
(1137, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/152', 75, 0, '2017-08-12 12:35:45'),
(1138, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-12 12:35:45'),
(1139, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-12 12:35:45'),
(1140, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/153', 75, 0, '2017-08-12 12:37:18'),
(1141, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/153', 75, 0, '2017-08-12 12:37:18'),
(1142, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-12 12:37:18'),
(1143, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-12 12:37:18'),
(1144, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/154', 75, 0, '2017-08-14 13:39:19'),
(1145, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/154', 75, 0, '2017-08-14 13:39:19'),
(1146, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-14 13:39:19'),
(1147, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-14 13:39:19'),
(1148, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/155', 75, 0, '2017-08-18 13:26:57'),
(1149, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/155', 75, 0, '2017-08-18 13:26:57'),
(1150, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-18 13:26:57'),
(1151, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-18 13:26:57'),
(1152, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/156', 75, 0, '2017-08-18 13:28:17'),
(1153, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/156', 75, 0, '2017-08-18 13:28:17'),
(1154, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-18 13:28:17'),
(1155, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-18 13:28:17'),
(1156, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/157', 75, 0, '2017-08-18 13:30:24'),
(1157, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/157', 75, 0, '2017-08-18 13:30:24'),
(1158, 'You have a new assignment', 'MyAssignments', 'workassignments/current', 75, 0, '2017-08-18 13:30:24'),
(1159, 'You have submitted a new assignment', 'MyAssignments', 'workassignments/all', 75, 0, '2017-08-18 13:30:24'),
(1160, 'Your application for leave is pending with your supervisor', 'MyLeaves', 'leaveportal/all', 61, 0, '2017-08-28 04:18:21'),
(1161, 'Yor have a pending approval for leave application', 'MyApprovals', 'approvals/all', 16, 0, '2017-08-28 04:18:21'),
(1162, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/95', 70, 0, '2017-09-08 16:54:46'),
(1163, 'Assignment Status Updated', 'MyAssignments', 'workassignments/update_status/95', 15, 0, '2017-09-08 16:54:46');

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE `projects` (
  `id` int(11) NOT NULL,
  `project_name` varchar(255) NOT NULL,
  `project_id` varchar(45) DEFAULT NULL,
  `project_owner` int(11) DEFAULT NULL,
  `details` text,
  `client_name` varchar(255) DEFAULT NULL,
  `client_contact` varchar(50) DEFAULT NULL,
  `client_mail` varchar(45) DEFAULT NULL,
  `alternate_contact` varchar(45) DEFAULT NULL,
  `address` text,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` int(11) DEFAULT '1',
  `priority` int(11) DEFAULT NULL,
  `notes` longtext,
  `type` varchar(80) NOT NULL,
  `initialQuantity` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`id`, `project_name`, `project_id`, `project_owner`, `details`, `client_name`, `client_contact`, `client_mail`, `alternate_contact`, `address`, `start_date`, `end_date`, `status`, `priority`, `notes`, `type`, `initialQuantity`) VALUES
(1, 'Bulker ', 'PRJ10000', 15, 'Regular supply of Fly Ash ', 'Ultratech Cement Dankuni', '9830098300', 'mohit@gmail.com', '9830098301', 'Dankuni', '2017-04-01', '2018-03-31', 1, 1, '1.Rate of Fly Ash Rs.523/- + VAT\r\nProject Information updated on Wednesday 15th of March 2017 08:47:22 AM', 'Fly Ash', '0.00'),
(2, 'Fly Ash', 'PRJ10000', 15, '', 'Ultratech cement dankuni', '0000000000', 'ultra@gmail.com', '1111111111', 'dankuni', '2017-03-26', '2017-03-27', 1, 1, '\r\nProject Information updated on Sunday 26th of March 2017 09:29:55 AM', 'Fly Ash', '0.00'),
(3, 'GVK Mumbai Airport', 'PRJ10000', 16, '', 'GVK', '999999999', 'abc@gvk.com', '', '', '2017-03-28', '2018-02-28', 1, 3, '\r\nProject Information updated on Tuesday 28th of March 2017 10:21:04 AM', 'Fly Ash', '0.00'),
(4, 'Software Function Check', 'PRJ10000', 16, '', 'Self', 'self', 'self', 'self', 'self', '2017-05-10', '2017-05-13', 1, 4, 'Checking of all functions thoroughly\r\nProject Information updated on Wednesday 10th of May 2017 10:03:47 AM', 'Fly Ash', '0.00'),
(5, 'Investment House DA 516', 'PRJ10000', 15, '', 'Self', '9999999999', 'self', '', '', '0000-00-00', '0000-00-00', 1, 4, '', 'Fund Growth', '0.00'),
(6, 'sample project for ticket testing', 'PROJECT20170002', 15, '', 'test', 'test', 'test', 'test', 'test', '2017-06-24', '2017-06-25', 1, 1, '', 'testing', '100000.00'),
(7, 'Jindal India Limited', 'PROJECT20170003', 15, '', 'Jindal India Limited', '9999999999', 'aaa@aaa.com', '', '', '2017-07-22', '2017-07-29', 1, 4, '', 'Civil Construction', '0.00'),
(8, 'NCC Agartala Airport', 'PROJECT20170004', 84, '', 'NCC', 'abc', 'abc@abc.com', '', '', '2017-07-28', '2017-10-31', 1, 2, 'Rig machine\r\nProject Information updated on Friday 28th of July 2017 11:38:27 AM\r\nProject Information updated on Friday 28th of July 2017 11:39:36 AM\r\nProject Information updated on Friday 28th of July 2017 11:40:19 AM', 'CIVIL - Piling', '0.00'),
(9, 'NCC Agartala', 'PROJECT20170005', 84, '', 'NCC', '999999999', 'ncc', '', '', '2017-08-02', '2017-10-31', 1, 4, '', 'Civil - Piling', '0.00');

--
-- Triggers `projects`
--
DELIMITER $$
CREATE TRIGGER `projects_AFTER_UPDATE` AFTER UPDATE ON `projects` FOR EACH ROW BEGIN
	if NEW.status=0 then
		update project_worklog set status='I' where project_id=NEW.id;
        update resources set status=2 where project_id=NEW.id;
        update employees set project_id=null where id=NEW.project_owner;
    elseif NEW.status=2 then
		update project_worklog set status='I' where project_id=NEW.id;
    end if;
    
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `project_allocation_status_cd`
--

CREATE TABLE `project_allocation_status_cd` (
  `id` int(11) NOT NULL,
  `status` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `project_allocation_status_cd`
--

INSERT INTO `project_allocation_status_cd` (`id`, `status`) VALUES
(1, 'ALLOCATED'),
(2, 'UNALLOCATED'),
(3, 'BILLABLE'),
(4, 'NON_BILLABLE');

-- --------------------------------------------------------

--
-- Table structure for table `project_roles`
--

CREATE TABLE `project_roles` (
  `id` int(11) NOT NULL,
  `role_name` varchar(80) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `project_roles`
--

INSERT INTO `project_roles` (`id`, `role_name`) VALUES
(1, 'Accountant'),
(2, 'Jr. Accountant'),
(3, 'Sr. Accountant'),
(4, 'Marketing'),
(5, 'Jr. Accountant Billing'),
(6, 'Front Desk Coordinator'),
(7, 'Data Steward');

-- --------------------------------------------------------

--
-- Table structure for table `project_seq`
--

CREATE TABLE `project_seq` (
  `count` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `project_seq`
--

INSERT INTO `project_seq` (`count`) VALUES
(1),
(2),
(3),
(4),
(5),
(6);

-- --------------------------------------------------------

--
-- Table structure for table `project_worklog`
--

CREATE TABLE `project_worklog` (
  `id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `start_date` timestamp NULL DEFAULT NULL,
  `end_date` timestamp NULL DEFAULT NULL,
  `createdAt` timestamp NULL DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `title` varchar(80) DEFAULT NULL,
  `description` text,
  `status` varchar(1) DEFAULT 'A'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `project_worklog`
--

INSERT INTO `project_worklog` (`id`, `project_id`, `start_date`, `end_date`, `createdAt`, `createdBy`, `file`, `title`, `description`, `status`) VALUES
(1, 2, '2017-03-26 13:03:51', '2017-03-27 13:05:16', '2017-03-26 07:34:35', 15, NULL, 'Give me details of fly task', 'Give me details of fly task', 'A'),
(2, 3, '2017-03-27 18:53:15', '2017-03-27 18:54:52', '2017-03-27 13:24:25', 16, NULL, 'need to collect contacts ', '', 'I'),
(3, 3, '2017-03-28 18:59:18', '2017-03-31 19:00:18', '2017-03-27 13:29:51', 15, NULL, 'Find out all the suppliers', 'Find out all the suppliers', 'I');

--
-- Triggers `project_worklog`
--
DELIMITER $$
CREATE TRIGGER `project_worklog_BEFORE_INSERT` BEFORE INSERT ON `project_worklog` FOR EACH ROW BEGIN
	SET NEW.createdAt=NOW();
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `project_worklog_updates`
--

CREATE TABLE `project_worklog_updates` (
  `id` int(11) NOT NULL,
  `task_id` int(11) DEFAULT NULL,
  `comment` text,
  `postedBy` int(11) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `project_worklog_updates`
--

INSERT INTO `project_worklog_updates` (`id`, `task_id`, `comment`, `postedBy`, `file`, `timestamp`) VALUES
(1, 1, 'hi', 15, '', '2017-03-26 07:35:41'),
(2, 1, 'att', 15, '', '2017-07-22 11:53:32');

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `id` int(11) NOT NULL,
  `service_order` varchar(15) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  `allocation_starts` date DEFAULT NULL,
  `allocation_ends` date DEFAULT NULL,
  `hourly_rate` double DEFAULT NULL,
  `status` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `resources`
--

INSERT INTO `resources` (`id`, `service_order`, `resource_id`, `project_id`, `role`, `allocation_starts`, `allocation_ends`, `hourly_rate`, `status`) VALUES
(1, NULL, 19, 1, 'Front Desk Coordinator', '2017-04-01', '2018-03-31', NULL, 1),
(2, NULL, 22, 2, 'Accountant', '2017-03-26', '2017-03-27', NULL, 1),
(3, NULL, 12, 2, 'Jr. Accountant', '2017-03-26', '2017-03-27', NULL, 1),
(4, NULL, 17, 2, 'Front Desk Coordinator', '2017-03-26', '2017-03-26', NULL, 2),
(5, NULL, 12, 3, 'Marketing', '2017-03-28', '2018-02-28', NULL, 1),
(6, NULL, 21, 3, 'Accountant', '2017-03-28', '2018-02-28', NULL, 1),
(7, NULL, 45, 3, 'Front Desk Coordinator', '2017-03-28', '2018-02-28', NULL, 1),
(8, NULL, 40, 4, 'Sr. Accountant', '2017-05-10', '2017-05-13', NULL, 1),
(9, NULL, 12, 4, 'Marketing', '2017-05-10', '2017-05-13', NULL, 1),
(10, NULL, 12, 6, 'Data Steward', '2017-06-24', '2017-07-08', NULL, 2),
(11, NULL, 13, 6, 'Front Desk Coordinator', '2017-06-24', '2017-06-25', NULL, 1),
(12, NULL, 19, 6, 'Accountant', '2017-06-24', '2017-06-25', NULL, 1),
(13, NULL, 72, 6, 'Field Resource', '2017-06-27', '2017-06-30', NULL, 1),
(14, NULL, 85, 6, 'Data Steward', '2017-06-28', '2017-07-21', NULL, 1),
(15, NULL, 26, 7, 'Accountant', '2017-07-22', '2017-08-03', NULL, 1),
(16, NULL, 12, 7, NULL, '2017-07-22', '2017-07-29', NULL, 1),
(17, NULL, 16, 7, 'Marketing', '2017-07-22', '2017-10-19', NULL, 1),
(18, NULL, 70, 8, 'Front Desk Coordinator', '2017-07-28', '2017-10-31', NULL, 1),
(19, NULL, 70, 9, 'Marketing', '2017-08-02', '2017-10-31', NULL, 1),
(20, NULL, 12, 9, NULL, '2017-08-02', '2017-10-31', NULL, 1);

--
-- Triggers `resources`
--
DELIMITER $$
CREATE TRIGGER `resources_AFTER_INSERT` AFTER INSERT ON `resources` FOR EACH ROW BEGIN
	update employees set project_id=NEW.project_id where id=NEW.resource_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `resources_AFTER_UPDATE` AFTER UPDATE ON `resources` FOR EACH ROW BEGIN
	if getStatusCode(NEW.status)="UNALLOCATED"
    then
    update employees set project_id=null where id=NEW.resource_id;
    else
    update employees set project_id=NEW.project_id where id=NEW.resource_id;
    end if;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `supply_challan`
--

CREATE TABLE `supply_challan` (
  `id` int(11) NOT NULL,
  `ticket_id` int(11) DEFAULT NULL,
  `target_employee` int(11) DEFAULT NULL,
  `type` varchar(1) DEFAULT NULL,
  `challan_no` varchar(50) DEFAULT NULL,
  `submitted_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `comment` text,
  `file_path` varchar(255) DEFAULT NULL,
  `file_path2` varchar(255) DEFAULT NULL,
  `file_path3` varchar(255) DEFAULT NULL,
  `status` varchar(1) DEFAULT 'N',
  `approver` int(11) DEFAULT NULL,
  `active` varchar(1) DEFAULT 'A'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `ticket_no` varchar(50) DEFAULT NULL,
  `loading_location` varchar(80) DEFAULT NULL,
  `loading_poc` int(11) DEFAULT NULL,
  `unloading_location` varchar(80) DEFAULT NULL,
  `unloading_poc` int(11) DEFAULT NULL,
  `vehicle` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `project_id` int(11) DEFAULT NULL,
  `status` varchar(1) DEFAULT 'A',
  `amount` decimal(10,2) DEFAULT NULL,
  `approved` tinyint(1) DEFAULT '0',
  `goods_desc` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_seq`
--

CREATE TABLE `ticket_seq` (
  `count` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ticket_seq`
--

INSERT INTO `ticket_seq` (`count`) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle`
--

CREATE TABLE `vehicle` (
  `id` int(11) NOT NULL,
  `vehicle_name` varchar(50) DEFAULT NULL,
  `driver_name` varchar(80) DEFAULT NULL,
  `vehicle_number` varchar(12) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(1) DEFAULT 'A'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `vehicle`
--

INSERT INTO `vehicle` (`id`, `vehicle_name`, `driver_name`, `vehicle_number`, `created_at`, `status`) VALUES
(1, 'TATA 12 WHEEL', 'RAMESH', 'WB20E4747', '2017-06-16 16:18:50', 'A'),
(2, 'A1', 'Balu Baski', 'WB11C9524', '2017-06-24 11:36:40', 'A'),
(3, 'A2', 'CHATA LAL MAHATO', 'WB11C9526', '2017-07-07 08:15:21', 'A'),
(4, 'A3', 'Mukesh Ray', 'WB11D0199', '2017-07-07 08:17:29', 'A'),
(5, 'A4', 'GUDDU NONIA', 'WB11D0200', '2017-07-07 08:20:10', 'A'),
(6, 'A5', 'DAYANAND PANDIT', 'WB11D0201', '2017-07-07 08:21:23', 'A'),
(7, 'A6', 'NANDU YADAV', 'WB11D0203', '2017-07-07 08:22:25', 'A'),
(8, 'A7', 'PAPPU CHOUDHARY', 'WB11D0206', '2017-07-07 08:26:35', 'A'),
(9, 'A8', 'MANOJ PANDIT', 'WB11D1328', '2017-07-07 08:32:35', 'A'),
(10, 'A9', 'SOHAN ROY', 'WB11D1329', '2017-07-07 08:34:35', 'A'),
(11, 'A10', 'RAMJIT SINGH', 'WB11D1330', '2017-07-07 08:36:16', 'A'),
(12, 'A11', 'PAWAN KUMAR', 'WB11D1331', '2017-07-07 09:07:10', 'A'),
(13, 'A12', 'ANIL KUMAR', 'WB11D1632', '2017-07-07 09:08:06', 'A'),
(14, 'A13', 'DHANANJAY MONDAL', 'WB11D1462', '2017-07-07 09:09:03', 'A'),
(15, 'A14', 'SATYENDAR BHARATI', 'WB11D1463', '2017-07-07 09:10:35', 'A'),
(16, 'A15', 'SARVAN KUMAR', 'WB11D1464', '2017-07-07 09:13:39', 'A'),
(17, 'A16', 'SADHU MAHATO', 'WB11D3614', '2017-07-07 09:15:18', 'A'),
(18, 'A17', 'SHIV SANKAR YADAV', 'NL02N1358', '2017-07-07 09:16:25', 'A'),
(19, 'A18', 'PAPPU YADAV', 'NL02N1124', '2017-07-07 09:22:09', 'A'),
(20, 'B1', '', 'GJ05AU6640', '2017-07-07 09:23:14', 'A'),
(21, 'B2', 'MUNNA RAI', 'GJ05AU6368', '2017-07-07 09:23:57', 'A'),
(22, 'B3', '', 'GJ05AU6632', '2017-07-07 09:24:56', 'A'),
(23, 'B4', '', 'GJ05AT1392', '2017-07-07 09:25:20', 'A'),
(24, 'A20', 'PAPPU YADAV', 'NL02N1124', '2017-08-02 05:24:15', 'A');

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_attr`
--

CREATE TABLE `vehicle_attr` (
  `id` int(11) NOT NULL,
  `vehicle_id` int(11) DEFAULT NULL,
  `attribute_tp_cd` int(11) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `expiry_dt` date DEFAULT NULL,
  `end_on` date DEFAULT NULL,
  `last_data` int(11) DEFAULT NULL,
  `last_updated_by` int(11) DEFAULT NULL,
  `last_updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vehicle_attr`
--

INSERT INTO `vehicle_attr` (`id`, `vehicle_id`, `attribute_tp_cd`, `value`, `expiry_dt`, `end_on`, `last_data`, `last_updated_by`, `last_updated_at`) VALUES
(1, 2, 100, '999999999', '2017-05-07', '2017-06-24', NULL, 15, '2017-06-24 11:38:31'),
(2, 2, 105, 'a544bbe47dd3e503e4ef97ea48a5b1a2.pdf', '2017-09-20', '2017-07-07', NULL, 16, '2017-06-24 11:39:26'),
(3, 2, 100, '9831098310', '0000-00-00', '2017-07-07', NULL, 16, '2017-06-24 11:39:59'),
(4, 2, 500, '10', '0000-00-00', NULL, NULL, NULL, '2017-06-24 11:43:55'),
(5, 3, 100, '8013220355', '0000-00-00', NULL, NULL, NULL, '2017-07-07 08:16:05'),
(6, 4, 100, '8327092431', '0000-00-00', '2017-07-07', NULL, 16, '2017-07-07 08:17:51'),
(7, 5, 100, '9609007197', '0000-00-00', '2017-07-22', NULL, 16, '2017-07-07 08:20:32'),
(8, 6, 100, '7294855232', '0000-00-00', '2017-07-22', NULL, 16, '2017-07-07 08:21:45'),
(9, 7, 100, '8271652074', '0000-00-00', '2017-07-22', NULL, 16, '2017-07-07 08:24:04'),
(10, 12, 100, '7739945843', '0000-00-00', '2017-07-22', NULL, 16, '2017-07-07 09:07:33'),
(11, 13, 100, '8479810774', '0000-00-00', '2017-07-07', NULL, 16, '2017-07-07 09:08:26'),
(12, 14, 100, '8759336110', '0000-00-00', '2017-07-22', NULL, 16, '2017-07-07 09:09:24'),
(13, 15, 100, '8335937935', '0000-00-00', NULL, NULL, NULL, '2017-07-07 09:10:57'),
(14, 16, 100, '8167081357', '0000-00-00', NULL, NULL, NULL, '2017-07-07 09:14:37'),
(15, 17, 100, '8276992184', '0000-00-00', NULL, NULL, NULL, '2017-07-07 09:15:34'),
(16, 18, 100, '7044358772', '0000-00-00', NULL, NULL, NULL, '2017-07-07 09:17:45'),
(17, 19, 100, '9903530846', '0000-00-00', NULL, NULL, NULL, '2017-07-07 09:22:34'),
(18, 21, 100, '7063557236', '0000-00-00', NULL, NULL, NULL, '2017-07-07 09:24:25'),
(19, 2, 100, '7384291080', '0000-00-00', NULL, NULL, NULL, '2017-07-07 09:32:00'),
(20, 2, 101, 'WB4120050125413', '0000-00-00', '2017-07-07', NULL, 16, '2017-07-07 09:32:57'),
(21, 2, 111, NULL, '0000-00-00', '2017-07-28', NULL, 16, '2017-07-07 09:37:19'),
(22, 2, 101, 'WB4120050125413', '2017-07-10', NULL, NULL, NULL, '2017-07-07 09:38:23'),
(23, 2, 111, NULL, '2018-03-02', '2017-07-28', NULL, 16, '2017-07-07 09:38:51'),
(24, 2, 104, NULL, '2016-03-04', '2017-07-07', NULL, 16, '2017-07-07 09:40:11'),
(25, 2, 105, NULL, '2017-09-22', '2017-07-26', NULL, 16, '2017-07-07 09:40:39'),
(26, 2, 108, NULL, '2018-03-05', '2017-07-26', NULL, 16, '2017-07-07 09:41:08'),
(27, 2, 106, '', '2018-06-04', '2017-07-26', NULL, 16, '2017-07-07 09:41:52'),
(28, 2, 109, NULL, '2021-08-17', '2017-07-07', NULL, 15, '2017-07-07 09:44:57'),
(29, 2, 107, NULL, '2021-08-17', '2017-07-26', NULL, 16, '2017-07-07 09:45:25'),
(30, 2, 110, NULL, '2018-02-25', '2017-07-26', NULL, 16, '2017-07-07 09:45:52'),
(31, 3, 101, 'WB1519880152045', '2017-12-19', '2017-07-07', NULL, 16, '2017-07-07 09:48:33'),
(32, 3, 111, NULL, '2018-03-02', NULL, NULL, NULL, '2017-07-07 09:48:56'),
(33, 3, 109, NULL, '2021-03-07', '2017-07-26', NULL, 16, '2017-07-07 09:49:19'),
(34, 3, 107, NULL, '2021-03-07', '2017-07-07', NULL, 16, '2017-07-07 09:49:58'),
(35, 3, 107, NULL, '2018-06-04', NULL, NULL, NULL, '2017-07-07 09:50:22'),
(36, 3, 106, '', '2018-06-04', '2017-07-26', NULL, 16, '2017-07-07 09:50:53'),
(37, 3, 110, NULL, '2018-02-25', '2017-07-26', NULL, 16, '2017-07-07 09:51:15'),
(38, 3, 105, NULL, '2017-06-27', '2017-07-07', NULL, 16, '2017-07-07 09:51:40'),
(39, 3, 108, NULL, '2018-03-05', '2017-07-26', NULL, 16, '2017-07-07 09:52:16'),
(40, 3, 105, NULL, '2018-03-05', '2017-07-07', NULL, 16, '2017-07-07 09:56:49'),
(41, 3, 105, NULL, '2017-09-27', '2017-07-26', NULL, 16, '2017-07-07 09:57:23'),
(42, 4, 111, NULL, '2018-05-08', NULL, NULL, NULL, '2017-07-07 10:30:12'),
(43, 4, 109, NULL, '2021-05-12', '2017-07-28', NULL, 16, '2017-07-07 10:30:40'),
(44, 4, 107, NULL, '2021-05-12', '2017-07-28', NULL, 16, '2017-07-07 10:31:17'),
(45, 4, 106, '', '2017-08-09', '2017-07-28', NULL, 16, '2017-07-07 10:31:37'),
(46, 4, 110, NULL, '2018-05-02', '2017-07-28', NULL, 16, '2017-07-07 10:32:03'),
(47, 4, 105, NULL, '2017-08-24', '2017-07-28', NULL, 16, '2017-07-07 10:32:38'),
(48, 4, 100, '', '2018-05-09', '2017-07-22', NULL, 16, '2017-07-07 10:32:54'),
(49, 5, 111, NULL, '2018-05-08', NULL, NULL, NULL, '2017-07-07 10:36:01'),
(50, 5, 109, NULL, '2021-05-10', '2017-07-21', NULL, 16, '2017-07-07 10:36:55'),
(51, 5, 107, NULL, '2021-05-10', NULL, NULL, NULL, '2017-07-07 10:38:18'),
(52, 5, 106, '', '2018-07-02', NULL, NULL, NULL, '2017-07-07 10:38:53'),
(53, 5, 110, NULL, '2018-02-28', '2017-07-21', NULL, 16, '2017-07-07 10:39:18'),
(54, 5, 105, NULL, '2017-12-09', '2017-07-21', NULL, 16, '2017-07-07 10:39:42'),
(55, 5, 108, NULL, '2018-05-09', '2017-07-21', NULL, 16, '2017-07-07 10:40:04'),
(56, 6, 111, NULL, '2018-05-05', NULL, NULL, NULL, '2017-07-07 10:41:32'),
(57, 6, 109, NULL, '2021-05-12', NULL, NULL, NULL, '2017-07-07 10:42:03'),
(58, 6, 107, NULL, '2021-05-15', '2017-07-21', NULL, 16, '2017-07-07 10:42:30'),
(59, 6, 106, '', '2017-08-09', '2017-07-21', NULL, 16, '2017-07-07 10:42:54'),
(60, 6, 110, NULL, '2018-05-02', '2017-07-21', NULL, 16, '2017-07-07 10:43:13'),
(61, 6, 105, NULL, '2017-08-24', '2017-07-21', NULL, 16, '2017-07-07 10:43:40'),
(62, 6, 108, NULL, '2018-05-09', '2017-07-21', NULL, 16, '2017-07-07 10:44:07'),
(63, 7, 111, NULL, '2018-05-05', NULL, NULL, NULL, '2017-07-07 10:50:24'),
(64, 7, 109, NULL, '2021-08-17', NULL, NULL, NULL, '2017-07-07 10:50:55'),
(65, 7, 107, NULL, '2021-08-17', NULL, NULL, NULL, '2017-07-07 10:51:21'),
(66, 7, 106, '', '2018-07-02', NULL, NULL, NULL, '2017-07-07 10:51:40'),
(67, 7, 110, NULL, '2018-02-28', NULL, NULL, NULL, '2017-07-07 10:52:04'),
(68, 7, 105, NULL, '2017-11-04', NULL, NULL, NULL, '2017-07-07 10:53:17'),
(69, 7, 108, NULL, '0000-00-00', NULL, NULL, NULL, '2017-07-07 10:53:59'),
(70, 8, 100, '', '1999-03-30', '2017-07-07', NULL, 16, '2017-07-07 10:54:58'),
(71, 8, 100, '9903302147', '0000-00-00', '2017-07-22', NULL, 16, '2017-07-07 10:55:24'),
(72, 8, 111, NULL, '2018-05-08', NULL, NULL, NULL, '2017-07-07 10:55:51'),
(73, 8, 109, NULL, '2021-08-17', NULL, NULL, NULL, '2017-07-07 10:56:15'),
(74, 8, 107, NULL, '2021-08-17', NULL, NULL, NULL, '2017-07-07 10:56:36'),
(75, 8, 106, '', '2018-07-02', NULL, NULL, NULL, '2017-07-07 10:56:55'),
(76, 8, 110, NULL, '2018-02-28', NULL, NULL, NULL, '2017-07-07 10:57:16'),
(77, 8, 105, NULL, '2017-12-09', NULL, NULL, NULL, '2017-07-07 10:59:24'),
(78, 8, 108, NULL, '2018-05-09', NULL, NULL, NULL, '2017-07-07 10:59:40'),
(79, 9, 100, '8479880803', '0000-00-00', NULL, NULL, NULL, '2017-07-07 11:01:25'),
(80, 9, 111, NULL, '2018-08-30', NULL, NULL, NULL, '2017-07-07 11:01:59'),
(81, 9, 109, NULL, '2021-09-07', '2017-07-11', NULL, 16, '2017-07-07 11:02:28'),
(82, 9, 107, NULL, '2021-09-07', '2017-07-11', NULL, 16, '2017-07-07 11:02:50'),
(83, 9, 106, '', '2017-12-01', '2017-07-11', NULL, 16, '2017-07-07 11:03:10'),
(84, 9, 110, NULL, '2017-08-16', '2017-07-11', NULL, 16, '2017-07-07 11:03:30'),
(85, 9, 105, NULL, '2017-11-02', '2017-07-11', NULL, 16, '2017-07-07 11:03:56'),
(86, 9, 108, NULL, '2017-10-02', NULL, NULL, NULL, '2017-07-07 11:04:30'),
(87, 10, 100, '9647168301', '0000-00-00', NULL, NULL, NULL, '2017-07-07 11:26:41'),
(88, 10, 101, '', '0000-00-00', '2017-07-07', NULL, 16, '2017-07-07 11:27:59'),
(89, 10, 101, 'WB1519880152045', '2017-12-19', NULL, NULL, NULL, '2017-07-07 11:28:53'),
(90, 10, 111, NULL, '2018-08-30', NULL, NULL, NULL, '2017-07-07 11:29:22'),
(91, 10, 109, NULL, '2021-09-07', '2017-07-28', NULL, 16, '2017-07-07 11:29:43'),
(92, 10, 107, NULL, '2021-09-07', NULL, NULL, NULL, '2017-07-07 11:30:16'),
(93, 10, 106, '', '2017-12-01', '2017-07-28', NULL, 16, '2017-07-07 11:30:55'),
(94, 10, 110, NULL, '2017-08-16', '2017-08-18', NULL, 16, '2017-07-07 11:31:17'),
(95, 10, 105, NULL, '2017-11-04', NULL, NULL, NULL, '2017-07-07 11:31:37'),
(96, 10, 108, NULL, '2017-10-02', '2017-07-28', NULL, 16, '2017-07-07 11:36:21'),
(97, 11, 100, '8621055133', '0000-00-00', '2017-07-07', NULL, 16, '2017-07-07 11:38:40'),
(98, 11, 111, NULL, '2018-08-30', NULL, NULL, NULL, '2017-07-07 11:39:00'),
(99, 11, 109, NULL, '2021-09-07', '2017-07-28', NULL, 16, '2017-07-07 11:39:23'),
(100, 11, 107, NULL, '2021-09-07', '2017-07-28', NULL, 16, '2017-07-07 11:39:43'),
(101, 11, 106, '', '2017-12-01', '2017-07-28', NULL, 16, '2017-07-07 11:40:01'),
(102, 11, 110, NULL, '2017-08-16', '2017-07-28', NULL, 16, '2017-07-07 11:40:25'),
(103, 11, 105, NULL, '2017-11-04', '2017-07-28', NULL, 16, '2017-07-07 11:40:43'),
(104, 11, 100, '', '2017-10-02', '2017-07-22', NULL, 16, '2017-07-07 11:41:25'),
(105, 12, 111, NULL, '2018-08-30', NULL, NULL, NULL, '2017-07-07 11:43:38'),
(106, 12, 109, NULL, '2021-09-06', NULL, NULL, NULL, '2017-07-07 11:44:11'),
(107, 12, 107, NULL, '2021-09-06', '2017-08-04', NULL, 16, '2017-07-07 11:45:03'),
(108, 12, 106, '', '2017-12-01', '2017-08-04', NULL, 16, '2017-07-07 11:45:28'),
(109, 12, 110, NULL, '2017-08-16', '2017-08-04', NULL, 16, '2017-07-07 11:45:50'),
(110, 12, 105, NULL, '2017-11-22', '2017-08-04', NULL, 16, '2017-07-07 11:46:11'),
(111, 12, 108, NULL, '2017-10-03', '2017-08-04', NULL, 16, '2017-07-07 11:46:32'),
(112, 14, 111, NULL, '2018-09-20', NULL, NULL, NULL, '2017-07-07 11:47:58'),
(113, 14, 109, NULL, '2021-09-21', '2017-07-29', NULL, 16, '2017-07-07 11:48:17'),
(114, 14, 107, NULL, '2021-09-27', '2017-07-29', NULL, 16, '2017-07-07 11:48:39'),
(115, 14, 106, '', '2017-12-22', '2017-07-29', NULL, 16, '2017-07-07 11:49:04'),
(116, 14, 110, NULL, '2017-09-09', '2017-07-29', NULL, 16, '2017-07-07 11:49:23'),
(117, 14, 105, NULL, '2017-11-22', '2017-07-29', NULL, 16, '2017-07-07 11:49:44'),
(118, 14, 108, NULL, '2017-10-04', '2017-07-29', NULL, 16, '2017-07-07 11:50:05'),
(119, 15, 111, NULL, '2018-09-20', NULL, NULL, NULL, '2017-07-07 11:51:36'),
(120, 15, 109, NULL, '2021-09-28', '2017-07-29', NULL, 16, '2017-07-07 11:51:55'),
(121, 15, 107, NULL, '2021-09-28', '2017-07-29', NULL, 16, '2017-07-07 11:52:17'),
(122, 15, 106, '', '2017-12-21', '2017-07-29', NULL, 16, '2017-07-07 11:52:39'),
(123, 15, 110, NULL, '2017-09-09', '2017-07-29', NULL, 16, '2017-07-07 11:52:54'),
(124, 15, 105, NULL, '2017-11-22', '2017-07-29', NULL, 16, '2017-07-07 11:53:19'),
(125, 15, 108, NULL, '2017-10-04', '2017-07-29', NULL, 16, '2017-07-07 11:53:34'),
(126, 16, 111, NULL, '2018-09-20', NULL, NULL, NULL, '2017-07-07 11:55:12'),
(127, 16, 109, NULL, '2021-09-27', '2017-07-29', NULL, 16, '2017-07-07 11:55:34'),
(128, 16, 107, NULL, '2021-09-27', '2017-07-29', NULL, 16, '2017-07-07 11:56:07'),
(129, 16, 106, '', '2017-12-21', '2017-07-29', NULL, 16, '2017-07-07 11:56:31'),
(130, 16, 110, NULL, '2017-09-09', '2017-07-29', NULL, 16, '2017-07-07 11:56:49'),
(131, 16, 105, NULL, '2017-11-22', '2017-07-29', NULL, 16, '2017-07-07 11:57:10'),
(132, 16, 108, NULL, '2017-10-04', '2017-07-29', NULL, 16, '2017-07-07 11:57:30'),
(133, 13, 100, '', '2018-10-18', '2017-07-22', NULL, 16, '2017-07-07 12:07:10'),
(134, 13, 111, NULL, '2018-10-18', NULL, NULL, NULL, '2017-07-07 12:07:33'),
(135, 13, 109, NULL, '2021-10-24', NULL, NULL, NULL, '2017-07-07 12:08:12'),
(136, 13, 107, NULL, '2021-10-24', NULL, NULL, NULL, '2017-07-07 12:08:33'),
(137, 13, 106, '', '2018-01-08', '2017-07-21', NULL, 16, '2017-07-07 12:08:49'),
(138, 13, 110, NULL, '2017-08-16', '2017-07-21', NULL, 16, '2017-07-07 12:09:08'),
(139, 13, 105, NULL, '2017-11-21', NULL, NULL, NULL, '2017-07-07 12:09:25'),
(140, 13, 108, NULL, '2018-05-09', '2017-07-21', NULL, 16, '2017-07-07 12:09:42'),
(141, 17, 111, NULL, '2019-04-02', '2017-07-29', NULL, 16, '2017-07-07 12:10:37'),
(142, 17, 109, NULL, '2022-04-16', '2017-07-29', NULL, 16, '2017-07-07 12:11:00'),
(143, 17, 107, NULL, '2022-04-16', '2017-07-29', NULL, 16, '2017-07-07 12:11:36'),
(144, 17, 106, '', '2018-07-02', '2017-07-29', NULL, 16, '2017-07-07 12:12:03'),
(145, 17, 110, NULL, '2018-03-20', '2017-07-29', NULL, 16, '2017-07-07 12:12:23'),
(146, 17, 105, NULL, '2017-11-11', '2017-07-29', NULL, 16, '2017-07-07 12:12:39'),
(147, 17, 108, NULL, '2018-05-09', '2017-07-29', NULL, 16, '2017-07-07 12:12:57'),
(148, 18, 111, NULL, '2018-05-28', NULL, NULL, NULL, '2017-07-07 12:15:58'),
(149, 18, 109, NULL, '2017-07-12', NULL, NULL, NULL, '2017-07-07 12:16:40'),
(150, 18, 106, '', '2017-09-30', NULL, NULL, NULL, '2017-07-07 12:16:58'),
(151, 18, 110, NULL, '2017-07-24', NULL, NULL, NULL, '2017-07-07 12:17:12'),
(152, 18, 105, NULL, '2017-11-11', NULL, NULL, NULL, '2017-07-07 12:17:30'),
(153, 18, 108, NULL, '2017-06-08', NULL, NULL, NULL, '2017-07-07 12:17:53'),
(154, 19, 111, NULL, '2020-05-28', NULL, NULL, NULL, '2017-07-07 12:20:04'),
(155, 19, 109, NULL, '2020-07-02', NULL, NULL, NULL, '2017-07-07 12:20:26'),
(156, 19, 106, '', '2017-06-30', NULL, NULL, NULL, '2017-07-07 12:20:45'),
(157, 19, 110, NULL, '2017-07-13', NULL, NULL, NULL, '2017-07-07 12:21:00'),
(158, 2, 115, '123456', '2017-07-08', '2017-07-08', NULL, 16, '2017-07-07 14:06:26'),
(159, 2, 109, '39e612f28a291a6cae659b6ed9440012.pdf', '2018-03-30', '2017-07-26', NULL, 16, '2017-07-07 15:59:25'),
(160, 2, 115, '11111', '0000-00-00', '2017-07-29', NULL, 16, '2017-07-08 13:07:49'),
(161, 1, 115, '11111', '2017-07-14', NULL, NULL, NULL, '2017-07-08 13:09:04'),
(162, 1, 105, '44ce30f721749c7bb002b46514934c40.pdf', '0000-00-00', '2017-07-11', NULL, 15, '2017-07-11 07:42:59'),
(163, 1, 105, '004a02aeff17def8987d3ce20cc984a0.pdf', '2016-07-18', '2017-07-11', NULL, 15, '2017-07-11 07:44:56'),
(164, 1, 105, 'c6f69b77376f86c2d7e2f293a0707ee5.pdf', '2017-08-09', NULL, NULL, NULL, '2017-07-11 07:46:10'),
(165, 2, 111, 'eb35ea60c7fc04fd249f9b591630ef37.pdf', '2017-09-18', '2017-07-28', NULL, 16, '2017-07-11 07:49:02'),
(166, 9, 104, 'af88118b629e526fafb5aedb342cb049.pdf', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-11 11:05:59'),
(167, 9, 105, '37f6021418277b192b5c6e2b15663417.pdf', '2017-11-02', '2017-07-28', NULL, 16, '2017-07-11 11:08:14'),
(168, 9, 106, '840e002e9c0cd6624014a6d8c0c8a54f.pdf', '2017-12-01', '2017-07-28', NULL, 16, '2017-07-11 11:09:21'),
(169, 9, 107, '519557705fb8dd33ec2aa424b81ba9ca.pdf', '2021-09-07', '2017-07-28', NULL, 16, '2017-07-11 11:10:12'),
(170, 9, 110, '8b53f4ea5314de22960944730e6a632e.pdf', '2017-08-16', '2017-07-28', NULL, 16, '2017-07-11 11:11:10'),
(171, 9, 109, '9cf20fd742b5d9a4b682dec2bdcc8b84.pdf', '2021-09-07', '2017-07-28', NULL, 16, '2017-07-11 11:12:02'),
(172, 20, 104, '088d4a43218b3f0592da2a9c55e3a575.pdf', '0000-00-00', NULL, NULL, NULL, '2017-07-11 11:23:22'),
(173, 20, 111, '05bb9001e0395b3379efeafe92998052.pdf', '2018-02-20', NULL, NULL, NULL, '2017-07-11 11:25:37'),
(174, 20, 106, '5aa5d8308c499f1e757925147eee1add.pdf', '2017-09-30', NULL, NULL, NULL, '2017-07-11 11:26:39'),
(175, 20, 107, '633f34cf052a233cb29d331048699b33.pdf', '2016-08-08', '2017-07-21', NULL, 16, '2017-07-11 11:30:15'),
(176, 20, 109, 'fb3941871b099a3bf5b83f99e5d9612a.pdf', '2016-03-23', '2017-07-21', NULL, 16, '2017-07-11 11:31:20'),
(177, 21, 104, 'c8dacc37094101152935e5e089b09872.pdf', '0000-00-00', NULL, NULL, NULL, '2017-07-11 11:36:15'),
(178, 21, 105, 'a829a89d764f7461276f11abb061e00d.pdf', '2017-09-18', NULL, NULL, NULL, '2017-07-11 11:37:27'),
(179, 21, 106, '4d10cda8b2cde93f86a46437dc94f045.pdf', '2017-09-30', NULL, NULL, NULL, '2017-07-11 11:38:33'),
(180, 21, 107, 'cb043c86bc18c24a7f4abd31b25f014b.pdf', '2016-08-08', '2017-07-21', NULL, 16, '2017-07-11 11:40:48'),
(181, 21, 109, '23554720d36a8c58c579343635868b9c.pdf', '2016-03-07', '2017-07-21', NULL, 16, '2017-07-11 11:42:14'),
(182, 21, 110, '5517f8797d2af3c3e8fc43800e3ac203.pdf', '2018-02-20', NULL, NULL, NULL, '2017-07-11 11:44:44'),
(183, 22, 104, '01881f42e4ad72f9c112a6d768ea539b.pdf', '0000-00-00', NULL, NULL, NULL, '2017-07-11 11:47:30'),
(184, 22, 109, '9dfc699def4517fb56ff98834bdee3e7.pdf', '2022-01-27', NULL, NULL, NULL, '2017-07-11 12:12:58'),
(185, 22, 107, '33854fda7cc6aa4045bca982be52c686.pdf', '2022-01-30', NULL, NULL, NULL, '2017-07-11 12:14:16'),
(186, 22, 110, '9b4ed80c500c56805046af0d960c5027.pdf', '2018-02-26', NULL, NULL, NULL, '2017-07-11 12:23:11'),
(187, 22, 106, '8460ae00489bac9d09c83fd7a4c32da6.pdf', '2017-09-30', NULL, NULL, NULL, '2017-07-11 12:24:23'),
(188, 22, 111, '51051f7b0f0d7c608932a61b51f058d1.pdf', '2018-02-20', NULL, NULL, NULL, '2017-07-11 12:25:24'),
(189, 22, 105, '0a173f95fe787553c245115e624adff4.pdf', '2017-07-06', NULL, NULL, NULL, '2017-07-11 12:27:14'),
(190, 21, 115, 'T1361093215', '2015-09-04', '2017-07-21', NULL, 16, '2017-07-20 12:25:09'),
(191, 21, 122, 'B0079410115', '2015-04-12', '2017-07-21', NULL, 16, '2017-07-20 12:26:44'),
(192, 21, 116, 'C2226334215', '2015-11-20', '2017-07-21', NULL, 16, '2017-07-20 12:30:05'),
(193, 21, 116, 'C2026354215', '2015-11-20', '2017-07-21', NULL, 16, '2017-07-20 12:31:21'),
(194, 21, 123, 'P.C.R.12780', '2014-08-25', '2017-07-21', NULL, 16, '2017-07-20 12:40:56'),
(195, 21, 122, 'SCR17160U', '2014-12-29', '2017-07-21', NULL, 16, '2017-07-20 12:42:43'),
(196, 21, 118, 'SCR04599U', '2014-12-29', '2017-07-21', NULL, 16, '2017-07-20 12:52:35'),
(197, 21, 119, 'SCR07845U', '2012-12-29', '2017-07-21', NULL, 16, '2017-07-20 12:54:54'),
(198, 20, 107, NULL, NULL, '2017-07-21', NULL, 16, '2017-07-21 06:50:28'),
(199, 20, 107, '559614da372d1097bb1f4622ae2cec4a.pdf', '2021-08-08', NULL, NULL, NULL, '2017-07-21 06:51:12'),
(200, 20, 109, 'c84d8777d0b836ce63147df4efb2953e.pdf', '2022-01-27', NULL, NULL, NULL, '2017-07-21 06:52:52'),
(201, 20, 110, '5fac1ede647d547c388183ff057b2d12.pdf', '2018-02-26', NULL, NULL, NULL, '2017-07-21 06:57:05'),
(202, 21, 109, 'cded4442981db89acb16d06cdf2a9e13.pdf', '2022-01-27', NULL, NULL, NULL, '2017-07-21 08:05:55'),
(203, 21, 107, '81fc1d1d30d535b517f2998a12ee2b57.pdf', '2021-08-08', NULL, NULL, NULL, '2017-07-21 08:07:35'),
(204, 21, 115, 'T1361093215', '2015-09-04', '2017-07-21', NULL, 16, '2017-07-21 08:23:40'),
(205, 21, 116, 'C2226334215', '2015-11-20', '2017-07-21', NULL, 16, '2017-07-21 08:24:18'),
(206, 21, 117, 'C2026354215', '2015-11-20', '2017-07-21', NULL, 16, '2017-07-21 08:24:48'),
(207, 21, 118, 'SCR04599U', '2014-12-29', '2017-07-21', NULL, 16, '2017-07-21 08:25:36'),
(208, 21, 119, 'SCR07845U', '2012-12-29', '2017-07-21', NULL, 16, '2017-07-21 08:26:24'),
(209, 21, 122, 'B0079410115', '2015-04-12', '2017-07-21', NULL, 16, '2017-07-21 08:27:16'),
(210, 21, 123, 'PCR12780', '2014-08-25', '2017-07-21', NULL, 16, '2017-07-21 08:28:07'),
(211, 21, 124, 'SCR17160U', '2014-12-29', '2017-07-21', NULL, 16, '2017-07-21 08:28:50'),
(212, 5, 104, 'da62e6df501df00c01cc92f8d71c27af.pdf', '0000-00-00', NULL, NULL, NULL, '2017-07-21 08:29:34'),
(213, 21, 125, 'PL129677A', '2014-08-28', '2017-07-21', NULL, 16, '2017-07-21 08:29:53'),
(214, 21, 126, 'PL129883A', '2014-08-28', '2017-07-21', NULL, 16, '2017-07-21 08:30:41'),
(215, 21, 129, 'SCR18838U', '2014-11-17', '2017-07-21', NULL, 16, '2017-07-21 08:31:23'),
(216, 22, 115, 'T2816054315', '2015-11-07', '2017-07-21', NULL, 16, '2017-07-21 08:33:27'),
(217, 22, 116, 'C2125944215', '2015-11-23', '2017-07-21', NULL, 16, '2017-07-21 08:34:18'),
(218, 22, 117, 'C2226634215', '2015-11-23', '2017-07-21', NULL, 16, '2017-07-21 08:34:57'),
(219, 22, 118, 'SCR04447U', '2014-12-29', '2017-07-21', NULL, 16, '2017-07-21 08:35:38'),
(220, 22, 119, 'Co227370516', '2016-02-19', '2017-07-21', NULL, 16, '2017-07-21 08:37:47'),
(221, 22, 122, 'T2916353915', '2015-11-07', '2017-07-21', NULL, 16, '2017-07-21 08:40:01'),
(222, 22, 123, 'C2427294215', '2015-12-02', '2017-07-21', NULL, 16, '2017-07-21 08:40:52'),
(223, 22, 124, 'C2826604315', '2015-12-02', '2017-07-21', NULL, 16, '2017-07-21 08:41:29'),
(224, 22, 125, 'C0626790516', '2016-02-19', '2017-07-21', NULL, 16, '2017-07-21 08:44:33'),
(225, 22, 126, 'PCR12801U', '2014-08-25', '2017-07-21', NULL, 16, '2017-07-21 08:45:33'),
(226, 22, 129, 'C0225950916', '0000-00-00', '2017-07-21', NULL, 16, '2017-07-21 09:06:09'),
(227, 22, 129, 'C1027290616', '0000-00-00', '2017-07-21', NULL, 16, '2017-07-21 09:06:45'),
(228, 5, 105, '17b1f4e012ac5c054e99c60c79545949.pdf', '2017-12-09', NULL, NULL, NULL, '2017-07-21 09:07:01'),
(229, 23, 115, 'T0435803515', '2015-09-12', '2017-07-21', NULL, 16, '2017-07-21 09:09:26'),
(230, 5, 108, '07e6df060aaea84d241cdbb7c8e66b89.pdf', '2018-05-09', NULL, NULL, NULL, '2017-07-21 09:13:10'),
(231, 5, 110, 'f0b7ddf5afac1fe476483390f346a713.pdf', '2018-02-28', NULL, NULL, NULL, '2017-07-21 09:16:01'),
(232, 23, 116, 'C0426252615', '2015-09-12', '2017-07-21', NULL, 16, '2017-07-21 09:16:31'),
(233, 23, 117, 'C0528162715', '2015-09-12', '2017-07-21', NULL, 16, '2017-07-21 09:17:14'),
(234, 23, 118, 'C1027102715', '2015-09-12', '2017-07-21', NULL, 16, '2017-07-21 09:19:25'),
(235, 23, 119, 'C1628032415', '2015-09-12', '2017-07-21', NULL, 16, '2017-07-21 09:20:43'),
(236, 23, 122, 'T0438653515', '2015-09-12', '2017-07-21', NULL, 16, '2017-07-21 09:21:27'),
(237, 23, 123, 'C1025580216', '2016-02-03', '2017-07-21', NULL, 16, '2017-07-21 09:22:26'),
(238, 23, 124, 'C0926580116', '2016-02-03', '2017-07-21', NULL, 16, '2017-07-21 09:23:10'),
(239, 23, 125, 'C2926082615', '2015-09-12', '2017-07-21', NULL, 16, '2017-07-21 09:24:02'),
(240, 23, 126, 'C2328602515', '2015-09-12', '2017-07-21', NULL, 16, '2017-07-21 09:24:53'),
(241, 23, 129, 'ML012316R', '2014-02-07', '2017-07-21', NULL, 16, '2017-07-21 09:25:48'),
(242, 20, 115, 'T2714534715', '2015-12-14', '2017-07-21', NULL, 16, '2017-07-21 09:27:36'),
(243, 20, 116, 'SCR07845U', '2014-12-29', '2017-07-21', NULL, 16, '2017-07-21 09:28:53'),
(244, 20, 117, 'SCR18838U', '2014-11-17', '2017-07-21', NULL, 16, '2017-07-21 09:29:24'),
(245, 20, 118, 'MCR13777U', '2015-03-11', '2017-07-21', NULL, 16, '2017-07-21 09:30:03'),
(246, 20, 119, 'HCR10992U', '2015-03-11', '2017-07-21', NULL, 16, '2017-07-21 09:30:53'),
(247, 20, 122, 'T2112344615', '2015-12-14', '2017-07-21', NULL, 16, '2017-07-21 09:31:31'),
(248, 20, 123, 'C0926144915', '2016-01-04', '2017-07-21', NULL, 16, '2017-07-21 09:32:17'),
(249, 20, 124, 'C1127064515', '2016-01-04', '2017-07-21', NULL, 16, '2017-07-21 09:32:59'),
(250, 20, 125, 'MCR14183U', '2015-03-11', '2017-07-21', NULL, 16, '2017-07-21 09:34:08'),
(251, 20, 126, 'PLI29691A', '2014-08-28', '2017-07-21', NULL, 16, '2017-07-21 09:35:07'),
(252, 20, 129, 'T0642302814', '2014-07-31', '2017-07-21', NULL, 16, '2017-07-21 09:35:57'),
(253, 7, 115, 'C2140252515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 09:37:55'),
(254, 7, 116, 'C2149982515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 09:38:35'),
(255, 7, 117, 'C2117692515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 09:39:16'),
(256, 7, 118, 'C2116492515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 09:39:45'),
(257, 7, 119, 'C2121942515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 09:41:13'),
(258, 7, 120, 'C2110532515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 09:41:51'),
(259, 7, 121, 'C2160492515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 09:42:39'),
(260, 7, 122, 'C2153772515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 09:43:27'),
(261, 7, 123, 'C2140332515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 09:44:23'),
(262, 5, 109, 'dc6e0462bda1fe91386d6013dad4bf95.pdf', '2021-05-10', NULL, NULL, NULL, '2017-07-21 10:07:48'),
(263, 6, 104, '52af70aba5f578615e8c3f94c6bcc10f.pdf', '0000-00-00', NULL, NULL, NULL, '2017-07-21 10:11:20'),
(264, 6, 106, 'ce454fbf10d72bf9093e47516d6d8b98.pdf', '2017-08-09', NULL, NULL, NULL, '2017-07-21 10:12:51'),
(265, 6, 105, '0068e878c4a58cd4526efebfc015c34f.pdf', '2017-12-15', '2017-07-21', NULL, 16, '2017-07-21 10:14:05'),
(266, 6, 105, '134b2730673d93b5b5212ee0cb1e81b6.pdf', '2017-12-15', NULL, NULL, NULL, '2017-07-21 10:14:35'),
(267, 6, 108, '2077b3f46dd7c0e20f446f505689f204.pdf', '2017-05-09', NULL, NULL, NULL, '2017-07-21 10:16:32'),
(268, 6, 110, '9474940121f5d36668a5a12351ea18b7.pdf', '2018-05-02', NULL, NULL, NULL, '2017-07-21 10:17:23'),
(269, 6, 107, '49828926cb8ecb111b836bbda294a39b.pdf', '2021-05-12', NULL, NULL, NULL, '2017-07-21 10:26:37'),
(270, 13, 104, 'a87cbe31307504383428b863964792b0.pdf', '0000-00-00', NULL, NULL, NULL, '2017-07-21 10:35:18'),
(271, 13, 108, '3db75ae8ad063822fcf5da380798113e.pdf', '2017-11-21', NULL, NULL, NULL, '2017-07-21 10:36:29'),
(272, 13, 106, '4c195cf896065b15515b1bb2690353ee.pdf', '2017-01-08', NULL, NULL, NULL, '2017-07-21 10:37:50'),
(273, 13, 110, '1fe744cf927e7ae03bcc9ad45893fa8a.pdf', '2017-08-16', '2017-08-18', NULL, 16, '2017-07-21 10:39:19'),
(274, 7, 124, 'C0814382315', '0000-00-00', NULL, NULL, NULL, '2017-07-21 11:52:12'),
(275, 7, 125, 'C0334804415', '0000-00-00', NULL, NULL, NULL, '2017-07-21 11:53:08'),
(276, 7, 126, 'C2112732515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 11:53:47'),
(277, 7, 127, 'C2105202515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 11:54:16'),
(278, 7, 128, 'C135949415', '0000-00-00', NULL, NULL, NULL, '2017-07-21 11:54:50'),
(279, 7, 129, 'C2158092515', '0000-00-00', NULL, NULL, NULL, '2017-07-21 11:55:19'),
(280, 5, 115, 'C1658612415', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 11:56:36'),
(281, 5, 116, 'C2732034715', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 11:57:03'),
(282, 5, 117, 'C2139484615', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 11:57:26'),
(283, 5, 118, 'C1860142415', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 11:58:19'),
(284, 5, 119, 'C2638064715', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 11:58:53'),
(285, 5, 120, 'C2743324715', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 11:59:26'),
(286, 5, 121, 'C3054504815', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 11:59:54'),
(287, 5, 122, 'C2149422515', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 12:00:24'),
(288, 5, 123, 'C2057342415', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 12:00:49'),
(289, 5, 124, 'C2711514715', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 12:01:26'),
(290, 5, 125, 'C2702354715', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 12:01:57'),
(291, 5, 126, 'C2637824715', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 12:02:29'),
(292, 5, 127, 'C2704994715', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 12:02:59'),
(293, 5, 128, 'C1640822415', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 12:03:31'),
(294, 5, 129, 'C2239702515', '0000-00-00', '2017-07-28', NULL, 16, '2017-07-21 12:03:55'),
(295, 21, 115, 'T0635451017', '2017-03-18', NULL, NULL, NULL, '2017-07-21 12:23:42'),
(296, 21, 116, 'C2530310817', '2017-03-18', NULL, NULL, NULL, '2017-07-21 12:24:10'),
(297, 21, 117, 'C2519120817', '2017-03-18', NULL, NULL, NULL, '2017-07-21 12:24:52'),
(298, 21, 118, 'C0825581916', '2016-06-02', NULL, NULL, NULL, '2017-07-21 12:25:19'),
(299, 21, 119, 'C0225950916', '2016-03-15', NULL, NULL, NULL, '2017-07-21 12:25:54'),
(300, 21, 122, 'T2119112016', '2016-06-02', NULL, NULL, NULL, '2017-07-21 12:26:47'),
(301, 21, 123, 'C1826250716', '2016-03-11', NULL, NULL, NULL, '2017-07-21 12:27:25'),
(302, 21, 124, 'C2025160716', '2016-03-11', '2017-07-21', NULL, 16, '2017-07-21 12:28:25'),
(303, 21, 124, 'C1527010716', '2016-04-13', '2017-07-21', NULL, 16, '2017-07-21 12:28:56'),
(304, 21, 126, 'C2627310816', '2016-04-13', NULL, NULL, NULL, '2017-07-21 12:29:30'),
(305, 21, 124, 'C2025160716', '2016-03-11', NULL, NULL, NULL, '2017-07-21 12:30:45'),
(306, 21, 125, 'C1527010716', '2016-04-13', NULL, NULL, NULL, '2017-07-21 12:31:14'),
(307, 21, 129, 'C1072102715', '2015-09-12', NULL, NULL, NULL, '2017-07-21 12:31:48'),
(308, 20, 115, 'T2117752916', '2016-08-05', NULL, NULL, NULL, '2017-07-21 12:33:10'),
(309, 20, 116, 'C2718060417', '2017-02-10', NULL, NULL, NULL, '2017-07-21 12:33:39'),
(310, 20, 117, 'C2718620417', '2017-02-10', NULL, NULL, NULL, '2017-07-21 12:34:20'),
(311, 20, 118, 'C1425591116', '2016-04-20', NULL, NULL, NULL, '2017-07-21 12:34:44'),
(312, 20, 119, 'C1726571116', '2016-04-20', NULL, NULL, NULL, '2017-07-21 12:35:42'),
(313, 20, 122, 'T2063462916', '2016-08-05', NULL, NULL, NULL, '2017-07-21 12:36:09'),
(314, 20, 123, 'C0425372716', '2016-08-30', NULL, NULL, NULL, '2017-07-21 12:36:51'),
(315, 20, 124, 'C1425792816', '2016-08-30', '2017-07-21', NULL, 16, '2017-07-21 12:37:19'),
(316, 20, 124, 'C1626182416', '2016-06-28', '2017-07-21', NULL, 16, '2017-07-21 12:37:53'),
(317, 20, 126, 'C1626042416', '2016-06-28', NULL, NULL, NULL, '2017-07-21 12:38:24'),
(318, 20, 129, 'C2125944215', '2015-11-23', NULL, NULL, NULL, '2017-07-21 12:38:50'),
(319, 20, 124, 'C1425792816', '2016-08-30', NULL, NULL, NULL, '2017-07-21 12:39:48'),
(320, 20, 125, 'C1626182416', '2016-06-28', NULL, NULL, NULL, '2017-07-21 12:40:17'),
(321, 22, 115, 'T0420072716', '2016-07-15', NULL, NULL, NULL, '2017-07-21 12:42:10'),
(322, 22, 116, 'C1125603216', '2016-10-22', NULL, NULL, NULL, '2017-07-21 12:42:36'),
(323, 22, 117, 'C2144642916', '2016-10-22', NULL, NULL, NULL, '2017-07-21 12:43:24'),
(324, 22, 118, 'C1226291916', '2016-06-02', NULL, NULL, NULL, '2017-07-21 12:43:50'),
(325, 22, 119, 'C0626790516', '2016-02-19', NULL, NULL, NULL, '2017-07-21 12:44:47'),
(326, 22, 122, 'T0343682716', '2016-07-15', NULL, NULL, NULL, '2017-07-21 12:45:39'),
(327, 22, 123, 'C2427294215', '2015-12-02', NULL, NULL, NULL, '2017-07-21 12:46:13'),
(328, 22, 124, 'C2826604315', '2015-12-02', NULL, NULL, NULL, '2017-07-21 12:46:45'),
(329, 22, 125, 'C0920674516', '2017-02-04', NULL, NULL, NULL, '2017-07-21 12:47:22'),
(330, 22, 126, 'C0821724516', '2017-02-04', NULL, NULL, NULL, '2017-07-21 12:47:53'),
(331, 22, 129, 'T1361093215', '2015-09-04', NULL, NULL, NULL, '2017-07-21 12:48:23'),
(332, 23, 115, 'T1343521916', '2016-06-09', NULL, NULL, NULL, '2017-07-21 12:51:39'),
(333, 23, 116, 'C1628293316', '2016-12-06', NULL, NULL, NULL, '2017-07-21 12:52:09'),
(334, 23, 117, 'C2425423016', '2016-12-06', NULL, NULL, NULL, '2017-07-21 12:52:42'),
(335, 23, 118, 'C1825573316', '2016-09-24', NULL, NULL, NULL, '2017-07-21 12:53:14'),
(336, 23, 119, 'C1825053316', '2016-09-24', NULL, NULL, NULL, '2017-07-21 12:53:41'),
(337, 23, 122, 'T1343101916', '2016-06-09', NULL, NULL, NULL, '2017-07-21 12:54:08'),
(338, 23, 123, 'C2025610716', '2016-03-11', NULL, NULL, NULL, '2017-07-21 12:54:48'),
(339, 23, 124, 'C0926580116', '2016-02-03', '2017-07-21', NULL, 16, '2017-07-21 12:55:16'),
(340, 23, 124, 'C1027290616', '2016-03-15', '2017-07-21', NULL, 16, '2017-07-21 12:55:50'),
(341, 23, 126, 'C3125743116', '0000-00-00', NULL, NULL, NULL, '2017-07-21 12:56:54'),
(342, 23, 129, 'T2714534715', '2015-12-14', NULL, NULL, NULL, '2017-07-21 12:57:22'),
(343, 23, 124, 'C0926580116', '2016-02-03', NULL, NULL, NULL, '2017-07-21 12:58:29'),
(344, 23, 125, 'C1027290616', '2016-03-15', NULL, NULL, NULL, '2017-07-21 12:58:57'),
(345, 2, 102, 'JUGAL HEMBREM', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:00:00'),
(346, 4, 100, '8327092431', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:02:03'),
(347, 4, 102, 'BAKSA KALINDI', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:02:27'),
(348, 5, 100, '8873598416', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:07:47'),
(349, 5, 102, 'BRAHMANAND NONIA', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:08:42'),
(350, 6, 100, '9903302147', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:12:33'),
(351, 7, 100, '9934765262', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:13:34'),
(352, 7, 102, 'VIJAY KUMAR CHOUDHARY', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:14:03'),
(353, 8, 100, '7294855232', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:15:07'),
(354, 8, 102, 'BIKASH KUMAR', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:15:30'),
(355, 11, 100, '8621055133', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:17:56'),
(356, 11, 102, 'ANIL KUMAR', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:18:14'),
(357, 12, 100, '7319766965', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:19:21'),
(358, 12, 102, 'RAJESH KUMAR YADAV', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:19:48'),
(359, 13, 100, '7908246581', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:20:45'),
(360, 14, 100, '8768277568', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:25:19'),
(361, 14, 102, 'INDRAJEET HALDAR', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:25:52'),
(362, 16, 102, 'PANKAJ MAHATO', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:27:06'),
(363, 17, 102, 'SURENDRA MAHATO', '0000-00-00', NULL, NULL, NULL, '2017-07-22 11:28:53'),
(364, 2, 104, '66c310580bf10415bdaa2b90e407dfcb.pdf', '2018-03-02', NULL, NULL, NULL, '2017-07-26 10:49:24'),
(365, 2, 105, 'bfec7a43dfbf8c25e9d9d012a50120bc.pdf', '2017-09-22', NULL, NULL, NULL, '2017-07-26 10:50:24'),
(366, 2, 106, 'ccb82d8c00c6878ce0907a13030bed1d.pdf', '2018-06-03', NULL, NULL, NULL, '2017-07-26 10:51:30'),
(367, 2, 108, '26d00311723445ac0fc17de9086d22cf.pdf', '2018-03-05', NULL, NULL, NULL, '2017-07-26 10:53:07'),
(368, 2, 109, '384ea0efd1bfa353f771fd750010c301.pdf', '2021-08-17', NULL, NULL, NULL, '2017-07-26 10:54:19'),
(369, 2, 110, '698d4d32276d5e1a4817169b57efb69e.pdf', '2018-02-25', NULL, NULL, NULL, '2017-07-26 10:57:52'),
(370, 2, 107, '09f3da970f9c2e2a36451f512cea7c39.pdf', '2021-08-17', NULL, NULL, NULL, '2017-07-26 10:59:13'),
(371, 3, 104, '77705567729cd48f9f434d6a31bda86f.pdf', '2018-03-02', NULL, NULL, NULL, '2017-07-26 11:01:25'),
(372, 3, 105, 'd49489eee89ca6eedf6e6fff3939e40d.pdf', '2017-09-22', NULL, NULL, NULL, '2017-07-26 11:02:26'),
(373, 3, 106, 'dc857ed30f59340a92610f6ba553490c.pdf', '2018-06-03', NULL, NULL, NULL, '2017-07-26 11:26:10'),
(374, 3, 108, '0f257deb5c8c380fdd14a74344586b08.pdf', '2018-03-05', NULL, NULL, NULL, '2017-07-26 11:30:07'),
(375, 3, 110, '09f032325cfe29bb6285e1446ce2caf9.pdf', '2018-02-25', NULL, NULL, NULL, '2017-07-26 11:31:04'),
(376, 3, 109, '1c629d766ee6d800417d06b3310f5585.pdf', '2021-03-07', NULL, NULL, NULL, '2017-07-26 11:32:03'),
(377, 3, 115, 'c1754712415', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:45:45'),
(378, 3, 116, 'C1223604615', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:46:24'),
(379, 3, 117, 'C2012244615', '2016-02-03', '2017-07-26', NULL, 16, '2017-07-26 11:46:58'),
(380, 3, 117, 'C2019962615', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:48:54'),
(381, 3, 118, 'C2012244615', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:49:25'),
(382, 3, 119, 'C1622954615', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:50:56'),
(383, 3, 120, 'C2006914615', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:52:18'),
(384, 3, 121, 'C4623054615', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:52:58'),
(385, 3, 122, 'C1691684915', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:53:41'),
(386, 3, 123, 'C2523624715', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:54:17'),
(387, 3, 124, 'C2043604915', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:56:02'),
(388, 3, 125, 'C2011684615', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:57:06'),
(389, 3, 126, 'C3014753515', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:57:40'),
(390, 3, 127, 'C3038534615', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:58:23'),
(391, 3, 128, 'C1622434615', '2016-02-03', NULL, NULL, NULL, '2017-07-26 11:59:44'),
(392, 4, 115, 'C2149422515', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:16:53'),
(393, 4, 116, 'C7860742475', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:17:30'),
(394, 4, 117, 'C2077514715', '0000-00-00', NULL, NULL, NULL, '2017-07-26 12:18:37'),
(395, 4, 118, 'C2704994715', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:19:12'),
(396, 4, 119, 'C0933954516', '0000-00-00', NULL, NULL, NULL, '2017-07-26 12:26:45'),
(397, 4, 120, 'C0270235415', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:27:56'),
(398, 4, 121, 'C2239702515', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:28:38'),
(399, 4, 122, 'C1658612415', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:29:16'),
(400, 4, 123, 'C2057342415', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:29:51'),
(401, 4, 124, 'C2139484615', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:30:25'),
(402, 4, 125, 'C2638064715', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:31:17'),
(403, 4, 126, 'C1940822415', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:32:02'),
(404, 4, 127, 'C1940822415', '2016-07-23', '2017-07-26', NULL, 16, '2017-07-26 12:33:43'),
(405, 4, 127, 'C2732034715', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:34:59'),
(406, 4, 128, 'C3054504815', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:36:44'),
(407, 4, 129, 'C2743324715', '2016-07-23', NULL, NULL, NULL, '2017-07-26 12:37:41'),
(408, 9, 104, '942b07f128cd27058c4a321cc633d655.pdf', '2018-08-13', NULL, NULL, NULL, '2017-07-28 09:10:21'),
(409, 9, 105, '58d4077e14f0995901eb8e09abbfe11e.pdf', '2017-11-02', NULL, NULL, NULL, '2017-07-28 09:11:12'),
(410, 9, 106, '2570fb88bbda67008d5a0f9baa8e11e5.pdf', '2017-12-01', NULL, NULL, NULL, '2017-07-28 09:12:07'),
(411, 9, 107, 'e48f2fbc04683ef7042faf2dac985d5f.pdf', '2021-09-07', NULL, NULL, NULL, '2017-07-28 09:13:18'),
(412, 9, 109, '889e2b65a81de9eea905eebc3df34b41.pdf', '2021-09-07', NULL, NULL, NULL, '2017-07-28 09:17:13'),
(413, 9, 110, '80ad53c995e773753f8b2a415b5a910a.pdf', '2017-08-16', '2017-08-18', NULL, 16, '2017-07-28 09:19:35'),
(414, 9, 115, 'C2422362516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:23:05'),
(415, 9, 116, 'C2465022516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:24:28'),
(416, 9, 117, 'C0301692216', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:24:59'),
(417, 9, 118, 'C2010282516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:25:39'),
(418, 9, 119, 'C1810702416', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:26:40'),
(419, 9, 120, 'C2330992516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:27:15'),
(420, 9, 121, 'C2458362516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:28:06'),
(421, 9, 122, 'C2544592516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:28:55'),
(422, 9, 123, 'C2572122516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:30:06'),
(423, 9, 124, 'C2003622516', '2016-04-26', NULL, NULL, NULL, '2017-07-28 09:30:43'),
(424, 9, 125, 'C2041352516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:31:22'),
(425, 9, 126, 'C1744182416', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:32:20'),
(426, 9, 127, 'C2006292516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:33:07'),
(427, 9, 128, 'C2494682516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 09:33:42'),
(428, 10, 108, '9d194005ea422af60829fac600350e3e.pdf', '2017-10-02', NULL, NULL, NULL, '2017-07-28 11:07:10'),
(429, 10, 109, 'f31026d85ca7522c04ea1efd1029628c.pdf', '2021-09-07', NULL, NULL, NULL, '2017-07-28 11:08:06'),
(430, 10, 106, '417c5e4036a655fbdd55da066e137ca0.pdf', '2017-12-01', NULL, NULL, NULL, '2017-07-28 11:09:04'),
(431, 10, 115, 'C2541372516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:09:54'),
(432, 10, 116, 'C2462222516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:11:00'),
(433, 10, 117, 'C1105082816', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:11:32'),
(434, 10, 118, 'C2023592516', '2017-07-26', NULL, NULL, NULL, '2017-07-28 11:12:11'),
(435, 10, 119, 'C1134672816', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:13:01'),
(436, 10, 120, 'C1113172816', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:13:37'),
(437, 10, 121, 'C2458042516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:14:11'),
(438, 10, 122, 'C2463302516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:15:42'),
(439, 10, 123, 'C2444562516', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:18:09'),
(440, 10, 124, 'C1015992816', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:19:03'),
(441, 10, 125, 'C11141192816', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:19:55'),
(442, 10, 126, 'C1140642816', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:20:31'),
(443, 10, 127, 'C1138942816', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:21:13'),
(444, 10, 128, 'C1035692816', '2016-07-26', NULL, NULL, NULL, '2017-07-28 11:21:55'),
(445, 11, 104, 'cd97cefd432cced18c5b0a13c55cf9cd.pdf', '2018-08-30', NULL, NULL, NULL, '2017-07-28 11:25:55'),
(446, 11, 105, 'a1da8fbec6887f729458e382e888fa9c.pdf', '2017-11-22', NULL, NULL, NULL, '2017-07-28 11:26:42'),
(447, 11, 106, 'a23c6fb00a7b236e4f24f068298ad654.pdf', '2017-12-01', NULL, NULL, NULL, '2017-07-28 11:28:16'),
(448, 11, 108, '2238ffdcdc118a66b9cbc0d47abe41c8.pdf', '2017-10-03', NULL, NULL, NULL, '2017-07-28 11:30:04'),
(449, 11, 107, NULL, NULL, '2017-07-28', NULL, 16, '2017-07-28 11:35:59'),
(450, 11, 107, '48c256f6c9c054f691ee3609b40a593d.pdf', '2021-09-07', NULL, NULL, NULL, '2017-07-28 11:36:03'),
(451, 11, 109, 'e2d419028c4456fcdeee076c11e86a1d.pdf', '2021-09-07', NULL, NULL, NULL, '2017-07-28 11:37:27'),
(452, 11, 110, '2d229088c142b502550bca524c70effb.pdf', '2017-08-16', '2017-08-18', NULL, 16, '2017-07-28 11:38:23'),
(453, 11, 131, '1fa29791cb6d075cb45d4cb7d81a44be.pdf', '2021-09-17', NULL, NULL, NULL, '2017-07-28 11:53:56'),
(454, 11, 116, 'C1063871916', '2016-07-26', NULL, NULL, NULL, '2017-07-28 12:25:35'),
(455, 11, 117, 'C2336041616', '2016-07-26', NULL, NULL, NULL, '2017-07-28 12:26:42'),
(456, 11, 118, 'C2311171616', '2016-07-26', NULL, NULL, NULL, '2017-07-28 12:27:20'),
(457, 11, 120, 'C2345181616', '2016-07-26', NULL, NULL, NULL, '2017-07-28 12:28:25'),
(458, 11, 121, 'C0663331416', '2016-07-26', NULL, NULL, NULL, '2017-07-28 12:28:57'),
(459, 11, 122, 'C2032341216', '2016-07-26', NULL, NULL, NULL, '2017-07-28 12:29:59'),
(460, 11, 123, 'C1023980616', '2016-07-26', '2017-07-28', NULL, 16, '2017-07-28 12:30:40'),
(461, 11, 124, 'C1906761616', '2016-07-26', NULL, NULL, NULL, '2017-07-28 12:31:37'),
(462, 11, 125, 'C2339671616', '2016-07-26', NULL, NULL, NULL, '2017-07-28 12:32:10'),
(463, 11, 126, 'C2403791716', '2016-07-26', NULL, NULL, NULL, '2017-07-28 12:32:50'),
(464, 11, 127, 'C2202991616', '2016-07-26', NULL, NULL, NULL, '2017-07-28 12:43:33'),
(465, 11, 123, 'C1023980616', '2016-07-26', NULL, NULL, NULL, '2017-07-28 12:49:36'),
(466, 4, 104, 'd712ea276f815d6a198609d542225f1f.pdf', '2018-05-08', NULL, NULL, NULL, '2017-07-28 13:26:37'),
(467, 4, 105, 'ef521bdcd787945e745a2f279dc3e8fb.pdf', '2017-08-24', NULL, NULL, NULL, '2017-07-28 13:27:27'),
(468, 4, 106, '7e3dc1f746af423a6cd078f443b92130.pdf', '2017-08-09', '2017-07-28', NULL, 16, '2017-07-28 13:28:20'),
(469, 4, 106, NULL, NULL, NULL, NULL, NULL, '2017-07-28 13:28:28'),
(470, 4, 107, '080a0aaae3ae2ccf3ea55d50b649d131.pdf', '2021-05-12', NULL, NULL, NULL, '2017-07-28 13:28:57'),
(471, 4, 108, '9d47da296f5bbdb8a88f2b3cd3c2aeac.pdf', '2018-05-09', NULL, NULL, NULL, '2017-07-28 13:29:52'),
(472, 4, 109, '725027fdb85f0d4deba57cbf33cc9260.pdf', '2021-05-12', NULL, NULL, NULL, '2017-07-28 13:30:40'),
(473, 4, 110, 'd4e0931a9a2bb7a2a7a915417f877a27.pdf', '2018-05-02', NULL, NULL, NULL, '2017-07-28 13:31:42'),
(474, 4, 131, 'e2095648832d13468154024b05a156f7.pdf', '2021-05-12', NULL, NULL, NULL, '2017-07-28 13:33:46'),
(475, 5, 115, 'C2121024615', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:37:57'),
(476, 5, 116, 'C2223774715', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:39:09'),
(477, 5, 117, 'C2222194715', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:39:49'),
(478, 5, 118, 'C1503643715', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:40:26'),
(479, 5, 119, 'C1722194615', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:41:02'),
(480, 5, 120, 'C1643583715', '2016-04-23', NULL, NULL, NULL, '2017-07-28 13:42:28'),
(481, 5, 121, 'C2706223415', '0000-00-00', NULL, NULL, NULL, '2017-07-28 13:43:16'),
(482, 5, 122, 'C1606873715', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:44:38'),
(483, 5, 123, 'C1204103615', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:45:10'),
(484, 5, 124, 'C2915393415', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:46:05'),
(485, 5, 125, 'C1639793715', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:46:38'),
(486, 5, 126, 'C1642853715', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:47:10'),
(487, 5, 127, 'C2158244615', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:47:42'),
(488, 5, 128, 'C1721214615', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:48:16'),
(489, 6, 115, 'C2158032515', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:52:49'),
(490, 6, 116, 'C2249362515', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:53:21'),
(491, 6, 117, 'C0612774415', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:53:49'),
(492, 6, 118, 'C0338614415', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:54:18'),
(493, 6, 119, 'C0612434516', '2016-04-23', NULL, NULL, NULL, '2017-07-28 13:54:50'),
(494, 6, 120, 'C2207912515', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:55:18'),
(495, 6, 121, 'C2040262415', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:56:20'),
(496, 6, 122, 'C2034412415', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:56:52'),
(497, 6, 123, 'C2149702515', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:57:24'),
(498, 6, 124, 'C0608474415', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:57:53'),
(499, 6, 125, 'C1904932415', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:58:26'),
(500, 6, 126, 'C0403814415', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:58:58'),
(501, 6, 127, 'C1812782415', '2016-07-23', NULL, NULL, NULL, '2017-07-28 13:59:31'),
(502, 6, 128, 'C2224652915', '2016-07-23', NULL, NULL, NULL, '2017-07-28 14:00:03'),
(503, 14, 104, 'd5bd26b7e47b70ebbbcb95656965c008.pdf', '2018-09-20', NULL, NULL, NULL, '2017-07-29 06:01:39'),
(504, 14, 105, 'f00a7af9e35245a348ab58fe2da27027.pdf', '2017-11-22', NULL, NULL, NULL, '2017-07-29 06:02:29'),
(505, 14, 106, 'b7c24129cf10f4a2566dfb93231d11ba.pdf', '0000-00-00', '2017-07-29', NULL, 16, '2017-07-29 06:39:06'),
(506, 14, 106, '6a3e24d0b5974bef5012ce78f076d79b.pdf', '2017-12-21', NULL, NULL, NULL, '2017-07-29 06:41:10'),
(507, 14, 107, '64c391a7bb7d9938d705d5d4b1e49230.pdf', '2021-09-27', NULL, NULL, NULL, '2017-07-29 06:42:18'),
(508, 14, 108, '049a68db80916701871d8822b456d8d2.pdf', '2017-10-04', NULL, NULL, NULL, '2017-07-29 06:49:57'),
(509, 14, 109, 'aa95b0f856c1065707bfff86a0cd4128.pdf', '2021-09-27', NULL, NULL, NULL, '2017-07-29 06:52:18'),
(510, 14, 110, '64685cd9487d6e8ffb31faaa347ce2c0.pdf', '2017-09-09', NULL, NULL, NULL, '2017-07-29 06:53:16'),
(511, 14, 131, 'd616627d050f957b75d3c748de073735.pdf', '2021-09-27', NULL, NULL, NULL, '2017-07-29 06:54:36'),
(512, 14, 115, 'C0960822316', '2016-08-22', NULL, NULL, NULL, '2017-07-29 06:56:45'),
(513, 14, 116, 'C0619452316', '2016-08-22', NULL, NULL, NULL, '2017-07-29 06:57:18'),
(514, 14, 117, 'C1731682516', '2016-08-22', NULL, NULL, NULL, '2017-07-29 06:58:04'),
(515, 14, 118, 'C1232232416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 06:58:30'),
(516, 14, 119, 'C1709312416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 06:59:01'),
(517, 14, 120, 'C1901472516', '2016-08-22', NULL, NULL, NULL, '2017-07-29 06:59:39'),
(518, 14, 121, 'C1062962316', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:05:56'),
(519, 14, 122, 'C0660262316', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:06:26'),
(520, 14, 123, 'C1020922316', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:06:55'),
(521, 14, 124, 'C1312042416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:07:23'),
(522, 14, 125, 'C1330992416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:07:51'),
(523, 14, 126, 'C1320192416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:08:24'),
(524, 14, 127, 'C1305522416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:09:46'),
(525, 14, 128, 'C0452622216', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:10:16'),
(526, 14, 129, 'C1023482316', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:10:48'),
(527, 15, 104, '888126cc62a95d1a7831947eb87f260b.pdf', '2018-09-20', NULL, NULL, NULL, '2017-07-29 07:13:22'),
(528, 15, 105, '6d6c68f5496eb9ca2dbca0cd18eac75c.pdf', '2017-11-22', NULL, NULL, NULL, '2017-07-29 07:14:12'),
(529, 15, 106, '856fe2e0bcc12691c737d146894ebcd6.pdf', '2017-12-21', NULL, NULL, NULL, '2017-07-29 07:15:03'),
(530, 15, 107, 'c0fe72e8947603225c10e9c9c8cc8f82.pdf', '2021-09-28', NULL, NULL, NULL, '2017-07-29 07:16:02'),
(531, 15, 108, '3fff9a0e16ae631ed8bfe31bf69d6090.pdf', '2017-10-04', NULL, NULL, NULL, '2017-07-29 07:17:16'),
(532, 15, 109, 'a15d8549d990fceef0730d8eeecad369.pdf', '2021-09-28', NULL, NULL, NULL, '2017-07-29 07:18:24'),
(533, 15, 110, 'ac4083268e56245509398d96b0b3b673.pdf', '2017-09-09', NULL, NULL, NULL, '2017-07-29 07:19:09'),
(534, 15, 131, '08289bc1b8b3e0457a78651ddc0e95e5.pdf', '2021-09-28', NULL, NULL, NULL, '2017-07-29 07:20:14'),
(535, 15, 115, 'C2442272517', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:22:23'),
(536, 15, 116, 'C2562752516', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:22:54'),
(537, 15, 117, 'C2421242516', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:23:23'),
(538, 15, 118, 'C1404592416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:23:53'),
(539, 15, 119, 'C2127222516', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:24:22'),
(540, 15, 120, 'C1211452416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:25:01'),
(541, 15, 121, 'C1022292316', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:25:39'),
(542, 15, 122, 'C0923362316', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:57:50'),
(543, 15, 123, 'C0822092316', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:58:41'),
(544, 15, 124, 'C1430922416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 07:59:11'),
(545, 15, 125, 'C2109302516', '0000-00-00', NULL, NULL, NULL, '2017-07-29 08:00:04'),
(546, 15, 126, 'C1738612416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 08:00:36'),
(547, 15, 127, 'C1334812416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 08:02:53'),
(548, 15, 128, 'C1065082316', '2016-08-22', NULL, NULL, NULL, '2017-07-29 08:03:50'),
(549, 15, 129, 'C2131362516', '2016-08-22', NULL, NULL, NULL, '2017-07-29 08:04:37'),
(550, 16, 104, '4071bcc4f82845880ecc33fb96345745.pdf', '2018-10-18', NULL, NULL, NULL, '2017-07-29 08:07:09'),
(551, 16, 105, 'd34a69cfe335012f7d6992c5f8541cd0.pdf', '2017-11-21', NULL, NULL, NULL, '2017-07-29 08:08:12'),
(552, 16, 106, '42f02b603e47baf03a9f05f8c8214f84.pdf', '2018-01-08', NULL, NULL, NULL, '2017-07-29 08:09:30'),
(553, 16, 107, NULL, NULL, '2017-07-29', NULL, 16, '2017-07-29 08:10:34'),
(554, 16, 107, NULL, '2021-10-24', NULL, NULL, NULL, '2017-07-29 08:10:52'),
(555, 16, 108, '414860e5a2524045a3a44b44807c0142.pdf', '2017-11-21', NULL, NULL, NULL, '2017-07-29 08:11:36'),
(556, 16, 109, NULL, '2021-10-24', NULL, NULL, NULL, '2017-07-29 09:02:41'),
(557, 16, 110, '5f20655bd8d5a3d9d1d7d94de4602d29.pdf', '2017-08-16', NULL, NULL, NULL, '2017-07-29 09:03:18'),
(558, 16, 131, '90e917a5fb5ee5c31cef2b920bd3172f.pdf', '2021-10-24', NULL, NULL, NULL, '2017-07-29 09:04:16'),
(559, 16, 115, 'C1922861116', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:05:31'),
(560, 16, 116, 'C1222071916', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:05:59'),
(561, 16, 117, 'C0931013616', '2016-12-28', NULL, NULL, NULL, '2017-07-29 09:06:30'),
(562, 16, 118, 'C1227111916', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:06:58'),
(563, 16, 119, 'C1261291916', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:07:48'),
(564, 16, 120, 'C1300611917', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:08:22'),
(565, 16, 121, 'C1220801916', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:08:51'),
(566, 16, 122, 'C1723141616', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:09:23');
INSERT INTO `vehicle_attr` (`id`, `vehicle_id`, `attribute_tp_cd`, `value`, `expiry_dt`, `end_on`, `last_data`, `last_updated_by`, `last_updated_at`) VALUES
(567, 16, 123, 'C1860391116', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:10:00'),
(568, 16, 124, 'C1302501916', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:25:03'),
(569, 16, 125, 'C1327341916', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:26:15'),
(570, 16, 126, 'C1304971916', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:26:53'),
(571, 16, 127, 'C1332181916', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:27:35'),
(572, 16, 128, 'C0523841416', '2016-08-22', NULL, NULL, NULL, '2017-07-29 09:28:10'),
(573, 17, 104, 'da7feb446df6fd271fea356fec72af9e.pdf', '0000-00-00', NULL, NULL, NULL, '2017-07-29 09:31:41'),
(574, 17, 105, 'ebabdf94766a53db572afb9d8a5dc3af.pdf', '2017-11-11', NULL, NULL, NULL, '2017-07-29 09:39:11'),
(575, 17, 106, 'fb46d5c89882c1b5a7ea5711aa2cf7a6.pdf', '2018-07-02', NULL, NULL, NULL, '2017-07-29 09:43:33'),
(576, 17, 107, 'ebfea90a73e64fd5fb03cad6baff37c0.pdf', '2022-04-16', NULL, NULL, NULL, '2017-07-29 09:55:41'),
(577, 17, 108, 'b4feeef30c84467d6dd0a3739082be47.pdf', '2018-05-09', NULL, NULL, NULL, '2017-07-29 10:09:56'),
(578, 17, 109, 'af44104011285ecedbe10fcd72722553.pdf', '2022-04-16', NULL, NULL, NULL, '2017-07-29 10:44:51'),
(579, 17, 110, 'a47686f9b11488c0a0f308661a3da0e0.pdf', '2018-03-20', NULL, NULL, NULL, '2017-07-29 10:48:46'),
(580, 17, 115, 'C2571972516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:49:40'),
(581, 17, 116, 'C2423162516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:50:06'),
(582, 17, 117, 'C2542312516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:50:46'),
(583, 17, 118, 'C2303372516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:52:09'),
(584, 17, 119, 'C0738282316', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:52:39'),
(585, 17, 120, 'C2202822516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:53:08'),
(586, 17, 121, 'C2564052516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:53:42'),
(587, 17, 122, 'C2506412516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:54:13'),
(588, 17, 123, 'C1715532416', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:54:39'),
(589, 17, 124, 'C2106542516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:55:15'),
(590, 17, 125, 'C1716632516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:55:47'),
(591, 17, 126, 'C1403642516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 10:57:18'),
(592, 17, 127, 'C0738282316', '2016-09-06', '2017-07-29', NULL, 16, '2017-07-29 10:58:12'),
(593, 17, 127, 'C2563432516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 11:02:42'),
(594, 17, 128, 'C2545702516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 11:03:13'),
(595, 17, 129, 'C2132022516', '2016-09-06', NULL, NULL, NULL, '2017-07-29 11:03:47'),
(596, 17, 111, 'c6836a8f528e93ec1241e85b77fc9813.pdf', '2019-02-02', NULL, NULL, NULL, '2017-07-29 11:04:40'),
(597, 2, 115, 'C1621504615', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 11:08:42'),
(598, 2, 116, 'C2941463415', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 11:09:11'),
(599, 2, 117, 'C2130834615', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 11:09:42'),
(600, 2, 118, 'C2610443415', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 11:10:08'),
(601, 2, 120, 'C1959794215', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 11:11:27'),
(602, 2, 121, 'C2161484615', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 12:27:10'),
(603, 2, 122, 'C2112704615', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 12:27:44'),
(604, 2, 123, 'C1866484215', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 12:28:15'),
(605, 2, 125, 'C2224404715', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 12:29:19'),
(606, 2, 127, 'C3024973515', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 12:33:16'),
(607, 2, 128, 'C2912193415', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 12:33:58'),
(608, 2, 129, 'C2906273415', '2016-02-03', '2017-09-23', NULL, 16, '2017-07-29 12:35:54'),
(609, 24, 115, 'B0036762715', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:26:15'),
(610, 24, 116, 'B57482031516', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:26:41'),
(611, 24, 117, 'K0138310416', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:27:15'),
(612, 24, 118, 'C5732341516', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:28:32'),
(613, 24, 119, 'N143404215', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:28:57'),
(614, 24, 120, 'V0121031415', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:30:19'),
(615, 24, 121, 'K0086374515', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:31:05'),
(616, 24, 122, 'R0077544015', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:32:25'),
(617, 24, 123, 'C0088044115', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:33:19'),
(618, 24, 124, 'R0121354215', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:33:49'),
(619, 24, 125, 'R0205314415', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:34:58'),
(620, 24, 126, 'C0198974415', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:35:44'),
(621, 24, 127, 'KC062226', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:36:28'),
(622, 24, 128, 'B0036712715', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:37:06'),
(623, 24, 129, 'RL14245A', '2017-06-03', NULL, NULL, NULL, '2017-08-02 05:37:33'),
(624, 12, 104, 'f6ee61fc6527ade1ae9cf5b2644e2989.pdf', '0000-00-00', NULL, NULL, NULL, '2017-08-04 05:43:57'),
(625, 12, 105, '40191c389b299b3d543b601d8af3dfa5.pdf', '2017-11-22', NULL, NULL, NULL, '2017-08-04 07:35:52'),
(626, 12, 106, '99e05284c3cc78f1c0d70c93778bf29c.pdf', '2017-12-01', NULL, NULL, NULL, '2017-08-04 07:44:34'),
(627, 12, 107, '4b4c8addeedd3f22f9d02b1fe55e00d8.pdf', '2021-09-06', NULL, NULL, NULL, '2017-08-04 08:53:55'),
(628, 12, 110, '9639d5bb6089c3619dc93d401da1507b.pdf', '2017-08-16', '2017-08-18', NULL, 16, '2017-08-04 08:54:38'),
(629, 12, 108, '9b7128b0256a11e91adfe81389dd8243.pdf', '2017-10-03', NULL, NULL, NULL, '2017-08-04 09:27:47'),
(630, 12, 131, '11e91d5c91b71c9ba316586b43f2cd4a.pdf', '2021-09-06', NULL, NULL, NULL, '2017-08-04 09:29:00'),
(631, 12, 115, 'C1263881916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:35:58'),
(632, 12, 116, 'C1221881916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:37:35'),
(633, 12, 117, 'C1315841916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:38:51'),
(634, 12, 118, 'C1327851916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:39:26'),
(635, 12, 119, 'C1303861916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:40:35'),
(636, 12, 120, 'C1207681916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:41:11'),
(637, 12, 121, 'C1260651916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:41:44'),
(638, 12, 122, 'C1220741916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:42:16'),
(639, 12, 123, 'C2162381216', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:42:53'),
(640, 12, 124, 'C1310721916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:43:33'),
(641, 12, 125, 'C1327231916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:44:58'),
(642, 12, 126, 'C2024471216', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:45:32'),
(643, 12, 127, 'C1315841916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:46:32'),
(644, 12, 128, 'C1223041916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:47:13'),
(645, 12, 129, 'C1315831916', '2016-07-26', NULL, NULL, NULL, '2017-08-04 09:47:48'),
(646, 9, 110, '8616a9590a21986c2b1f344455483e9d.pdf', '2018-08-16', NULL, NULL, NULL, '2017-08-18 09:36:42'),
(647, 10, 110, 'a069895580cfe18d400ca8eec13f65fd.pdf', '2018-08-16', NULL, NULL, NULL, '2017-08-18 09:38:22'),
(648, 11, 110, '0242ddad0b75478c6befcb99de49ed5e.pdf', '2018-08-16', NULL, NULL, NULL, '2017-08-18 09:39:45'),
(649, 12, 110, '7ab9e496446fed583c404b5796ee3b2f.pdf', '2018-08-16', NULL, NULL, NULL, '2017-08-18 09:41:31'),
(650, 13, 110, '8851724f6f9c015ddef49432e3de851f.jpg', '2018-08-16', NULL, NULL, NULL, '2017-08-18 09:43:13'),
(651, 2, 115, 'T0812922717', '2017-08-28', NULL, NULL, NULL, '2017-09-23 09:29:24'),
(652, 2, 116, 'C2912193415', '0000-00-00', NULL, NULL, NULL, '2017-09-23 09:33:35'),
(653, 2, 117, 'C0118402617', '0017-08-28', NULL, NULL, NULL, '2017-09-23 09:35:41'),
(654, 2, 118, 'C0530282317', '0017-08-28', NULL, NULL, NULL, '2017-09-23 09:36:25'),
(655, 2, 119, 'C2130834615', '0000-00-00', '2017-09-23', NULL, 16, '2017-09-23 09:39:03'),
(656, 2, 119, 'C2130834615', '0016-02-03', NULL, NULL, NULL, '2017-09-23 09:40:01'),
(657, 2, 120, 'C630249735', '0000-00-00', NULL, NULL, NULL, '2017-09-23 09:42:37'),
(658, 2, 121, 'C2112704615', '0016-02-03', NULL, NULL, NULL, '2017-09-23 09:43:19'),
(659, 2, 122, 'T0716462717', '0000-00-00', '2017-09-23', NULL, 16, '2017-09-23 09:43:56'),
(660, 2, 122, 'T0812922717', '0000-00-00', NULL, NULL, NULL, '2017-09-23 09:44:23'),
(661, 2, 123, 'C1119172417', '0017-07-20', NULL, NULL, NULL, '2017-09-23 09:45:18'),
(662, 2, 124, 'C1218092417', '0017-07-20', NULL, NULL, NULL, '2017-09-23 09:46:37'),
(663, 2, 125, 'C1217972417', '0017-07-20', NULL, NULL, NULL, '2017-09-23 09:47:08'),
(664, 2, 126, 'C2224404715', '0016-02-03', NULL, NULL, NULL, '2017-09-23 09:48:01'),
(665, 2, 127, '1860482415', '0016-02-03', NULL, NULL, NULL, '2017-09-23 09:48:58'),
(666, 2, 128, 'C1923054615', '0000-00-00', NULL, NULL, NULL, '2017-09-23 09:49:35'),
(667, 2, 129, 'C2941463415', '0016-02-03', NULL, NULL, NULL, '2017-09-23 09:50:07');

-- --------------------------------------------------------

--
-- Table structure for table `worklog`
--

CREATE TABLE `worklog` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `issuer_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `start_on` datetime NOT NULL,
  `end_on` datetime DEFAULT NULL,
  `status` varchar(45) DEFAULT 'I',
  `deleted` varchar(1) DEFAULT 'A',
  `description` longtext,
  `file` varchar(255) DEFAULT NULL,
  `status_approved` int(1) DEFAULT '0',
  `approval_pending` int(1) DEFAULT '0',
  `lastUpdatedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `project_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `worklog`
--

INSERT INTO `worklog` (`id`, `name`, `issuer_id`, `employee_id`, `start_on`, `end_on`, `status`, `deleted`, `description`, `file`, `status_approved`, `approval_pending`, `lastUpdatedAt`, `project_id`) VALUES
(1, 'LNT Garden Reach Pond Ash Requirement', 15, 15, '2017-03-15 17:26:30', '2017-03-18 17:27:48', 'I', 'A', 'Look for pond fly ash for filling work at LNT Garden Reach site on a priority basis.', NULL, 0, 0, '2017-03-15 11:58:00', NULL),
(2, 'Ahmedabad Metro Construction', 15, 16, '2017-03-27 18:21:53', '2017-03-31 18:23:15', 'I', 'A', 'Call the companies associated with Ahmedabad Metro Construction', NULL, 0, 0, '2017-03-28 09:25:26', NULL),
(3, 'utility', 16, 16, '2017-03-27 18:34:53', '2017-03-29 18:35:53', 'I', 'A', 'gdfgdfb', NULL, 0, 0, '2017-05-08 11:23:15', NULL),
(4, 'AHMEDABAD METRO PROJECT', 16, 16, '2017-03-28 14:24:12', '2018-03-31 14:25:29', 'I', 'A', '', NULL, 0, 0, '2017-03-30 09:20:27', NULL),
(5, 'LIST OF LEFT EMPLOYEES 2013-2017', 16, 12, '2017-03-28 14:26:51', '2017-03-29 14:28:12', 'I', 'A', '', NULL, 0, 0, '2017-03-28 08:57:21', NULL),
(6, 'CRISIL & ISO Logo', 15, 16, '2017-03-28 14:52:45', '2017-04-07 14:54:15', 'C', 'A', 'CRISIL & ISO Logo on email website and letterhead.', NULL, 1, 0, '2017-04-07 12:43:32', NULL),
(7, 'Material Shifting', 15, 19, '2017-03-28 14:53:49', '2017-04-07 14:55:10', 'I', 'A', 'Material shifting from Ultratech Dankuni to Shalimar', NULL, 0, 0, '2017-03-28 09:24:52', NULL),
(8, 'DRIVER SALARY FOR FEB 2017', 16, 16, '2017-03-28 14:55:44', '2017-03-29 14:57:06', 'I', 'A', '', NULL, 0, 0, '2017-04-07 12:44:23', NULL),
(9, 'Bridge & Roof - Santragachi', 15, 51, '2017-03-28 14:55:49', '2017-04-30 14:57:08', 'X', 'A', 'Tender', NULL, 0, 0, '2017-05-30 11:15:15', NULL),
(10, 'Extra Claim Bill', 15, 15, '2017-03-28 14:56:29', '2017-04-15 14:57:45', 'I', 'A', 'Talk with Dhawan Sir for Extra Claim', NULL, 0, 0, '2017-03-28 09:27:21', NULL),
(11, 'Fixed Cost Sheet for ATPL - monthly basis', 15, 16, '2017-03-28 14:57:20', '2017-04-30 14:58:51', 'I', 'A', 'Fixed Cost Sheet for ATPL - monthly basis', NULL, 0, 0, '2017-06-01 08:54:56', NULL),
(12, 'LNT - Purulia, Rampurhat, Raiganj', 15, 21, '2017-03-28 14:58:08', '2017-04-05 14:59:39', 'I', 'A', 'Discuss with Kailash ji. We need to take order and start supply.', NULL, 0, 1, '2017-07-26 05:17:39', NULL),
(13, 'Vendor Registration - PWD', 15, 51, '2017-03-28 14:59:16', '2017-04-15 15:00:35', 'X', 'A', 'Need to register ATPL at PWD', NULL, 0, 0, '2017-05-30 11:16:07', NULL),
(14, 'Ford Car Case', 15, 18, '2017-03-28 15:00:18', '2017-08-31 15:01:33', 'I', 'A', 'Filing date - 29.03.2017', NULL, 0, 0, '2017-08-01 08:38:47', NULL),
(15, 'SALARY PAYMENT EMPLOYEE', 16, 16, '2017-04-07 17:13:09', '2017-04-07 17:14:37', 'I', 'A', '', NULL, 0, 0, '2017-04-07 11:43:56', NULL),
(16, 'SALARY OF DRIVERS', 16, 16, '2017-04-07 17:13:55', '2017-04-07 17:16:10', 'I', 'A', '', NULL, 0, 0, '2017-04-07 12:47:03', NULL),
(17, 'NEW RECRUITMENT', 16, 16, '2017-04-07 17:15:22', '2017-05-01 17:16:45', 'C', 'A', '', NULL, 1, 0, '2017-07-31 07:38:51', NULL),
(18, 'COMPLIANCE FOR MARCH 2017', 16, 16, '2017-04-07 18:17:45', '2017-04-21 18:19:24', 'C', 'A', '', NULL, 1, 0, '2017-07-31 07:38:13', NULL),
(19, 'All compliance register submition to UTCL', 16, 26, '2017-04-07 18:26:40', '2017-04-10 18:28:24', 'C', 'A', 'all register need to update and submit to UTCL', NULL, 1, 0, '2017-07-31 07:30:22', NULL),
(20, 'To Ms.Dipanti Shaw', 15, 21, '2017-05-08 17:11:41', '2017-05-09 17:13:30', 'C', 'A', 'Update me when u r finish', 'fb5da339524fe1b271225e83e428a28f.docx', 1, 0, '2017-05-08 11:48:53', NULL),
(21, 'work for myself', 21, 21, '2017-05-08 17:22:24', '2017-05-09 17:23:39', 'I', 'A', 'test', NULL, 0, 1, '2017-05-09 11:04:06', NULL),
(22, '', 17, 17, '2017-05-08 17:23:25', '2017-05-09 17:24:36', 'I', 'A', '', NULL, 0, 1, '2017-05-08 11:55:00', NULL),
(23, 'RENEWAL OF FLY ASH QUOTA OF ALL SOURCE DPL ,ANDAL AND MEJIA', 21, 21, '2017-05-09 16:17:39', '0000-00-00 00:00:00', 'I', 'A', '', NULL, 0, 0, '2017-05-09 11:03:22', NULL),
(24, 'Navyug Minerals Purchase Entry in ATPL 17-18', 40, 40, '2017-05-10 11:44:08', '2017-05-10 12:30:08', 'I', 'A', '5 bills', NULL, 0, 1, '2017-05-11 05:51:35', NULL),
(25, 'Stock Opening ATPL Entry', 40, 40, '2017-05-10 12:47:40', '2017-05-10 13:15:00', 'I', 'A', '', NULL, 0, 1, '2017-05-11 09:54:57', NULL),
(26, 'LNT FIN\'S PAPER SHOULD BE MAKE ARRANGE TODAY AND SEND', 21, 21, '2017-05-10 12:23:56', '0000-00-00 00:00:00', 'I', 'A', '', '3befdffaaec5db7ab12a58be3f052480.pdf', 0, 0, '2017-05-10 06:56:31', NULL),
(27, 'BUlker Driver details', 16, 12, '2017-05-10 13:22:08', '2017-05-17 13:23:35', 'I', 'A', 'details', 'e9419ff125e956c50fe498fafc0525b4.jpg', 0, 0, '2017-05-10 07:54:46', NULL),
(28, 'Esi PF', 15, 16, '2017-05-11 13:25:32', '2017-05-13 13:26:32', 'C', 'D', 'Payment Urgent', NULL, 1, 0, '2017-05-10 07:58:06', NULL),
(29, 'Kusum Himatsingka and Purushottam Himatsingka address change form ready (Kotak Securities)  ', 40, 40, '2017-05-10 14:49:41', '0000-00-00 00:00:00', 'I', 'A', '', NULL, 0, 0, '2017-05-10 09:21:54', NULL),
(30, 'Purchase Entry against Sales in ATPL making', 40, 40, '2017-05-10 14:51:56', '0000-00-00 00:00:00', 'I', 'A', '', NULL, 0, 0, '2017-05-10 09:22:30', NULL),
(31, 'new challan records , ', 61, 61, '0000-00-00 00:00:00', '2010-05-20 17:00:00', 'I', 'A', '', NULL, 0, 0, '2017-05-10 11:16:58', NULL),
(32, 'Fly Ash Daily Terget', 58, 58, '2017-05-11 09:16:18', '0000-00-00 00:00:00', 'I', 'A', '', NULL, 0, 1, '2017-05-11 04:01:44', NULL),
(33, 'Fly Ash Planner', 58, 58, '2017-05-11 09:37:57', '2017-05-11 09:53:00', 'I', 'A', '', '1b432c4465a4ee31a266e3e87df09da4.xlsx', 0, 1, '2017-05-11 04:24:37', NULL),
(34, 'ATPL purchase and sales bill check upto may', 40, 40, '2017-05-11 11:18:30', '2017-05-11 13:40:25', 'I', 'A', '', NULL, 0, 1, '2017-05-11 09:56:17', NULL),
(35, 'Share Holding Pattern of Anish Reators , Himatsingka Consultacy and Aadarsh', 40, 40, '2017-05-11 13:42:20', '2017-05-11 14:42:56', 'I', 'A', '', NULL, 0, 1, '2017-05-11 09:56:34', NULL),
(36, 'Purchase Entry ATPL 17-18', 40, 40, '2017-05-11 15:22:07', '2017-05-15 17:21:40', 'I', 'A', 'start 15:00.07', NULL, 0, 1, '2017-05-11 12:25:30', NULL),
(37, 'Sales Bill Reconcile with Seema Ji', 40, 40, '2017-05-12 11:00:32', '2017-05-12 12:30:00', 'I', 'A', '', NULL, 0, 1, '2017-05-12 07:17:38', NULL),
(38, 'purchase entry of Fly Ash Bricks, Sand , Ballast, silver sand, stone dust etc', 40, 40, '2017-05-12 12:48:26', '0000-00-00 00:00:00', 'I', 'A', '', NULL, 0, 0, '2017-05-12 07:20:12', NULL),
(39, 'purchase entry of Fly Ash Bricks, Sand , Ballast, silver sand, stone dust etc', 40, 40, '2017-05-12 12:50:51', '2017-05-12 14:49:54', 'I', 'A', '', NULL, 0, 1, '2017-05-12 11:29:55', NULL),
(40, 'SIP BOOK PURUSHOTTAM HIMATSINGKA HUF AND KUSUM HIMATSINGKA', 40, 40, '2017-05-12 17:57:11', '2017-05-12 17:58:11', 'I', 'A', '', NULL, 0, 1, '2017-05-12 11:29:36', NULL),
(41, 'bulker driver salary', 44, 44, '2017-05-16 16:20:51', '2017-05-20 16:24:42', 'I', 'A', '', NULL, 0, 1, '2017-05-16 10:54:34', NULL),
(42, 'Tally Entry all company', 15, 12, '2017-05-27 15:16:17', '2017-05-29 15:17:32', 'I', 'A', 'All companies purchase and sale including banking transactions data to be updated in tally by monday.', NULL, 0, 0, '2017-05-27 09:49:48', NULL),
(43, 'Tally Full Access', 70, 21, '2017-05-27 17:00:34', '2017-06-15 17:01:41', 'I', 'A', 'You need to handle all timely entries into tally. You cannot and will not share your password with any one. You are responsible for the entire accounts team.', NULL, 0, 0, '2017-05-27 11:32:25', NULL),
(44, 'Payment follow up (src,rdc and others as well)', 21, 21, '2017-05-29 18:59:56', '2017-05-31 19:00:56', 'I', 'A', '', NULL, 0, 0, '2017-05-27 13:30:41', NULL),
(45, 'LNT LIMIT PAPER TO BE TAKE', 21, 21, '2017-05-29 19:25:33', '2017-05-29 19:26:33', 'I', 'A', '', NULL, 0, 1, '2017-07-26 05:19:04', NULL),
(46, 'Bank book entries', 75, 75, '2017-05-29 10:34:17', '2017-05-29 10:42:30', 'I', 'A', 'Tally entries of Aadarsh Tradlink of all banks', NULL, 0, 1, '2017-05-29 05:40:25', NULL),
(47, 'tally entry', 75, 75, '2017-05-29 11:14:50', '2017-05-30 11:16:01', 'I', 'A', '', NULL, 0, 1, '2017-05-29 05:45:45', NULL),
(48, 'Balancesheet of laxmi traders & suppliers', 75, 75, '2017-05-29 11:30:24', '0000-00-00 00:00:00', 'I', 'A', 'Updating Balancesheet with dep on building', NULL, 0, 0, '2017-05-29 06:13:29', NULL),
(49, 'segregation of Ambuja sale bill challan', 75, 75, '2017-05-29 11:43:29', '2017-05-29 11:44:33', 'I', 'A', '', NULL, 0, 0, '2017-05-29 07:46:49', NULL),
(50, 'ITR form', 75, 75, '2017-05-29 16:49:19', '2017-05-29 16:50:20', 'I', 'A', 'ITR form fill up of nitesh huf and purushottam huf. completed', NULL, 0, 0, '2017-05-29 11:23:07', NULL),
(51, 'tally entry', 75, 75, '2017-05-29 19:03:59', '2017-05-29 19:05:05', 'I', 'A', 'tally entry of Aashi Tie-up updated', NULL, 0, 0, '2017-05-29 13:34:48', NULL),
(52, 'GST requirement of Ambuja Cement', 15, 21, '2017-06-01 14:23:08', '2017-06-04 14:24:23', 'C', 'A', 'Check today\'s email and revert to Ambuja.', NULL, 1, 0, '2017-06-03 11:05:42', NULL),
(53, 'LNT Purchase Order from Rajiv Chaudhury  for ITC projet site', 15, 12, '2017-06-03 16:33:14', '2017-06-05 16:34:51', 'I', 'A', 'Need PO by Monday', NULL, 0, 0, '2017-06-03 11:05:00', NULL),
(54, 'west bengal tender follow up ', 21, 21, '2017-06-10 16:25:37', '2017-07-31 16:26:37', 'I', 'A', '', NULL, 0, 0, '2017-06-10 10:56:44', NULL),
(55, 'Call Mr.Abhishek Prahlada for Sub Brokership appointment on Saturday', 15, 15, '2017-06-16 12:35:48', '2017-06-16 12:36:48', 'I', 'A', '', NULL, 0, 0, '2017-06-12 07:06:32', NULL),
(56, 'Driver Salary Hisaab Check - Ashok Tiwary', 15, 15, '2017-06-14 11:20:05', '2017-06-15 11:21:20', 'I', 'A', '', NULL, 0, 0, '2017-06-14 05:50:35', NULL),
(57, 'Pintu Expense check', 15, 15, '2017-06-14 11:20:33', '2017-06-15 11:21:45', 'I', 'A', '', NULL, 0, 0, '2017-06-14 05:51:01', NULL),
(58, 'Vinay Madan mail reply and name transfer', 15, 15, '2017-06-14 11:20:58', '2017-06-15 11:22:38', 'I', 'A', '', NULL, 0, 0, '2017-06-14 05:51:50', NULL),
(59, 'HBDM - Axis Bank Handover letter for EDC Machine', 15, 12, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'I', 'A', '', NULL, 0, 0, '2017-07-21 19:59:47', NULL),
(60, 'Credit Card Statement - AMEX and HDFC', 15, 12, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'I', 'A', '', NULL, 0, 0, '2017-06-14 05:52:38', NULL),
(61, 'Mobile Handset for software - Pritam Sahu', 15, 15, '2017-06-14 11:22:36', '2017-06-15 11:24:07', 'I', 'A', '', NULL, 0, 0, '2017-06-14 05:53:23', NULL),
(62, '', 79, 12, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'C', 'A', '', NULL, 1, 0, '2017-06-21 06:12:29', NULL),
(63, 'HR RELATED ISSUE', 84, 26, '2017-06-27 18:58:41', '2017-06-29 19:00:05', 'I', 'A', 'All file already with you', NULL, 0, 0, '2017-06-27 13:30:09', NULL),
(64, 'TEST321', 15, 15, '2017-07-05 15:21:43', '2017-07-05 15:22:43', 'I', 'D', 'TEST321', 'bc9d1f565af08a0eb32cf9a5644db966.jpg', 0, 0, '2017-07-04 09:52:41', NULL),
(65, 'Trinity account 11 status update and share trading activation ipo', 15, 40, '2017-07-04 16:21:40', '2017-07-09 16:23:10', 'I', 'A', 'Update me on 10/7 on this positively', NULL, 0, 0, '2017-07-04 10:53:07', NULL),
(66, 'Email Ambuja farakka renewal', 15, 15, '2017-07-17 08:38:50', '2017-07-17 08:39:50', 'C', 'A', 'We came to know that your Farakka renewal is going to happen. We want to participate in the renewal contract .please provide me with an enquiry. To Ankita cc lakhotia\r\n2. Call mr.lakhotia and ask for the dates of renewal.', NULL, 1, 0, '2017-07-17 12:15:10', NULL),
(67, 'Ambuja - Lakhotia', 15, 15, '2017-07-24 08:42:39', '0000-00-00 00:00:00', 'I', 'A', 'Jamshedpur to sindhri - adhunik to acc\r\nBudge budge to sankrail\r\nSagar dighi to Farakka\r\nLakhotia ji follow up.', NULL, 0, 0, '2017-07-17 03:15:24', NULL),
(68, 'LNT Rajiv Chaudhary email', 15, 15, '2017-07-17 09:48:41', '2017-07-18 09:49:55', 'C', 'A', '', NULL, 1, 0, '2017-07-21 04:56:13', NULL),
(69, 'Mr.Lohias daughter admission Techno India', 15, 15, '2017-07-25 20:51:15', '2017-07-29 20:52:15', 'C', 'A', '', NULL, 1, 0, '2017-07-24 13:12:26', NULL),
(70, 'Amex Corporate Card', 15, 15, '2017-07-18 20:54:13', '2017-07-31 20:55:33', 'I', 'A', '', NULL, 0, 0, '2017-07-21 19:57:27', NULL),
(71, 'Tata Telematics in new vehicles', 15, 15, '2017-07-18 20:54:56', '2017-07-23 20:57:25', 'I', 'A', '', NULL, 0, 0, '2017-07-21 19:53:12', NULL),
(72, 'Binata Broad Band BSNL', 15, 15, '2017-07-18 20:57:55', '2017-07-29 20:59:27', 'I', 'A', '', NULL, 0, 0, '2017-07-21 19:56:05', NULL),
(73, 'Bank book entries', 75, 75, '2017-07-22 16:27:45', '2017-07-22 16:27:45', 'I', 'A', 'Bank entries updated of Aadarsh Tradlink', NULL, 0, 0, '2017-07-22 11:01:00', NULL),
(74, 'Bank book entries', 75, 75, '0000-00-00 00:00:00', '2017-07-22 16:27:45', 'I', 'A', 'Bank entries updated of Aadarsh Tradlink', NULL, 0, 0, '2017-07-22 11:01:47', NULL),
(75, 'Updation of Bank entries and opening balance', 75, 75, '2017-07-22 16:31:45', '2017-07-22 16:34:08', 'I', 'A', 'Bank entry updated of fy 2016-17 of Sakar, Equi Minerals, Emerging Minerals, Himatsingka consultancy and suspense need to clarify, some bank statement is not in file, informed Dipak about the query', NULL, 0, 0, '2017-07-22 11:06:57', NULL),
(76, 'vat return summary', 75, 75, '2017-07-22 18:46:14', '2017-07-22 18:47:33', 'I', 'A', 'vat return summary of aadarsh prepared', NULL, 0, 0, '2017-07-22 13:17:42', NULL),
(77, 'Follow up email to skipper for payment', 15, 21, '2017-07-24 18:42:35', '2017-07-25 18:43:35', 'I', 'A', '', NULL, 0, 0, '2017-07-24 13:15:05', NULL),
(78, 'Regus follow up for money receipt', 15, 13, '2017-07-25 22:14:24', '2017-07-31 22:14:24', 'I', 'A', '', NULL, 0, 0, '2017-07-24 16:45:47', NULL),
(79, 'Printing Order', 16, 16, '2017-07-26 11:57:16', '2017-08-12 12:00:53', 'I', 'A', 'Blank Challan\r\nLetter Head\r\nHimatsingka & Co', NULL, 0, 0, '2017-08-02 11:11:13', NULL),
(80, 'Invitation to RFQ - Request for Quotation Code rfq_9835 on LafargeHolcim eSourcing Portal', 21, 21, '2027-07-20 17:00:00', '0000-00-00 00:00:00', 'I', 'A', 'Mohit bhaiya my be look this...@390/- per MT', NULL, 0, 0, '2017-07-27 13:47:27', NULL),
(81, 'Ambuja RFQ', 15, 15, '2017-07-24 18:54:02', '2017-08-01 18:55:45', 'C', 'A', '', NULL, 1, 0, '2017-07-31 14:59:41', NULL),
(82, 'UTCL Reconciliation according to client wastage as WO', 15, 84, '2017-07-24 18:55:34', '2017-07-30 19:15:35', 'C', 'A', 'RA Bill wise reco', NULL, 1, 0, '2017-07-29 11:21:10', NULL),
(83, 'Bricks Reco', 15, 84, '2017-07-28 19:15:01', '2017-07-30 19:16:01', 'I', 'A', '', NULL, 0, 0, '2017-07-28 08:45:32', NULL),
(84, 'Final Bill Reco for Road Work', 15, 84, '2017-07-28 19:15:24', '2017-07-30 19:16:24', 'C', 'A', '', NULL, 1, 0, '2017-07-29 11:18:30', NULL),
(85, 'Jindal RA Bill', 15, 15, '2017-07-28 19:21:02', '2017-07-30 19:22:02', 'I', 'A', '', NULL, 0, 0, '2017-07-28 08:51:34', NULL),
(86, 'RAMCO Planning', 15, 44, '2017-07-28 19:21:25', '2017-07-30 19:22:25', 'I', 'A', '', NULL, 0, 0, '2017-07-28 08:55:33', NULL),
(87, 'Haldia Fly Ash ', 15, 70, '2017-07-28 19:25:25', '2017-07-30 19:26:25', 'I', 'A', '', NULL, 0, 0, '2017-07-28 08:56:02', NULL),
(88, 'Haldia Chemical Gypsum, Slag export to Bangladesh and Fly Ash export', 15, 70, '2017-07-28 19:25:53', '0000-00-00 00:00:00', 'I', 'A', '', NULL, 0, 0, '2017-08-02 09:52:37', NULL),
(89, 'Fly ash new plant Haldia', 15, 70, '2017-07-28 19:27:00', '2017-07-30 19:28:00', 'I', 'A', '', NULL, 0, 0, '2017-07-28 08:57:39', NULL),
(90, 'JJKR visit', 15, 70, '2017-07-28 19:27:30', '2017-07-28 19:28:30', 'I', 'A', '', NULL, 0, 0, '2017-07-31 04:52:42', NULL),
(91, 'Rail Sleeper Factory', 15, 15, '2017-07-28 14:29:08', '2017-07-30 14:30:13', 'I', 'A', 'Prasad SRC and Google', NULL, 0, 0, '2017-07-28 09:01:10', NULL),
(92, 'Garden Reach LNT Sand urgent', 15, 13, '2017-07-28 15:13:07', '2017-07-28 15:13:07', 'I', 'A', 'Zone 2 sand urgently required at Garden Reach LNT site', NULL, 0, 0, '2017-07-28 09:45:36', NULL),
(93, 'Skipper Visit', 15, 15, '2017-07-29 15:14:32', '2017-07-29 15:15:32', 'I', 'A', 'Mr.Vinod Bansal for paver block. Last price provided Rs.92 plus GST', NULL, 0, 0, '2017-07-28 09:46:58', NULL),
(94, 'Police Traffic Guard - Facebook', 15, 15, '2017-07-28 15:15:27', '2017-07-28 15:16:47', 'I', 'D', '', NULL, 0, 0, '2017-07-28 09:47:35', NULL),
(95, 'Deepak Cash payment to Kailash ji to be checked from cash book', 15, 70, '2017-07-28 15:26:45', '2017-07-31 15:27:54', 'C', 'A', '', NULL, 1, 0, '2017-09-08 16:54:46', NULL),
(96, 'LNT - Pakur sourcing and Betia delivery', 15, 38, '2017-07-28 14:29:40', '2017-07-31 14:33:37', 'I', 'A', 'Sindhi Bazaar and Pakur area', NULL, 0, 0, '2017-08-02 09:19:29', NULL),
(97, 'Ambuja conclave membership', 15, 15, '2017-07-31 20:58:00', '2017-07-31 20:59:00', 'I', 'A', '', NULL, 0, 0, '2017-07-29 15:29:19', NULL),
(98, 'Announcement of New Office Timing', 16, 16, '2017-07-31 12:55:08', '2017-07-31 12:56:29', 'C', 'A', '9 AM to 6 PM announced by letter to all official staffs.signed and receiving.', '6ea927b59d24741757ab7ed92b3d67d3.doc', 1, 0, '2017-08-01 05:12:35', NULL),
(99, 'Monthly Seminer with Lalit ji', 16, 16, '2017-07-31 12:59:01', '2017-08-05 13:00:27', 'I', 'A', '', NULL, 0, 0, '2017-08-02 10:49:37', NULL),
(100, 'Download all the cesc bill of June', 16, 16, '2017-07-31 13:03:31', '2017-08-15 13:05:06', 'C', 'A', '', NULL, 1, 0, '2017-08-01 05:17:02', NULL),
(101, 'Employee Review', 16, 16, '2017-07-31 13:04:24', '2017-08-15 13:08:20', 'I', 'A', '', NULL, 0, 0, '2017-08-03 08:21:06', NULL),
(102, 'Soumita Mukherjee As Site Engineer', 16, 16, '2017-07-31 13:09:06', '2017-08-01 13:10:45', 'C', 'A', '', NULL, 1, 0, '2017-08-01 05:10:59', NULL),
(103, 'DAILY EMPLOYEE ATTENDENCE', 74, 74, '2017-08-01 10:04:56', '2017-08-31 10:06:39', 'I', 'A', '', NULL, 0, 0, '2017-08-01 04:35:28', NULL),
(104, 'GOPAL JI CHOUBEY-LOGISTICS', 16, 16, '2017-08-01 10:44:08', '2017-08-01 10:45:27', 'C', 'A', '', NULL, 1, 0, '2017-08-01 05:15:51', NULL),
(105, 'STAFF SALARY OF THE MONTH OF JULY', 16, 16, '2017-08-01 10:47:31', '2017-08-05 10:50:02', 'I', 'A', '', NULL, 0, 0, '2017-08-02 10:57:43', NULL),
(106, 'DRIVER SALARY OF THE MONTH OF JULY', 16, 16, '2017-08-05 10:49:23', '2017-08-15 10:50:23', 'I', 'A', '', NULL, 0, 0, '2017-08-01 05:20:36', NULL),
(107, 'Leonard Ledger Confirmation', 44, 44, '2017-08-01 16:01:27', '2017-08-01 18:02:41', 'I', 'A', 'Confirm Ledger Balance', NULL, 0, 0, '2017-08-01 10:32:25', NULL),
(108, '', 44, 44, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:46:25', NULL),
(109, 'Emirates Dues Clear & A/c Confirmation', 44, 44, '2017-08-01 16:16:29', '2017-08-02 18:13:47', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:47:11', NULL),
(110, 'Pond Ash MRN From L&T Gardenreach', 44, 44, '2017-08-01 16:17:15', '2017-08-04 23:18:35', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:47:50', NULL),
(111, 'IFB A/c Confirmation', 44, 44, '2017-08-01 16:17:54', '2017-08-02 18:19:15', 'I', 'A', '', '4e3a8395d2aba54544d3d1869d9828d2.xlsx', 0, 0, '2017-08-01 10:48:44', NULL),
(112, 'L&T Sahibganj', 44, 44, '2017-08-01 16:18:48', '2017-08-10 18:20:07', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:49:19', NULL),
(113, 'UTCL Hyderabad Fly Ash Work Start', 44, 44, '2017-08-01 16:19:22', '2017-08-15 18:20:48', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:49:57', NULL),
(114, 'Bhutan Sample send. ', 44, 44, '2017-08-01 16:20:01', '2017-08-03 18:21:22', 'I', 'A', 'Fly Ash Sample', NULL, 0, 0, '2017-08-01 10:50:42', NULL),
(115, 'Buy Cement from Durgapur', 44, 44, '2017-08-01 16:20:45', '2017-08-04 18:22:05', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:51:17', NULL),
(116, 'Fly Ash Bricks Plants order for fly ash', 44, 44, '2017-08-01 16:21:20', '2017-08-04 18:22:39', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:51:49', NULL),
(117, 'JSW  Salboni order for Fly Ash', 44, 44, '2017-08-01 16:21:52', '2017-08-04 18:23:08', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:52:15', NULL),
(118, 'OCL salboni fly ash order', 44, 44, '2017-08-01 16:22:19', '2017-08-04 16:23:31', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:52:49', NULL),
(119, 'Railway Sleepers supply to Jajpur', 44, 44, '2017-08-01 16:22:53', '2017-08-10 16:24:09', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:53:22', NULL),
(120, 'Fly Ash Bricks Design Mix to ILFS', 44, 44, '2017-08-01 16:23:26', '2017-08-01 18:24:54', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:54:00', NULL),
(121, 'Fly Ash Bricks Quotation to ILFS', 44, 44, '2017-08-01 16:24:04', '2017-08-01 18:25:25', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:54:31', NULL),
(122, 'New Work Seek from Emami Jajpur', 44, 44, '2017-08-01 16:24:35', '2017-08-15 18:27:18', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:56:52', NULL),
(123, 'Damari Port Work Seek', 44, 44, '2017-08-01 16:26:55', '2017-08-15 16:28:54', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:58:04', NULL),
(124, 'Costing for Hywa from Kharagpur From Ujjan Kundu', 44, 44, '2017-08-01 16:28:07', '2017-08-02 16:30:25', 'I', 'A', '', NULL, 0, 0, '2017-08-01 10:59:32', NULL),
(125, 'Haldia Fly Ash Loading And Unloading Data Collection', 44, 44, '2017-08-01 16:29:36', '2017-08-12 16:29:36', 'I', 'A', 'Sending Arun to Haldia.', NULL, 0, 0, '2017-08-01 11:02:11', NULL),
(126, 'Quartz uses & Orders.', 44, 44, '2017-08-01 16:32:14', '2017-08-15 18:33:28', 'I', 'A', '', NULL, 0, 0, '2017-08-01 11:02:37', NULL),
(127, 'Bank book entries of all central companies', 75, 75, '2017-08-01 18:09:35', '2017-08-01 18:10:41', 'I', 'A', '', NULL, 0, 0, '2017-08-01 12:39:55', NULL),
(128, 'balancesheet of Himatsingka and consultancy, Sakar consultancy, Equi minerals drafted', 75, 75, '2017-08-01 18:09:50', '2017-08-01 18:11:46', 'I', 'A', '', NULL, 0, 0, '2017-08-01 12:41:06', NULL),
(129, 'MF Dedicate Team Allotment', 15, 15, '2017-08-02 10:30:04', '2017-08-15 10:31:14', 'I', 'A', '', NULL, 0, 0, '2017-08-02 09:14:45', NULL),
(130, 'UTCL - Arijit Rs.1,00,000 SD for supply of Fly Ash under its quota from Andal and Mejia', 15, 70, '2017-08-02 15:25:20', '2017-08-09 15:27:01', 'I', 'A', '', NULL, 0, 0, '2017-08-02 10:08:25', NULL),
(131, 'STOCK AUGUST', 16, 16, '2017-08-02 16:12:28', '2017-08-31 16:13:48', 'I', 'A', '', '4d3301f566e1f25e876f2e6c71f1e7d1.pdf', 0, 0, '2017-08-02 10:45:01', NULL),
(132, 'Abhishikta for Back Office Executive', 16, 16, '2017-08-05 16:15:39', '2017-08-05 16:16:39', 'C', 'A', 'will join on 5th Aug', NULL, 1, 0, '2017-08-09 04:38:43', NULL),
(133, 'PF and ESIC PAYMENT -JULY', 16, 16, '2017-08-02 16:17:54', '2017-08-14 16:19:28', 'I', 'A', '', NULL, 0, 0, '2017-08-02 10:48:41', NULL),
(134, 'ON TRAINING PROCESS-GOPAL JI CHOWBEY', 16, 16, '2017-08-02 16:22:03', '2017-08-31 16:24:09', 'C', 'A', '', NULL, 1, 0, '2017-08-09 04:37:45', NULL),
(135, 'Balance sheet of 5 companies drafted fully with computation and submitted to sir', 75, 75, '2017-08-02 18:19:36', '2017-08-02 18:21:32', 'I', 'A', '', NULL, 0, 0, '2017-08-02 12:50:51', NULL),
(136, 'coordinated with Auditor for whitesnow Balancesheet', 75, 75, '2017-08-02 18:20:46', '2017-08-02 18:22:16', 'I', 'A', '', NULL, 0, 0, '2017-08-02 12:51:35', NULL),
(137, 'Stock statement drafted for the month of july 2017', 75, 75, '2017-08-02 18:21:29', '2017-08-02 18:23:13', 'I', 'A', '', NULL, 0, 0, '2017-08-02 12:52:27', NULL),
(138, 'Bank book entries', 75, 75, '2017-08-03 17:30:08', '2017-08-03 17:32:04', 'I', 'A', 'Bank entries done in tally of Aadarsh kotak 1810, 0962, icici Bank', NULL, 0, 0, '2017-08-03 12:02:07', NULL),
(139, 'Annexure of dry fly ash Bill', 75, 75, '2017-08-03 17:32:01', '2017-08-03 17:33:29', 'I', 'A', 'Annexure of Dry fly ash Bill for the period of 16.07.17 to 31.07.2017 prepared', NULL, 0, 0, '2017-08-03 12:05:49', NULL),
(140, 'Stock statement for the month of July 2017', 75, 75, '2017-08-03 17:35:43', '2017-08-03 17:36:54', 'I', 'A', 'workings on Stock staement', NULL, 0, 0, '2017-08-03 12:10:13', NULL),
(141, 'Correction of Opening Balance of Aadarsh', 75, 75, '2017-08-04 11:47:20', '2017-08-04 11:49:28', 'I', 'A', 'correction of opening balance in tally of Aadarsh 2017-18 as per final tally 2016-17.', NULL, 0, 0, '2017-08-04 06:22:45', NULL),
(142, 'IST QTR BALANCE SHEET OF AADARSH', 75, 75, '2017-08-04 18:36:30', '2017-08-04 18:38:14', 'I', 'A', 'IST QTR BALANCESHEET OF AADARSH PREPARED FROM 01-04-2017 TO 30-06-2017', NULL, 0, 0, '2017-08-04 13:09:13', NULL),
(143, 'OPENING BALANCE SHEET FIGURE', 75, 75, '2017-08-04 18:39:05', '2017-08-04 18:40:29', 'I', 'A', 'OPENING BALANCE CHANGED IN TALLY AS PER LAST AUDITED BALANCESHEET', NULL, 0, 0, '2017-08-04 13:11:20', NULL),
(144, 'Rice purchase entries', 75, 75, '2017-08-05 17:59:20', '2017-08-05 18:00:43', 'I', 'A', 'rice purchase bill entries of Aadarsh from 1.04.17 to 30.06.17 done', NULL, 0, 0, '2017-08-05 12:31:29', NULL),
(145, 'purchase Bill entries ', 75, 75, '2017-08-05 18:01:22', '2017-08-05 18:02:42', 'I', 'A', 'Purchase Bill entries of some electronic items from ritvik commercial done', NULL, 0, 0, '2017-08-05 12:33:18', NULL),
(146, 'vat retrun summary', 75, 75, '2017-08-05 18:03:11', '2017-08-05 18:04:26', 'I', 'A', 'As per changes in purchase and sale, vat return summary drafted', NULL, 0, 0, '2017-08-05 12:34:49', NULL),
(147, 'Bank book entries', 75, 75, '2017-08-05 18:04:42', '2017-08-05 18:06:41', 'I', 'A', 'Bank Book entries of Aadarsh (kotak 1810, 0962, icici) done', NULL, 0, 0, '2017-08-05 12:36:47', NULL),
(148, 'kotak security share details updated', 75, 75, '2017-08-07 15:50:30', '2017-08-07 15:52:23', 'I', 'A', 'Share details updated in tally and excel', NULL, 0, 0, '2017-08-07 10:22:18', NULL),
(149, 'stock statement prepared', 75, 75, '2017-08-10 18:42:41', '2017-08-10 18:44:14', 'I', 'A', 'stock statement prepared', NULL, 0, 0, '2017-08-10 13:13:43', NULL),
(150, 'BRS', 75, 75, '2017-08-10 18:43:41', '2017-08-10 18:45:09', 'I', 'A', 'BRS of Kotak 1810 for the month of July 2017', NULL, 0, 0, '2017-08-10 13:15:10', NULL),
(151, 'SRC ledger correction', 75, 75, '2017-08-10 18:45:08', '2017-08-10 18:47:11', 'I', 'A', 'coordinate with Dipanti In correction of SRC ledger', NULL, 0, 0, '2017-08-10 13:17:26', NULL),
(152, 'Bank book entries ', 75, 75, '2017-08-12 18:04:38', '2017-08-12 18:05:50', 'I', 'A', 'Bank Book entries of aadarsh updated.', NULL, 0, 0, '2017-08-12 12:35:45', NULL),
(153, 'Balancesheet of laxmi coal', 75, 75, '2017-08-12 18:05:43', '2017-08-12 18:07:14', 'I', 'A', 'Balance sheet of Laxmi Coal updated as per changes made', NULL, 0, 0, '2017-08-12 12:37:18', NULL),
(154, 'correction of Tally entries', 75, 75, '2017-08-14 19:08:08', '2017-08-14 19:09:21', 'I', 'A', 'Correction of Tally entries of Aadarsh ( as per GST and Reverse charge)', NULL, 0, 0, '2017-08-14 13:39:19', NULL),
(155, 'pass book entries of phs huf, nkh huf, ajay, anju, jyoti, khushi trust ', 75, 75, '2017-08-18 18:55:04', '2017-08-18 18:57:45', 'I', 'A', 'pass book entries of phs huf, nkh huf, ajay, anju, jyoti, khushi trust till 16.08.2017', NULL, 0, 0, '2017-08-18 13:26:57', NULL),
(156, 'IGST BILL BOOKING', 75, 75, '2017-08-18 18:56:55', '2017-08-18 18:58:22', 'I', 'A', 'Igst Bill of Crisil booked', NULL, 0, 0, '2017-08-18 13:28:17', NULL),
(157, 'Calculation of Tax on RCM', 75, 75, '2017-08-18 18:58:15', '2017-08-18 18:59:48', 'I', 'A', 'clearing concept of calculation of tax under rcm and credit of the same\r\n\r\ndiscussed with seema for the doubts relating rcm', NULL, 0, 0, '2017-08-18 13:30:24', NULL);

--
-- Triggers `worklog`
--
DELIMITER $$
CREATE TRIGGER `trig_new_assignment` AFTER INSERT ON `worklog` FOR EACH ROW BEGIN
	insert into worklog_audit (comment, op_id, work_id) values (concat('Assignment created for ', getNameFromId(NEW.employee_id)), NEW.issuer_id, NEW.id);
    INSERT INTO notifications (message, module, url, target_id) values ('You have a new assignment', 'MyAssignments', 'workassignments/current', NEW.employee_id);
    INSERT INTO notifications (message, module, url, target_id) values ('You have submitted a new assignment', 'MyAssignments', 'workassignments/all', NEW.issuer_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `worklog_audit`
--

CREATE TABLE `worklog_audit` (
  `id` int(11) NOT NULL,
  `comment` longtext NOT NULL,
  `op_id` int(11) NOT NULL,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `work_id` int(11) NOT NULL,
  `file` int(1) DEFAULT '0',
  `file_name` varchar(80) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `worklog_audit`
--

INSERT INTO `worklog_audit` (`id`, `comment`, `op_id`, `timestamp`, `work_id`, `file`, `file_name`) VALUES
(1, 'Assignment created for Mohit Dokania', 15, '2017-03-15 11:58:00', 1, 0, NULL),
(2, 'Assignment created for Binata Koruri', 15, '2017-03-27 12:53:18', 2, 0, NULL),
(3, 'need to call further for followe up', 16, '2017-03-27 12:57:41', 2, 0, NULL),
(4, 'How many have you called today?', 15, '2017-03-27 12:59:12', 2, 0, NULL),
(5, 'all done', 16, '2017-03-27 13:00:08', 2, 0, NULL),
(6, 'Reopened', 15, '2017-03-27 13:01:03', 2, 0, NULL),
(7, 'Reopened', 15, '2017-03-27 13:01:05', 2, 0, NULL),
(8, 'Reopened', 15, '2017-03-27 13:01:09', 2, 0, NULL),
(9, '', 15, '2017-03-27 13:02:20', 2, 0, NULL),
(10, '', 15, '2017-03-27 13:02:26', 2, 0, NULL),
(11, 'Assignment created for Binata Koruri', 16, '2017-03-27 13:05:22', 3, 0, NULL),
(12, 'Assignment created for Binata Koruri', 16, '2017-03-28 08:55:08', 4, 0, NULL),
(13, '1.RITES:MR.A K MAINI :09811820329 2.AECOM ASKED TO CONTACT AHMEDABAD OFFICE 3.J KUMAR INFRA: 02267743555:jkpurchase@jkumar.com(asked for co profile) 4.D R AGARWAL& INFRACON: SANTANU MUKHERJEE:9979889481 5.AFCON:02267191000: will call on Wed', 16, '2017-03-28 08:55:46', 4, 0, NULL),
(14, 'Assignment created for KAILASH AGARWAL', 16, '2017-03-28 08:57:21', 5, 0, NULL),
(15, 'Assignment created for Binata Koruri', 15, '2017-03-28 09:23:49', 6, 0, NULL),
(16, 'Assignment created for PINTU KANTI', 15, '2017-03-28 09:24:52', 7, 0, NULL),
(17, 'Reopened', 15, '2017-03-28 09:25:26', 2, 0, NULL),
(18, 'Assignment created for Binata Koruri', 16, '2017-03-28 09:26:18', 8, 0, NULL),
(19, 'Assignment created for GOPAL  CHAKRABORTY', 15, '2017-03-28 09:26:29', 9, 0, NULL),
(20, 'Assignment created for Mohit Dokania', 15, '2017-03-28 09:27:21', 10, 0, NULL),
(21, 'Assignment created for Binata Koruri', 15, '2017-03-28 09:28:09', 11, 0, NULL),
(22, 'Assignment created for DIPANTI SHAW', 15, '2017-03-28 09:29:16', 12, 0, NULL),
(23, 'We have already got the CRISIL logo.', 16, '2017-03-28 09:29:21', 6, 0, NULL),
(24, 'Assignment created for GOPAL  CHAKRABORTY', 15, '2017-03-28 09:30:18', 13, 0, NULL),
(25, 'Assignment created for RADHE KRISHNA  JULUKA', 15, '2017-03-28 09:30:59', 14, 0, NULL),
(26, 'Update for JKumar Infra: had word with Mr.Prafulla from purchase team,he will contact further for paver block. ', 16, '2017-03-30 09:20:27', 4, 0, NULL),
(27, 'Assignment created for Binata Koruri', 16, '2017-04-07 11:43:56', 15, 0, NULL),
(28, 'Assignment created for Binata Koruri', 16, '2017-04-07 11:45:23', 16, 0, NULL),
(29, 'Assignment created for Binata Koruri', 16, '2017-04-07 11:46:07', 17, 0, NULL),
(30, 'crisil logo', 16, '2017-04-07 11:52:14', 6, 1, '577a60fabb9b8d7405b1513d36db0399.pdf'),
(31, 'duv certification', 16, '2017-04-07 12:01:17', 6, 1, '98430894e918b6f0eadcfeda4aae45a2.jpg'),
(32, 'ISO 9001-2015', 16, '2017-04-07 12:01:59', 6, 1, 'b69417e75b3a7e44a88cd452bd2cb6f2.jpg'),
(33, '', 16, '2017-04-07 12:42:48', 6, 1, 'd5557f9cf7c1c96022dc927844b7861e.JPG'),
(34, '', 16, '2017-04-07 12:43:11', 6, 1, 'ab795069a163f05525cc8ff3794a7c04.jpg'),
(35, 'added to signature ', 16, '2017-04-07 12:43:32', 6, 0, NULL),
(36, 'sheet signed and submitted to NKH', 16, '2017-04-07 12:44:23', 8, 0, NULL),
(37, 'sheet signed and submitted to NKH', 16, '2017-04-07 12:47:03', 16, 0, NULL),
(38, 'Assignment created for Binata Koruri', 16, '2017-04-07 12:48:44', 18, 0, NULL),
(39, 'SUCHANDRA SAHA -FRONT DESK-WILL JOIN ON 10/04/2017', 16, '2017-04-07 12:50:30', 17, 0, NULL),
(40, 'PRATEEK GOEL - As Sr. Accountant; will join by 15/04/2017', 16, '2017-04-07 12:53:48', 17, 0, NULL),
(41, 'Kamal Majumdar- as Sales Executive;will join by 2/05/2017', 16, '2017-04-07 12:54:41', 17, 0, NULL),
(42, 'PF ECR ready;payment due ', 16, '2017-04-07 12:55:37', 18, 0, NULL),
(43, 'ESIC challan ready ,payment due only', 16, '2017-04-07 12:56:05', 18, 0, NULL),
(44, 'Assignment created for VISHAL  SHARMA', 16, '2017-04-07 12:58:06', 19, 0, NULL),
(45, 'Petoria Street CESC done', 16, '2017-04-07 13:01:08', 3, 0, NULL),
(46, 'Reopened', 16, '2017-05-08 11:23:15', 3, 0, NULL),
(47, 'Assignment created for DIPANTI SHAW', 15, '2017-05-08 11:45:31', 20, 0, NULL),
(48, 'I don\'t understand this....', 21, '2017-05-08 11:47:06', 20, 0, NULL),
(49, '...done', 21, '2017-05-08 11:48:20', 20, 1, 'b6e570a0dd06a4303774521eb40474a2.pdf'),
(50, 'Requested Approval.', 21, '2017-05-08 11:48:20', 20, 1, 'b6e570a0dd06a4303774521eb40474a2.pdf'),
(51, '...done', 21, '2017-05-08 11:48:25', 20, 1, 'f5982c1ed47edd14c0166034b586c4d0.pdf'),
(52, 'Requested Approval.', 21, '2017-05-08 11:48:25', 20, 1, 'f5982c1ed47edd14c0166034b586c4d0.pdf'),
(53, '', 15, '2017-05-08 11:48:53', 20, 0, NULL),
(54, 'Assignment created for DIPANTI SHAW', 21, '2017-05-08 11:52:54', 21, 0, NULL),
(55, 'Assignment created for DIPAK SHARMA', 17, '2017-05-08 11:54:01', 22, 0, NULL),
(56, 'UPDATE AND HANDED TO BHAIYA', 17, '2017-05-08 11:55:00', 22, 0, NULL),
(57, 'Requested Approval.', 17, '2017-05-08 11:55:00', 22, 0, NULL),
(58, 'Assignment created for DIPANTI SHAW', 21, '2017-05-09 11:03:22', 23, 0, NULL),
(59, '', 21, '2017-05-09 11:04:06', 21, 0, NULL),
(60, 'Requested Approval.', 21, '2017-05-09 11:04:06', 21, 0, NULL),
(61, 'Materials delivered there alreday however we will not contniue to do supply there further as costing is more than order rate.', 21, '2017-05-09 11:07:44', 12, 0, NULL),
(62, 'Assignment created for SADHANA  JAISWAL', 40, '2017-05-10 06:16:37', 24, 0, NULL),
(63, 'Assignment created for SADHANA  JAISWAL', 40, '2017-05-10 06:20:12', 25, 0, NULL),
(64, 'Assignment created for DIPANTI SHAW', 21, '2017-05-10 06:56:31', 26, 0, NULL),
(65, 'Assignment created for KAILASH AGARWAL', 16, '2017-05-10 07:53:17', 27, 0, NULL),
(66, '', 16, '2017-05-10 07:54:27', 27, 0, NULL),
(67, 'Reopened', 16, '2017-05-10 07:54:46', 27, 0, NULL),
(68, 'Assignment created for Binata Koruri', 15, '2017-05-10 07:56:25', 28, 0, NULL),
(69, 'paid', 16, '2017-05-10 07:58:06', 28, 0, NULL),
(70, 'Assignment created for SADHANA  JAISWAL', 40, '2017-05-10 09:21:54', 29, 0, NULL),
(71, 'Assignment created for SADHANA  JAISWAL', 40, '2017-05-10 09:22:30', 30, 0, NULL),
(72, 'Assignment created for SUMIT KUMAR CHOUBEY', 61, '2017-05-10 11:16:58', 31, 0, NULL),
(73, 'Assignment created for SAROJ KUMAR GUPTA', 58, '2017-05-11 03:47:28', 32, 0, NULL),
(74, '', 58, '2017-05-11 04:01:44', 32, 0, NULL),
(75, 'Requested Approval.', 58, '2017-05-11 04:01:44', 32, 0, NULL),
(76, 'Assignment created for SAROJ KUMAR GUPTA', 58, '2017-05-11 04:24:09', 33, 0, NULL),
(77, '', 58, '2017-05-11 04:24:37', 33, 0, NULL),
(78, 'Requested Approval.', 58, '2017-05-11 04:24:37', 33, 0, NULL),
(79, 'Assignment created for SADHANA  JAISWAL', 40, '2017-05-11 05:51:03', 34, 0, NULL),
(80, '', 40, '2017-05-11 05:51:35', 24, 0, NULL),
(81, 'Requested Approval.', 40, '2017-05-11 05:51:35', 24, 0, NULL),
(82, 'Assignment created for SADHANA  JAISWAL', 40, '2017-05-11 08:14:50', 35, 0, NULL),
(83, 'Assignment created for SADHANA  JAISWAL', 40, '2017-05-11 09:54:34', 36, 0, NULL),
(84, 'done', 40, '2017-05-11 09:54:57', 25, 0, NULL),
(85, 'Requested Approval.', 40, '2017-05-11 09:54:57', 25, 0, NULL),
(86, 'kusum himatsingka sign left', 40, '2017-05-11 09:55:43', 29, 0, NULL),
(87, 'done', 40, '2017-05-11 09:56:17', 34, 0, NULL),
(88, 'Requested Approval.', 40, '2017-05-11 09:56:17', 34, 0, NULL),
(89, 'done', 40, '2017-05-11 09:56:34', 35, 0, NULL),
(90, 'Requested Approval.', 40, '2017-05-11 09:56:34', 35, 0, NULL),
(91, '10 mm and 20 mm done (fly ash and sand purchase left for more bills will come soon)', 40, '2017-05-11 12:25:19', 36, 0, NULL),
(92, '10 mm and 20 mm done (fly ash and sand purchase left for more bills will come soon)', 40, '2017-05-11 12:25:30', 36, 0, NULL),
(93, 'Requested Approval.', 40, '2017-05-11 12:25:30', 36, 0, NULL),
(94, 'Assignment created for SADHANA  JAISWAL', 40, '2017-05-12 05:32:02', 37, 0, NULL),
(95, 'Checked upto Bill no.17', 40, '2017-05-12 07:17:38', 37, 0, NULL),
(96, 'Requested Approval.', 40, '2017-05-12 07:17:38', 37, 0, NULL),
(97, 'Assignment created for SADHANA  JAISWAL', 40, '2017-05-12 07:20:12', 38, 0, NULL),
(98, 'Assignment created for SADHANA  JAISWAL', 40, '2017-05-12 07:21:32', 39, 0, NULL),
(99, 'Assignment created for SADHANA  JAISWAL', 40, '2017-05-12 11:29:09', 40, 0, NULL),
(100, 'DONE', 40, '2017-05-12 11:29:36', 40, 0, NULL),
(101, 'Requested Approval.', 40, '2017-05-12 11:29:36', 40, 0, NULL),
(102, 'DONE', 40, '2017-05-12 11:29:55', 39, 0, NULL),
(103, 'Requested Approval.', 40, '2017-05-12 11:29:55', 39, 0, NULL),
(104, 'Assignment created for SANKET TULSHYAN', 44, '2017-05-16 10:53:52', 41, 0, NULL),
(105, 'salary sheet not yet ready.', 44, '2017-05-16 10:54:18', 41, 0, NULL),
(106, 'complete', 44, '2017-05-16 10:54:34', 41, 0, NULL),
(107, 'Requested Approval.', 44, '2017-05-16 10:54:34', 41, 0, NULL),
(108, 'Assignment created for KAILASH AGARWAL', 15, '2017-05-27 09:47:37', 42, 0, NULL),
(109, 'narration should be there with the entries', 15, '2017-05-27 09:49:10', 42, 0, NULL),
(110, '', 15, '2017-05-27 09:49:33', 42, 0, NULL),
(111, 'Reopened', 15, '2017-05-27 09:49:48', 42, 0, NULL),
(112, 'Assignment created for DIPANTI SHAW', 70, '2017-05-27 11:32:25', 43, 0, NULL),
(113, 'Assignment created for DIPANTI SHAW', 21, '2017-05-27 13:30:41', 44, 0, NULL),
(114, 'Assignment created for DIPANTI SHAW', 21, '2017-05-27 13:56:13', 45, 0, NULL),
(115, 'Assignment created for KABITA  PASWAN', 75, '2017-05-29 05:39:20', 46, 0, NULL),
(116, '', 75, '2017-05-29 05:40:25', 46, 0, NULL),
(117, 'Requested Approval.', 75, '2017-05-29 05:40:25', 46, 0, NULL),
(118, 'Assignment created for KABITA  PASWAN', 75, '2017-05-29 05:45:12', 47, 0, NULL),
(119, '', 75, '2017-05-29 05:45:44', 47, 0, NULL),
(120, 'Requested Approval.', 75, '2017-05-29 05:45:44', 47, 0, NULL),
(121, '', 75, '2017-05-29 05:45:45', 47, 0, NULL),
(122, 'Requested Approval.', 75, '2017-05-29 05:45:45', 47, 0, NULL),
(123, 'Assignment created for KABITA  PASWAN', 75, '2017-05-29 06:13:29', 48, 0, NULL),
(124, 'Assignment created for KABITA  PASWAN', 75, '2017-05-29 07:46:49', 49, 0, NULL),
(125, 'Assignment created for KABITA  PASWAN', 75, '2017-05-29 11:23:07', 50, 0, NULL),
(126, 'Assignment created for KABITA  PASWAN', 75, '2017-05-29 13:34:48', 51, 0, NULL),
(127, '', 15, '2017-05-30 11:15:15', 9, 0, NULL),
(128, '', 15, '2017-05-30 11:16:07', 13, 0, NULL),
(129, 'Assignment created for DIPANTI SHAW', 15, '2017-06-01 08:54:09', 52, 0, NULL),
(130, 'Binata complete this task on an urgent basis', 15, '2017-06-01 08:54:56', 11, 0, NULL),
(131, 'Assignment created for KAILASH AGARWAL', 15, '2017-06-03 11:04:16', 53, 0, NULL),
(132, 'Ask  for PO', 15, '2017-06-03 11:05:00', 53, 0, NULL),
(133, '', 15, '2017-06-03 11:05:42', 52, 0, NULL),
(134, 'Assignment created for DIPANTI SHAW', 21, '2017-06-10 10:56:44', 54, 0, NULL),
(135, 'Assignment created for Mohit Dokania', 15, '2017-06-12 07:06:32', 55, 0, NULL),
(136, 'Assignment created for Mohit Dokania', 15, '2017-06-14 05:50:35', 56, 0, NULL),
(137, 'Assignment created for Mohit Dokania', 15, '2017-06-14 05:51:01', 57, 0, NULL),
(138, 'Assignment created for Mohit Dokania', 15, '2017-06-14 05:51:50', 58, 0, NULL),
(139, 'Assignment created for KAILASH AGARWAL', 15, '2017-06-14 05:52:14', 59, 0, NULL),
(140, 'Assignment created for KAILASH AGARWAL', 15, '2017-06-14 05:52:38', 60, 0, NULL),
(141, 'Assignment created for Mohit Dokania', 15, '2017-06-14 05:53:23', 61, 0, NULL),
(142, 'Assignment created for KAILASH AGARWAL', 79, '2017-06-21 06:11:20', 62, 0, NULL),
(143, '', 79, '2017-06-21 06:12:29', 62, 0, NULL),
(144, 'Assignment created for VISHAL  SHARMA', 84, '2017-06-27 13:30:09', 63, 0, NULL),
(145, 'Assignment created for Mohit Dokania', 15, '2017-07-04 09:52:41', 64, 0, NULL),
(146, 'Assignment created for SADHANA  JAISWAL', 15, '2017-07-04 10:53:07', 65, 0, NULL),
(147, 'Assignment created for Mohit Dokania', 15, '2017-07-17 03:12:23', 66, 0, NULL),
(148, 'Assignment created for Mohit Dokania', 15, '2017-07-17 03:15:24', 67, 0, NULL),
(149, 'Assignment created for Mohit Dokania', 15, '2017-07-17 04:19:14', 68, 0, NULL),
(150, '', 15, '2017-07-17 12:15:10', 66, 0, NULL),
(151, 'Assignment created for Mohit Dokania', 15, '2017-07-18 15:22:10', 69, 0, NULL),
(152, 'Assignment created for Mohit Dokania', 15, '2017-07-18 15:24:52', 70, 0, NULL),
(153, 'Assignment created for Mohit Dokania', 15, '2017-07-18 15:26:47', 71, 0, NULL),
(154, 'Assignment created for Mohit Dokania', 15, '2017-07-18 15:28:51', 72, 0, NULL),
(155, '', 15, '2017-07-21 04:56:13', 68, 0, NULL),
(156, 'email sent to them on 22.07.2017. awaiting there reply. can call there call center no. and take help.', 15, '2017-07-21 19:53:12', 71, 0, NULL),
(157, 'followed up binata on 21.07.2017. She said she is sending someone to BSNL office.', 15, '2017-07-21 19:56:05', 72, 0, NULL),
(158, '21.07.2017 - Talked with Mr.saheb Piri. He is going to introduce me to his colleague in the coming week as he has left the job. Fresh appliation is to be made.', 15, '2017-07-21 19:57:27', 70, 0, NULL),
(159, '19.07.2017 - Handed the machine to Joydeep of Axis Bank. he has told he willl deliver it to the 3rd party and the Lien will be released. 21.07.2017 - Again followed up with him, he says it will be resolved by coming wednesday 26.07.2017', 15, '2017-07-21 19:59:47', 59, 0, NULL),
(160, 'Assignment created for KABITA  PASWAN', 75, '2017-07-22 11:01:00', 73, 0, NULL),
(161, 'Assignment created for KABITA  PASWAN', 75, '2017-07-22 11:01:47', 74, 0, NULL),
(162, 'Assignment created for KABITA  PASWAN', 75, '2017-07-22 11:06:57', 75, 0, NULL),
(163, 'Assignment created for KABITA  PASWAN', 75, '2017-07-22 13:17:42', 76, 0, NULL),
(164, 'admission done', 15, '2017-07-24 13:10:48', 69, 0, NULL),
(165, '', 15, '2017-07-24 13:12:26', 69, 0, NULL),
(166, 'Assignment created for DIPANTI SHAW', 15, '2017-07-24 13:15:05', 77, 0, NULL),
(167, 'Assignment created for AKASH KUMAR MISHRA', 15, '2017-07-24 16:45:47', 78, 0, NULL),
(168, '', 21, '2017-07-26 05:17:14', 12, 0, NULL),
(169, '', 21, '2017-07-26 05:17:37', 12, 0, NULL),
(170, 'Requested Approval.', 21, '2017-07-26 05:17:37', 12, 0, NULL),
(171, '', 21, '2017-07-26 05:17:39', 12, 0, NULL),
(172, 'Requested Approval.', 21, '2017-07-26 05:17:39', 12, 0, NULL),
(173, '', 21, '2017-07-26 05:19:04', 45, 0, NULL),
(174, 'Requested Approval.', 21, '2017-07-26 05:19:04', 45, 0, NULL),
(175, 'Assignment created for Binata Koruri', 16, '2017-07-26 06:33:40', 79, 0, NULL),
(176, 'Assignment created for DIPANTI SHAW', 21, '2017-07-27 13:47:27', 80, 0, NULL),
(177, 'Assignment created for Mohit Dokania', 15, '2017-07-28 08:25:42', 81, 0, NULL),
(178, 'Assignment created for GOVIND CHOWDHURY', 15, '2017-07-28 08:45:06', 82, 0, NULL),
(179, 'Assignment created for GOVIND CHOWDHURY', 15, '2017-07-28 08:45:32', 83, 0, NULL),
(180, 'Assignment created for GOVIND CHOWDHURY', 15, '2017-07-28 08:46:08', 84, 0, NULL),
(181, 'Assignment created for Mohit Dokania', 15, '2017-07-28 08:51:34', 85, 0, NULL),
(182, 'Assignment created for SANKET TULSHYAN', 15, '2017-07-28 08:55:33', 86, 0, NULL),
(183, 'Assignment created for Nitesh Himatsingka', 15, '2017-07-28 08:56:02', 87, 0, NULL),
(184, 'Assignment created for Nitesh Himatsingka', 15, '2017-07-28 08:57:09', 88, 0, NULL),
(185, 'Assignment created for Nitesh Himatsingka', 15, '2017-07-28 08:57:39', 89, 0, NULL),
(186, 'Assignment created for Nitesh Himatsingka', 15, '2017-07-28 08:58:02', 90, 0, NULL),
(187, 'Assignment created for Mohit Dokania', 15, '2017-07-28 09:01:10', 91, 0, NULL),
(188, 'Assignment created for AKASH KUMAR MISHRA', 15, '2017-07-28 09:45:36', 92, 0, NULL),
(189, 'Assignment created for Mohit Dokania', 15, '2017-07-28 09:46:58', 93, 0, NULL),
(190, 'Assignment created for Mohit Dokania', 15, '2017-07-28 09:47:35', 94, 0, NULL),
(191, 'Assignment created for Nitesh Himatsingka', 15, '2017-07-28 10:00:56', 95, 0, NULL),
(192, 'Assignment created for ARUN KUMAR', 15, '2017-07-28 10:01:11', 96, 0, NULL),
(193, 'DONE ', 84, '2017-07-29 11:18:30', 84, 0, NULL),
(194, 'DONE', 84, '2017-07-29 11:21:10', 82, 0, NULL),
(195, 'Assignment created for Mohit Dokania', 15, '2017-07-29 15:29:19', 97, 0, NULL),
(196, 'Mr.Govind will be reaching on 01.08.2017', 15, '2017-07-31 04:52:42', 90, 0, NULL),
(197, 'Assignment created for Binata Koruri', 16, '2017-07-31 07:29:00', 98, 0, NULL),
(198, 'Assignment created for Binata Koruri', 16, '2017-07-31 07:29:56', 99, 0, NULL),
(199, '', 16, '2017-07-31 07:30:22', 19, 0, NULL),
(200, 'had word with him regarding choosing the topic.He will inform.Any Saturday or Sunday', 16, '2017-07-31 07:31:31', 99, 0, NULL),
(201, 'Assignment created for Binata Koruri', 16, '2017-07-31 07:34:22', 100, 0, NULL),
(202, 'Assignment created for Binata Koruri', 16, '2017-07-31 07:37:45', 101, 0, NULL),
(203, '', 16, '2017-07-31 07:38:13', 18, 0, NULL),
(204, '', 16, '2017-07-31 07:38:44', 17, 0, NULL),
(205, '', 16, '2017-07-31 07:38:51', 17, 0, NULL),
(206, 'Assignment created for Binata Koruri', 16, '2017-07-31 07:40:07', 102, 0, NULL),
(207, 'offer letter sent .Joining on 1st August', 16, '2017-07-31 07:58:28', 102, 0, NULL),
(208, 'adhunk to acc chaibasa quotation given 490', 15, '2017-07-31 14:59:03', 81, 0, NULL),
(209, 'adhunk to acc chaibasa quotation given 490', 15, '2017-07-31 14:59:11', 81, 0, NULL),
(210, 'adhunk to acc chaibasa quotation given 490', 15, '2017-07-31 14:59:38', 81, 0, NULL),
(211, 'adhunk to acc chaibasa quotation given 490', 15, '2017-07-31 14:59:41', 81, 0, NULL),
(212, 'Assignment created for SUCHANDRA  SAHA', 74, '2017-08-01 04:35:28', 103, 0, NULL),
(213, 'documentation done', 16, '2017-08-01 05:10:33', 102, 0, NULL),
(214, 'joined', 16, '2017-08-01 05:10:59', 102, 0, NULL),
(215, '', 16, '2017-08-01 05:12:35', 98, 0, NULL),
(216, 'Assignment created for Binata Koruri', 16, '2017-08-01 05:14:49', 104, 0, NULL),
(217, 'DOCUMENTATION COMPLETE AND JOINED', 16, '2017-08-01 05:15:51', 104, 0, NULL),
(218, 'COMPLETE AND ALL PAID', 16, '2017-08-01 05:17:02', 100, 0, NULL),
(219, 'Assignment created for Binata Koruri', 16, '2017-08-01 05:19:22', 105, 0, NULL),
(220, 'Assignment created for Binata Koruri', 16, '2017-08-01 05:20:36', 106, 0, NULL),
(221, 'next date 03.08.2017', 15, '2017-08-01 08:38:47', 14, 0, NULL),
(222, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:32:25', 107, 0, NULL),
(223, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:46:25', 108, 0, NULL),
(224, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:47:11', 109, 0, NULL),
(225, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:47:50', 110, 0, NULL),
(226, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:48:44', 111, 0, NULL),
(227, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:49:19', 112, 0, NULL),
(228, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:49:57', 113, 0, NULL),
(229, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:50:42', 114, 0, NULL),
(230, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:51:17', 115, 0, NULL),
(231, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:51:49', 116, 0, NULL),
(232, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:52:15', 117, 0, NULL),
(233, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:52:49', 118, 0, NULL),
(234, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:53:22', 119, 0, NULL),
(235, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:54:00', 120, 0, NULL),
(236, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:54:31', 121, 0, NULL),
(237, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:56:52', 122, 0, NULL),
(238, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:58:04', 123, 0, NULL),
(239, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 10:59:32', 124, 0, NULL),
(240, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 11:02:11', 125, 0, NULL),
(241, 'Assignment created for SANKET TULSHYAN', 44, '2017-08-01 11:02:37', 126, 0, NULL),
(242, 'Sending Arun. Arun & Chandan will Do the data collection', 44, '2017-08-01 11:03:58', 125, 0, NULL),
(243, 'Meeting scheduled for 04/07/2017', 44, '2017-08-01 11:35:38', 117, 0, NULL),
(244, 'Assignment created for KABITA  PASWAN', 75, '2017-08-01 12:39:55', 127, 0, NULL),
(245, 'Assignment created for KABITA  PASWAN', 75, '2017-08-01 12:41:06', 128, 0, NULL),
(246, 'Assignment created for Mohit Dokania', 15, '2017-08-02 05:00:26', 129, 0, NULL),
(247, 'Dona, Suchandra, Sadhna, Vishal, Admin Lady', 15, '2017-08-02 09:14:15', 129, 0, NULL),
(248, 'Ashish', 15, '2017-08-02 09:14:34', 129, 0, NULL),
(249, 'Sonu', 15, '2017-08-02 09:14:45', 129, 0, NULL),
(250, 'under process....', 15, '2017-08-02 09:19:29', 96, 0, NULL),
(251, 'Arun and Chandan responsibility for HEL CESC output data and destination details', 15, '2017-08-02 09:52:37', 88, 0, NULL),
(252, 'Assignment created for Nitesh Himatsingka', 15, '2017-08-02 10:08:25', 130, 0, NULL),
(253, 'Assignment created for Binata Koruri', 16, '2017-08-02 10:45:01', 131, 0, NULL),
(254, 'Assignment created for Binata Koruri', 16, '2017-08-02 10:46:50', 132, 0, NULL),
(255, 'offer letter sent .Joining on 5th August', 16, '2017-08-02 10:47:23', 132, 0, NULL),
(256, 'Assignment created for Binata Koruri', 16, '2017-08-02 10:48:41', 133, 0, NULL),
(257, 'PEAK PERFORMANCE', 16, '2017-08-02 10:49:37', 99, 0, NULL),
(258, 'Assignment created for Binata Koruri', 16, '2017-08-02 10:53:23', 134, 0, NULL),
(259, 'SUBMITTED TO NKH', 16, '2017-08-02 10:57:43', 105, 0, NULL),
(260, '4 BLANK CHALLAN RECV 4000-4200', 16, '2017-08-02 11:04:30', 79, 0, NULL),
(261, '4 BLANK CHALLAN RECV 4000-4200', 16, '2017-08-02 11:04:32', 79, 0, NULL),
(262, 'PRINTED ENVELOP RECV 100pc', 16, '2017-08-02 11:11:13', 79, 0, NULL),
(263, 'Assignment created for KABITA  PASWAN', 75, '2017-08-02 12:50:51', 135, 0, NULL),
(264, 'Assignment created for KABITA  PASWAN', 75, '2017-08-02 12:51:35', 136, 0, NULL),
(265, 'Assignment created for KABITA  PASWAN', 75, '2017-08-02 12:52:27', 137, 0, NULL),
(266, 'SENT TO BUJBUJ', 16, '2017-08-03 08:19:00', 134, 0, NULL),
(267, 'SANKET', 16, '2017-08-03 08:19:50', 101, 0, NULL),
(268, 'SANKET,SONU,MAMAJI,AASHISH REVIEW COMPLETE', 16, '2017-08-03 08:21:03', 101, 0, NULL),
(269, 'SANKET,SONU,MAMAJI,AASHISH REVIEW COMPLETE', 16, '2017-08-03 08:21:06', 101, 0, NULL),
(270, 'Assignment created for KABITA  PASWAN', 75, '2017-08-03 12:02:07', 138, 0, NULL),
(271, 'Assignment created for KABITA  PASWAN', 75, '2017-08-03 12:05:49', 139, 0, NULL),
(272, 'Assignment created for KABITA  PASWAN', 75, '2017-08-03 12:10:13', 140, 0, NULL),
(273, 'Assignment created for KABITA  PASWAN', 75, '2017-08-04 06:22:45', 141, 0, NULL),
(274, 'Assignment created for KABITA  PASWAN', 75, '2017-08-04 13:09:13', 142, 0, NULL),
(275, 'Assignment created for KABITA  PASWAN', 75, '2017-08-04 13:11:20', 143, 0, NULL),
(276, 'Assignment created for KABITA  PASWAN', 75, '2017-08-05 12:31:29', 144, 0, NULL),
(277, 'Assignment created for KABITA  PASWAN', 75, '2017-08-05 12:33:18', 145, 0, NULL),
(278, 'Assignment created for KABITA  PASWAN', 75, '2017-08-05 12:34:49', 146, 0, NULL),
(279, 'Assignment created for KABITA  PASWAN', 75, '2017-08-05 12:36:47', 147, 0, NULL),
(280, 'Assignment created for KABITA  PASWAN', 75, '2017-08-07 10:22:18', 148, 0, NULL),
(281, 'left ', 16, '2017-08-09 04:37:45', 134, 0, NULL),
(282, 'left ', 16, '2017-08-09 04:38:43', 132, 0, NULL),
(283, 'Assignment created for KABITA  PASWAN', 75, '2017-08-10 13:13:43', 149, 0, NULL),
(284, 'Assignment created for KABITA  PASWAN', 75, '2017-08-10 13:15:10', 150, 0, NULL),
(285, 'Assignment created for KABITA  PASWAN', 75, '2017-08-10 13:17:26', 151, 0, NULL),
(286, 'Assignment created for KABITA  PASWAN', 75, '2017-08-12 12:35:45', 152, 0, NULL),
(287, 'Assignment created for KABITA  PASWAN', 75, '2017-08-12 12:37:18', 153, 0, NULL),
(288, 'Assignment created for KABITA  PASWAN', 75, '2017-08-14 13:39:19', 154, 0, NULL),
(289, 'Assignment created for KABITA  PASWAN', 75, '2017-08-18 13:26:57', 155, 0, NULL),
(290, 'Assignment created for KABITA  PASWAN', 75, '2017-08-18 13:28:17', 156, 0, NULL),
(291, 'Assignment created for KABITA  PASWAN', 75, '2017-08-18 13:30:24', 157, 0, NULL),
(292, '', 15, '2017-09-08 16:54:46', 95, 0, NULL);

--
-- Triggers `worklog_audit`
--
DELIMITER $$
CREATE TRIGGER `worklog_audit_AFTER_INSERT` AFTER INSERT ON `worklog_audit` FOR EACH ROW BEGIN
	DECLARE eid INT(11);
    DECLARE iid INT(11);
    SELECT employee_id into eid from worklog where id=NEW.work_id;
    SELECT issuer_id into iid from worklog where id=NEW.work_id;
	INSERT INTO notifications (message, module, url, target_id) values ('Assignment Status Updated', 'MyAssignments', concat('workassignments/update_status/',NEW.work_id), eid);
    INSERT INTO notifications (message, module, url, target_id) values ('Assignment Status Updated', 'MyAssignments', concat('workassignments/update_status/',NEW.work_id), iid);
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_employee_ref_idx` (`employeeid`);

--
-- Indexes for table `cdattributetp`
--
ALTER TABLE `cdattributetp`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `attribute_tp_cd` (`attribute_tp_cd`);

--
-- Indexes for table `challans`
--
ALTER TABLE `challans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD UNIQUE KEY `employeeid_UNIQUE` (`employeeid`),
  ADD KEY `reports to_idx` (`supervisor_id`),
  ADD KEY `fkProjectId_idx` (`project_id`);

--
-- Indexes for table `employee_adv_rating`
--
ALTER TABLE `employee_adv_rating`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employee_rating`
--
ALTER TABLE `employee_rating`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employee_task_rating`
--
ALTER TABLE `employee_task_rating`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `field_assignments`
--
ALTER TABLE `field_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`);

--
-- Indexes for table `field_assignment_updates`
--
ALTER TABLE `field_assignment_updates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_fieldAssignment` (`assignment_id`);

--
-- Indexes for table `hierarchy`
--
ALTER TABLE `hierarchy`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`);

--
-- Indexes for table `leaves`
--
ALTER TABLE `leaves`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_applicant_id_idx` (`employee_id`),
  ADD KEY `fk_approver_id_idx` (`approved_by`),
  ADD KEY `fk_verifier_idx` (`verified_by`),
  ADD KEY `fk_pending_to_idx` (`pending_to`);

--
-- Indexes for table `leaves_approval`
--
ALTER TABLE `leaves_approval`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_leave_id_idx` (`leave_id`),
  ADD KEY `fk_employee_id_idx` (`employee_id`),
  ADD KEY `fk_supervisor_idx` (`supervisor_id`);

--
-- Indexes for table `leaves_taken`
--
ALTER TABLE `leaves_taken`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_applicant_idx` (`employee_id`),
  ADD KEY `fk_approver_idx` (`approved_by`);

--
-- Indexes for table `leave_audit`
--
ALTER TABLE `leave_audit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leave_balance`
--
ALTER TABLE `leave_balance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_employee_idx` (`employee_id`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_employee_target_idx` (`target_id`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_proj_owner_idx` (`project_owner`);

--
-- Indexes for table `project_allocation_status_cd`
--
ALTER TABLE `project_allocation_status_cd`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `project_roles`
--
ALTER TABLE `project_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`);

--
-- Indexes for table `project_seq`
--
ALTER TABLE `project_seq`
  ADD PRIMARY KEY (`count`);

--
-- Indexes for table `project_worklog`
--
ALTER TABLE `project_worklog`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_project_idx` (`project_id`),
  ADD KEY `fk_owner_idx` (`createdBy`);

--
-- Indexes for table `project_worklog_updates`
--
ALTER TABLE `project_worklog_updates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`);

--
-- Indexes for table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_resourceId_idx` (`resource_id`),
  ADD KEY `fk_projectId_idx` (`project_id`),
  ADD KEY `fk_allocationStat_idx` (`status`);

--
-- Indexes for table `supply_challan`
--
ALTER TABLE `supply_challan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ticket_seq`
--
ALTER TABLE `ticket_seq`
  ADD PRIMARY KEY (`count`);

--
-- Indexes for table `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vehicle_attr`
--
ALTER TABLE `vehicle_attr`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `worklog`
--
ALTER TABLE `worklog`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_issuer_id_idx` (`issuer_id`),
  ADD KEY `fk_employee_id_idx` (`employee_id`);

--
-- Indexes for table `worklog_audit`
--
ALTER TABLE `worklog_audit`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`),
  ADD KEY `fk_comment_owner_idx` (`op_id`),
  ADD KEY `fk_worklog_id_idx` (`work_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `cdattributetp`
--
ALTER TABLE `cdattributetp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;
--
-- AUTO_INCREMENT for table `challans`
--
ALTER TABLE `challans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;
--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95;
--
-- AUTO_INCREMENT for table `employee_adv_rating`
--
ALTER TABLE `employee_adv_rating`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `employee_rating`
--
ALTER TABLE `employee_rating`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `field_assignments`
--
ALTER TABLE `field_assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `field_assignment_updates`
--
ALTER TABLE `field_assignment_updates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=221;
--
-- AUTO_INCREMENT for table `hierarchy`
--
ALTER TABLE `hierarchy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `leaves`
--
ALTER TABLE `leaves`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
--
-- AUTO_INCREMENT for table `leaves_approval`
--
ALTER TABLE `leaves_approval`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
--
-- AUTO_INCREMENT for table `leaves_taken`
--
ALTER TABLE `leaves_taken`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `leave_audit`
--
ALTER TABLE `leave_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `leave_balance`
--
ALTER TABLE `leave_balance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
--
-- AUTO_INCREMENT for table `modules`
--
ALTER TABLE `modules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1164;
--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `project_allocation_status_cd`
--
ALTER TABLE `project_allocation_status_cd`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `project_roles`
--
ALTER TABLE `project_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `project_seq`
--
ALTER TABLE `project_seq`
  MODIFY `count` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `project_worklog`
--
ALTER TABLE `project_worklog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `project_worklog_updates`
--
ALTER TABLE `project_worklog_updates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `resources`
--
ALTER TABLE `resources`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `supply_challan`
--
ALTER TABLE `supply_challan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `ticket_seq`
--
ALTER TABLE `ticket_seq`
  MODIFY `count` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
--
-- AUTO_INCREMENT for table `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
--
-- AUTO_INCREMENT for table `vehicle_attr`
--
ALTER TABLE `vehicle_attr`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=668;
--
-- AUTO_INCREMENT for table `worklog`
--
ALTER TABLE `worklog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=158;
--
-- AUTO_INCREMENT for table `worklog_audit`
--
ALTER TABLE `worklog_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=293;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `fkProjectId` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_reports_to` FOREIGN KEY (`supervisor_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Constraints for table `leaves`
--
ALTER TABLE `leaves`
  ADD CONSTRAINT `fk_applicant_id` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_approver_id` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_pending_to` FOREIGN KEY (`pending_to`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_verifier` FOREIGN KEY (`verified_by`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `leaves_approval`
--
ALTER TABLE `leaves_approval`
  ADD CONSTRAINT `fk_employee_id_reference` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_leave_id` FOREIGN KEY (`leave_id`) REFERENCES `leaves` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_supervisor` FOREIGN KEY (`supervisor_id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `leaves_taken`
--
ALTER TABLE `leaves_taken`
  ADD CONSTRAINT `fk_applicant` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_approver` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `leave_balance`
--
ALTER TABLE `leave_balance`
  ADD CONSTRAINT `fk_employee_balance` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_employee_target` FOREIGN KEY (`target_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
  ADD CONSTRAINT `fk_proj_owner` FOREIGN KEY (`project_owner`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `project_worklog`
--
ALTER TABLE `project_worklog`
  ADD CONSTRAINT `fk_owner` FOREIGN KEY (`createdBy`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_project` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `resources`
--
ALTER TABLE `resources`
  ADD CONSTRAINT `fk_allocationStat` FOREIGN KEY (`status`) REFERENCES `project_allocation_status_cd` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_projectId` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_resourceId` FOREIGN KEY (`resource_id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `worklog`
--
ALTER TABLE `worklog`
  ADD CONSTRAINT `fk_employee_id` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_issuer_id` FOREIGN KEY (`issuer_id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `worklog_audit`
--
ALTER TABLE `worklog_audit`
  ADD CONSTRAINT `fk_comment_owner` FOREIGN KEY (`op_id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_worklog_id` FOREIGN KEY (`work_id`) REFERENCES `worklog` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
