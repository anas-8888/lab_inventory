-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 27, 2025 at 02:39 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lab_inventory`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` int(11) NOT NULL,
  `action_name` varchar(255) NOT NULL COMMENT 'اسم الحركة بالعربية',
  `actor_id` int(11) DEFAULT NULL COMMENT 'رقم المستخدم المنفذ',
  `actor_name_snapshot` varchar(100) DEFAULT NULL COMMENT 'اسم المستخدم وقت التنفيذ',
  `method` varchar(10) NOT NULL COMMENT 'نوع الطلب',
  `path` varchar(500) NOT NULL COMMENT 'مسار الطلب',
  `status_code` int(11) DEFAULT NULL COMMENT 'كود الاستجابة',
  `ip_address` varchar(45) DEFAULT NULL COMMENT 'عنوان IP',
  `user_agent` text DEFAULT NULL COMMENT 'معلومات المتصفح',
  `created_at` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'وقت التنفيذ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='سجل حركات النظام';

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `action_name`, `actor_id`, `actor_name_snapshot`, `method`, `path`, `status_code`, `ip_address`, `user_agent`, `created_at`) VALUES
(327, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:44:52'),
(328, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:45:09'),
(329, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:45:25'),
(330, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:46:23'),
(331, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:46:24'),
(332, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:47:24'),
(333, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:48:33'),
(334, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:48:52'),
(335, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:48:55'),
(336, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:48:55'),
(337, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:50:52'),
(338, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:50:52'),
(339, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:52:23'),
(340, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:52:23'),
(341, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:55:12'),
(342, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:55:12'),
(343, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:55:42'),
(344, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:55:49'),
(345, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:56:50'),
(346, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:57:32'),
(347, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/11/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:57:48'),
(348, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:58:29'),
(349, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 15:59:42'),
(350, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:00:39'),
(351, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:00:53'),
(352, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:00:53'),
(353, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/11/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:37:56'),
(354, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:38:50'),
(355, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:38:50'),
(356, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:38:53'),
(357, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:38:57'),
(358, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:38:57'),
(359, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:38:58'),
(360, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:38:59'),
(361, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:42:06'),
(362, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:42:17'),
(363, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:42:21'),
(364, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:42:21'),
(365, 'استعراض costs cost-statement id', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:42:26'),
(366, 'إضافة/تحديث costs orders', 20, 'ADMIN2', 'POST', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:42:49'),
(367, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:42:51'),
(368, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/12/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:42:54'),
(369, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:43:10'),
(370, 'عرض تفاصيل طلبية', 20, 'ADMIN2', 'GET', '/costs/orders/12', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:43:12'),
(371, 'تحديث costs orders id', 20, 'ADMIN2', 'PUT', '/costs/orders/12', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:43:17'),
(372, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:43:18'),
(373, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/12/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:43:19'),
(374, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:44:06'),
(375, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/12/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:44:07'),
(376, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:44:08'),
(377, 'عرض تفاصيل طلبية', 20, 'ADMIN2', 'GET', '/costs/orders/12', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:44:09'),
(378, 'تحديث costs orders id', 20, 'ADMIN2', 'PUT', '/costs/orders/12', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:44:25'),
(379, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:44:26'),
(380, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/12/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:44:27'),
(381, 'طباعة طلبية', 20, 'ADMIN2', 'GET', '/costs/orders/12/print', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:44:36'),
(382, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/12/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:44:52'),
(383, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/12/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:44:53'),
(384, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/12/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:44:56'),
(385, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/12/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:45:02'),
(386, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/12/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:46:36'),
(387, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:46:53'),
(388, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:48:38'),
(389, 'عرض تفاصيل طلبية', 20, 'ADMIN2', 'GET', '/costs/orders/12', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:48:53'),
(390, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:49:02'),
(391, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:49:17'),
(392, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:49:40'),
(393, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:50:09'),
(394, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:50:11'),
(395, 'استعراض costs cost-statement id', 20, 'ADMIN2', 'GET', '/costs/cost-statement/47', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:50:19'),
(396, 'استعراض costs cost-statement id', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:50:26'),
(397, 'إضافة/تحديث costs orders', 20, 'ADMIN2', 'POST', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:50:35'),
(398, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:50:36'),
(399, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:50:38'),
(400, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:50:42'),
(401, 'عرض تفاصيل طلبية', 20, 'ADMIN2', 'GET', '/costs/orders/13', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:50:58'),
(402, 'تحديث costs orders id', 20, 'ADMIN2', 'PUT', '/costs/orders/13', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:51:04'),
(403, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:51:05'),
(404, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:51:08'),
(405, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.0.0', '2025-09-27 16:51:10'),
(406, 'عرض صفحة تسجيل الدخول', NULL, 'النظام', 'GET', '/auth/login', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 14:58:46'),
(407, 'تسجيل الدخول', NULL, 'النظام', 'POST', '/auth/login', 302, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 14:58:53'),
(408, 'استعراض home', 20, 'ADMIN2', 'GET', '/home', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 14:58:53'),
(409, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 14:59:03'),
(410, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 14:59:23'),
(411, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:05:24'),
(412, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:05:26'),
(413, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:05:28'),
(414, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:05:33'),
(415, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:05:33'),
(416, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:07:08'),
(417, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:07:11'),
(418, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:11:29'),
(419, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:12:06'),
(420, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:12:09'),
(421, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:12:11'),
(422, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:12:41'),
(423, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:12:41'),
(424, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:12:42'),
(425, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:12:42'),
(426, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:12:43'),
(427, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:12:43'),
(428, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:12:52'),
(429, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:12:52'),
(430, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:06'),
(431, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:07'),
(432, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:07'),
(433, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:07'),
(434, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:27'),
(435, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:28'),
(436, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:30'),
(437, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:30'),
(438, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:31'),
(439, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:31'),
(440, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:32'),
(441, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:13:32'),
(442, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:14:01'),
(443, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/53/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:14:01'),
(444, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:17:08'),
(445, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:17:10'),
(446, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:17:54'),
(447, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:17:55'),
(448, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:22:02'),
(449, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:24:35'),
(450, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/10/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:24:44'),
(451, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/12/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:24:47'),
(452, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/6/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:24:50'),
(453, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/41/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:26:28'),
(454, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/41/logs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:26:30'),
(455, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:26:43'),
(456, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/6/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:26:45'),
(457, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/13/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:26:49'),
(458, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:30:47'),
(459, 'استعراض costs cost-statement id', 20, 'ADMIN2', 'GET', '/costs/cost-statement/44', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:30:55'),
(460, 'استعراض costs cost-statement id', 20, 'ADMIN2', 'GET', '/costs/cost-statement/24', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:31:05'),
(461, 'إضافة/تحديث costs orders', 20, 'ADMIN2', 'POST', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:31:06'),
(462, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:31:08'),
(463, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:31:12'),
(464, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/44/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:31:21'),
(465, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/44/logs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:31:21'),
(466, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/24/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:31:44'),
(467, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/24/logs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:31:44'),
(468, 'زيارة الصفحة الرئيسية', 20, 'ADMIN2', 'GET', '/', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:40:35'),
(469, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:40:37'),
(470, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:40:39'),
(471, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:40:41'),
(472, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:40:46'),
(473, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:40:48'),
(474, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/44/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:40:52'),
(475, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/44/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:40:52'),
(476, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:41:21'),
(477, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:41:23'),
(478, 'عرض تفاصيل عرض سعر', 20, 'ADMIN2', 'GET', '/costs/quotations/61', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:41:24'),
(479, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:41:37'),
(480, 'عرض تفاصيل عرض سعر', 20, 'ADMIN2', 'GET', '/costs/quotations/60', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:41:38'),
(481, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:41:40'),
(482, 'عرض تفاصيل عرض سعر', 20, 'ADMIN2', 'GET', '/costs/quotations/59', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:41:42'),
(483, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:41:48'),
(484, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:41:49'),
(485, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:41:58'),
(486, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:41:59'),
(487, 'عرض تفاصيل عرض سعر', 20, 'ADMIN2', 'GET', '/costs/quotations/58', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:42:02'),
(488, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:42:23'),
(489, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:42:24'),
(490, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:42:25'),
(491, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:42:30'),
(492, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/logs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:42:30'),
(493, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:43:58'),
(494, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:43:59'),
(495, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:44:12'),
(496, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:44:12'),
(497, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:44:14'),
(498, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:44:14'),
(499, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:44:23'),
(500, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:44:23'),
(501, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:44:28'),
(502, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/55/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:44:28'),
(503, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:45:26'),
(504, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:45:27'),
(505, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:45:28'),
(506, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:47:48'),
(507, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/24/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:47:52'),
(508, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/24/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:47:52'),
(509, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/24/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:48:11'),
(510, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/24/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:48:11'),
(511, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:48:14'),
(512, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:48:40'),
(513, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:48:59'),
(514, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:49:09'),
(515, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:50:33'),
(516, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:50:34'),
(517, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:50:43'),
(518, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:50:47'),
(519, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:50:51'),
(520, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:50:57'),
(521, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:51:10');
INSERT INTO `activity_logs` (`id`, `action_name`, `actor_id`, `actor_name_snapshot`, `method`, `path`, `status_code`, `ip_address`, `user_agent`, `created_at`) VALUES
(522, 'طباعة طلبية', 20, 'ADMIN2', 'GET', '/costs/orders/14/print', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:51:17'),
(523, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 500, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:53:20'),
(524, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 500, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:53:22'),
(525, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:53:40'),
(526, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:54:01'),
(527, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:54:10'),
(528, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/14/details', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:54:10'),
(529, 'طباعة طلبية', 20, 'ADMIN2', 'GET', '/costs/orders/14/print', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:54:15'),
(530, 'طباعة طلبية', 20, 'ADMIN2', 'GET', '/costs/orders/14/print', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:54:47'),
(531, 'استعراض costs orders id print-pdf-raw', NULL, 'النظام', 'GET', '/costs/orders/14/print-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-21 15:55:13'),
(532, 'استعراض costs orders id pdf', 20, 'ADMIN2', 'GET', '/costs/orders/14/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-21 15:55:23'),
(533, 'عرض صفحة تسجيل الدخول', NULL, 'النظام', 'GET', '/auth/login', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:05:59'),
(534, 'تسجيل الدخول', NULL, 'النظام', 'POST', '/auth/login', 302, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:06:01'),
(535, 'استعراض home', 20, 'ADMIN2', 'GET', '/home', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:06:01'),
(536, 'استعراض الفواتير', 20, 'ADMIN2', 'GET', '/invoices', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:06:32'),
(537, 'استعراض الشهادات', 20, 'ADMIN2', 'GET', '/certificates', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:06:35'),
(538, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:06:39'),
(539, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:06:40'),
(540, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:09:05'),
(541, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:14:23'),
(542, 'استعراض الشهادات', 20, 'ADMIN2', 'GET', '/certificates', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:29:23'),
(543, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:32:55'),
(544, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:32:56'),
(545, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:35:50'),
(546, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:36:39'),
(547, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:36:55'),
(548, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:37:18'),
(549, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:38:10'),
(550, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:38:34'),
(551, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:42:13'),
(552, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:42:57'),
(553, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:45:45'),
(554, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:46:17'),
(555, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:54:27'),
(556, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:54:46'),
(557, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:56:15'),
(558, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:56:16'),
(559, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:57:10'),
(560, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:57:11'),
(561, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:59:28'),
(562, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 16:59:30'),
(563, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:01:08'),
(564, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:01:10'),
(565, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:02:16'),
(566, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:02:17'),
(567, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:02:28'),
(568, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:02:28'),
(569, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:06:34'),
(570, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:06:34'),
(571, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:07:13'),
(572, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:09:20'),
(573, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:11:56'),
(574, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:12:40'),
(575, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:14:36'),
(576, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:24:47'),
(577, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:24:59'),
(578, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:29:38'),
(579, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:29:42'),
(580, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:29:44'),
(581, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:29:45'),
(582, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:29:52'),
(583, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:29:53'),
(584, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:29:58'),
(585, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:30:19'),
(586, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:30:50'),
(587, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:31:20'),
(588, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:31:24'),
(589, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:31:37'),
(590, 'استعراض الشهادات', 20, 'ADMIN2', 'GET', '/certificates', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:31:39'),
(591, 'عرض تفاصيل شهادة', 20, 'ADMIN2', 'GET', '/certificates/create-type', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:31:40'),
(592, 'استعراض certificates create internal', 20, 'ADMIN2', 'GET', '/certificates/create/internal', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:31:41'),
(593, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:34:22'),
(594, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:34:23'),
(595, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:34:42'),
(596, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:34:43'),
(597, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 17:50:14'),
(598, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:02:59'),
(599, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:08:08'),
(600, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:11:07'),
(601, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:12:56'),
(602, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:20:19'),
(603, 'إضافة/تحديث costs quotations', 20, 'ADMIN2', 'POST', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:21:45'),
(604, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:21:47'),
(605, 'عرض تفاصيل عرض سعر', 20, 'ADMIN2', 'GET', '/costs/quotations/62', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:21:49'),
(606, 'عرض تفاصيل عرض سعر', 20, 'ADMIN2', 'GET', '/costs/quotations/62', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:22:02'),
(607, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:22:04'),
(608, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:22:13'),
(609, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:22:14'),
(610, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:22:44'),
(611, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:22:45'),
(612, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:27:36'),
(613, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:27:38'),
(614, 'إضافة/تحديث costs orders', 20, 'ADMIN2', 'POST', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:28:35'),
(615, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:28:37'),
(616, 'استعراض costs orders id details', 20, 'ADMIN2', 'GET', '/costs/orders/15/details', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:28:39'),
(617, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:29:44'),
(618, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:29:45'),
(619, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:29:52'),
(620, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:29:52'),
(621, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:32:47'),
(622, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:32:52'),
(623, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:32:52'),
(624, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:33:24'),
(625, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:33:24'),
(626, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:33:34'),
(627, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:33:34'),
(628, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:34:40'),
(629, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:34:41'),
(630, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:36:27'),
(631, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:36:27'),
(632, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:36:48'),
(633, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:36:49'),
(634, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:36:49'),
(635, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:37:10'),
(636, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:37:13'),
(637, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:37:13'),
(638, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:37:13'),
(639, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:38:33'),
(640, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:38:35'),
(641, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:38:35'),
(642, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/59/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:38:50'),
(643, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:38:50'),
(644, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/59/logs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:38:50'),
(645, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:38:52'),
(646, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:41:21'),
(647, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:41:21'),
(648, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:41:22'),
(649, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:42:16'),
(650, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:42:35'),
(651, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:42:35'),
(652, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:44:07'),
(653, 'استعراض .well-known appspecific com.chrome.devtools.json', 20, 'ADMIN2', 'GET', '/.well-known/appspecific/com.chrome.devtools.json', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:44:07'),
(654, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:45:29'),
(655, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:45:39'),
(656, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:46:33'),
(657, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:49:06'),
(658, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:49:07'),
(659, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:49:53'),
(660, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:49:53'),
(661, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:54:15'),
(662, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:54:16'),
(663, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:54:52'),
(664, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:54:53'),
(665, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:55:36'),
(666, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:55:39'),
(667, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:56:19'),
(668, 'استعراض عروض الأسعار', 20, 'ADMIN2', 'GET', '/costs/quotations', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:56:20'),
(669, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:57:15'),
(670, 'استعراض الطلبيات', 20, 'ADMIN2', 'GET', '/costs/orders', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:57:19'),
(671, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:57:29'),
(672, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:57:30'),
(673, 'استعراض costs cost-statement id print-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/63/print-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 18:57:39'),
(674, 'استعراض costs cost-statement id pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:57:44'),
(675, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 18:58:55'),
(676, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:00:44'),
(677, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:02:02'),
(678, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:02:18'),
(679, 'عرض صفحة تسجيل الدخول', NULL, 'النظام', 'GET', '/auth/login', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:02:23'),
(680, 'عرض صفحة تسجيل الدخول', NULL, 'النظام', 'GET', '/auth/login', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:02:28'),
(681, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:02:33'),
(682, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:04:16'),
(683, 'عرض صفحة تسجيل الدخول', NULL, 'النظام', 'GET', '/auth/login', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:04:21'),
(684, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:04:26'),
(685, 'استعراض المخزون', 20, 'ADMIN2', 'GET', '/inventory', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:05:22'),
(686, 'استعراض المخزون', 20, 'ADMIN2', 'GET', '/inventory', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:05:37'),
(687, 'عرض تفاصيل عينة', NULL, 'النظام', 'GET', '/inventory/print-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:05:40'),
(688, 'استعراض inventory export pdf', 20, 'ADMIN2', 'GET', '/inventory/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:05:42'),
(689, 'استعراض المخزون', 20, 'ADMIN2', 'GET', '/inventory', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:05:48'),
(690, 'استعراض المخزون', 20, 'ADMIN2', 'GET', '/inventory', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:06:13'),
(691, 'استعراض المخزون', 20, 'ADMIN2', 'GET', '/inventory', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:06:23'),
(692, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:06:26'),
(693, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:06:27'),
(694, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:06:32'),
(695, 'استعراض costs cost-statement export print-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/export/print-pdf-raw', 302, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:06:34'),
(696, 'عرض صفحة تسجيل الدخول', NULL, 'النظام', 'GET', '/auth/login', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:06:34'),
(697, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:06:42'),
(698, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:06:58'),
(699, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:06:58'),
(700, 'استعراض costs cost-statement id print-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/63/print-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:07:00'),
(701, 'استعراض costs cost-statement id pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:07:05'),
(702, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:07:47'),
(703, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:07:48'),
(704, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:07:54'),
(705, 'استعراض costs cost-statement id print-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/63/print-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:07:56'),
(706, 'استعراض costs cost-statement id pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:08:02'),
(707, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:08:49'),
(708, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:08:50'),
(709, 'استعراض costs cost-statement id print-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/63/print-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:08:52'),
(710, 'استعراض costs cost-statement id pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:08:56'),
(711, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:09:11'),
(712, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:11:40'),
(713, 'استعراض المخزون', 20, 'ADMIN2', 'GET', '/inventory', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:12:13'),
(714, 'استعراض exports inventory excel', 20, 'ADMIN2', 'GET', '/exports/inventory/excel', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:12:16'),
(715, 'استعراض exports inventory excel', 20, 'ADMIN2', 'GET', '/exports/inventory/excel', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:12:16'),
(716, 'عرض تفاصيل عينة', NULL, 'النظام', 'GET', '/inventory/print-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:12:25'),
(717, 'استعراض inventory export pdf', 20, 'ADMIN2', 'GET', '/inventory/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:12:27');
INSERT INTO `activity_logs` (`id`, `action_name`, `actor_id`, `actor_name_snapshot`, `method`, `path`, `status_code`, `ip_address`, `user_agent`, `created_at`) VALUES
(718, 'استعراض المخزون', 20, 'ADMIN2', 'GET', '/inventory', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:12:56'),
(719, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:12:57'),
(720, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:12:58'),
(721, 'استعراض costs cost-statement export print-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/export/print-pdf-raw', 302, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:13:03'),
(722, 'عرض صفحة تسجيل الدخول', NULL, 'النظام', 'GET', '/auth/login', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:13:03'),
(723, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:13:10'),
(724, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:22:13'),
(725, 'استعراض costs cost-statement export print-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/export/print-pdf-raw', 302, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:22:16'),
(726, 'عرض صفحة تسجيل الدخول', NULL, 'النظام', 'GET', '/auth/login', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-25 19:22:16'),
(727, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:22:21'),
(728, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:29:59'),
(729, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:30:01'),
(730, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:30:05'),
(731, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:31:45'),
(732, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:31:56'),
(733, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:32:12'),
(734, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:34:01'),
(735, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:34:03'),
(736, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 404, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:34:10'),
(737, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:35:03'),
(738, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:35:08'),
(739, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:36:38'),
(740, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:36:39'),
(741, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:38:28'),
(742, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 500, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:38:32'),
(743, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:38:45'),
(744, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 500, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:38:48'),
(745, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:39:53'),
(746, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:40:17'),
(747, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:40:22'),
(748, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:42:03'),
(749, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:42:10'),
(750, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:43:05'),
(751, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:43:06'),
(752, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:44:25'),
(753, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:45:23'),
(754, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:45:35'),
(755, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:45:59'),
(756, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-25 19:46:00'),
(757, 'عرض صفحة تسجيل الدخول', NULL, 'النظام', 'GET', '/auth/login', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:01:45'),
(758, 'تسجيل الدخول', NULL, 'النظام', 'POST', '/auth/login', 302, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:01:47'),
(759, 'استعراض home', 20, 'ADMIN2', 'GET', '/home', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:01:47'),
(760, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:01:56'),
(761, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:01:58'),
(762, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:02:04'),
(763, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:08:25'),
(764, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:08:40'),
(765, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:09:17'),
(766, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:09:19'),
(767, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:09:20'),
(768, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:12:28'),
(769, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:12:34'),
(770, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:13:02'),
(771, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:13:03'),
(772, 'استعراض costs cost-statement id pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:13:05'),
(773, 'استعراض costs cost-statement id print', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/print', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:13:06'),
(774, 'استعراض costs cost-statement id pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/pdf', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:13:28'),
(775, 'استعراض costs cost-statement id print', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/print', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:13:29'),
(776, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:13:47'),
(777, 'استعراض المخزون', 20, 'ADMIN2', 'GET', '/inventory', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:18:47'),
(778, 'استعراض المخزون', 20, 'ADMIN2', 'GET', '/inventory', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:19:37'),
(779, 'عرض تفاصيل عينة', NULL, 'النظام', 'GET', '/inventory/print-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:19:41'),
(780, 'استعراض inventory export pdf', 20, 'ADMIN2', 'GET', '/inventory/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:19:45'),
(781, 'استعراض الفواتير', 20, 'ADMIN2', 'GET', '/invoices', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:19:55'),
(782, 'استعراض الشهادات', 20, 'ADMIN2', 'GET', '/certificates', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:19:56'),
(783, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:19:57'),
(784, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:19:59'),
(785, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:20:00'),
(786, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:20:03'),
(787, 'استعراض costs cost-statement print-list-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/print-list-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:20:05'),
(788, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:20:33'),
(789, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:22:07'),
(790, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:22:23'),
(791, 'استعراض costs cost-statement id print', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/print', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:22:26'),
(792, 'استعراض costs cost-statement id print-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/63/print-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:22:33'),
(793, 'استعراض costs cost-statement id pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:22:53'),
(794, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:23:06'),
(795, 'استعراض costs cost-statement print-list-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/print-list-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:23:09'),
(796, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:23:23'),
(797, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:26:12'),
(798, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:27:05'),
(799, 'استعراض costs cost-statement print-list-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/print-list-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:27:07'),
(800, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:27:12'),
(801, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:28:25'),
(802, 'استعراض costs cost-statement print-list-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/print-list-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:28:27'),
(803, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:28:33'),
(804, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:29:39'),
(805, 'استعراض costs cost-statement print-list-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/print-list-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:29:41'),
(806, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:29:51'),
(807, 'استعراض المخزون', 20, 'ADMIN2', 'GET', '/inventory', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:30:36'),
(808, 'عرض تفاصيل عينة', NULL, 'النظام', 'GET', '/inventory/print-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:30:39'),
(809, 'استعراض inventory export pdf', 20, 'ADMIN2', 'GET', '/inventory/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:30:42'),
(810, 'استعراض كل المستخدمين', 20, 'ADMIN2', 'GET', '/users', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:31:50'),
(811, 'استعراض لوحة التكاليف', 20, 'ADMIN2', 'GET', '/costs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:32:04'),
(812, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:32:05'),
(813, 'استعراض costs cost-statement id preview', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/preview', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:32:07'),
(814, 'استعراض costs cost-statement id logs', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/logs', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:32:08'),
(815, 'استعراض costs cost-statement id print-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/63/print-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:32:10'),
(816, 'استعراض costs cost-statement id pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/63/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:32:24'),
(817, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:32:42'),
(818, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:33:28'),
(819, 'استعراض costs cost-statement print-list-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/print-list-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:33:30'),
(820, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:33:51'),
(821, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:36:37'),
(822, 'استعراض costs cost-statement print-list-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/print-list-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:37:21'),
(823, 'استعراض costs cost-statement', 20, 'ADMIN2', 'GET', '/costs/cost-statement', 304, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:37:22'),
(824, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:37:25'),
(825, 'استعراض costs cost-statement print-list-pdf-raw', NULL, 'النظام', 'GET', '/costs/cost-statement/print-list-pdf-raw', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/93.0.4577.0 Safari/537.36', '2025-10-27 16:37:25'),
(826, 'استعراض costs cost-statement export pdf', 20, 'ADMIN2', 'GET', '/costs/cost-statement/export/pdf', 200, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36 Edg/141.0.0.0', '2025-10-27 16:37:29');

-- --------------------------------------------------------

--
-- Table structure for table `certificates`
--

CREATE TABLE `certificates` (
  `id` int(11) NOT NULL,
  `certificate_number` varchar(50) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `type` enum('internal','external') DEFAULT NULL,
  `date` date DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `customer_phone` varchar(20) DEFAULT NULL,
  `customer_address` text DEFAULT NULL,
  `analyst` varchar(100) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`items`)),
  `total_quantity` decimal(10,2) DEFAULT NULL,
  `total_weight` decimal(10,2) DEFAULT NULL,
  `public_id` varchar(36) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL COMMENT 'Timestamp of soft-delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `certificates`
--

INSERT INTO `certificates` (`id`, `certificate_number`, `year`, `type`, `date`, `customer_name`, `customer_phone`, `customer_address`, `analyst`, `notes`, `items`, `total_quantity`, `total_weight`, `public_id`, `created_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(80, '2', 2025, 'external', '2025-06-25', 'شركة أصالة حمدي شاكر', NULL, 'حماة-مزارع الرقيطة', 'م . زاهر عبد الكريم صبوح', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0.1,\"total_weight\":0,\"ph\":1.4,\"peroxide\":17,\"abs_232\":2.237,\"abs_270\":0.202,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.19,\"abs_266\":0.205,\"k_232\":null,\"k_270\":null,\"delta_k\":0.004,\"stigmastadiene\":0.05}]', 0.00, 0.00, '6e36cd29', 13, '2025-06-25 11:10:19', '2025-06-25 11:10:19', NULL),
(81, '3', 2025, 'external', '2025-06-26', 'شركة أصالة -حمدي شاكر', NULL, 'حماة-مزارع الرقيطة', 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1.45,\"peroxide\":19.5,\"abs_232\":2.295,\"abs_270\":0.201,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.189,\"abs_266\":0.206,\"k_232\":null,\"k_270\":null,\"delta_k\":0.004,\"stigmastadiene\":null}]', 0.00, 0.00, '63480fb9', 13, '2025-06-26 14:42:29', '2025-06-26 14:42:29', NULL),
(82, '4', 2025, 'external', '2025-06-29', 'شركة أصالة حمدي شاكر', NULL, 'حماة-مزارع الرقيطة', 'م . زاهر عبد الكريم صبوح', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0.75,\"peroxide\":14,\"abs_232\":2.165,\"abs_270\":0.233,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.217,\"abs_266\":0.233,\"k_232\":null,\"k_270\":null,\"delta_k\":0.008,\"stigmastadiene\":0.2}]', 0.00, 0.00, '669598c7', 13, '2025-06-29 07:42:22', '2025-06-29 07:42:22', NULL),
(86, '5', 2025, 'external', '2025-06-29', 'مؤسسة اليسر التجارية', '0988111125', 'حماة- قمحانة', 'م . زاهر عبد الكريم صبوح', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1.3,\"peroxide\":17,\"abs_232\":1.901,\"abs_270\":0.155,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.149,\"abs_266\":0.162,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0}]', 0.00, 0.00, '163240c3', 13, '2025-06-29 10:02:35', '2025-06-29 10:02:35', NULL),
(87, '6', 2025, 'external', '2025-06-30', 'محمد الابراهيم أبو حسام', NULL, 'ادلب-كورين', 'محمد خالد العثمانلي', 'بيدون', '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0.8,\"peroxide\":16.5,\"abs_232\":2.197,\"abs_270\":0.119,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.113,\"abs_266\":0.131,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.003,\"stigmastadiene\":null}]', 0.00, 0.00, '71efbf57', 13, '2025-06-30 09:35:39', '2025-06-30 09:35:39', NULL),
(89, '7', 2025, 'external', '2025-06-30', 'معصرة العديل', NULL, 'سلمية - أم العمد', 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1.45,\"peroxide\":19,\"abs_232\":1.967,\"abs_270\":0.165,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.158,\"abs_266\":0.171,\"k_232\":null,\"k_270\":null,\"delta_k\":null,\"stigmastadiene\":null}]', 0.00, 0.00, '3247dd55', 13, '2025-06-30 09:43:48', '2025-06-30 09:43:48', NULL),
(94, '9', 2025, 'external', '2025-07-02', 'عينة شاملة رقم 35', NULL, NULL, 'م . زاهر عبد الكريم صبوح', 'الذمم 1222+1223+1224+1225+1226+1227', '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0,\"peroxide\":0,\"abs_232\":2.167,\"abs_270\":0.171,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.163,\"abs_266\":0.182,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0.04}]', 0.00, 0.00, 'a2483026', 13, '2025-07-02 09:32:08', '2025-07-02 09:32:08', NULL),
(95, '10', 2025, 'external', '2025-07-03', 'شركة أصالة', NULL, 'حماة-مزارع الرقيطة', 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1.8,\"peroxide\":14.5,\"abs_232\":2.167,\"abs_270\":0.209,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.199,\"abs_266\":0.217,\"k_232\":null,\"k_270\":null,\"delta_k\":0.002,\"stigmastadiene\":null}]', 0.00, 0.00, '9577f51e', 13, '2025-07-03 11:02:45', '2025-07-03 11:02:45', NULL),
(96, '11', 2025, 'external', '2025-07-03', 'ابراهيم أبو ياسر', NULL, 'ادلب-كورين', 'م . زاهر عبد الكريم صبوح', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0.7,\"peroxide\":0,\"abs_232\":2.039,\"abs_270\":0.183,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.174,\"abs_266\":0.196,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":null}]', 0.00, 0.00, '92afddb1', 13, '2025-07-03 12:56:23', '2025-07-03 12:56:23', NULL),
(97, '12', 2025, 'internal', '2025-07-03', 'ابراهيم ياسر الابراهيم', NULL, NULL, 'محمد خالد صفوان عثمانلي', NULL, '[{\"sample_number\":\"1235\",\"quantity\":156,\"packaging_unit\":\"لتر\",\"packaging_weight\":156,\"total_weight\":156,\"ph\":0.9,\"peroxide\":13,\"abs_232\":2.166,\"abs_270\":0.2,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.188,\"abs_266\":0.213,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0}]', 156.00, 156.00, 'b7c2ce1d', 3, '2025-07-03 14:30:12', '2025-07-03 14:30:12', NULL),
(101, '13', 2025, 'external', '2025-07-05', 'عينة شاملة رقم 36', NULL, NULL, 'م . زاهر عبد الكريم صبوح', 'الزمم من 1228 الى 1239', '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0.8,\"peroxide\":15.5,\"abs_232\":2.043,\"abs_270\":0.146,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.138,\"abs_266\":0.154,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0.1}]', 0.00, 0.00, '7202e3e2', 13, '2025-07-05 09:08:20', '2025-07-05 09:08:20', NULL),
(103, '15', 2025, 'external', '2025-07-05', 'نسيم فرح', NULL, NULL, 'م . زاهر عبد الكريم صبوح', '350برميل بوزن صافي110كغ لكل برميل', '[{\"sample_number\":null,\"quantity\":350,\"packaging_unit\":\"برميل\",\"packaging_weight\":110,\"total_weight\":38500,\"ph\":0.73,\"peroxide\":14,\"abs_232\":2.208,\"abs_270\":0.177,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.168,\"abs_266\":0.188,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0.04}]', 350.00, 38500.00, '4ad22862', 13, '2025-07-05 10:30:01', '2025-07-05 10:30:01', NULL),
(104, '16', 2025, 'internal', '2025-07-05', 'محمود نورس الابراهيم', NULL, NULL, 'محمد عثمانلي', NULL, '[{\"sample_number\":\"1238\",\"quantity\":9,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.101,\"total_weight\":143.83,\"ph\":0.6,\"peroxide\":15,\"abs_232\":1.901,\"abs_270\":0.128,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.12,\"abs_266\":0.138,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0},{\"sample_number\":\"1237\",\"quantity\":227,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":3627.86,\"ph\":0.7,\"peroxide\":13,\"abs_232\":1.916,\"abs_270\":0.158,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.148,\"abs_266\":0.168,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0},{\"sample_number\":\"1236\",\"quantity\":80,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.099,\"total_weight\":1715.3,\"ph\":0.5,\"peroxide\":18.5,\"abs_232\":1.985,\"abs_270\":0.148,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.143,\"abs_266\":0.153,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":0}]', 316.00, 5486.99, '1392d39e', 3, '2025-07-05 18:03:24', '2025-07-05 18:03:24', NULL),
(105, '17', 2025, 'external', '2025-07-07', 'أبراهيم أبو ياسر', NULL, 'ادلب-كورين', 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":2.15,\"peroxide\":18,\"abs_232\":2.199,\"abs_270\":0.196,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.186,\"abs_266\":0.199,\"k_232\":null,\"k_270\":null,\"delta_k\":0.004,\"stigmastadiene\":null}]', 0.00, 0.00, 'b9778723', 13, '2025-07-07 08:20:24', '2025-07-07 08:20:24', NULL),
(106, '18', 2025, 'external', '2025-07-07', 'شركة الشرق الادنى-سيرجيلا', NULL, 'حماة-طريق محردة-المجدل', 'م . زاهر عبد الكريم صبوح', 'T4', '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1.75,\"peroxide\":26,\"abs_232\":2.749,\"abs_270\":0.292,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.275,\"abs_266\":0.293,\"k_232\":null,\"k_270\":null,\"delta_k\":0.008,\"stigmastadiene\":0.01}]', 0.00, 0.00, 'a78fcaba', 13, '2025-07-07 13:25:09', '2025-07-07 13:25:09', NULL),
(107, '19', 2025, 'external', '2025-07-08', 'عبدالرزاق نصر', NULL, 'حماة-الحمرا', 'م . زاهر عبد الكريم صبوح', NULL, '[{\"sample_number\":null,\"quantity\":50,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0.4,\"peroxide\":null,\"abs_232\":1.879,\"abs_270\":0.181,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.174,\"abs_266\":0.19,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":null}]', 50.00, 0.00, '2fb54545', 13, '2025-07-08 07:52:10', '2025-07-08 07:52:10', NULL),
(108, '20', 2025, 'external', '2025-07-09', 'محمود نورس', NULL, 'ادلب-كورين', 'م . زاهر عبد الكريم صبوح', 'الذمة رقم 1237+1238 (ستغماستاديين رقم 43)', '[{\"sample_number\":null,\"quantity\":236,\"packaging_unit\":\"تنك\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":null,\"peroxide\":null,\"abs_232\":null,\"abs_270\":null,\"abs_268\":null,\"abs_262\":null,\"abs_274\":null,\"abs_266\":null,\"k_232\":null,\"k_270\":null,\"delta_k\":null,\"stigmastadiene\":0.13}]', 236.00, 0.00, '5fe62c05', 13, '2025-07-09 08:06:47', '2025-07-09 08:06:47', NULL),
(109, '21', 2025, 'external', '2025-07-09', 'أبراهيم أبو ياسر', NULL, 'ادلب-كورين', 'م . زاهر عبد الكريم صبوح', 'ذمة رقم 1235 (ستغماستاديين رقم 42)', '[{\"sample_number\":null,\"quantity\":156,\"packaging_unit\":\"تنك\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0,\"peroxide\":0,\"abs_232\":null,\"abs_270\":null,\"abs_268\":null,\"abs_262\":null,\"abs_274\":null,\"abs_266\":null,\"k_232\":null,\"k_270\":null,\"delta_k\":null,\"stigmastadiene\":0.07}]', 156.00, 0.00, '296942f4', 13, '2025-07-09 08:09:11', '2025-07-09 08:09:11', NULL),
(110, '22', 2025, 'external', '2025-07-10', 'علاء أباظة', NULL, 'حمص-تلبيسة', 'م . زاهر عبد الكريم صبوح', 'تنك فرز', '[{\"sample_number\":null,\"quantity\":11,\"packaging_unit\":\"تنك\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":3,\"peroxide\":19,\"abs_232\":2.508,\"abs_270\":0.313,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.295,\"abs_266\":0.308,\"k_232\":null,\"k_270\":null,\"delta_k\":0.011,\"stigmastadiene\":null}]', 11.00, 0.00, 'd1965638', 13, '2025-07-10 11:51:39', '2025-07-10 11:51:39', NULL),
(112, '24', 2025, 'external', '2025-07-10', 'علاء أباظة', NULL, 'حمص-تلبيسة', 'محمد خالد العثمانلي', 'تنك ذمة رقم 1244', '[{\"sample_number\":null,\"quantity\":332,\"packaging_unit\":\"تنك\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1.75,\"peroxide\":18.5,\"abs_232\":2.27,\"abs_270\":0.215,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.204,\"abs_266\":0.221,\"k_232\":null,\"k_270\":null,\"delta_k\":0.003,\"stigmastadiene\":null}]', 332.00, 0.00, 'f435d093', 13, '2025-07-10 12:05:39', '2025-07-10 12:05:39', NULL),
(113, '25', 2025, 'internal', '2025-07-10', 'حكيم ناصر', NULL, NULL, 'محمد خالد العثمانلي', 'تنك', '[{\"sample_number\":\"1246\",\"quantity\":241,\"packaging_unit\":\"تنك\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":2.15,\"peroxide\":30,\"abs_232\":2.188,\"abs_270\":0.208,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.198,\"abs_266\":0.211,\"k_232\":null,\"k_270\":null,\"delta_k\":0.004,\"stigmastadiene\":0},{\"sample_number\":\"1245\",\"quantity\":250,\"packaging_unit\":\"لتر\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":1.7,\"peroxide\":28.5,\"abs_232\":2.066,\"abs_270\":0.181,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.173,\"abs_266\":0.186,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":0}]', 491.00, 2.00, '2704715d', 13, '2025-07-10 13:14:12', '2025-07-10 13:14:12', NULL),
(114, '26', 2025, 'internal', '2025-07-10', 'حكيم ناصر', NULL, 'عفرين', 'محمد خالد صفوان عثمانلي', NULL, '[{\"sample_number\":\"1246\",\"quantity\":241,\"packaging_unit\":\"لتر\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":2.15,\"peroxide\":30,\"abs_232\":2.188,\"abs_270\":0.208,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.198,\"abs_266\":0.211,\"k_232\":null,\"k_270\":null,\"delta_k\":0.004,\"stigmastadiene\":0},{\"sample_number\":\"1245\",\"quantity\":250,\"packaging_unit\":\"لتر\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":1.7,\"peroxide\":28.5,\"abs_232\":2.066,\"abs_270\":0.181,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.173,\"abs_266\":0.186,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":0}]', 491.00, 2.00, '94f09511', 3, '2025-07-10 14:04:05', '2025-07-10 14:04:05', NULL),
(115, '27', 2025, 'external', '2025-07-12', 'حكيم ناصر', NULL, NULL, 'م . زاهر عبد الكريم صبوح', '491 تنكة ذمم رقم 1245+1246', '[{\"sample_number\":null,\"quantity\":491,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1.92,\"peroxide\":29.2,\"abs_232\":2.301,\"abs_270\":0.207,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.195,\"abs_266\":0.211,\"k_232\":null,\"k_270\":null,\"delta_k\":0.003,\"stigmastadiene\":0.02}]', 491.00, 0.00, '1625c753', 13, '2025-07-12 09:17:18', '2025-07-12 09:17:18', NULL),
(116, '28', 2025, 'internal', '2025-07-12', 'قاسم مسعف الحاج اعرابي', NULL, 'حماه زور بلحسين', 'م . زاهر صبوح', '1250/1251/1252', '[{\"sample_number\":\"1252\",\"quantity\":21,\"packaging_unit\":\"لتر\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":1.2,\"peroxide\":17.5,\"abs_232\":2.236,\"abs_270\":0.193,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.184,\"abs_266\":0.199,\"k_232\":null,\"k_270\":null,\"delta_k\":0.002,\"stigmastadiene\":0},{\"sample_number\":\"1251\",\"quantity\":12,\"packaging_unit\":\"لتر\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":0.5,\"peroxide\":17,\"abs_232\":1.994,\"abs_270\":0.152,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.146,\"abs_266\":0.159,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0},{\"sample_number\":\"1250\",\"quantity\":134,\"packaging_unit\":\"لتر\",\"packaging_weight\":0.101,\"total_weight\":1,\"ph\":0.7,\"peroxide\":12.5,\"abs_232\":2.042,\"abs_270\":0.194,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.187,\"abs_266\":0.204,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0}]', 167.00, 3.00, '9a4ea02f', 3, '2025-07-12 14:24:35', '2025-07-12 14:24:35', NULL),
(117, '29', 2025, 'external', '2025-07-13', 'شركة أصالة', NULL, 'حماة-مزارع الرقيطة', 'محمد خالد العثمانلي', 'شركة أصالة -حمدي شاكر', '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":2,\"peroxide\":23.5,\"abs_232\":2.731,\"abs_270\":0.269,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.253,\"abs_266\":0.272,\"k_232\":null,\"k_270\":null,\"delta_k\":0.006,\"stigmastadiene\":null}]', 0.00, 0.00, '32fb4a4b', 13, '2025-07-13 11:23:34', '2025-07-13 11:23:34', NULL),
(118, '30', 2025, 'internal', '2025-07-14', 'الشرق الادنى', '0334743673', 'حماه طريق محردة قرية المجدل', 'م . زاهر صبوح', NULL, '[{\"sample_number\":\"1259\",\"quantity\":500,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":8020,\"ph\":1.7,\"peroxide\":25.5,\"abs_232\":2.674,\"abs_270\":0.254,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.239,\"abs_266\":0.256,\"k_232\":null,\"k_270\":null,\"delta_k\":0.006,\"stigmastadiene\":0},{\"sample_number\":\"1254\",\"quantity\":500,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.102,\"total_weight\":8050,\"ph\":1.7,\"peroxide\":26,\"abs_232\":2.78,\"abs_270\":0.278,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.26,\"abs_266\":0.28,\"k_232\":null,\"k_270\":null,\"delta_k\":0.008,\"stigmastadiene\":0},{\"sample_number\":\"1260\",\"quantity\":148,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.101,\"total_weight\":2357,\"ph\":2.05,\"peroxide\":23.5,\"abs_232\":2.707,\"abs_270\":0.293,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.276,\"abs_266\":0.294,\"k_232\":null,\"k_270\":null,\"delta_k\":0.007,\"stigmastadiene\":0}]', 1148.00, 18427.00, '5dc9060b', 3, '2025-07-14 07:49:43', '2025-07-14 07:49:43', NULL),
(119, '31', 2025, 'external', '2025-07-14', 'محمد الابراهيم أبو حسام', NULL, 'ادلب-كورين', 'م . زاهر عبد الكريم صبوح', 'عينة شاملة ذمم رقم 1255+1257+1258 عدد أجمالي 407', '[{\"sample_number\":null,\"quantity\":407,\"packaging_unit\":\"تنك\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1.54,\"peroxide\":15.7,\"abs_232\":1.997,\"abs_270\":0.165,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.157,\"abs_266\":0.17,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":0.12}]', 407.00, 0.00, 'f575b5d4', 13, '2025-07-14 08:41:50', '2025-07-14 08:41:50', NULL),
(120, '32', 2025, 'external', '2025-07-14', 'عينة شاملة رقم 47', NULL, NULL, 'م . زاهر عبد الكريم صبوح', 'الذمم 1240+1242+1243+1247+1248+1249+1250+1251+1252+1253', '[{\"sample_number\":null,\"quantity\":null,\"packaging_unit\":\"-\",\"packaging_weight\":null,\"total_weight\":null,\"ph\":null,\"peroxide\":null,\"abs_232\":2.138,\"abs_270\":0.19,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.181,\"abs_266\":0.199,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0.02}]', 0.00, 0.00, '284a16b7', 13, '2025-07-14 12:49:51', '2025-07-14 12:49:51', NULL),
(121, '33', 2025, 'external', '2025-07-15', 'شركة الشرق الادنى-سيرجيلا', NULL, NULL, 'م . زاهر عبد الكريم صبوح', 'عينة شاملة للذمم 1254+1259+1260+1261+1262', '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":null,\"peroxide\":null,\"abs_232\":2.618,\"abs_270\":0.235,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.222,\"abs_266\":0.241,\"k_232\":null,\"k_270\":null,\"delta_k\":0.003,\"stigmastadiene\":0.04}]', 0.00, 0.00, 'a55f7de9', 13, '2025-07-15 08:09:07', '2025-07-15 08:09:07', NULL),
(122, '34', 2025, 'external', '2025-07-15', 'محمد عجاج 231برميل بوزن 110 كيلو غرام', NULL, NULL, 'م . زاهر عبد الكريم صبوح', 'ضخة خزانات', '[{\"sample_number\":null,\"quantity\":231,\"packaging_unit\":\"برميل\",\"packaging_weight\":110,\"total_weight\":25410,\"ph\":1.65,\"peroxide\":22,\"abs_232\":2.523,\"abs_270\":0.233,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.221,\"abs_266\":0.237,\"k_232\":null,\"k_270\":null,\"delta_k\":0.004,\"stigmastadiene\":0.04}]', 231.00, 25410.00, '555c6a32', 13, '2025-07-15 10:16:25', '2025-07-15 10:16:25', NULL),
(123, '35', 2025, 'external', '2025-07-16', 'محمد عجاج 139برميل بوزن 110', NULL, NULL, 'محمد خالد العثمانلي', 'ضخة خزانات (براميل)', '[{\"sample_number\":null,\"quantity\":139,\"packaging_unit\":\"برميل\",\"packaging_weight\":110,\"total_weight\":15290,\"ph\":1,\"peroxide\":17.5,\"abs_232\":2.192,\"abs_270\":0.186,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.179,\"abs_266\":0.196,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":null}]', 139.00, 15290.00, 'e3638aa8', 13, '2025-07-16 10:09:29', '2025-07-16 10:09:29', NULL),
(124, '36', 2025, 'external', '2025-07-16', 'أزاد شيخو', NULL, NULL, 'محمد خالد العثمانلي', '16-7-2025', '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1.3,\"peroxide\":20.5,\"abs_232\":2.278,\"abs_270\":0.197,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.187,\"abs_266\":0.204,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":null}]', 0.00, 0.00, 'ef599cb6', 13, '2025-07-16 10:11:15', '2025-07-16 10:11:15', NULL),
(125, '37', 2025, 'external', '2025-07-17', 'حسام حلاق', NULL, NULL, 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1.3,\"peroxide\":20.5,\"abs_232\":2.225,\"abs_270\":0.196,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.184,\"abs_266\":0.206,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":null}]', 0.00, 0.00, 'e3a13484', 13, '2025-07-17 06:32:38', '2025-07-17 06:32:38', NULL),
(126, '38', 2025, 'external', '2025-07-17', 'نسيم رياض فرح', NULL, 'لبنان', 'محمد خالد العثمانلي', 'طلبية 220 برميل غذائي وزن 110 كغ السائق أحمد صبحي خطاب', '[{\"sample_number\":null,\"quantity\":220,\"packaging_unit\":\"برميل غذائي\",\"packaging_weight\":110,\"total_weight\":24200,\"ph\":1.6,\"peroxide\":18,\"abs_232\":2.27,\"abs_270\":0.215,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.204,\"abs_266\":0.221,\"k_232\":null,\"k_270\":null,\"delta_k\":0.003,\"stigmastadiene\":0.04}]', 220.00, 24200.00, 'b33d3cda', 13, '2025-07-17 15:58:16', '2025-07-17 15:58:16', NULL),
(127, '39', 2025, 'external', '2025-07-23', 'شركة أصالة', NULL, 'حماة-مزارع الرقيطة', 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":2.6,\"peroxide\":23,\"abs_232\":2.093,\"abs_270\":0.18,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.176,\"abs_266\":0.18,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":null}]', 0.00, 0.00, '7c76634e', 13, '2025-07-23 12:03:57', '2025-07-23 12:03:57', NULL),
(128, '40', 2025, 'external', '2025-07-27', 'نسيم رياض فرح', NULL, 'لبنان', 'محمد خالد العثمانلي', 'برميل عدد 141 بوزن 110 لكل برميل', '[{\"sample_number\":null,\"quantity\":141,\"packaging_unit\":\"برميل\",\"packaging_weight\":110,\"total_weight\":15510,\"ph\":0.65,\"peroxide\":14.5,\"abs_232\":2.094,\"abs_270\":0.182,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.174,\"abs_266\":0.19,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":null}]', 141.00, 15510.00, '8a6f0c46', 13, '2025-07-27 09:26:13', '2025-07-27 09:26:13', NULL),
(129, '41', 2025, 'external', '2025-07-27', 'عبد الغني الرحال', NULL, 'حماة-قمحانة', 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0.5,\"peroxide\":11,\"abs_232\":3.202,\"abs_270\":1.4,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.23,\"abs_266\":1.345,\"k_232\":null,\"k_270\":null,\"delta_k\":0.112,\"stigmastadiene\":12.55}]', 0.00, 0.00, 'c3b2d688', 13, '2025-07-27 14:29:48', '2025-07-27 14:29:48', NULL),
(130, '42', 2025, 'external', '2025-07-31', 'ابراهيم أبو ياسر', NULL, 'ادلب-كورين', 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":12,\"packaging_unit\":\"تنك\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1,\"peroxide\":1,\"abs_232\":2.052,\"abs_270\":0.356,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.335,\"abs_266\":0.349,\"k_232\":null,\"k_270\":null,\"delta_k\":0.015,\"stigmastadiene\":null}]', 12.00, 0.00, 'c74164d7', 13, '2025-07-31 13:27:31', '2025-07-31 13:27:31', NULL),
(132, '44', 2025, 'external', '2025-08-03', 'حكيم ناصر', NULL, NULL, 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":1,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":6.1,\"peroxide\":79.5,\"abs_232\":3.084,\"abs_270\":1.723,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.628,\"abs_266\":1.755,\"k_232\":null,\"k_270\":null,\"delta_k\":0.031,\"stigmastadiene\":null},{\"sample_number\":null,\"quantity\":2,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":5.35,\"peroxide\":47.5,\"abs_232\":3.034,\"abs_270\":1.167,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.098,\"abs_266\":1.152,\"k_232\":null,\"k_270\":null,\"delta_k\":0.042,\"stigmastadiene\":null},{\"sample_number\":null,\"quantity\":3,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":7,\"peroxide\":51.5,\"abs_232\":3.045,\"abs_270\":1.155,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.104,\"abs_266\":1.137,\"k_232\":null,\"k_270\":null,\"delta_k\":0.035,\"stigmastadiene\":null}]', 6.00, 0.00, '40d5d133', 13, '2025-08-03 15:49:47', '2025-08-03 15:49:47', NULL),
(133, '45', 2025, 'internal', '2025-08-04', 'السيد عبدو فهيم المحترم', NULL, 'حلب - عفرين', 'محمد خالد العثمانلي', 'نتيجة تحليل زيت وارد', '[{\"sample_number\":\"1299\",\"quantity\":250,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":0.8,\"peroxide\":11.5,\"abs_232\":1.826,\"abs_270\":0.147,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.141,\"abs_266\":0.156,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.002,\"stigmastadiene\":0},{\"sample_number\":\"1300\",\"quantity\":250,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":0.9,\"peroxide\":13,\"abs_232\":1.817,\"abs_270\":0.15,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.143,\"abs_266\":0.156,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0}]', 500.00, 2.00, 'dad5eeab', 13, '2025-08-04 10:42:01', '2025-08-04 10:42:01', NULL),
(134, '46', 2025, 'internal', '2025-08-04', 'محمود نورس', NULL, 'ادلب-كورين', 'محمد خالد العثمانلي', 'تنك فرز (تحليل الحموضة والبروكسيد وهمي)', '[{\"sample_number\":\"1304\",\"quantity\":5,\"packaging_unit\":\"تنك\",\"packaging_weight\":0.101,\"total_weight\":1,\"ph\":1,\"peroxide\":1,\"abs_232\":2.374,\"abs_270\":0.405,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.389,\"abs_266\":0.391,\"k_232\":null,\"k_270\":null,\"delta_k\":0.015,\"stigmastadiene\":0}]', 5.00, 1.00, '32828b18', 13, '2025-08-04 12:49:24', '2025-08-04 12:49:24', NULL),
(135, '47', 2025, 'internal', '2025-08-04', 'السيد ابراهيم ياسر الابراهيم', NULL, 'ادلب - كورين', 'محمد خالد صفوان عثمانلي', 'عينة داخلية زيت جورة مخالفة', '[{\"sample_number\":\"1306\",\"quantity\":181,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.101,\"total_weight\":2888.1,\"ph\":3.35,\"peroxide\":0,\"abs_232\":3.22,\"abs_270\":1.175,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.112,\"abs_266\":1.19,\"k_232\":null,\"k_270\":null,\"delta_k\":0.025,\"stigmastadiene\":0}]', 181.00, 2888.10, '2dec3fb9', 3, '2025-08-04 20:30:10', '2025-08-04 20:30:10', NULL),
(136, '48', 2025, 'external', '2025-08-06', 'نسيم رياض فرح', NULL, 'لبنان', 'محمد خالد العثمانلي', 'طلبية (290 برميل غذائي وزن 110 - 70 برميل غذائي وزن 110كغ )\nالسائق : أحمد صبحي خطاب', '[{\"sample_number\":null,\"quantity\":290,\"packaging_unit\":\"برميل\",\"packaging_weight\":110,\"total_weight\":31900,\"ph\":0.7,\"peroxide\":13,\"abs_232\":2.064,\"abs_270\":0.166,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.157,\"abs_266\":0.174,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":null},{\"sample_number\":null,\"quantity\":70,\"packaging_unit\":\"برميل\",\"packaging_weight\":110,\"total_weight\":7700,\"ph\":1.6,\"peroxide\":16,\"abs_232\":2.214,\"abs_270\":0.178,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.17,\"abs_266\":0.182,\"k_232\":null,\"k_270\":null,\"delta_k\":0.002,\"stigmastadiene\":null}]', 360.00, 39600.00, 'a24427e7', 13, '2025-08-06 08:35:53', '2025-08-06 08:35:53', NULL),
(137, '49', 2025, 'external', '2025-08-06', 'نسيم رياض فرح', NULL, 'لبنان', 'محمد خالد العثمانلي', 'طلبية (290 برميل غذائي وزن 110)\nالسائق: أحمد صبحي خطاب', '[{\"sample_number\":null,\"quantity\":290,\"packaging_unit\":\"برميل\",\"packaging_weight\":110,\"total_weight\":31900,\"ph\":0.7,\"peroxide\":13,\"abs_232\":2.064,\"abs_270\":0.166,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.157,\"abs_266\":0.174,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":null}]', 290.00, 31900.00, 'd5d2345c', 13, '2025-08-06 08:40:09', '2025-08-06 08:40:09', NULL),
(138, '50', 2025, 'external', '2025-08-06', 'نسيم رياض فرح', NULL, 'لبنان', 'محمد خالد العثمانلي', 'طلبية (70 برميل غذائي وزن110)\nالسائق : أحمد صبحي خطاب', '[{\"sample_number\":null,\"quantity\":70,\"packaging_unit\":\"برميل\",\"packaging_weight\":110,\"total_weight\":7700,\"ph\":1.6,\"peroxide\":16,\"abs_232\":2.214,\"abs_270\":0.178,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.17,\"abs_266\":0.182,\"k_232\":null,\"k_270\":null,\"delta_k\":0.002,\"stigmastadiene\":null}]', 70.00, 7700.00, 'c3fe77a7', 13, '2025-08-06 08:43:38', '2025-08-06 08:43:38', NULL),
(139, '51', 2025, 'external', '2025-08-06', 'علاء أباظة', NULL, 'حمص-تلبيسة', 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":1,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0.65,\"peroxide\":27,\"abs_232\":1.952,\"abs_270\":0.14,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.131,\"abs_266\":0.153,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.002,\"stigmastadiene\":null},{\"sample_number\":null,\"quantity\":2,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0.65,\"peroxide\":55.5,\"abs_232\":2.555,\"abs_270\":0.161,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.149,\"abs_266\":0.175,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":null}]', 3.00, 0.00, '6e6a1a93', 13, '2025-08-06 09:50:37', '2025-08-06 09:50:37', NULL),
(140, '52', 2025, 'external', '2025-08-06', 'علاء أباظة', NULL, 'حمص-تلبيسة', 'محمد خالد العثمانلي', 'عدد 300-1.....عدد300-2', '[{\"sample_number\":null,\"quantity\":300,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0.7,\"peroxide\":14,\"abs_232\":2.055,\"abs_270\":0.163,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.156,\"abs_266\":0.167,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":null},{\"sample_number\":null,\"quantity\":300,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0.65,\"peroxide\":13,\"abs_232\":2.009,\"abs_270\":0.149,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.142,\"abs_266\":0.155,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":null}]', 600.00, 0.00, '520c7f38', 13, '2025-08-06 11:44:10', '2025-08-06 11:44:10', NULL),
(141, '53', 2025, 'internal', '2025-08-13', 'علاء أباظة', NULL, 'حمص-تلبيسة', 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":\"1323\",\"quantity\":66,\"packaging_unit\":\"بيدون\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":0.55,\"peroxide\":21.5,\"abs_232\":2.453,\"abs_270\":0.214,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.211,\"abs_266\":0.219,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0},{\"sample_number\":\"1322\",\"quantity\":220,\"packaging_unit\":\"تنك\",\"packaging_weight\":0.103,\"total_weight\":1,\"ph\":0.6,\"peroxide\":12.5,\"abs_232\":2.05,\"abs_270\":0.173,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.167,\"abs_266\":0.181,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0},{\"sample_number\":\"1321\",\"quantity\":220,\"packaging_unit\":\"تنك\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":0.7,\"peroxide\":13.5,\"abs_232\":1.992,\"abs_270\":0.155,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.148,\"abs_266\":0.167,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.003,\"stigmastadiene\":0}]', 506.00, 3.00, '17ed51fc', 13, '2025-08-13 11:05:39', '2025-08-13 11:05:39', NULL),
(142, '54', 2025, 'external', '2025-08-14', 'نسيم رياض فرح', NULL, 'لبنان', 'محمد خالد العثمانلي', 'عينة خارجية', '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":4.45,\"peroxide\":25,\"abs_232\":2.543,\"abs_270\":0.231,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.222,\"abs_266\":0.229,\"k_232\":null,\"k_270\":null,\"delta_k\":0.006,\"stigmastadiene\":null}]', 0.00, 0.00, 'dd3836fe', 13, '2025-08-14 08:54:21', '2025-08-14 08:54:21', NULL),
(143, '55', 2025, 'internal', '2025-08-14', 'حسن بدر', NULL, NULL, 'محمد خالد عثمانلي', NULL, '[{\"sample_number\":\"1326\",\"quantity\":250,\"packaging_unit\":\"لتر\",\"packaging_weight\":0.1,\"total_weight\":3997.3,\"ph\":0.55,\"peroxide\":12.5,\"abs_232\":2.046,\"abs_270\":0.166,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.158,\"abs_266\":0.178,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.002,\"stigmastadiene\":0},{\"sample_number\":\"1325\",\"quantity\":250,\"packaging_unit\":\"لتر\",\"packaging_weight\":0.103,\"total_weight\":3995.9,\"ph\":0.55,\"peroxide\":15,\"abs_232\":2.16,\"abs_270\":0.185,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.176,\"abs_266\":0.198,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.002,\"stigmastadiene\":0}]', 500.00, 7993.20, '98c2cbba', 3, '2025-08-14 12:21:13', '2025-08-14 12:21:13', NULL),
(144, '56', 2025, 'external', '2025-08-16', 'نسيم رياض فرح', NULL, 'لبنان', 'محمد خالد العثمانلي', 'عينة خارجية', '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":4.45,\"peroxide\":25,\"abs_232\":2.543,\"abs_270\":0.231,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.222,\"abs_266\":0.229,\"k_232\":null,\"k_270\":null,\"delta_k\":0.006,\"stigmastadiene\":0.012}]', 0.00, 0.00, '34787f1a', 13, '2025-08-16 14:25:09', '2025-08-16 14:25:09', NULL),
(145, '57', 2025, 'internal', '2025-08-20', 'محمد حسام الابراهيم وشركاه', NULL, 'ادلب بلدة كورين', 'محمد خالد صفوان عثمانلي', NULL, '[{\"sample_number\":\"1339\",\"quantity\":17,\"packaging_unit\":\"بيدون\",\"packaging_weight\":0.1,\"total_weight\":307.9,\"ph\":0.7,\"peroxide\":28.5,\"abs_232\":2.463,\"abs_270\":0.173,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.164,\"abs_266\":0.178,\"k_232\":null,\"k_270\":null,\"delta_k\":0.002,\"stigmastadiene\":0},{\"sample_number\":\"1338\",\"quantity\":82,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":1309.6,\"ph\":0.95,\"peroxide\":11.5,\"abs_232\":2.113,\"abs_270\":0.182,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.175,\"abs_266\":0.187,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":0}]', 99.00, 1617.50, '3532514e', 3, '2025-08-20 15:25:15', '2025-08-20 15:25:15', NULL),
(146, '58', 2025, 'internal', '2025-08-20', 'عبدالرحمن فهمي سيدو المحترم', NULL, 'حلب عفرين', 'محمد خالد صفوان عثمانلي', NULL, '[{\"sample_number\":\"1340\",\"quantity\":250,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":0.8,\"peroxide\":12,\"abs_232\":1.785,\"abs_270\":0.151,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.145,\"abs_266\":0.157,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0},{\"sample_number\":\"1341\",\"quantity\":250,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":0.75,\"peroxide\":12,\"abs_232\":1.779,\"abs_270\":0.144,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.138,\"abs_266\":0.15,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0},{\"sample_number\":\"1342\",\"quantity\":500,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":0.75,\"peroxide\":11.5,\"abs_232\":1.787,\"abs_270\":0.139,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.133,\"abs_266\":0.147,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0},{\"sample_number\":\"1343\",\"quantity\":500,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.099,\"total_weight\":1,\"ph\":0.75,\"peroxide\":11,\"abs_232\":1.791,\"abs_270\":0.138,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.132,\"abs_266\":0.145,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0},{\"sample_number\":\"1344\",\"quantity\":200,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.101,\"total_weight\":1,\"ph\":0.8,\"peroxide\":11.5,\"abs_232\":1.814,\"abs_270\":0.136,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.131,\"abs_266\":0.142,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0}]', 1700.00, 5.00, 'e18fe763', 3, '2025-08-20 15:30:29', '2025-08-20 15:30:29', NULL),
(147, '59', 2025, 'internal', '2025-08-20', 'عبدالرحمن فهمي سيدو المحترم', NULL, 'حلب عفرين', 'محمد خالد صفوان عثمانلي', NULL, '[{\"sample_number\":\"1334\",\"quantity\":250,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":3997.1,\"ph\":0.45,\"peroxide\":11.5,\"abs_232\":1.842,\"abs_270\":0.15,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.144,\"abs_266\":0.159,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.002,\"stigmastadiene\":0},{\"sample_number\":\"1335\",\"quantity\":250,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":4001.1,\"ph\":0.45,\"peroxide\":11.5,\"abs_232\":1.85,\"abs_270\":0.153,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.148,\"abs_266\":0.161,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0}]', 500.00, 7998.20, 'a7561ce9', 3, '2025-08-20 15:32:01', '2025-08-20 15:32:01', NULL),
(148, '60', 2025, 'internal', '2025-08-21', 'محمود نورس الابراهيم وشركاه', NULL, 'ادلب بلدة كورين', 'محمد خالد صفوان عثمانلي', 'الزيت الوارد بتاريخ اليوم', '[{\"sample_number\":\"1355\",\"quantity\":265,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.101,\"total_weight\":4229.8,\"ph\":0.85,\"peroxide\":13,\"abs_232\":2.13,\"abs_270\":0.183,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.171,\"abs_266\":0.194,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":0},{\"sample_number\":\"1354\",\"quantity\":280,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.101,\"total_weight\":4466.7,\"ph\":0.85,\"peroxide\":13,\"abs_232\":2.085,\"abs_270\":0.186,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.175,\"abs_266\":0.196,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0},{\"sample_number\":\"1352\",\"quantity\":248,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":3960.2,\"ph\":0.75,\"peroxide\":12.5,\"abs_232\":2.082,\"abs_270\":0.172,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.163,\"abs_266\":0.177,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":0},{\"sample_number\":\"1351\",\"quantity\":250,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.101,\"total_weight\":3987,\"ph\":0.65,\"peroxide\":14.5,\"abs_232\":2.155,\"abs_270\":0.184,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.173,\"abs_266\":0.193,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":0}]', 1043.00, 16643.70, 'c6f9e68c', 3, '2025-08-21 16:07:26', '2025-08-21 16:07:26', NULL),
(149, '61', 2025, 'internal', '2025-08-21', 'عبدالرحمن فهمي سيدو', NULL, 'حلب عفرين', 'محمد خالد صفوان عثمانلي', NULL, '[{\"sample_number\":\"1350\",\"quantity\":500,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.101,\"total_weight\":7985,\"ph\":0.75,\"peroxide\":12.5,\"abs_232\":1.857,\"abs_270\":0.143,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.136,\"abs_266\":0.15,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0},{\"sample_number\":\"1349\",\"quantity\":8,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.099,\"total_weight\":128.03,\"ph\":1.05,\"peroxide\":13,\"abs_232\":1.946,\"abs_270\":0.254,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.241,\"abs_266\":0.252,\"k_232\":null,\"k_270\":null,\"delta_k\":0.007,\"stigmastadiene\":0},{\"sample_number\":\"1348\",\"quantity\":252,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":4032.96,\"ph\":0.75,\"peroxide\":11,\"abs_232\":1.762,\"abs_270\":0.138,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.132,\"abs_266\":0.144,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0},{\"sample_number\":\"1347\",\"quantity\":260,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":4158.8,\"ph\":0.8,\"peroxide\":13,\"abs_232\":1.984,\"abs_270\":0.159,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.151,\"abs_266\":0.165,\"k_232\":null,\"k_270\":null,\"delta_k\":0.002,\"stigmastadiene\":0}]', 1020.00, 16304.79, '410b4e80', 3, '2025-08-21 16:13:27', '2025-08-21 16:13:27', NULL),
(150, '62', 2025, 'external', '2025-08-23', 'ابراهيم أبو ياسر', NULL, 'ادلب-كورين', 'محمد خالد العثمانلي', 'تنك فرز من ذمة عدد أجمالي 209', '[{\"sample_number\":null,\"quantity\":14,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0,\"peroxide\":0,\"abs_232\":2.522,\"abs_270\":0.349,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.335,\"abs_266\":0.345,\"k_232\":null,\"k_270\":null,\"delta_k\":0.009,\"stigmastadiene\":0},{\"sample_number\":null,\"quantity\":13,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0,\"peroxide\":0,\"abs_232\":2.75,\"abs_270\":0.309,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.295,\"abs_266\":0.313,\"k_232\":null,\"k_270\":null,\"delta_k\":0.005,\"stigmastadiene\":0}]', 27.00, 0.00, 'f89b52de', 13, '2025-08-23 14:10:59', '2025-08-23 14:10:59', NULL),
(151, '63', 2025, 'internal', '2025-08-28', 'التحليل الوسطي للمستودع', NULL, NULL, 'محمد عثمانلي', NULL, '[{\"sample_number\":\"1366\",\"quantity\":60,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":962.1,\"ph\":1.25,\"peroxide\":14.5,\"abs_232\":1.755,\"abs_270\":0.151,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.146,\"abs_266\":0.153,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":0},{\"sample_number\":\"1362\",\"quantity\":102,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":1635.8,\"ph\":0.8,\"peroxide\":11.5,\"abs_232\":1.86,\"abs_270\":0.135,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.134,\"abs_266\":0.136,\"k_232\":null,\"k_270\":null,\"delta_k\":0.001,\"stigmastadiene\":0},{\"sample_number\":\"1334\",\"quantity\":250,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":3997.1,\"ph\":0.45,\"peroxide\":11.5,\"abs_232\":1.842,\"abs_270\":0.15,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.144,\"abs_266\":0.159,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.002,\"stigmastadiene\":0},{\"sample_number\":\"1358\",\"quantity\":115,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.101,\"total_weight\":1837.15,\"ph\":0.8,\"peroxide\":12.5,\"abs_232\":2.026,\"abs_270\":0.204,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.195,\"abs_266\":0.213,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0}]', 527.00, 8432.15, '748e0713', 3, '2025-08-28 17:06:27', '2025-08-28 17:06:27', NULL),
(152, '64', 2025, 'external', '2025-08-30', 'زاهر عجاج', NULL, 'حماة- قمحانة', 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0,\"peroxide\":0,\"abs_232\":2.655,\"abs_270\":0.318,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.296,\"abs_266\":0.312,\"k_232\":null,\"k_270\":null,\"delta_k\":0.014,\"stigmastadiene\":null}]', 0.00, 0.00, '15691eef', 13, '2025-08-30 07:54:40', '2025-08-30 07:54:40', NULL),
(153, '65', 2025, 'external', '2025-08-30', 'شركة مبخر', NULL, 'سورية -ريف دمشق', 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":0.95,\"peroxide\":11.5,\"abs_232\":2.069,\"abs_270\":0.198,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.193,\"abs_266\":0.193,\"k_232\":null,\"k_270\":null,\"delta_k\":0.005,\"stigmastadiene\":0.045}]', 0.00, 0.00, '7163d008', 13, '2025-08-30 08:43:28', '2025-08-30 08:43:28', NULL),
(154, '66', 2025, 'internal', '2025-09-03', 'عبدالرحمن فهمي سيدو', NULL, 'حلب عفرين', 'محمد خالد صفوان عثمانلي', NULL, '[{\"sample_number\":\"1371\",\"quantity\":250,\"packaging_unit\":\"لتر\",\"packaging_weight\":0.101,\"total_weight\":1,\"ph\":0.9,\"peroxide\":14,\"abs_232\":2.011,\"abs_270\":0.15,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.144,\"abs_266\":0.159,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.001,\"stigmastadiene\":0},{\"sample_number\":\"1370\",\"quantity\":250,\"packaging_unit\":\"لتر\",\"packaging_weight\":0.101,\"total_weight\":1,\"ph\":0.9,\"peroxide\":15.5,\"abs_232\":1.918,\"abs_270\":0.152,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.145,\"abs_266\":0.161,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0}]', 500.00, 2.00, 'ac573ab6', 3, '2025-09-03 08:07:40', '2025-09-03 08:07:40', NULL),
(155, '67', 2025, 'external', '2025-09-03', 'حسن البدر', NULL, NULL, 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":0,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":3.45,\"peroxide\":15,\"abs_232\":2.389,\"abs_270\":0.475,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.449,\"abs_266\":0.452,\"k_232\":null,\"k_270\":null,\"delta_k\":0.024,\"stigmastadiene\":null}]', 0.00, 0.00, '8ecb933b', 13, '2025-09-03 12:39:20', '2025-09-03 12:39:20', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cost_logs`
--

CREATE TABLE `cost_logs` (
  `id` int(11) NOT NULL,
  `material_id` int(11) DEFAULT NULL,
  `material_name` varchar(255) NOT NULL,
  `unit_cost` decimal(15,2) NOT NULL,
  `unit_cost_syp` decimal(15,2) DEFAULT NULL,
  `package_cost` decimal(15,2) NOT NULL,
  `package_cost_syp` decimal(15,2) DEFAULT NULL,
  `calculation_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cost_logs`
--

INSERT INTO `cost_logs` (`id`, `material_id`, `material_name`, `unit_cost`, `unit_cost_syp`, `package_cost`, `package_cost_syp`, `calculation_date`) VALUES
(1, NULL, 'تفاحي مكسر', 1.11, 11660.04, 625.21, 6564728.52, '2025-08-13 16:40:32'),
(2, NULL, 'تفاحي مكسر', 1.11, 11660.04, 625.21, 6564728.52, '2025-08-13 16:44:28'),
(3, NULL, 'زيت زيتون أول قياس واحد ليتر ', 4.33, 45423.86, 53.04, 556898.79, '2025-08-13 16:52:12'),
(4, NULL, 'زيت زيتون أول قياس واحد ليتر ', 4.32, 45330.00, 4.44, 601102.50, '2025-08-13 16:59:53'),
(5, NULL, 'زيت زيتون أول  2ليتر ', 8.96, 94031.25, 54.86, 576000.00, '2025-08-14 12:24:05'),
(6, NULL, 'زيت زيتون أول قياس واحد ليتر ', 4.32, 45330.00, 57.25, 601102.50, '2025-08-14 21:46:48'),
(7, NULL, 'زيت زيتون أول قياس واحد ليتر ', 4.89, 51375.00, 5.02, 679687.50, '2025-08-14 21:47:26'),
(8, NULL, 'تفاحي مكسر', 5.10, 53550.00, 52.50, 551250.00, '2025-08-14 22:15:19'),
(9, NULL, 'تفاحي مكسر', 5.12, 53760.00, 5.54, 552475.00, '2025-08-14 22:16:24'),
(10, NULL, 'تفاحي مكسر', 5.20, 54600.00, 5.62, 560875.00, '2025-08-14 22:16:50'),
(11, NULL, 'زيت زيتون أول  2ليتر ', 83.24, 874031.00, 83.37, 5255999.00, '2025-08-17 17:17:15'),
(12, NULL, 'زيتون مقطع1', 125.00, 1312500.00, 2521.00, 26470500.00, '2025-08-17 17:28:54'),
(13, NULL, 'زيتون مقطع', 125.00, 1312500.00, 2521.00, 26470500.00, '2025-08-17 17:30:35'),
(14, NULL, 'زيتون مقطع', 125.00, 1312500.00, 2521.00, 26470500.00, '2025-08-17 17:31:52'),
(15, NULL, 'زيت زيتون أول  2ليتر ', 8.96, 94031.00, 9.09, 575999.00, '2025-08-17 18:07:14'),
(16, NULL, 'زيت زيتون أول  2ليتر ', 8.96, 94031.00, 9.09, 575999.00, '2025-08-17 18:07:17'),
(17, NULL, 'زيت زيتون أول  2ليتر ', 8.96, 94080.00, 9.09, 576293.00, '2025-08-17 18:08:22'),
(18, NULL, 'زيت زيتون أول  2ليتر ', 8.96, 94080.00, 9.09, 576293.00, '2025-08-17 18:08:36'),
(19, NULL, 'زيت زيتون أول  2ليتر ', 8.96, 94080.00, 9.09, 576293.00, '2025-08-17 18:09:57'),
(20, NULL, 'زيت زيتون معبأ قياس واحد لتر', 4.56, 47928.00, 55.90, 586948.50, '2025-08-17 18:16:43'),
(21, NULL, 'تفاحي مكسر', 421.11, 4421666.67, 42212.11, 443227166.67, '2025-08-17 18:20:45'),
(22, NULL, 'زيتون مقطع2', 800.00, 8400000.00, 64081.00, 672850500.00, '2025-08-17 18:24:07'),
(23, NULL, 'زيتون مقطع2', 800.00, 8400000.00, 801.00, 672850500.00, '2025-08-17 18:24:24'),
(24, 13, 'زيتون أخضر تفاحي', 9.44, 99096.67, 9.54, 100190.42, '2025-08-17 18:25:10'),
(25, 13, 'زيتون أخضر تفاحي', 9.44, 99097.00, 9.54, 100191.00, '2025-08-17 18:26:50'),
(26, NULL, 'زيت زيتون معبأ قياس واحد لتر', 4.56, 47828.00, 4.69, 585749.00, '2025-08-17 18:29:10'),
(27, 14, 'زيتون أخضر تفاحي', 0.94, 9916.67, 12.43, 130550.00, '2025-08-17 18:42:40'),
(28, 15, 'زيتون  أخضر تفاحي ', 1.44, 15108.33, 9.73, 102200.00, '2025-08-18 06:49:31'),
(29, 16, 'زيتون ', 3.46, 36368.18, 14.95, 157022.73, '2025-08-18 06:51:07'),
(30, 17, 'زيتون أخضر جلط كالامتا', 9.48, 99516.67, 9.58, 100610.42, '2025-08-18 06:53:08'),
(31, 18, 'زيتون أخضر جلط كالامت', 0.89, 9391.67, 11.83, 124250.00, '2025-08-18 06:54:30'),
(32, 18, 'زيتون أخضر جلط كالامتا', 0.89, 9392.00, 0.99, 124254.00, '2025-08-18 06:54:40'),
(33, 14, 'زيتون أخضر تفاحي', 0.94, 9917.00, 1.04, 130554.00, '2025-08-18 06:55:07'),
(34, 16, 'زيتون أخضر تفاحي', 3.46, 36368.00, 3.56, 157022.00, '2025-08-18 06:55:43'),
(35, 19, 'زيتون أخضر جلط كالامت', 1.39, 14583.33, 17.77, 186550.00, '2025-08-18 06:56:45'),
(36, 19, 'زيتون أخضر جلط كالامتا', 1.39, 14583.00, 1.49, 186546.00, '2025-08-18 06:56:55'),
(37, 20, 'زيتون أخضر جلط كالامت', 3.00, 31500.00, 13.10, 137550.00, '2025-08-18 06:58:07'),
(38, 19, 'زيتون أخضر جلط كالامتا', 1.39, 14583.00, 1.49, 99048.00, '2025-08-18 06:58:27'),
(39, 20, 'زيتون أخضر جلط كالامت', 3.00, 31500.00, 3.10, 137550.00, '2025-08-18 06:58:37'),
(40, 21, 'زيتون سلطة بالزيت', 1.62, 16961.54, 20.48, 215088.46, '2025-08-18 07:02:18'),
(41, 22, 'زيتون أخضر مقطع', 1.18, 12357.69, 15.22, 159842.31, '2025-08-18 07:03:49'),
(42, 23, 'زيتون أسود مقطع', 1.08, 11307.69, 14.02, 147242.31, '2025-08-18 07:05:24'),
(43, 23, 'زيتون أسود مقطع', 1.08, 11308.00, 1.18, 147246.00, '2025-08-18 07:05:31'),
(44, 22, 'زيتون أخضر مقطع', 1.18, 12358.00, 1.28, 159846.00, '2025-08-18 07:05:38'),
(45, 24, 'زيتون أخضر مثقب محشو ليمون / جزر / فليفلة / زعتر ', 1.01, 10616.67, 13.23, 138950.00, '2025-08-18 07:07:22'),
(46, 24, 'زيتون أخضر مثقب محشو ليمون / جزر / فليفلة / زعتر ', 1.01, 10617.00, 1.11, 138954.00, '2025-08-18 07:07:30'),
(47, 21, 'زيتون سلطة بالزيت', 1.62, 16962.00, 1.72, 215094.00, '2025-08-18 07:07:55'),
(48, 15, 'زيتون  أخضر تفاحي ', 1.44, 15108.00, 1.54, 102198.00, '2025-08-18 07:08:05'),
(49, 25, 'زيتون أخضر تفاحي مفرغ سادة', 82.70, 868350.00, 82.70, 868350.00, '2025-08-18 10:38:34'),
(50, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(51, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(52, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(53, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(54, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(55, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(56, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(57, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(58, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(59, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(60, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(61, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(62, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(63, 38, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:31'),
(64, NULL, 'زيتون أخضر تفاحي مفقش', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-18 10:41:32'),
(65, 25, 'زيتون أخضر تفاحي مفرغ سادة', 118.06, 1239600.00, 118.06, 1239600.00, '2025-08-18 10:45:04'),
(66, 41, 'زيتون أخضر شرائخ', 126.11, 1324200.00, 126.11, 1324200.00, '2025-08-18 10:47:30'),
(67, 41, 'زيتون أخضر مقطع شرائح', 126.11, 1324200.00, 126.11, 1324200.00, '2025-08-18 10:49:45'),
(68, 42, 'زيتون أخضر جلط كالاماتا مفقش', 1.40, 14700.00, 1.40, 14700.00, '2025-08-18 10:51:00'),
(69, 42, 'زيتون أخضر جلط كالاماتا مفقش', 99.30, 1042650.00, 99.30, 1042650.00, '2025-08-18 10:51:26'),
(70, NULL, 'زيتون زيتون بلدي خام حموضة أقل من 0.7', 517.22, 5430781.58, 517.22, 5430781.58, '2025-08-18 11:12:57'),
(71, 44, 'زيتون زيتون بلدي خام حموضة أقل من 0.7', 517.22, 5430781.58, 517.22, 5430781.58, '2025-08-18 11:12:57'),
(72, NULL, 'Olive oli extra virgin 1 liter', 5.04, 52885.71, 61.57, 646441.07, '2025-08-21 14:08:33'),
(73, 46, 'زيت زيتون مذاق الشام واحد لتر ', 4.61, 48428.57, 56.72, 595580.36, '2025-08-24 08:41:00'),
(74, 47, 'زيت زيتون عجاج واحد لتر ', 4.61, 48428.57, 56.72, 595580.36, '2025-08-24 08:42:58'),
(75, 48, 'زيت زيتون مذاق الشام 500 مل ', 4.61, 48428.57, 56.72, 595580.36, '2025-08-24 08:47:15'),
(76, 48, 'زيت زيتون مذاق الشام 500 مل ', 4.60, 48328.00, 4.73, 1174310.00, '2025-08-24 08:47:30'),
(77, 48, 'زيت زيتون مذاق الشام 500 مل ', 2.43, 25527.00, 2.56, 627086.00, '2025-08-24 08:47:53'),
(78, 49, 'زيت زيتون عجاج 500 مل ', 4.61, 48428.57, 56.72, 595580.36, '2025-08-24 08:48:28'),
(79, 38, 'زيتون أخضر تفاحي مفقش 90 كغ', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-24 11:32:18'),
(80, 44, 'زيتون زيتون بلدي خام حموضة أقل من 0.7 ( 110 ) كغ', 517.22, 5430782.00, 517.22, 5430782.00, '2025-08-24 11:33:50'),
(81, 42, 'زيتون أخضر جلط كالاماتا مفقش ( 90 كغ)', 99.30, 1042650.00, 99.30, 1042650.00, '2025-08-24 11:34:08'),
(82, 41, 'زيتون أخضر مقطع شرائح ( 80 كغ )', 126.11, 1324200.00, 126.11, 1324200.00, '2025-08-24 11:35:34'),
(83, 38, 'زيتون أخضر تفاحي مفقش  ( 90 كغ )', 99.20, 1041600.00, 99.20, 1041600.00, '2025-08-24 11:35:47'),
(84, 25, 'زيتون أخضر تفاحي مفرغ سادة ( 75 كغ )', 118.06, 1239600.00, 118.06, 1239600.00, '2025-08-24 11:36:00'),
(85, 24, 'زيتون أخضر مثقب محشو ليمون / جزر / فليفلة / زعتر  ( 400 غ )', 1.01, 10617.00, 1.11, 138954.00, '2025-08-24 11:36:15'),
(86, 21, 'زيتون سلطة بالزيت ( 660 غ )', 1.72, 18028.00, 1.82, 227886.00, '2025-08-24 11:36:38'),
(87, 20, 'زيتون أخضر جلط كالامتا ( 1800 غ )', 3.00, 31500.00, 3.10, 137550.00, '2025-08-24 11:37:00'),
(88, 19, 'زيتون أخضر جلط كالامتا ( 800 غ )', 1.39, 14583.00, 1.49, 99048.00, '2025-08-24 11:37:18'),
(89, 18, 'زيتون أخضر جلط كالامتا ( 400 غ )', 0.89, 9392.00, 0.99, 124254.00, '2025-08-24 11:37:35'),
(90, 17, 'زيتون أخضر جلط كالامتا ( 7 كغ )', 9.48, 99517.00, 9.58, 100611.00, '2025-08-24 11:37:49'),
(91, 16, 'زيتون أخضر تفاحي ( 1800 غ )', 3.46, 36368.00, 3.56, 157022.00, '2025-08-24 11:38:04'),
(92, 15, 'زيتون  أخضر تفاحي  ( 800 غ )', 1.44, 15108.00, 1.54, 102198.00, '2025-08-24 11:38:16'),
(93, 14, 'زيتون أخضر تفاحي ( 400 غ )', 0.94, 9917.00, 1.04, 130554.00, '2025-08-24 11:38:30'),
(94, 13, 'زيتون أخضر تفاحي ( 7 كغ ) ', 9.44, 99097.00, 9.54, 100191.00, '2025-08-24 11:38:41'),
(95, 22, 'زيتون أخضر مقطع ( 400 غ )', 1.18, 12358.00, 1.28, 159846.00, '2025-08-24 11:38:58'),
(96, 23, 'زيتون أسود مقطع ( 400 غ )', 1.08, 11308.00, 1.18, 147246.00, '2025-08-24 11:39:09'),
(97, 50, 'لوز بلدي قلب حبة اسبانية', 15.00, 157500.00, 0.00, 0.00, '2025-08-24 11:40:29'),
(98, 50, 'لوز بلدي قلب حبة اسبانية', 15.00, 157500.00, 15.00, 157500.00, '2025-08-24 11:41:11'),
(99, 51, 'مخلل جزر بلدي', 22.70, 238350.00, 22.70, 238350.00, '2025-08-24 11:42:30'),
(100, 52, 'زيتون تفاحي مفقش حبة ناعمة ( 80 كغ )', 80.30, 843150.00, 80.30, 843150.00, '2025-08-24 11:44:42'),
(101, 49, 'زيت زيتون عجاج 500 مل ', 4.60, 48328.00, 4.73, 594374.00, '2025-08-24 11:55:43'),
(102, 53, 'زيت زيتون عجاج 5 لتر ', 22.16, 232692.86, 45.45, 477198.21, '2025-08-25 08:00:34'),
(103, 49, 'زيت زيتون عجاج 500 مل ', 2.43, 25527.00, 2.56, 627086.00, '2025-08-25 08:31:03'),
(104, 49, 'زيت زيتون عجاج 500 مل ', 2.44, 25588.00, 2.57, 628550.00, '2025-08-25 08:32:15'),
(105, 49, 'زيت زيتون عجاج 500 مل ', 2.45, 25728.00, 2.58, 631910.00, '2025-08-25 08:32:44'),
(106, 49, 'زيت زيتون عجاج 500 مل ', 2.45, 25728.00, 2.58, 631910.00, '2025-08-25 08:33:15'),
(107, 54, 'شرائح زيتون أسود', 55.00, 577500.00, 0.00, 0.00, '2025-08-26 11:20:47'),
(108, 55, 'دبس فليفلة بلدية حارة', 1.30, 13650.00, 0.00, 0.00, '2025-08-26 11:22:13'),
(109, 44, 'زيت زيتون بلدي خام حموضة أقل من 0.7 ( 110 ) كغ', 517.22, 5430782.00, 517.22, 5430782.00, '2025-08-26 11:23:56'),
(110, 56, 'زيت زيتون بلدي خام ', 73.15, 768075.00, 0.00, 0.00, '2025-08-26 11:24:45'),
(111, 49, 'زيت زيتون عجاج 500 مل ', 2.45, 25728.00, 2.58, 323174.00, '2025-08-27 14:08:55'),
(112, 56, 'زيت زيتون بلدي خام ', 73.15, 768075.00, 73.15, 768075.00, '2025-09-06 16:14:42'),
(113, 57, 'غتلا', 35.22, 369767.99, 2.00, 21000.00, '2025-09-06 16:16:04'),
(114, 20, 'زيتون أخضر جلط كالامتا ( 1800 غ )', 3.00, 31500.00, 13.10, 137550.00, '2025-09-07 11:29:48'),
(115, 58, 'يبيلبي', 3.00, 31500.00, 13.10, 137550.00, '2025-09-07 11:31:01'),
(116, 59, 'يبيلبي', 3.30, 34650.00, 24.20, 254100.00, '2025-09-08 16:11:27'),
(117, 60, 'زيت زيتون', 9.17, 96250.00, 47.83, 502250.00, '2025-09-09 13:35:55'),
(118, 61, 'زيت زيتون', 6.37, 66902.50, 42.86, 450012.50, '2025-09-09 13:37:26'),
(119, 63, 'زيت زيتون', 6.67, 70000.00, 44.33, 465500.00, '2025-09-11 11:01:06');

-- --------------------------------------------------------

--
-- Table structure for table `currencies`
--

CREATE TABLE `currencies` (
  `id` int(11) NOT NULL,
  `code` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `symbol` varchar(10) NOT NULL,
  `is_default` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `currencies`
--

INSERT INTO `currencies` (`id`, `code`, `name`, `symbol`, `is_default`, `created_at`, `updated_at`) VALUES
(1, 'USD', 'دولار أمريكي', '$', 1, '2025-08-07 15:36:40', '2025-08-07 15:36:40'),
(2, 'SYP', 'ليرة سورية', 'ل.س', 0, '2025-08-07 15:36:40', '2025-08-07 15:36:40');

-- --------------------------------------------------------

--
-- Table structure for table `exchange_rates`
--

CREATE TABLE `exchange_rates` (
  `id` int(11) NOT NULL,
  `from_currency_id` int(11) NOT NULL,
  `to_currency_id` int(11) NOT NULL,
  `rate` decimal(10,4) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `exchange_rates`
--

INSERT INTO `exchange_rates` (`id`, `from_currency_id`, `to_currency_id`, `rate`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 10500.0000, '2025-08-07 15:36:40', '2025-08-09 11:36:01');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `sample_number` varchar(50) NOT NULL,
  `supplier_or_sample_name` varchar(255) NOT NULL,
  `base_quantity` decimal(10,2) DEFAULT NULL,
  `current_quantity` decimal(10,2) DEFAULT NULL,
  `sample_weight` decimal(10,3) DEFAULT NULL,
  `net_weight_total` decimal(10,2) NOT NULL,
  `ph` decimal(4,2) DEFAULT NULL,
  `peroxide_value` decimal(10,2) DEFAULT NULL,
  `absorption_readings` varchar(255) DEFAULT NULL,
  `sigma_absorbance` decimal(10,3) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `analyst` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_rejected` tinyint(1) DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL COMMENT 'Timestamp of soft-delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`id`, `date`, `sample_number`, `supplier_or_sample_name`, `base_quantity`, `current_quantity`, `sample_weight`, `net_weight_total`, `ph`, `peroxide_value`, `absorption_readings`, `sigma_absorbance`, `notes`, `analyst`, `created_at`, `updated_at`, `is_rejected`, `deleted_at`) VALUES
(129, '2025-06-19', '0', 'تصافي زيت الزيتون ', 51.00, 0.00, 0.100, 816.00, 1.00, 28.00, '2.693 0.286 0.279 0.263 0.005', NULL, 'تنك ', 'م . زاهر عبد الكريم صبوح ', '2025-06-19 09:36:24', '2025-06-26 07:46:26', 0, NULL),
(130, '2025-06-19', '1147', 'سالم ابراهيم المحمد ', 24.00, 0.00, 0.100, 384.00, 1.55, 45.00, '2.756 0.390 0.399 0.383 0.013', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 09:39:41', '2025-06-25 06:08:00', 0, NULL),
(131, '2025-06-19', '1162', 'حكيم ناصر ', 200.00, 0.00, 0.100, 3202.92, 2.80, 16.00, '1.886 0.155 0.157 0.143 0.003', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 09:40:50', '2025-06-25 06:08:00', 0, NULL),
(132, '2025-06-19', '1170', 'قاسم مسعف الحاج اعرابي', 30.00, 0.00, 0.100, 479.55, 1.55, 28.50, '2.467 0.202 0.198 0.191 0.002', NULL, 'بيدون / مقلوب لتنك بالمستودع', 'محمد خالد عثمانلي ', '2025-06-19 09:42:39', '2025-06-21 15:18:34', 0, NULL),
(133, '2025-06-19', '1171', 'سالم ابراهيم المحمد ', 166.00, 0.00, 0.100, 2659.00, 0.50, 12.00, '2.038 0.220 0.212 0.202 0.001', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 09:44:31', '2025-06-22 12:52:26', 0, NULL),
(134, '2025-06-19', '1172', 'سالم ابراهيم المحمد ', 303.00, 0.00, 0.100, 4827.20, 0.65, 18.00, '2.244 0.192 0.185 0.173 0.002', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 09:45:56', '2025-06-25 06:08:00', 0, NULL),
(135, '2025-06-19', '1173', 'سالم ابراهيم المحمد ', 31.00, 0.00, NULL, 493.50, 1.80, 18.00, '2.719 0.376 0.380 0.360 0.013', NULL, 'تنك  علام اسود ', 'محمد خالد عثمانلي ', '2025-06-19 09:48:26', '2025-08-06 14:12:47', 0, NULL),
(136, '2025-06-19', '1174', 'حسن بدر ', 174.00, 0.00, 0.100, 2785.50, 0.70, 18.00, '2.061 0.195 0.180 0.171 -0.03', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 09:51:00', '2025-06-25 06:08:00', 0, NULL),
(137, '2025-06-19', '1175', 'معصرة العديل', 156.00, 0.00, 0.100, 2506.60, 0.50, 12.00, '1.900 0.184 0.171 0.166 -0.004', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 09:56:54', '2025-06-26 09:46:28', 0, NULL),
(138, '2025-06-19', '1178', 'محمود نورس الأبراهيم', 178.00, 0.00, 0.100, 2848.00, 1.40, 13.00, '1.937 0.168 0.156 0.146 -0.001', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 09:58:27', '2025-06-21 15:09:00', 0, NULL),
(139, '2025-06-19', '1179', 'محمود نورس الأبراهيم', 22.00, 0.00, 0.100, 354.00, 2.45, 17.00, '2.418 0.263 0.256 0.242 0.003', NULL, 'تنك من فرز العينة 1178 عدد 200', 'محمد خالد عثمانلي ', '2025-06-19 10:00:40', '2025-06-21 15:18:34', 0, NULL),
(140, '2025-06-19', '1180', 'غسان عبدالحميد عودة ', 247.00, 0.00, 0.100, 3959.40, 0.70, 11.50, '1.838 0.159 0.157 0.152 0.001', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 10:02:05', '2025-06-25 06:08:00', 0, NULL),
(141, '2025-06-19', '1181', 'غسان عبدالحميد عودة', 222.00, 0.00, 0.100, 3550.60, 1.25, 21.00, '1.845 0.167 0.163 0.155 0.002', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 10:03:50', '2025-06-21 15:09:00', 0, NULL),
(142, '2025-06-19', '1182', 'سالم ابراهيم المحمد ', 250.00, 0.00, 0.100, 3977.50, 0.75, 12.50, '2.188 0.177 0.164 0.154 -0.001', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 10:05:10', '2025-06-25 06:08:00', 0, NULL),
(143, '2025-06-19', '1183', 'سالم ابراهيم المحمد ', 250.00, 0.00, 0.102, 3977.50, 0.70, 15.50, '2.107 0.172 0.161 0.151 -0.001', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 10:06:31', '2025-06-25 06:08:00', 0, NULL),
(144, '2025-06-19', '1184', 'ميشيل سليم زيود ', 39.00, 0.00, 0.100, 621.10, 0.75, 23.00, '2.642 0.213 0.202 0.190 0.000', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 10:07:37', '2025-06-25 06:08:00', 0, NULL),
(145, '2025-06-19', '1185', 'سالم ابراهيم المحمد ', 250.00, 0.00, 0.100, 3997.66, 0.70, 17.00, '2.116 0.188 0.174 0.163 -0.002', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 10:08:40', '2025-06-25 06:08:00', 0, NULL),
(146, '2025-06-19', '1186', 'سالم ابراهيم المحمد ', 232.00, 0.00, 0.100, 3709.83, 0.65, 15.00, '2.092 0.196 0.185 0.174 0.000', NULL, 'تنك العدد الاساسي 250 رفض 18 تنكة ', 'محمد خالد عثمانلي ', '2025-06-19 10:10:59', '2025-06-25 06:08:00', 0, NULL),
(147, '2025-06-19', '1187', 'سالم ابراهيم المحمد ', 18.00, 0.00, 0.100, 288.00, 0.80, 20.00, '2.561 0.342 0.348 0.333 0.011', NULL, 'تنك مفروز من الزمة 1186 ( مرفوض مرتجع )', 'محمد خالد عثمانلي ', '2025-06-19 10:13:12', '2025-09-02 12:57:36', 1, NULL),
(148, '2025-06-19', '1188', 'محمد حسام الأبراهيم', 266.00, 0.00, 0.100, 4251.30, 0.75, 18.00, '1.963 0.153 0.146 0.139 0.000', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 10:15:11', '2025-06-25 06:08:00', 0, NULL),
(155, '2025-06-19', '1189', 'محمد حسام الابراهيم', 208.00, 0.00, 0.100, 3314.80, 0.70, 10.50, '1.963 0.153 0.146 0.139 0.000', NULL, '190تنك+18بيدون', 'محمد خالد العثمانلي', '2025-06-19 13:37:55', '2025-06-25 06:08:00', 0, NULL),
(156, '2025-06-19', '1190', 'محمود نورس الأبراهيم', 158.00, 0.00, 0.100, 2542.00, 1.35, 19.00, '2.108 0.255 0.247 0.240 -0.001', 0.030, 'تنك', 'محمد خالد العثمانلي', '2025-06-19 13:43:14', '2025-06-26 09:46:28', 0, NULL),
(157, '2025-06-19', '1191', 'محمود نورس الأبراهيم', 42.00, 0.00, 0.100, 1.00, 3.10, NULL, '2.602 0.320 0.320 0.305 0.007', NULL, 'تنك ', 'محمد خالد العثمانلي', '2025-06-19 13:45:02', '2025-09-02 12:57:36', 1, NULL),
(158, '2025-06-19', '1192', 'سالم المحمد', 101.00, 0.00, 0.102, 1610.40, 1.45, 17.50, '2.221 0.248 0.236 0.224 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-06-19 13:49:25', '2025-06-21 15:18:34', 0, NULL),
(159, '2025-06-19', '1193', 'سالم ابراهيم المحمد ', 37.00, 0.00, 0.101, 1.00, 0.90, NULL, '2.158 0.246 0.248 0.224 0.013', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 14:01:11', '2025-09-02 12:57:36', 1, NULL),
(160, '2025-06-19', '1194', 'سالم ابراهيم المحمد ', 315.00, 0.00, 0.100, 5042.30, 0.80, 16.00, '2.125 0.207 0.193 0.183 -0.003', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 14:02:31', '2025-06-25 06:08:00', 0, NULL),
(161, '2025-06-19', '1195', 'سالم ابراهيم المحمد ', 47.00, 0.00, 0.100, 807.90, 0.60, 29.50, '2.686 0.240 0.222 0.208 -0.002', NULL, 'بيدون', 'محمد خالد عثمانلي ', '2025-06-19 14:03:44', '2025-06-25 06:08:00', 0, NULL),
(162, '2025-06-19', '1196', 'مهدي العادل', 230.00, 0.00, 0.100, 3679.80, 0.75, 14.00, '2.044 0.163 0.156 0.152 -0.001', NULL, '222تنك+8بيدون', 'محمد خالد عثمانلي ', '2025-06-19 14:06:30', '2025-08-06 14:12:47', 0, NULL),
(163, '2025-06-19', '1197', 'مهدي العادل', 207.00, 0.00, 0.100, 3306.90, 1.10, 14.50, '2.041 0.173 0.167 0.162 -0.001', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 14:08:32', '2025-06-22 12:52:26', 0, NULL),
(164, '2025-06-19', '1198', 'محمد حسام الأبراهيم', 108.00, 0.00, 0.100, 1721.00, 0.50, 14.00, '2.072 0.177 0.159 0.149 -0.004', NULL, 'تنك95+13بيدون', 'م . زاهر عبد الكريم صبوح ', '2025-06-19 14:10:03', '2025-06-26 09:46:28', 0, NULL),
(167, '2025-06-21', '1199', 'نورس حماد ', 61.00, 0.00, 0.103, 976.75, 1.80, 25.50, '2.587 0.200 0.195 0.187 0.002', NULL, 'بيدون أبيض سعة 16 كغ', 'م.زاهر عبدالكريم صبوح', '2025-06-21 08:17:33', '2025-08-06 14:12:47', 0, NULL),
(168, '2025-06-22', '1200', 'مهدي العادل', 72.00, 0.00, 0.103, 1150.50, 0.65, 11.50, '1.871 0.145 0.137 0.133 -0.002', NULL, 'تنك', 'م.زاهر عبدالكريم صبوح', '2025-06-22 10:10:34', '2025-06-23 05:33:37', 0, NULL),
(169, '2025-06-23', '1201', 'قتيبة شيخ نجار', 187.00, 0.00, 0.102, 2989.20, 0.70, 15.00, '2.094 0.165 0.148 0.138 -0.003', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-06-23 12:00:22', '2025-06-26 09:46:28', 0, NULL),
(170, '2025-06-23', '1202', 'محمود نورس', 99.00, 0.00, 0.100, 1584.95, 0.80, 29.00, '2.537 0.164 0.160 0.156 0.000', NULL, 'بيدون', 'م . زاهر عبد الكريم صبوح ', '2025-06-23 12:37:20', '2025-06-26 09:46:28', 0, NULL),
(171, '2025-06-23', '1203', 'محمود نورس', 107.00, 0.00, 0.100, 1711.00, 0.90, 9.50, '1.796 0.140 0.134 0.131 -0.001', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-06-23 12:39:10', '2025-06-26 09:46:28', 0, NULL),
(172, '2025-06-23', '1204', 'محمود نورس', 184.00, 0.00, 0.100, 2941.60, 0.70, 13.00, '2.070 0.199 0.184 0.174 -0.002', NULL, '182تنك+2بيدون', 'م . زاهر عبد الكريم صبوح ', '2025-06-23 13:49:35', '2025-06-26 09:46:28', 0, NULL),
(173, '2025-06-23', '1205', 'محمود نورس', 2.00, 0.00, 0.100, 32.00, 0.65, 13.00, '2.113 0.246 0.242 0.234 0.002', NULL, 'تنك فرز', 'م . زاهر عبد الكريم صبوح ', '2025-06-23 14:01:28', '2025-06-26 09:46:28', 0, NULL),
(174, '2025-06-25', '1206', 'علي قنيني', 198.00, 0.00, 0.100, 3154.16, 1.20, 13.50, '1.954 0.148 0.142 0.135 0.000', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-06-25 07:07:54', '2025-06-26 08:23:03', 0, NULL),
(175, '2025-06-25', '1207', 'علي قنيني', 210.00, 0.00, 0.100, 3345.33, 1.40, 13.00, '1.963 0.176 0.170 0.161 0.001', NULL, '', 'م . زاهر عبد الكريم صبوح ', '2025-06-25 07:09:46', '2025-06-26 08:23:03', 0, NULL),
(176, '2025-06-25', '1208', 'علاء أباظة', 250.00, 0.00, 0.099, 3991.51, 1.55, 19.00, '2.047 0.168 0.160 0.152 0.000', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-06-25 13:11:51', '2025-06-26 13:07:45', 0, NULL),
(177, '2025-06-25', '1209', 'علاء أباظة', 239.00, 0.00, 0.099, 3815.88, 1.70, 21.00, '2.047 0.159 0.150 0.141 0.000', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-06-25 13:13:28', '2025-06-26 13:08:08', 0, NULL),
(178, '2025-06-25', '1210', 'علاء أباظة', 11.00, 0.00, 0.105, 176.00, 3.00, 19.00, '2.508 0.308 0.313 0.295 0.011', NULL, 'تنك فرز', 'م . زاهر عبد الكريم صبوح ', '2025-06-25 13:14:46', '2025-08-07 07:47:39', 0, NULL),
(179, '2025-06-26', '0', 'تصافي زمة 2', 9.00, 0.00, 0.101, 144.00, 1.30, NULL, '2.785 0.317 0.306 0.287 0.004', NULL, 'تصافي تنك ', 'محمد خالد العثمانلي', '2025-06-26 07:48:13', '2025-06-26 08:23:03', 0, NULL),
(181, '2025-06-26', '1211', 'حكيم ناصر', 250.00, 0.00, 0.100, 3988.00, 1.45, 19.00, '1.862 0.158 0.151 0.144 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-06-26 07:56:38', '2025-06-28 09:03:58', 0, NULL),
(182, '2025-06-26', '1212', 'حكيم ناصر', 221.00, 0.00, 0.101, 3526.14, 1.30, 16.50, '1.914 0.165 0.157 0.148 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-06-26 07:57:47', '2025-06-28 09:03:58', 0, NULL),
(183, '2025-06-26', '1213', 'حكيم ناصر', 39.00, 0.00, 0.102, 622.26, 3.20, 18.50, '2.290 0.308 0.314 0.297 0.011', NULL, 'تنك فرز طعمة سيئة ', 'محمد خالد العثمانلي', '2025-06-26 07:58:53', '2025-06-28 09:03:58', 0, NULL),
(184, '2025-06-28', '1214', 'نورس الحماد', 65.00, 0.00, 0.099, 1041.65, 1.85, 28.00, '2.437 0.204 0.203 0.195 0.004', NULL, 'بيدون', 'م . زاهر عبد الكريم صبوح ', '2025-06-28 07:12:32', '2025-07-15 13:50:36', 0, NULL),
(185, '2025-06-28', '1215', 'حسن البدر', 85.00, 0.00, 0.103, 1360.30, 1.20, 16.50, '2.181 0.203 0.194 0.183 0.001', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-06-28 13:03:15', '2025-08-06 14:12:47', 0, NULL),
(186, '2025-06-29', '1217', 'سالم المحمد', 230.00, 0.00, 0.100, 3674.44, 0.50, 13.50, '2.073 0.190 0.174 0.164 -0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-06-29 10:08:46', '2025-07-02 11:02:09', 0, NULL),
(187, '2025-06-29', '1218', 'سالم المحمد', 211.00, 0.00, 0.101, 3369.67, 0.60, 14.00, '2.058 0.170 0.157 0.150 -0.003', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-06-29 11:06:35', '2025-07-02 11:02:09', 0, NULL),
(188, '2025-06-29', '1219', 'سالم المحمد', 35.00, 0.00, 0.103, 692.60, 0.40, 21.00, '2.393 0.218 0.203 0.189 0.000', NULL, 'جركل', 'م . زاهر عبد الكريم صبوح ', '2025-06-29 11:07:43', '2025-07-02 11:02:09', 0, NULL),
(189, '2025-06-29', '1220', 'سالم المحمد', 23.00, 0.00, 0.102, 367.31, 1.20, 19.50, '2.179 0.221 0.210 0.197 0.001', NULL, 'فرز جركل عدد1+ تنك عدد22', 'م . زاهر عبد الكريم صبوح ', '2025-06-29 11:09:08', '2025-07-02 11:02:09', 0, NULL),
(190, '2025-06-29', '1221', 'سالم المحمد', 1.00, 0.00, 0.103, 21.80, 0.40, 19.00, '2.174 0.193 0.174 0.162 -0.003', NULL, 'جركل عدد 1 طعمة ورائحة سيئة (مازوت)', 'م . زاهر عبد الكريم صبوح ', '2025-06-29 11:13:01', '2025-07-02 11:02:09', 0, NULL),
(191, '2025-06-30', '1222', 'محمد حسام الابراهيم', 72.00, 0.00, 0.100, 1154.90, 0.40, 7.00, '1.770 0.138 0.131 0.128 -0.003', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-06-30 11:01:16', '2025-07-02 11:02:09', 0, NULL),
(192, '2025-06-30', '1223', 'محمد حسام الابراهيم', 139.00, 0.00, 0.108, 2217.85, 0.70, 17.50, '2.390 0.149 0.141 0.137 -0.002', NULL, 'بيدون', 'م . زاهر عبد الكريم صبوح ', '2025-06-30 11:02:19', '2025-06-30 14:02:41', 0, NULL),
(193, '2025-07-01', '1224', 'مصطفى الابراهيم', 141.00, 0.00, 0.100, 2258.15, 1.75, 28.50, '2.251 0.178 0.176 0.171 0.002', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-01 12:37:42', '2025-07-02 11:02:09', 0, NULL),
(194, '2025-07-01', '1225', 'محمود نورس', 250.00, 0.00, 0.104, 3987.75, 0.75, 13.00, '2.199 0.202 0.188 0.177 -0.002', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-07-01 14:36:14', '2025-07-02 11:02:09', 0, NULL),
(195, '2025-07-01', '1226', 'محمود نورس', 230.00, 0.00, 0.100, 3668.73, 0.75, 13.00, '2.075 0.180 0.165 0.158 -0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-01 15:47:17', '2025-07-02 11:02:09', 0, NULL),
(196, '2025-07-01', '1227', 'محمود نورس', 20.00, 0.00, 0.100, 319.02, 2.25, 18.50, '2.282 0.280 0.276 0.259 0.007', NULL, 'تنك فرز طعمة ورائحة سيئة', 'محمد خالد العثمانلي', '2025-07-01 15:49:52', '2025-07-02 11:02:09', 0, NULL),
(197, '2025-07-02', '1228', 'ابراهيم أبو ياسر', 160.00, 0.00, 0.100, 2560.00, 0.80, 13.00, '1.951 0.172 0.161 0.154 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-02 11:31:55', '2025-07-27 08:44:35', 0, NULL),
(198, '2025-07-03', '1229', 'غسان عبد الحميد عودة', 140.00, 0.00, 0.100, 2238.50, 0.80, 12.00, '1.786 0.155 0.149 0.144 0.000', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-07-03 12:53:27', '2025-07-14 07:40:09', 0, NULL),
(199, '2025-07-03', '1230', 'غسان عبد الحميد عودة', 60.00, 0.00, 0.099, 963.80, 1.60, 12.50, '1.880 0.172 0.168 0.163 0.000', NULL, '', 'م . زاهر عبد الكريم صبوح ', '2025-07-03 12:54:45', '2025-07-15 13:50:36', 0, NULL),
(200, '2025-07-03', '1231', 'محمد حسام الابراهيم', 62.00, 0.00, 0.100, 989.60, 0.60, 11.00, '2.017 0.161 0.154 0.145 0.001', NULL, 'تنك (اللون خفيف )درعا ', 'محمد خالد العثمانلي', '2025-07-03 13:56:12', '2025-07-05 13:58:50', 0, NULL),
(201, '2025-07-03', '1232', 'محمد حسام الابراهيم', 10.00, 0.00, 0.100, 160.50, 0.85, 9.50, '1.840 0.151 0.138 0.129 -0.003', NULL, 'تنك (اللون خفيف ) درعا', 'محمد خالد العثمانلي', '2025-07-03 13:57:13', '2025-07-05 13:58:50', 0, NULL),
(202, '2025-07-03', '1233', 'محمد حسام الابراهيم', 111.00, 0.00, 0.100, 1765.22, 0.50, 23.50, '2.175 0.164 0.164 0.160 0.002', NULL, 'بدون', 'محمد خالد العثمانلي', '2025-07-03 14:18:38', '2025-07-27 14:34:17', 0, NULL),
(203, '2025-07-03', '1234', 'محمد حسام الابراهيم', 11.00, 0.00, 0.100, 174.93, 0.50, 23.50, '2.149 0.146 0.146 0.145 0.001', NULL, 'بدون فرز', 'م . زاهر عبد الكريم صبوح ', '2025-07-03 14:21:24', '2025-07-05 13:58:50', 0, NULL),
(204, '2025-07-03', '1235', 'ابراهيم الياسر', 156.00, 0.00, 0.100, 2487.70, 0.90, 13.00, '2.166 0.213 0.200 0.188 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-03 14:25:24', '2025-07-27 14:34:17', 0, NULL),
(205, '2025-07-05', '1236', 'محمود نورس', 80.00, 0.00, 0.099, 1715.30, 0.50, 18.50, '1.985 0.153 0.148 0.143 0.001', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-05 06:45:12', '2025-07-27 14:34:17', 0, NULL),
(206, '2025-07-05', '1237', 'محمود نورس', 227.00, 0.00, 0.100, 3627.86, 0.70, 13.00, '1.916 0.168 0.158 0.148 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-05 06:46:06', '2025-07-05 13:58:50', 0, NULL),
(207, '2025-07-05', '1238', 'محمود نورس', 9.00, 0.00, 0.101, 143.83, 0.60, 15.00, '1.901 0.138 0.128 0.120 -0.001', NULL, 'تنك فرز رائحة سيئة', 'محمد خالد العثمانلي', '2025-07-05 06:47:32', '2025-07-05 13:58:50', 0, NULL),
(208, '2025-07-05', '1239', 'نورس حماد ', 67.00, 0.00, 0.100, 1073.55, 1.80, 26.00, '2.209 0.170 0.166 0.159 0.002', NULL, 'بيدون ', 'محمد خالد العثمانلي', '2025-07-05 06:48:41', '2025-07-15 13:50:36', 0, NULL),
(209, '2025-07-07', '1240', 'أبراهيم أبو ياسر', 154.00, 0.00, 0.100, 2459.20, 0.55, 13.50, '2.132 0.204 0.190 0.178 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-07 08:45:52', '2025-07-27 14:34:17', 0, NULL),
(210, '2025-07-07', '1241', 'أبراهيم أبو ياسر', 2.00, 0.00, 0.101, 1.00, 1.00, 1.00, '2.934 0.693 0.729 0.698 0.034', NULL, 'أسيد بيروكسيد غير محلل تنك فرز', 'محمد خالد العثمانلي', '2025-07-07 08:47:01', '2025-09-02 12:57:36', 1, NULL),
(211, '2025-07-07', '1242', 'محمود نورس', 47.00, 0.00, 0.100, 755.00, 0.80, 1.80, '2.228 0.151 0.156 0.154 0.003', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-07 13:10:08', '2025-07-27 14:34:17', 0, NULL),
(212, '2025-07-09', '1243', 'عبدالرزاق نصر', 50.00, 0.00, 0.100, 803.50, 0.40, 9.50, '1.780 0.168 0.161 0.158 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-09 07:42:18', '2025-08-14 11:38:22', 0, NULL),
(213, '2025-07-10', '1244', 'علاء أباظة', 332.00, 0.00, 0.100, 1.00, 1.75, 18.50, '2.270 0.221 0.215 0.204 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-10 11:49:32', '2025-09-02 12:57:36', 1, NULL),
(214, '2025-07-10', '1245', 'حكيم ناصر', 250.00, 0.00, 0.100, 3983.80, 1.70, 28.50, '2.066 0.186 0.181 0.173 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-10 12:46:32', '2025-09-02 12:57:36', 1, NULL),
(215, '2025-07-10', '1246', 'حكيم ناصر', 241.00, 0.00, 0.100, 3837.00, 2.15, 30.00, '2.188 0.211 0.208 0.198 0.004', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-10 13:12:44', '2025-09-02 12:57:36', 1, NULL),
(216, '2025-07-12', '1247', 'نورس الحماد', 86.00, 0.00, 0.100, 1375.20, 2.65, 32.00, '2.401 0.207 0.202 0.190 0.004', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-12 08:52:38', '2025-07-14 07:40:09', 0, NULL),
(217, '2025-07-12', '1248', 'محمد صلاح العمر', 125.00, 0.00, 0.100, 1994.10, 0.85, 14.00, '2.001 0.180 0.172 0.164 0.000', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-07-12 10:10:12', '2025-08-06 14:12:47', 0, NULL),
(218, '2025-07-12', '1249', 'محمد صلاح العمر', 125.00, 0.00, 0.100, 2001.20, 0.85, 13.00, '2.024 0.194 0.186 0.180 -0.001', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-07-12 11:44:11', '2025-07-27 14:34:17', 0, NULL),
(219, '2025-07-12', '1250', 'قاسم عرابي', 134.00, 0.00, 0.101, 2141.10, 0.70, 12.50, '2.042 0.204 0.194 0.187 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-12 12:50:57', '2025-07-27 14:34:17', 0, NULL),
(220, '2025-07-12', '1251', 'قاسم عرابي', 12.00, 0.00, 0.100, 192.00, 0.50, 17.00, '1.994 0.159 0.152 0.146 0.000', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-12 14:07:00', '2025-07-27 14:34:17', 0, NULL),
(221, '2025-07-12', '1252', 'قاسم عرابي', 21.00, 0.00, 0.100, 331.55, 1.20, 17.50, '2.236 0.199 0.193 0.184 0.002', NULL, '', 'محمد خالد العثمانلي', '2025-07-12 14:10:07', '2025-07-14 07:40:09', 0, NULL),
(222, '2025-07-12', '1253', 'محمد صلاح العمر', 75.00, 0.00, 0.101, 1199.60, 0.85, 15.00, '1.890 0.168 0.160 0.153 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-12 14:11:25', '2025-07-14 07:40:09', 0, NULL),
(223, '2025-07-13', '1254', 'الشرق الأدنى', 500.00, 0.00, 0.102, 8050.00, 1.70, 26.00, '2.780 0.280 0.278 0.260 0.008', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-07-13 07:54:52', '2025-07-14 07:40:09', 0, NULL),
(224, '2025-07-13', '1255', 'محمد حسام الابراهيم', 256.00, 0.00, 0.100, 4094.40, 1.55, 10.50, '2.018 0.176 0.171 0.162 0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-13 12:02:36', '2025-07-14 07:40:09', 0, NULL),
(225, '2025-07-13', '1256', 'محمد حسام الابراهيم', 11.00, 0.00, 0.101, 1.00, 1.00, NULL, '2.491 0.287 0.286 0.272 0.007', NULL, 'تنك فرز رفض (تحليل الاسيد وهمي)', 'محمد خالد العثمانلي', '2025-07-13 12:09:10', '2025-09-02 12:57:36', 1, NULL),
(226, '2025-07-13', '1257', 'محمد حسام الابراهيم', 98.00, 0.00, 0.101, 1554.50, 1.50, 30.50, '2.046 0.150 0.150 0.145 0.003', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-13 12:48:14', '2025-07-14 13:07:41', 0, NULL),
(227, '2025-07-13', '1258', 'محمد حسام الابراهيم', 53.00, 0.00, 0.100, 849.90, 1.60, 13.50, '1.846 0.133 0.130 0.122 0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-13 12:50:24', '2025-07-14 07:40:09', 0, NULL),
(228, '2025-07-13', '1259', 'الشرق الأدنى', 500.00, 0.00, 0.100, 8020.00, 1.70, 25.50, '2.674 0.256 0.254 0.239 0.006', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-13 13:36:01', '2025-07-27 08:44:35', 0, NULL),
(229, '2025-07-13', '1260', 'الشرق الأدنى', 148.00, 0.00, 0.101, 2357.00, 2.05, 23.50, '2.707 0.294 0.293 0.276 0.007', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-13 13:57:03', '2025-07-14 07:40:09', 0, NULL),
(230, '2025-07-14', '1261', 'الشرق الأدنى', 500.00, 0.00, 0.100, 7995.00, 0.80, 17.00, '2.320 0.203 0.193 0.186 -0.001', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-07-14 10:51:38', '2025-07-15 08:31:12', 0, NULL),
(231, '2025-07-14', '1262', 'الشرق الأدنى', 465.00, 0.00, 0.100, 7445.00, 1.15, 17.50, '2.206 0.197 0.188 0.179 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-14 13:03:41', '2025-07-15 08:31:12', 0, NULL),
(232, '2025-07-15', '1263', 'نورس الحماد', 46.00, 0.00, 0.101, 738.70, 2.35, 28.50, '2.502 0.206 0.202 0.194 0.003', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-15 06:52:51', '2025-08-06 14:12:47', 0, NULL),
(233, '2025-07-26', '1264', 'الشرق الأدنى', 1415.00, 0.00, 0.100, 22650.00, 0.95, 18.50, '2.257 0.170 0.163 0.153 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-26 11:58:30', '2025-07-26 12:01:53', 0, NULL),
(234, '2025-07-28', '1265', 'نورس الحماد', 46.00, 0.00, 0.100, 734.10, 2.10, 37.00, '2.578 0.208 0.203 0.194 0.002', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-28 06:49:09', '2025-08-07 11:15:29', 0, NULL),
(235, '2025-07-28', '1268', 'تجميع الخزانات', 89.50, 0.00, 0.101, 1430.00, 1.55, 21.50, '2.581 0.236 0.230 0.219 0.003', NULL, '13 برميل وزن 110 كغ', 'محمد خالد عثمانلي ', '2025-07-28 12:40:39', '2025-07-29 15:06:25', 0, NULL),
(236, '2025-07-28', '1266', 'محمود نورس الأبراهيم', 99.00, 0.00, 0.101, 1582.40, 1.25, 12.50, '1.680 0.169 0.172 0.169 0.003', NULL, '', 'محمد خالد عثمانلي ', '2025-07-28 12:44:14', '2025-07-29 14:38:03', 0, NULL),
(237, '2025-07-28', '1267', 'محمود نورس الأبراهيم', 56.00, 0.00, 0.100, 896.50, 1.95, 24.50, '2.437 0.178 0.173 0.165 0.001', NULL, 'بيدون', 'محمد خالد عثمانلي ', '2025-07-28 12:46:21', '2025-07-29 14:38:03', 0, NULL),
(238, '2025-07-29', '0', 'تصافي ذمة 3', 42.00, 0.00, 0.102, 672.00, 1.35, 31.50, '2.846 0.435 0.430 0.404 0.010', NULL, 'تصافي ذمة 3', 'محمد خالد العثمانلي', '2025-07-29 14:24:00', '2025-08-26 11:43:51', 0, NULL),
(239, '2025-07-29', '1269', 'علاء أباظة', 106.00, 0.00, 0.100, 1694.00, 0.70, 14.00, '2.046 0.153 0.142 0.134 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-29 15:43:48', '2025-08-07 07:47:39', 0, NULL),
(240, '2025-07-29', '1270', 'علاء أباظة', 120.00, 0.00, 0.101, 1918.00, 1.50, 19.50, '2.149 0.177 0.176 0.168 0.003', NULL, 'تنك116+4بيدون', 'محمد خالد العثمانلي', '2025-07-29 15:44:47', '2025-08-07 11:15:29', 0, NULL),
(241, '2025-07-29', '1271', 'علاء أباظة', 100.00, 0.00, 0.100, 1598.00, 1.15, 16.00, '2.030 0.178 0.178 0.171 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-29 15:46:00', '2025-07-30 10:33:11', 0, NULL),
(242, '2025-07-30', '1272', 'ابراهيم أبو ياسر', 186.00, 0.00, 0.101, 2964.50, 0.80, 14.00, '2.163 0.197 0.189 0.177 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-30 14:46:05', '2025-08-07 07:47:39', 0, NULL),
(243, '2025-07-31', '1273', 'ابراهيم أبو ياسر', 158.00, 0.00, 0.100, 2526.40, 0.80, 10.00, '1.974 0.190 0.172 0.163 -0.004', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-31 13:11:12', '2025-08-07 07:47:39', 0, NULL),
(244, '2025-07-31', '1274', 'ابراهيم أبو ياسر', 6.00, 0.00, 0.100, 95.50, 0.65, 11.00, '1.956 0.206 0.192 0.183 -0.002', NULL, 'تنك فرز', 'محمد خالد العثمانلي', '2025-07-31 13:12:22', '2025-08-07 07:47:39', 0, NULL),
(245, '2025-07-31', '1275', 'محمود نورس', 180.00, 0.00, 0.100, 2878.80, 0.80, 11.50, '1.871 0.130 0.125 0.121 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-31 13:23:36', '2025-08-06 13:12:47', 0, NULL),
(246, '2025-07-31', '1276', 'ابراهيم أبو ياسر', 118.00, 0.00, 0.100, 1863.50, 1.70, 15.00, '2.030 0.147 0.145 0.137 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-31 13:54:13', '2025-08-07 11:15:29', 0, NULL),
(247, '2025-07-31', '1277', 'ابراهيم أبو ياسر', 20.00, 0.00, 0.101, 339.70, 2.20, 33.00, '2.603 0.176 0.176 0.169 0.004', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-31 13:56:08', '2025-08-07 07:47:39', 0, NULL),
(248, '2025-08-02', '1278', 'محمد حسام الابراهيم', 230.00, 0.00, 0.100, 3709.00, 0.70, 11.50, '1.837 0.133 0.130 0.126 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-02 07:18:33', '2025-08-07 07:47:39', 0, NULL),
(249, '2025-08-02', '1279', 'محمد حسام الابراهيم', 60.00, 0.00, 0.100, 913.00, 1.15, 14.00, '2.077 0.176 0.170 0.164 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-02 07:20:24', '2025-08-07 07:47:39', 0, NULL),
(250, '2025-08-02', '1280', 'ابراهيم أبو ياسر', 107.00, 0.00, 0.100, 1712.00, 0.80, 12.00, '2.007 0.196 0.185 0.176 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-02 08:07:11', '2025-08-07 07:47:39', 0, NULL),
(251, '2025-08-02', '1281', 'ابراهيم أبو ياسر', 69.00, 0.00, 0.100, 1097.00, 0.95, 23.50, '2.303 0.165 0.163 0.160 0.001', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-08-02 08:22:28', '2025-08-07 07:47:39', 0, NULL),
(252, '2025-08-02', '1282', 'نورس الحماد', 120.00, 0.00, 0.101, 1920.80, 0.80, 18.00, '2.216 0.155 0.157 0.154 0.002', NULL, 'بيدون', 'محمد حالد العثمانلي', '2025-08-02 09:09:56', '2025-08-07 07:47:39', 0, NULL),
(253, '2025-08-02', '1283', 'ابراهيم أبو ياسر', 191.00, 0.00, 0.100, 3051.60, 0.45, 11.50, '2.047 0.177 0.163 0.156 -0.004', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-02 14:04:53', '2025-08-14 11:38:22', 0, NULL),
(254, '2025-08-03', '1284', 'محمد حسام الابراهيم', 200.00, 0.00, 0.100, 3203.40, 1.05, 10.50, '1.718 0.149 0.145 0.139 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-03 07:43:09', '2025-08-07 07:47:39', 0, NULL),
(255, '2025-08-03', '1285', 'حسن البدر', 195.00, 0.00, 0.104, 3120.20, 1.10, 13.00, '2.202 0.225 0.217 0.206 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-03 10:02:08', '2025-08-07 13:32:27', 0, NULL),
(256, '2025-08-03', '1286', 'حسن البدر', 3.00, 0.00, NULL, 48.50, 1.00, 1.00, '2.702 0.734 0.768 0.730 0.036', NULL, 'تنك فرز', 'محمد خالد العثمانلي', '2025-08-03 10:03:30', '2025-09-02 12:57:36', 1, NULL),
(257, '2025-08-03', '1287', 'ابراهيم أبو ياسر', 174.00, 0.00, 0.100, 2774.60, 0.80, 15.50, '2.006 0.147 0.140 0.134 0.000', NULL, '170تنك+4بيدون', 'محمد خالد العثمانلي', '2025-08-03 10:04:48', '2025-08-07 07:47:39', 0, NULL),
(258, '2025-08-03', '1288', 'حكيم ناصر', 250.00, 0.00, 0.101, 3976.80, 0.60, 13.50, '1.987 0.151 0.141 0.135 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-03 17:23:45', '2025-08-05 05:52:18', 0, NULL),
(259, '2025-08-03', '1289', 'حكيم ناصر', 241.00, 0.00, 0.111, 3857.50, 0.90, 13.50, '1.945 0.142 0.138 0.133 0.000', NULL, 'تنك', 'محمد عجاج', '2025-08-03 17:25:14', '2025-08-05 05:52:18', 0, NULL),
(260, '2025-08-03', '1290', 'حكيم ناصر', 10.00, 0.00, 0.096, 160.00, 2.55, 13.00, '1.802 0.218 0.225 0.218 0.007', NULL, 'تنك فرز', 'محمد عجاج', '2025-08-03 17:27:01', '2025-08-07 07:47:39', 0, NULL),
(261, '2025-08-03', '1291', 'عبدالرزاق نصر', 16.00, 0.00, 0.100, 256.00, 0.60, 18.50, '1.779 0.150 0.146 0.144 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-03 17:27:54', '2025-08-07 07:47:39', 0, NULL),
(262, '2025-08-03', '1292', 'رياض عبد القادر', 120.00, 0.00, 0.100, 2793.80, 0.70, 16.50, '2.144 0.178 0.174 0.168 0.002', NULL, 'جركل', 'محمد خالد العثمانلي', '2025-08-03 17:29:34', '2025-08-07 07:47:39', 0, NULL),
(263, '2025-08-04', '1293', 'حكيم ناصر', 250.00, 0.00, 0.101, 3996.80, 0.75, 12.00, '1.894 0.169 0.160 0.153 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 07:48:51', '2025-08-04 15:42:34', 0, NULL),
(264, '2025-08-04', '1294', 'حكيم ناصر', 250.00, 0.00, 0.100, 3993.20, 0.75, 13.50, '1.705 0.149 0.141 0.136 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 07:49:34', '2025-08-04 15:42:34', 0, NULL),
(265, '2025-08-04', '1295', 'محمد حسام الابراهيم', 200.00, 0.00, 0.101, 3196.70, 1.65, 14.50, '2.136 0.177 0.175 0.167 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 10:07:51', '2025-08-07 11:15:29', 0, NULL),
(266, '2025-08-04', '1296', 'محمد حسام الابراهيم', 78.00, 0.00, 0.100, 1319.80, 1.60, 16.50, '2.146 0.178 0.172 0.164 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 10:08:52', '2025-08-07 11:15:29', 0, NULL),
(267, '2025-08-04', '1297', 'محمد حسام الابراهيم', 100.00, 0.00, 0.100, 1595.00, 1.15, 14.50, '2.067 0.181 0.173 0.168 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 10:10:18', '2025-08-06 13:12:47', 0, NULL),
(268, '2025-08-04', '1298', 'نورس الحماد', 29.00, 0.00, 0.100, 463.15, 2.15, 35.50, '2.618 0.208 0.203 0.196 0.001', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-08-04 10:11:18', '2025-08-07 11:15:29', 0, NULL),
(269, '2025-08-04', '1299', 'عبدالرحمن فهمي سيدو', 250.00, 0.00, 0.100, 4000.90, 0.80, 11.50, '1.826 0.156 0.147 0.141 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 10:12:21', '2025-08-05 06:00:12', 0, NULL),
(270, '2025-08-04', '1300', 'عبدالرحمن فهمي سيدو', 250.00, 0.00, 0.100, 3998.90, 0.90, 13.00, '1.817 0.156 0.150 0.143 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 10:40:26', '2025-08-05 06:00:12', 0, NULL),
(271, '2025-08-04', '1301', 'محمود نورس', 45.00, 0.00, 0.100, 721.60, 0.70, 14.00, '1.889 0.168 0.156 0.147 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 11:13:04', '2025-08-07 07:47:39', 0, NULL),
(272, '2025-08-04', '1302', 'محمود نورس', 47.00, 0.00, 0.100, 751.05, 0.70, 18.50, '2.047 0.157 0.161 0.161 0.003', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-08-04 11:15:10', '2025-08-07 07:47:39', 0, NULL),
(273, '2025-08-04', '1303', 'محمود نورس', 503.00, 0.00, 0.100, 8004.00, 0.90, 16.00, '2.117 0.200 0.192 0.185 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 12:45:45', '2025-08-05 08:51:46', 0, NULL),
(274, '2025-08-04', '1304', 'محمود نورس', 5.00, 0.00, 0.101, 1.00, 1.00, 1.00, '2.374 0.391 0.405 0.389 0.015', NULL, 'تنك فرز (تحليل اسيد بيروكسيد وهمي)', 'محمد خالد العثمانلي', '2025-08-04 12:46:33', '2025-09-02 12:57:36', 1, NULL),
(275, '2025-08-04', '1305', 'رياض عبد القادر', 91.00, 0.00, 0.101, 1969.65, 0.65, 21.50, '2.491 0.249 0.234 0.222 -0.001', NULL, 'جركل', 'محمد خالد عثمانلي ', '2025-08-04 15:12:19', '2025-08-07 07:47:39', 0, NULL),
(276, '2025-08-04', '1306', 'ابراهيم ابو ياسر', 181.00, 0.00, 0.101, 2888.10, 3.35, NULL, '3.220 1.190 1.175 1.112 0.025', NULL, 'زيت صناعي (جورة)', 'محمد خالد العثمانلي', '2025-08-04 15:14:08', '2025-08-26 11:43:51', 0, NULL),
(277, '2025-08-05', '1309', 'حسن البدر', 198.00, 0.00, 0.100, 3153.00, 0.85, 19.50, '2.187 0.198 0.188 0.177 0.001', NULL, 'تنك197+1بيدون', 'محمد خالد العثمانلي', '2025-08-05 09:22:32', '2025-08-14 11:38:22', 0, NULL),
(278, '2025-08-05', '1310', 'محمود نورس', 184.00, 0.00, 0.100, 2933.00, 0.55, 16.50, '2.080 0.202 0.184 0.176 -0.004', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-05 09:36:00', '2025-08-06 13:12:47', 0, NULL),
(279, '2025-08-05', '1311', 'محمود نورس', 2.00, 0.00, 0.102, 1.00, 1.00, 1.00, '2.598 0.475 0.493 0.472 0.019', NULL, 'تنك فرز(اسيد بيروكسيد تحليل وهمي)', 'محمد خالد العثمانلي', '2025-08-05 09:37:10', '2025-09-02 12:57:36', 1, NULL),
(280, '2025-08-05', '1312', 'محمود نورس', 156.00, 0.00, 0.101, 2491.00, 0.60, 12.00, '1.949 0.181 0.173 0.168 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-05 10:07:47', '2025-08-07 07:47:39', 0, NULL),
(281, '2025-08-05', '1313', 'مرتجع ', 85.00, 0.00, 0.100, 1351.00, 1.35, 19.00, '1.968 0.197 0.193 0.185 0.002', NULL, 'مرتجع من شركة ش.ا', 'محمد خالد العثمانلي', '2025-08-05 11:42:23', '2025-08-14 11:38:22', 0, NULL),
(282, '2025-08-05', '1314', 'ابراهيم أبو ياسر', 171.00, 0.00, 0.100, 2731.00, 0.50, 14.00, '2.124 0.204 0.190 0.181 -0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-05 13:05:30', '2025-08-14 11:38:22', 0, NULL),
(283, '2025-08-05', '1307', 'ابراهيم أبو ياسر', 134.00, 0.00, 0.100, 2158.00, 3.35, NULL, '2.882 0.612 0.646 0.631 0.025', NULL, 'زيت صناعي (جورة)', 'محمد خالد العثمانلي', '2025-08-05 13:11:01', '2025-08-26 11:43:51', 0, NULL),
(284, '2025-08-05', '1308', 'ابراهيم ابو ياسر', 149.00, 0.00, 0.101, 2383.00, 6.80, NULL, '3.053 1.477 1.602 1.401 0.163', NULL, 'زيت صناعي (جورة)', 'محمد خالد العثمانلي', '2025-08-05 13:48:41', '2025-08-26 11:43:51', 0, NULL),
(285, '2025-08-06', '1315', 'غسان عبد الحميد عودة', 100.00, 0.00, 0.100, 1598.50, 1.55, 18.00, '2.003 0.169 0.168 0.162 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-06 13:07:57', '2025-08-07 13:32:27', 0, NULL),
(286, '2025-08-06', '1316', 'غسان عبدالحميد عودة', 53.00, 0.00, 0.100, 848.00, 0.45, 13.00, '1.757 0.139 0.135 0.132 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-06 13:09:34', '2025-08-07 13:32:27', 0, NULL),
(287, '2025-08-06', '1317', 'غسان عبد الحميد عودة', 2.00, 0.00, 0.100, 32.10, 0.45, 10.00, '1.605 0.218 0.232 0.228 0.009', NULL, 'تنك فرز', 'محمد خالد العثمانلي', '2025-08-06 13:11:49', '2025-08-07 13:32:27', 0, NULL),
(288, '2025-08-07', '1318', 'مرتجع ', 38.00, 0.00, 0.101, 606.50, 1.45, 17.50, '2.037 0.210 0.207 0.199 0.003', NULL, 'مرتجع من شركة ش.أ', 'محمد خالد العثمانلي', '2025-08-07 13:38:03', '2025-08-26 11:49:09', 0, NULL),
(289, '2025-08-12', '1319', 'محمد حسام الابراهيم', 215.00, 0.00, 0.100, 3431.70, 0.60, 13.50, '2.025 0.197 0.184 0.176 -0.002', NULL, '', 'أحمد نور عجاج', '2025-08-12 12:40:52', '2025-08-26 11:49:09', 0, NULL),
(290, '2025-08-13', '1320', 'ابراهيم أبو ياسر', 201.00, 0.00, 0.103, 3197.50, 0.70, 12.00, '1.873 0.154 0.147 0.141 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-13 09:00:43', '2025-08-26 11:49:09', 0, NULL),
(291, '2025-08-13', '1321', 'علاء أباظة', 220.00, 0.00, 0.100, 3514.50, 0.70, 13.50, '1.992 0.167 0.155 0.148 -0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-13 11:01:45', '2025-08-26 11:49:09', 0, NULL),
(292, '2025-08-13', '1322', 'علاء أباظة', 220.00, 0.00, 0.103, 3512.60, 0.60, 12.50, '2.050 0.181 0.173 0.167 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-13 11:02:41', '2025-08-26 11:49:09', 0, NULL),
(293, '2025-08-13', '1323', 'علاء أباظة', 66.00, 0.00, 0.100, 1050.20, 0.55, 21.50, '2.453 0.219 0.214 0.211 -0.001', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-08-13 11:03:45', '2025-08-26 11:49:09', 0, NULL),
(294, '2025-08-13', '1324', 'محمد حسام الابراهيم', 156.00, 0.00, 0.101, 2486.30, 0.60, 15.50, '2.177 0.177 0.165 0.158 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-13 11:45:25', '2025-08-26 11:49:09', 0, NULL),
(295, '2025-08-14', '1325', 'حسن البدر', 250.00, 0.00, 0.103, 3995.90, 0.55, 15.00, '2.160 0.198 0.185 0.176 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-14 08:50:47', '2025-08-26 11:49:09', 0, NULL),
(296, '2025-08-14', '1326', 'حسن البدر', 250.00, 0.00, 0.100, 3997.30, 0.55, 12.50, '2.046 0.178 0.166 0.158 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-14 08:51:34', '2025-08-26 11:49:09', 0, NULL),
(297, '2025-08-16', '1327', 'حسن البدر', 174.00, 0.00, 0.100, 2780.40, 0.67, 16.00, '2.379 0.201 0.191 0.181 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-16 06:54:32', '2025-08-26 11:54:32', 0, NULL),
(298, '2025-08-17', '1328', 'عبدالرحمن فهمي سيدو', 250.00, 0.00, 0.100, 3988.00, 0.60, 14.00, '1.765 0.143 0.136 0.131 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-17 07:20:05', '2025-08-26 11:49:09', 0, NULL),
(299, '2025-08-17', '1329', 'عبدالرحمن فهمي سيدو', 250.00, 0.00, 0.100, 3994.30, 0.65, 12.00, '1.822 0.149 0.142 0.137 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-17 07:21:13', '2025-08-26 11:49:09', 0, NULL),
(300, '2025-08-17', '1330', 'عبدالرحمن فهمي سيدو', 280.00, 0.00, 0.101, 4476.30, 1.50, 14.50, '1.931 0.171 0.165 0.158 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-17 08:47:44', '2025-08-18 10:20:58', 0, NULL),
(301, '2025-08-17', '1331', 'عبدالرحمن فهمي سيدو', 270.00, 0.00, 0.100, 4315.00, 1.40, 15.50, '2.038 0.177 0.172 0.163 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-17 08:48:37', '2025-08-18 10:20:58', 0, NULL),
(302, '2025-08-18', '1332', 'غسان عبد الحميد عودة', 128.00, 0.00, 0.100, 2043.20, 0.65, 11.00, '1.780 0.151 0.148 0.143 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-18 12:28:32', '2025-08-26 11:49:09', 0, NULL),
(303, '2025-08-18', '1333', 'غسان عبد الحميد عودة', 67.00, 0.00, 0.101, 1071.40, 1.20, 17.00, '2.034 0.147 0.143 0.136 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-18 12:29:23', '2025-08-26 17:45:19', 0, NULL),
(304, '2025-08-19', '1334', 'عبدالرحمن فهمي سيدو', 250.00, 0.00, 0.100, 3997.10, 0.45, 11.50, '1.842 0.159 0.150 0.144 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-19 07:34:41', '2025-09-01 15:42:48', 0, NULL),
(305, '2025-08-19', '1335', 'عبدالرحمن فهمي سيدو', 250.00, 0.00, 0.100, 4001.10, 0.45, 11.50, '1.850 0.161 0.153 0.148 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-19 07:35:26', '2025-08-26 11:49:09', 0, NULL),
(306, '2025-08-19', '1336', 'عبدالرحمن فهمي سيدو', 280.00, 0.00, 0.101, 4469.10, 1.75, 13.50, '1.989 0.170 0.165 0.155 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-19 08:19:34', '2025-08-26 17:45:19', 0, NULL),
(307, '2025-08-19', '1337', 'عبدالرحمن فهمي سيدو', 270.00, 0.00, 0.100, 4317.10, 1.85, 13.00, '1.996 0.206 0.209 0.198 0.007', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-19 08:20:16', '2025-08-26 17:45:19', 0, NULL),
(308, '2025-08-19', '1338', 'محمد حسام الابراهيم', 82.00, 0.00, 0.100, 1309.60, 0.95, 11.50, '2.113 0.187 0.182 0.175 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-19 10:31:40', '2025-08-23 06:07:26', 0, NULL),
(309, '2025-08-19', '1339', 'محمد حسام الابراهيم', 17.00, 0.00, 0.100, 307.90, 0.70, 28.50, '2.463 0.178 0.173 0.164 0.002', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-08-19 10:32:30', '2025-08-23 06:07:26', 0, NULL),
(310, '2025-08-20', '1340', 'عبدالرحمن فهمي سيدو', 250.00, 0.00, 0.100, 3997.85, 0.80, 12.00, '1.785 0.157 0.151 0.145 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-20 09:37:36', '2025-08-23 06:07:26', 0, NULL),
(311, '2025-08-20', '1341', 'عبدالرحمن فهمي سيدو', 250.00, 0.00, 0.100, 3997.85, 0.75, 12.00, '1.779 0.150 0.144 0.138 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-20 09:38:30', '2025-08-21 08:29:24', 0, NULL),
(312, '2025-08-20', '1342', 'عبدالرحمن فهمي سيدو', 500.00, 0.00, 0.100, 7991.00, 0.75, 11.50, '1.787 0.147 0.139 0.133 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-20 09:39:17', '2025-08-21 07:13:34', 0, NULL),
(313, '2025-08-20', '1343', 'عبدالرحمن فهمي سيدو', 500.00, 0.00, 0.099, 7986.00, 0.75, 11.00, '1.791 0.145 0.138 0.132 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-20 09:40:07', '2025-08-21 07:13:34', 0, NULL),
(314, '2025-08-20', '1344', 'عبدالرحمن فهمي سيدو', 200.00, 0.00, 0.101, 3200.00, 0.80, 11.50, '1.814 0.142 0.136 0.131 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-20 10:07:50', '2025-08-21 08:29:24', 0, NULL),
(315, '2025-08-20', '1345', 'مهدي العادل', 55.00, 0.00, 0.101, 880.40, 0.85, 13.00, '1.996 0.181 0.179 0.172 0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-20 11:36:53', '2025-08-23 06:07:26', 0, NULL),
(316, '2025-08-20', '1346', 'محمد حسام الابراهيم', 73.00, 0.00, 0.100, 1168.10, 0.55, 8.50, '1.712 0.124 0.118 0.113 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-20 14:50:32', '2025-08-23 06:07:26', 0, NULL),
(317, '2025-08-21', '1347', 'عبدالرحمن فهمي سيدو', 260.00, 0.00, 0.100, 4158.80, 0.80, 13.00, '1.984 0.165 0.159 0.151 0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-21 07:53:38', '2025-08-23 06:07:26', 0, NULL),
(318, '2025-08-21', '1348', 'عبدالرحمن فهمي سيدو', 252.00, 0.00, 0.100, 4032.96, 0.75, 11.00, '1.762 0.144 0.138 0.132 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-21 07:54:37', '2025-08-21 14:47:51', 0, NULL),
(319, '2025-08-21', '1349', 'عبدالرحمن فهمي سيدو', 8.00, 0.00, 0.099, 128.03, 1.05, 13.00, '1.946 0.252 0.254 0.241 0.007', NULL, 'تنك فرز', 'محمد خالد العثمانلي', '2025-08-21 07:55:23', '2025-08-23 06:09:36', 0, NULL),
(320, '2025-08-21', '1350', 'عبدالرحمن فهمي سيدو', 500.00, 0.00, 0.101, 7985.00, 0.75, 12.50, '1.857 0.150 0.143 0.136 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-21 12:38:11', '2025-08-21 14:48:45', 0, NULL),
(321, '2025-08-21', '1351', 'محمود نورس', 250.00, 0.00, 0.101, 3987.00, 0.65, 14.50, '2.155 0.193 0.184 0.173 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-21 13:03:07', '2025-08-23 06:09:36', 0, NULL),
(322, '2025-08-21', '1352', 'محمود نورس', 248.00, 0.00, 0.100, 3960.20, 0.75, 12.50, '2.082 0.177 0.172 0.163 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-21 13:15:32', '2025-08-26 11:46:13', 0, NULL),
(323, '2025-08-21', '1353', 'محمود نورس', 2.00, 0.00, 0.101, 1.00, 1.00, 1.00, '2.684 0.721 0.763 0.729 0.038', NULL, 'تنك (تحليل الاسيد والببيروكسيد وهمي )', 'محمد خالد العثمانلي', '2025-08-21 13:16:31', '2025-09-02 12:57:36', 1, NULL),
(324, '2025-08-21', '1354', 'محمود نورس', 280.00, 0.00, 0.101, 4466.70, 0.85, 13.00, '2.085 0.196 0.186 0.175 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-21 14:51:38', '2025-08-23 06:09:36', 0, NULL),
(325, '2025-08-21', '1355', 'محمود نورس', 265.00, 0.00, 0.101, 4229.80, 0.85, 13.00, '2.130 0.194 0.183 0.171 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-21 14:52:40', '2025-08-26 11:46:13', 0, NULL),
(326, '2025-08-21', '1356', 'محمود نورس', 5.00, 0.00, 0.100, 1.00, 1.00, 1.00, '2.579 0.457 0.466 0.443 0.016', NULL, 'تنك فرز (اسيد بيروكسيد تحليل وهمي)\r\n', 'محمد خالد العثمانلي', '2025-08-21 14:58:03', '2025-09-02 12:57:36', 1, NULL),
(327, '2025-08-23', '1357', 'ابراهيم أبو ياسر', 67.00, 0.00, 0.101, 1070.34, 0.90, 15.50, '2.018 0.184 0.179 0.173 0.001', NULL, 'تنك ', 'محمد خالد العثمانلي', '2025-08-23 14:07:57', '2025-08-26 11:46:13', 0, NULL),
(328, '2025-08-23', '1358', 'ابراهيم أبو ياسر', 115.00, 0.00, 0.101, 1837.15, 0.80, 12.50, '2.026 0.213 0.204 0.195 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-23 14:08:55', '2025-09-01 15:42:48', 0, NULL),
(329, '2025-08-24', '1359', 'حسن البدر', 125.00, 0.00, 0.100, 1997.10, 0.60, 15.00, '2.167 0.171 0.157 0.148 -0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-24 08:10:08', '2025-08-26 11:49:09', 0, NULL),
(330, '2025-08-24', '1360', 'حسن البدر', 238.00, 0.00, 0.101, 3809.30, 0.60, 15.00, '2.029 0.177 0.163 0.153 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-24 08:10:55', '2025-08-26 11:49:09', 0, NULL),
(331, '2025-08-24', '1361', 'حسن البدر', 180.00, 0.00, 0.101, 2869.80, 0.60, 15.50, '2.204 0.201 0.188 0.178 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-24 08:11:37', '2025-08-26 11:49:09', 0, NULL),
(332, '2025-08-24', '1362', 'غسان عبد الحميد عودة', 102.00, 0.00, 0.100, 1635.80, 0.80, 11.50, '1.860 0.136 0.135 0.134 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-24 11:37:08', '2025-09-01 15:42:48', 0, NULL),
(333, '2025-08-24', '1363', 'غسان عبد الحميد عودة', 73.00, 0.00, 0.100, 1165.10, 1.50, 1.65, '1.935 0.162 0.162 0.155 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-24 11:38:03', '2025-08-26 17:45:19', 0, NULL),
(334, '2025-08-24', '1364', 'غسان عبد الحميد عودة', 28.00, 0.00, 0.100, 444.80, 1.00, 40.50, '2.527 0.179 0.181 0.174 0.005', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-08-24 11:39:12', '2025-08-26 17:45:19', 0, NULL),
(335, '2025-08-24', '1365', 'غسان عبد الحميد عودة', 1.00, 1.00, 0.101, 1.00, 4.50, 19.00, '2.695 0.548 0.569 0.547 0.022', NULL, 'تنك فرز', 'محمد خالد العثمانلي', '2025-08-24 11:40:09', '2025-08-24 11:40:20', 1, NULL),
(336, '2025-08-26', '0', 'تصافي زمة 4', 52.00, 0.00, 0.000, 832.00, 3.00, 30.00, '2.158 0.246 0.248 0.224 0.013', NULL, 'القراءات وهمية', 'محمد خالد عثمانلي ', '2025-08-26 11:41:46', '2025-08-26 11:43:51', 0, NULL),
(337, '2025-08-26', '1366', 'المعصرة الحديثة (أبوفراس)', 60.00, 0.00, 0.100, 962.10, 1.25, 14.50, '1.755 0.153 0.151 0.146 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-26 13:32:37', '2025-09-03 11:59:54', 0, NULL),
(338, '2025-08-26', '0', 'تصافي ذمة 5', 24.00, 12.00, 0.100, 1.00, 1.10, 43.00, '2.751 0.319 0.308 0.288 0.004', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-26 13:33:47', '2025-09-01 15:42:48', 0, NULL),
(339, '2025-08-30', '1367', 'زاهر عجاج', 10.00, 0.00, 0.100, 160.25, 0.70, 11.50, '1.929 0.239 0.222 0.216 -0.006', NULL, 'تنك', 'محمد حالد العثمانلي', '2025-08-30 13:51:57', '2025-09-03 13:11:19', 0, NULL),
(340, '2025-08-30', '1367', 'زاهر عجاج', 14.00, 0.00, 0.101, 224.35, 1.05, 27.50, '2.758 0.259 0.252 0.244 0.000', NULL, 'بيدون', 'محمد حالد العثمانلي', '2025-08-30 13:52:53', '2025-09-03 13:12:06', 0, NULL),
(341, '2025-09-02', '1368', 'زاهر عجاج', 1.00, 0.00, 1.000, 1.00, 1.00, 1.00, '2.897 0.556 0.540 0.528 -0.002', NULL, '', 'محمد خالد العثمانلي', '2025-09-02 12:55:34', '2025-09-02 12:57:36', 1, NULL),
(342, '2025-09-02', '1369', 'معصرة العديل', 270.00, 270.00, 0.100, 4327.40, 0.90, 14.00, '2.083 0.219 0.214 0.210 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-09-02 12:56:58', '2025-09-03 13:10:04', 0, NULL),
(343, '2025-09-03', '1370', 'عبدالرحمن فهمي سيدو', 250.00, 250.00, 0.101, 4001.90, 0.90, 15.50, '1.918 0.161 0.152 0.145 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-09-03 08:03:51', '2025-09-03 13:09:04', 0, NULL),
(344, '2025-09-03', '1371', 'عبدالرحمن فهمي سيدو', 250.00, 250.00, 0.101, 4008.80, 0.90, 14.00, '2.011 0.159 0.150 0.144 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-09-03 08:04:40', '2025-09-03 13:09:17', 0, NULL),
(345, '2025-09-03', '1372', 'ابراهيم أبو ياسر', 280.00, 280.00, 0.100, 4472.50, 0.55, 11.50, '1.825 0.157 0.150 0.144 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-09-03 12:49:30', '2025-09-06 13:42:51', 0, NULL),
(346, '2025-09-03', '1373', 'ابراهيم أبو ياسر', 219.00, 219.00, 0.101, 3499.20, 0.60, 15.50, '2.245 0.218 0.206 0.195 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-09-03 12:53:11', '2025-09-06 13:43:04', 0, NULL),
(347, '2025-09-03', '1374', 'ابراهيم أبو ياسر', 1.00, 1.00, 0.100, 1.00, 1.00, 1.00, '2.983 0.891 0.939 0.895 0.046', NULL, 'تنك فرز(اسيد بيروكسيد وهمي )\r\n', 'محمد خالد العثمانلي', '2025-09-03 13:13:40', '2025-09-07 12:54:23', 1, NULL),
(348, '2025-09-04', '1375', 'غسان عبد الحميد عودة', 100.00, 99.00, 0.101, 1599.40, 0.65, 11.00, '1.769 0.166 0.165 0.161 0.001', NULL, 'تنك\r\n', 'محمد خالد العثمانلي', '2025-09-04 12:18:39', '2025-09-07 12:53:30', 0, NULL),
(349, '2025-09-04', '1376', 'غسان عبدالحميد عودة', 103.00, 102.00, 0.101, 1647.20, 1.40, 14.50, '2.009 0.207 0.206 0.199 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-09-04 12:20:18', '2025-09-07 12:53:30', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `date` date NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `driver_name` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `customer_phone` varchar(20) DEFAULT NULL,
  `customer_address` text DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','processing','completed','cancelled') DEFAULT 'pending',
  `created_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `avg_ph` decimal(10,2) DEFAULT 0.00,
  `avg_peroxide` decimal(10,2) DEFAULT 0.00,
  `avg_232` decimal(10,2) DEFAULT 0.00,
  `avg_270` decimal(10,2) DEFAULT 0.00,
  `avg_delta_k` decimal(10,2) DEFAULT 0.00,
  `total_quantity_tanks` decimal(10,2) DEFAULT 0.00,
  `total_quantity_liters` decimal(10,2) DEFAULT 0.00,
  `deleted_at` datetime DEFAULT NULL COMMENT 'Timestamp of soft-delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `invoice_number`, `date`, `customer_name`, `driver_name`, `notes`, `customer_phone`, `customer_address`, `total_amount`, `status`, `created_by`, `created_at`, `updated_at`, `avg_ph`, `avg_peroxide`, `avg_232`, `avg_270`, `avg_delta_k`, `total_quantity_tanks`, `total_quantity_liters`, `deleted_at`) VALUES
(56, '0001', '2025-06-19', 'مرفوض مخرج من المستودع ( مرتجع  )', 'الزيت المرفوض', 'فاتورة للزيت المرفوض والمخرج الى أصحابه', NULL, NULL, 288.00, 'pending', 3, '2025-06-19 10:17:19', '2025-09-07 00:38:08', 1.82, 21.95, 2.22, 0.00, 0.00, 951.00, 15216.00, NULL),
(61, '221', '2025-06-21', 'مؤسسة اليسر', 'خالد طنب', 'تنك ', NULL, NULL, 8000.00, 'pending', 3, '2025-06-21 15:09:00', '2025-09-07 00:38:08', 1.61, 17.15, 1.89, 0.00, 0.00, 500.00, 8000.00, NULL),
(62, '222', '2025-06-21', 'مؤسسة اليسر', 'خالد طنب', 'تنك', NULL, NULL, 5600.00, 'pending', 3, '2025-06-21 15:18:34', '2025-09-07 00:38:08', 1.60, 16.11, 2.05, 0.00, 0.00, 350.00, 5600.00, NULL),
(65, '223', '2025-06-22', '( نسيم فرح ) ضخ للخزانات', 'عمر حديد ( ضخ خزانات )', 'طلبية 350 برميل وزن 110 كغ صافي ( خام)', NULL, NULL, 38640.00, 'pending', 3, '2025-06-22 10:42:28', '2025-09-07 00:38:08', 0.74, 16.65, 2.13, 0.00, 0.00, 2415.00, 38640.00, NULL),
(67, '224', '2025-06-22', 'شركة أصالة', 'خالد طنب', 'تنك ', NULL, NULL, 8432.00, 'pending', 13, '2025-06-22 12:52:26', '2025-09-07 00:38:08', 0.80, 12.68, 2.02, 0.00, 0.00, 527.00, 8432.00, NULL),
(68, '225', '2025-06-23', 'شركة أصالة', 'خالد طنب -عبدالستار طنب', '13 بيدون 307 تنك', NULL, NULL, 5120.00, 'pending', 3, '2025-06-23 05:33:37', '2025-09-07 00:38:08', 0.71, 13.92, 2.03, 0.00, 0.00, 320.00, 5120.00, NULL),
(71, '0002', '2025-06-25', 'مبيعات متفرقة', 'مبيعات متفرقة', 'خاص بالمبيعات المتفرقة', NULL, NULL, 16.00, 'pending', 3, '2025-06-24 21:11:48', '2025-09-07 00:38:08', 1.43, 19.36, 2.30, 0.00, 0.00, 11.00, 176.00, NULL),
(73, '226', '2025-06-26', 'مؤسسة اليسر', 'أويس خلوف', 'زيت زيتون بلدي - تنك كل حمل 100 تنكة ', NULL, NULL, 8153.32, 'pending', 3, '2025-06-26 08:21:35', '2025-09-07 00:38:08', 1.56, 17.32, 2.06, 0.00, 0.00, 1000.00, 16000.00, NULL),
(74, '227', '2025-06-26', '( نسيم فرح ) ضخ للخزانات', 'عمر حديد ( ضخ خزانات )', 'طلبية 350 برميل اكسترا ', NULL, NULL, 14405.99, 'pending', 3, '2025-06-26 09:41:19', '2025-09-07 00:38:08', 0.80, 15.55, 2.08, 0.00, 0.00, 983.00, 15728.00, NULL),
(75, '228', '2025-06-28', 'مؤسسة اليسر', 'أويس خلوف', 'عفريني ', NULL, NULL, 7577.96, 'pending', 3, '2025-06-28 09:03:58', '2025-09-07 00:38:08', 1.39, 17.83, 1.89, 0.00, 0.00, 475.00, 7577.96, NULL),
(76, '229', '2025-06-30', 'شركة أصالة', 'عوض منصور', '139بيدون+111تنك', NULL, NULL, 3990.52, 'pending', 13, '2025-06-30 14:02:41', '2025-09-07 00:38:08', 0.66, 15.95, 2.24, 0.00, 0.00, 250.00, 3990.52, NULL),
(77, '227', '2025-07-02', 'طلبية نسيم فرح الضخة الثانية', 'محمد مهدي', 'الضخة الثانية لطلبية نسيم رقم 227 عدد 350 برميل وزن 110 كغ', NULL, NULL, 17741.70, 'pending', 3, '2025-07-02 10:52:56', '2025-09-07 00:38:08', 0.81, 15.28, 2.12, 0.00, 0.00, 1102.00, 17632.00, NULL),
(79, '227', '2025-07-05', '( نسيم فرح ) ضخ للخزانات', 'عمر حديد ( ضخ خزانات )', 'الضخة (3)', NULL, NULL, 5208.16, 'pending', 3, '2025-07-05 13:58:50', '2025-09-07 00:38:08', 0.70, 13.03, 1.96, 0.00, 0.00, 326.00, 5208.16, NULL),
(80, '230', '2025-07-10', 'مؤسسة اليسر التجارية', 'أويس خلوف', '', NULL, NULL, 4439.30, 'pending', 3, '2025-07-10 06:25:19', '2025-09-07 00:38:08', 1.59, 20.63, 2.19, 0.00, 0.00, 278.00, 4448.00, NULL),
(82, '231', '2025-07-13', 'طلبية نسيم فرح — ضخ للخزانات', 'محمد مهدي', 'طلبية 220 برميل وزن 110 كغ', NULL, NULL, 14319.40, 'pending', 3, '2025-07-13 14:07:00', '2025-09-07 00:38:08', 1.62, 21.54, 2.40, 0.00, 0.00, 1597.00, 25552.00, NULL),
(83, '232', '2025-07-15', 'سيرجيلا - للتعبئة', 'محمد مهدي - احمد نور', 'الانتباه لتفريغ الخزنات قبل الضخ \nوعدم اضافة اي تنكة فوق العينات المرفقة\nالتعبئة محكمة بكيسين مع بعض والربط المحكم والتاكد من نظافة البراميل قبل تعبئة وعدم السماح للعمال بالتدخين اثناء تعبئة', NULL, NULL, 15440.00, 'pending', 3, '2025-07-15 08:31:12', '2025-09-07 00:38:08', 0.97, 17.24, 2.27, 0.00, 0.00, 965.00, 15440.00, NULL),
(86, '233', '2025-07-22', '( نسيم فرح ) ضخ للخزانات', 'محمد مهدي', '141 برميل وزن 110 كغ\nستيغماستاديين = 0.07', NULL, NULL, 15638.17, 'cancelled', 3, '2025-07-22 06:14:31', '2025-09-10 12:40:44', 0.72, 14.37, 2.09, 0.00, 0.00, 951.00, 15216.00, NULL),
(87, '233', '2025-07-26', 'نسيم رياض فرح', 'محمد مهدي', 'ضخة للخزانات (تعبئة براميل بوزن  110*206)', NULL, NULL, 22650.00, 'pending', 13, '2025-07-26 12:01:53', '2025-09-07 00:38:08', 0.95, 18.50, 2.26, 0.00, 0.00, 1415.00, 22650.00, NULL),
(89, '234', '2025-07-27', 'مؤسسة أصالة التجاربة', 'خالد طنب أبوعلي', 'أول ', NULL, NULL, 6539.20, 'pending', 3, '2025-07-27 08:43:49', '2025-09-07 00:38:08', 1.39, 21.12, 2.41, 0.00, 0.00, 450.00, 7200.00, NULL),
(91, '235', '2025-07-29', 'مؤسسة أصالة التجارية', 'خالدطنب', '', NULL, NULL, 4471.31, 'pending', 3, '2025-07-29 14:31:29', '2025-09-07 00:38:08', 1.59, 19.04, 2.26, 0.00, 0.00, 295.00, 4720.00, NULL),
(94, '236', '2025-07-30', 'مؤسسة أصالة التجارية', 'خالد طنب', 'تنك-هونداي', NULL, NULL, 3196.33, 'pending', 3, '2025-07-30 10:33:11', '2025-09-07 00:38:08', 1.33, 17.75, 2.09, 0.00, 0.00, 200.00, 3196.33, NULL),
(98, '237', '2025-08-02', 'نسيم رياض فرح', 'محمد مهدي عجاج', 'طلبية 290 برميل وزن 110 كغ صافي حموضة 0.8 (220 حمل الدنب + 70 حمل راس )', NULL, NULL, 16904.20, 'pending', 3, '2025-08-02 14:14:42', '2025-09-07 00:38:08', 0.83, 14.42, 2.03, 0.00, 0.00, 1941.00, 31056.00, NULL),
(101, '238', '2025-08-04', 'الشرق الادنى لمنتجات زيتون', 'خالد طنب - علاء الاحمد', 'تنك سيارتين مع علام الزمة رقم 1285 بالبخاخ ', NULL, NULL, 8807.05, 'pending', 3, '2025-08-04 15:42:34', '2025-09-07 00:38:08', 0.84, 14.31, 1.97, 0.00, 0.00, 1054.00, 8807.05, NULL),
(102, '239', '2025-08-05', 'الشرق الادنى لمنتجات الزيتون', 'خالد طنب', 'حمل خالد طنب رقم 2 مع التاكيد على علامة زمة  قم 1285', NULL, NULL, 8410.34, 'pending', 3, '2025-08-05 05:52:18', '2025-09-07 00:38:08', 0.77, 13.47, 1.98, 0.00, 0.00, 527.00, 8410.34, NULL),
(103, '240', '2025-08-05', 'الشرق الادنى لمنتجات الزيتون', 'علاء الاحمد', 'سيارة رقم 2 للسائق علاء مع التاكيد على علام الزمة رقم 1285', NULL, NULL, 8431.83, 'pending', 3, '2025-08-05 06:00:12', '2025-09-07 00:38:08', 0.86, 12.29, 1.84, 0.00, 0.00, 527.00, 8431.83, NULL),
(104, '237', '2025-08-05', '( نسيم فرح ) ضخ للخزانات', 'محمد مهدي عجاج', 'الضخة الثانية ( 70 برميل ) يتبع للطلبية رقم 237 ', NULL, NULL, 7896.92, 'pending', 3, '2025-08-05 13:55:49', '2025-09-07 00:38:08', 1.71, 18.69, 2.19, 0.00, 0.00, 498.50, 7976.00, NULL),
(106, '241', '2025-08-06', 'الشرق الادنى لمنتجات زيتون', 'خالد طنب', 'تنك', NULL, NULL, 7978.99, 'pending', 3, '2025-08-06 13:12:47', '2025-09-07 00:38:08', 0.82, 14.48, 1.99, 0.00, 0.00, 500.00, 7978.99, NULL),
(107, '242', '2025-08-07', 'الشرق الادنى لمنتجات الزيتون', 'علاء الاحمد', 'تنك', NULL, NULL, 7626.21, 'pending', 3, '2025-08-07 04:53:03', '2025-09-07 00:38:08', 0.69, 15.35, 2.08, 0.00, 0.00, 500.00, 8000.00, NULL),
(108, '243', '2025-08-07', 'الشرق الادنى لمنتجات الزيتون', 'خالد طنب', 'ملاحظة يضاف عدد 28 تنكة الى الفاتورة تم تخريجهم من البراميل عدد الاجمالي للفاتورة  422  ', NULL, NULL, 6299.04, 'pending', 3, '2025-08-07 05:33:26', '2025-09-07 00:38:08', 0.88, 14.53, 2.05, 0.00, 0.00, 394.00, 6304.00, NULL),
(109, '244', '2025-08-14', 'طلبية نسيم فرح - ضخ للخزانات', 'محمد مهدي', 'عدد 435 برميل وزن 110 كغ باقي من الضخة 21  برميل  معبئة وزن 110 كغ ', NULL, NULL, 14754.38, 'pending', 3, '2025-08-14 08:54:40', '2025-09-07 00:38:08', 0.60, 13.73, 2.02, 0.00, 0.00, 3173.00, 50768.00, NULL),
(111, '245', '2025-08-18', 'مؤسسة اليسر التجارية', 'أويس صبحي خلوف', '6 حمال بالجوندا', NULL, NULL, 9365.88, 'pending', 3, '2025-08-18 10:20:58', '2025-09-07 00:38:08', 1.45, 15.15, 1.99, 0.00, 0.00, 586.00, 9365.88, NULL),
(112, '246', '2025-08-18', 'أ نصري فاعوري أبوأحمد', 'محمد عجاج', 'بيد محمد مهيب+ أبوسعيد عدي تنكة', NULL, NULL, 31.96, 'pending', 3, '2025-08-18 10:33:33', '2025-09-07 00:38:08', 0.56, 13.75, 2.11, 0.00, 0.00, 4.00, 64.00, NULL),
(113, '247', '2025-08-21', 'الشرق الادنى لمنتجات الزيتون', 'حسين طنب + علاء الاحمد', 'تنك سيارتين ', NULL, NULL, 16869.39, 'pending', 3, '2025-08-21 07:13:16', '2025-09-07 00:38:08', 0.76, 11.49, 1.81, 0.00, 0.00, 1054.00, 16864.00, NULL),
(114, '248', '2025-08-21', 'الشرق الادنى لمنتجات الزيتون', 'حسين طنب', 'علام الزمة رقم 1337', NULL, NULL, 7198.14, 'pending', 3, '2025-08-21 07:18:21', '2025-09-07 00:38:08', 0.93, 11.96, 1.82, 0.00, 0.00, 527.00, 8432.00, NULL),
(115, '249', '2025-08-21', 'الشرق الادنى لمنتجات الزيتون', 'علاء الاحمد', 'تنك', NULL, NULL, 1488.70, 'pending', 3, '2025-08-21 08:27:58', '2025-09-07 00:38:08', 0.92, 12.04, 1.88, 0.00, 0.00, 527.00, 8432.00, NULL),
(116, '250', '2025-08-23', 'الشرق الادنى لمنتجات الزيتون', 'علاء الأحمد', 'تنك  مع علام الزمة رقم 1337', NULL, NULL, 7507.96, 'pending', 3, '2025-08-21 08:32:00', '2025-09-07 00:38:08', 0.87, 11.87, 1.87, 0.00, 0.00, 527.00, 8432.00, NULL),
(117, '251', '2025-08-21', 'الشرق الادنى لمنتجات الزيتون', 'علاء الاحمد', 'تنك  - تحميل مباشر من زمة عبدالرحمن ', NULL, NULL, 1.00, 'pending', 3, '2025-08-21 13:10:12', '2025-09-07 00:38:08', 0.75, 12.50, 1.86, 0.00, 0.00, 500.00, 1.00, NULL),
(118, '252', '2025-08-23', 'الشرق الادنى لمنتجات الزيتون', 'نايف طنب', 'تنك', NULL, NULL, 9571.34, 'pending', 3, '2025-08-23 06:09:36', '2025-09-07 00:38:08', 0.77, 13.63, 2.12, 0.00, 0.00, 600.00, 9571.34, NULL),
(119, '253', '2025-08-25', 'بسام جدعان أبوخلدون', 'أيمن أكرم المصري', 'بيد ايمن المصري', NULL, NULL, 317.71, 'pending', 3, '2025-08-25 14:31:20', '2025-09-07 00:38:08', 1.00, 40.50, 2.53, 0.00, 0.01, 20.00, 320.00, NULL),
(120, '254', '2025-08-26', 'الشرق الادنى لمنتجات الزيتون', 'علاء الأحمد', 'تنك ', NULL, NULL, 8270.73, 'pending', 3, '2025-08-26 11:37:02', '2025-09-07 00:38:08', 0.81, 13.08, 2.09, 0.00, 0.00, 518.00, 8288.00, NULL),
(121, '255', '2025-08-26', 'عبادة عطار', 'أحمد نور عجاج', 'بيدون أبيض غذائي ', NULL, NULL, 79.43, 'pending', 3, '2025-08-26 11:37:57', '2025-09-07 00:38:08', 1.00, 40.50, 2.53, 0.00, 0.01, 5.00, 80.00, NULL),
(122, '256', '2025-08-26', 'نسيم فرح  ( طلبية الصناعي )', 'أحمد صبحي خطاب', 'زيت جريان ', NULL, NULL, 8405.10, 'pending', 3, '2025-08-26 11:43:51', '2025-09-07 00:38:08', 4.26, 3.51, 2.97, 0.00, 0.06, 525.00, 8405.10, NULL),
(123, '257', '2025-08-26', 'حج عبدالله عجاج', 'أحمد نور  عجاج', 'تنك', NULL, NULL, 47.97, 'pending', 3, '2025-08-26 11:55:24', '2025-09-07 00:38:08', 0.45, 11.50, 1.84, 0.00, 0.00, 3.00, 47.97, NULL),
(124, '258', '2025-08-26', 'عبدالرزاق النصر', 'عبدالرزاق النصر', 'تنكة ', NULL, NULL, 15.99, 'pending', 3, '2025-08-26 11:56:13', '2025-09-07 00:38:08', 0.45, 11.50, 1.84, 0.00, 0.00, 1.00, 15.99, NULL),
(125, '258', '2025-08-26', 'مؤسسة أصالة التجارية', 'خالد طنب', 'تنك', NULL, NULL, 7936.46, 'pending', 3, '2025-08-26 17:44:20', '2025-09-07 00:38:08', 1.65, 12.50, 2.00, 0.00, 0.00, 500.00, 8000.00, NULL),
(126, '259', '2025-09-01', 'نسيم فرح ( ضخ للخزانات )', '', '', NULL, NULL, 8274.08, 'pending', 3, '2025-09-01 15:42:00', '2025-09-07 00:38:08', 0.70, 12.94, 1.91, 0.00, 0.00, 550.00, 8800.00, NULL),
(127, '260', '2025-09-03', 'أحمد صبحي خطاب', 'أبوأحمد سلقين', '', NULL, NULL, 64.14, 'processing', 3, '2025-09-03 11:59:02', '2025-09-07 00:40:54', 1.25, 14.50, 1.76, 0.00, 0.00, 4.00, 64.00, NULL),
(128, '21212', '2025-09-07', 'hgghhj', '', '', NULL, NULL, 31.99, 'cancelled', 18, '2025-09-07 12:53:30', '2025-09-10 12:32:12', 1.03, 12.75, 1.89, 0.00, 0.00, 2.00, 31.99, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `inventory_id` int(11) NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `sample_number` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `net_weight` decimal(10,2) DEFAULT NULL,
  `ph` decimal(5,2) DEFAULT NULL,
  `peroxide_value` decimal(10,2) DEFAULT NULL,
  `absorption_232` decimal(10,4) DEFAULT NULL,
  `absorption_266` decimal(10,4) DEFAULT NULL,
  `absorption_270` decimal(10,4) DEFAULT NULL,
  `absorption_274` decimal(10,4) DEFAULT NULL,
  `delta_k` decimal(10,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoice_items`
--

INSERT INTO `invoice_items` (`id`, `invoice_id`, `inventory_id`, `quantity`, `sample_number`, `price`, `created_at`, `net_weight`, `ph`, `peroxide_value`, `absorption_232`, `absorption_266`, `absorption_270`, `absorption_274`, `delta_k`) VALUES
(134, 61, 131, 100.00, '1162', 0.00, '2025-06-21 15:09:00', 1601.46, 2.80, 16.00, 1.8860, 0.1550, 0.1570, 0.1430, 0.0030),
(135, 61, 138, 178.00, '1178', 0.00, '2025-06-21 15:09:00', 2848.00, 1.40, 13.00, 1.9370, 0.1680, 0.1560, 0.1460, -0.0010),
(136, 61, 141, 222.00, '1181', 0.00, '2025-06-21 15:09:00', 3550.60, 1.25, 21.00, 1.8450, 0.1670, 0.1630, 0.1550, 0.0020),
(137, 62, 131, 84.00, '1162', 0.00, '2025-06-21 15:18:34', 1345.23, 2.80, 16.00, 1.8860, 0.1550, 0.1570, 0.1430, 0.0030),
(138, 62, 132, 30.00, '1170', 0.00, '2025-06-21 15:18:34', 479.55, 1.55, 28.50, 2.4670, 0.2020, 0.1980, 0.1910, 0.0020),
(139, 62, 139, 22.00, '1179', 0.00, '2025-06-21 15:18:34', 354.00, 2.45, 17.00, 2.4180, 0.2630, 0.2560, 0.2420, 0.0030),
(140, 62, 140, 113.00, '1180', 0.00, '2025-06-21 15:18:34', 1811.39, 0.70, 11.50, 1.8380, 0.1590, 0.1570, 0.1520, 0.0010),
(141, 62, 158, 101.00, '1192', 0.00, '2025-06-21 15:18:34', 1610.40, 1.45, 17.50, 2.2210, 0.2480, 0.2360, 0.2240, 0.0000),
(181, 67, 129, 4.00, '0', 0.00, '2025-06-22 12:52:26', 64.00, 1.00, 28.00, 2.6930, 0.2860, 0.2790, 0.2630, 0.0050),
(182, 67, 133, 166.00, '1171', 0.00, '2025-06-22 12:52:26', 2659.00, 0.50, 12.00, 2.0380, 0.2200, 0.2120, 0.2020, 0.0010),
(183, 67, 155, 150.00, '1189', 0.00, '2025-06-22 12:52:26', 2390.48, 0.70, 10.50, 1.9630, 0.1530, 0.1460, 0.1390, 0.0000),
(184, 67, 163, 207.00, '1197', 0.00, '2025-06-22 12:52:26', 3306.90, 1.10, 14.50, 2.0410, 0.1730, 0.1670, 0.1620, -0.0010),
(185, 68, 129, 11.00, '0', 0.00, '2025-06-23 05:33:37', 176.00, 1.00, 28.00, 2.6930, 0.2860, 0.2790, 0.2630, 0.0050),
(186, 68, 162, 208.00, '1196', 0.00, '2025-06-23 05:33:37', 3327.82, 0.75, 14.00, 2.0440, 0.1630, 0.1560, 0.1520, -0.0010),
(187, 68, 164, 29.00, '1198', 0.00, '2025-06-23 05:33:37', 462.12, 0.50, 14.00, 2.0720, 0.1770, 0.1590, 0.1490, -0.0040),
(188, 68, 168, 72.00, '1200', 0.00, '2025-06-23 05:33:37', 1150.50, 0.65, 11.50, 1.8710, 0.1450, 0.1370, 0.1330, -0.0020),
(202, 65, 129, 36.00, '0', 0.00, '2025-06-25 06:08:00', 576.00, 1.00, 28.00, 2.6930, 0.2860, 0.2790, 0.2630, 0.0050),
(203, 65, 130, 24.00, '1147', 0.00, '2025-06-25 06:08:00', 384.00, 1.55, 45.00, 2.7560, 0.3900, 0.3990, 0.3830, 0.0130),
(204, 65, 131, 16.00, '1162', 0.00, '2025-06-25 06:08:00', 256.00, 2.80, 16.00, 1.8860, 0.1550, 0.1570, 0.1430, 0.0030),
(205, 65, 134, 303.00, '1172', 0.00, '2025-06-25 06:08:00', 4848.00, 0.65, 18.00, 2.2440, 0.1920, 0.1850, 0.1730, 0.0020),
(206, 65, 136, 174.00, '1174', 0.00, '2025-06-25 06:08:00', 2784.00, 0.70, 18.00, 2.0610, 0.1950, 0.1800, 0.1710, -0.0300),
(207, 65, 140, 134.00, '1180', 0.00, '2025-06-25 06:08:00', 2144.00, 0.70, 11.50, 1.8380, 0.1590, 0.1570, 0.1520, 0.0010),
(208, 65, 142, 250.00, '1182', 0.00, '2025-06-25 06:08:00', 4000.00, 0.75, 12.50, 2.1880, 0.1770, 0.1640, 0.1540, -0.0010),
(209, 65, 143, 250.00, '1183', 0.00, '2025-06-25 06:08:00', 4000.00, 0.70, 15.50, 2.1070, 0.1720, 0.1610, 0.1510, -0.0010),
(210, 65, 144, 39.00, '1184', 0.00, '2025-06-25 06:08:00', 624.00, 0.75, 23.00, 2.6420, 0.2130, 0.2020, 0.1900, 0.0000),
(211, 65, 145, 250.00, '1185', 0.00, '2025-06-25 06:08:00', 4000.00, 0.70, 17.00, 2.1160, 0.1880, 0.1740, 0.1630, -0.0020),
(212, 65, 146, 232.00, '1186', 0.00, '2025-06-25 06:08:00', 3712.00, 0.65, 15.00, 2.0920, 0.1960, 0.1850, 0.1740, 0.0000),
(213, 65, 148, 266.00, '1188', 0.00, '2025-06-25 06:08:00', 4256.00, 0.75, 18.00, 1.9630, 0.1530, 0.1460, 0.1390, 0.0000),
(214, 65, 155, 58.00, '1189', 0.00, '2025-06-25 06:08:00', 928.00, 0.70, 10.50, 1.9630, 0.1530, 0.1460, 0.1390, 0.0000),
(215, 65, 160, 315.00, '1194', 0.00, '2025-06-25 06:08:00', 5040.00, 0.80, 16.00, 2.1250, 0.2070, 0.1930, 0.1830, -0.0030),
(216, 65, 161, 47.00, '1195', 0.00, '2025-06-25 06:08:00', 752.00, 0.60, 29.50, 2.6860, 0.2400, 0.2220, 0.2080, -0.0020),
(217, 65, 162, 21.00, '1196', 0.00, '2025-06-25 06:08:00', 336.00, 0.75, 14.00, 2.0440, 0.1630, 0.1560, 0.1520, -0.0010),
(239, 73, 167, 59.00, '1199', 0.00, '2025-06-26 08:23:03', 944.00, 1.80, 25.50, 2.5870, 0.2000, 0.1950, 0.1870, 0.0020),
(240, 73, 174, 198.00, '1206', 0.00, '2025-06-26 08:23:03', 3168.00, 1.20, 13.50, 1.9540, 0.1480, 0.1420, 0.1350, 0.0000),
(241, 73, 175, 210.00, '1207', 0.00, '2025-06-26 08:23:03', 3360.00, 1.40, 13.00, 1.9630, 0.1760, 0.1700, 0.1610, 0.0010),
(242, 73, 176, 250.00, '1208', 0.00, '2025-06-26 08:23:03', 4000.00, 1.55, 19.00, 2.0470, 0.1680, 0.1600, 0.1520, 0.0000),
(243, 73, 177, 239.00, '1209', 0.00, '2025-06-26 08:23:03', 3824.00, 1.70, 21.00, 2.0470, 0.1590, 0.1500, 0.1410, 0.0000),
(244, 73, 179, 9.00, '0', 0.00, '2025-06-26 08:23:03', 144.00, 1.30, 0.00, 2.7850, 0.3170, 0.3060, 0.2870, 0.0040),
(245, 73, 183, 35.00, '1213', 0.00, '2025-06-26 08:23:03', 560.00, 3.20, 18.50, 2.2900, 0.3080, 0.3140, 0.2970, 0.0110),
(264, 74, 135, 11.00, '1173', 0.00, '2025-06-26 09:46:28', 176.00, 1.80, 18.00, 2.7190, 0.3760, 0.3800, 0.3600, 0.0130),
(265, 74, 137, 156.00, '1175', 0.00, '2025-06-26 09:46:28', 2496.00, 0.50, 12.00, 1.9000, 0.1840, 0.1710, 0.1660, -0.0040),
(266, 74, 156, 158.00, '1190', 0.00, '2025-06-26 09:46:28', 2528.00, 1.35, 19.00, 2.1080, 0.2550, 0.2470, 0.2400, -0.0010),
(267, 74, 164, 79.00, '1198', 0.00, '2025-06-26 09:46:28', 1264.00, 0.50, 14.00, 2.0720, 0.1770, 0.1590, 0.1490, -0.0040),
(268, 74, 169, 187.00, '1201', 0.00, '2025-06-26 09:46:28', 2992.00, 0.70, 15.00, 2.0940, 0.1650, 0.1480, 0.1380, -0.0030),
(269, 74, 170, 99.00, '1202', 0.00, '2025-06-26 09:46:28', 1584.00, 0.80, 29.00, 2.5370, 0.1640, 0.1600, 0.1560, 0.0000),
(270, 74, 171, 107.00, '1203', 0.00, '2025-06-26 09:46:28', 1712.00, 0.90, 9.50, 1.7960, 0.1400, 0.1340, 0.1310, -0.0010),
(271, 74, 172, 184.00, '1204', 0.00, '2025-06-26 09:46:28', 2944.00, 0.70, 13.00, 2.0700, 0.1990, 0.1840, 0.1740, -0.0020),
(272, 74, 173, 2.00, '1205', 0.00, '2025-06-26 09:46:28', 32.00, 0.65, 13.00, 2.1130, 0.2460, 0.2420, 0.2340, 0.0020),
(273, 75, 181, 250.00, '1211', 0.00, '2025-06-28 09:03:58', 3988.00, 1.45, 19.00, 1.8620, 0.1580, 0.1510, 0.1440, 0.0010),
(274, 75, 182, 221.00, '1212', 0.00, '2025-06-28 09:03:58', 3526.14, 1.30, 16.50, 1.9140, 0.1650, 0.1570, 0.1480, 0.0000),
(275, 75, 183, 4.00, '1213', 0.00, '2025-06-28 09:03:58', 63.82, 3.20, 18.50, 2.2900, 0.3080, 0.3140, 0.2970, 0.0110),
(279, 76, 187, 111.00, '1218', 0.00, '2025-06-30 14:02:41', 1772.67, 0.60, 14.00, 2.0580, 0.1700, 0.1570, 0.1500, -0.0030),
(280, 76, 192, 139.00, '1223', 0.00, '2025-06-30 14:02:41', 2217.85, 0.70, 17.50, 2.3900, 0.1490, 0.1410, 0.1370, -0.0020),
(291, 77, 186, 230.00, '1217', 0.00, '2025-07-02 11:02:09', 3680.00, 0.50, 13.50, 2.0730, 0.1900, 0.1740, 0.1640, -0.0030),
(292, 77, 187, 100.00, '1218', 0.00, '2025-07-02 11:02:09', 1600.00, 0.60, 14.00, 2.0580, 0.1700, 0.1570, 0.1500, -0.0030),
(293, 77, 188, 35.00, '1219', 0.00, '2025-07-02 11:02:09', 560.00, 0.40, 21.00, 2.3930, 0.2180, 0.2030, 0.1890, 0.0000),
(294, 77, 189, 23.00, '1220', 0.00, '2025-07-02 11:02:09', 368.00, 1.20, 19.50, 2.1790, 0.2210, 0.2100, 0.1970, 0.0010),
(295, 77, 190, 1.00, '1221', 0.00, '2025-07-02 11:02:09', 16.00, 0.40, 19.00, 2.1740, 0.1930, 0.1740, 0.1620, -0.0030),
(296, 77, 191, 72.00, '1222', 0.00, '2025-07-02 11:02:09', 1152.00, 0.40, 7.00, 1.7700, 0.1380, 0.1310, 0.1280, -0.0030),
(297, 77, 193, 141.00, '1224', 0.00, '2025-07-02 11:02:09', 2256.00, 1.75, 28.50, 2.2510, 0.1780, 0.1760, 0.1710, 0.0020),
(298, 77, 194, 250.00, '1225', 0.00, '2025-07-02 11:02:09', 4000.00, 0.75, 13.00, 2.1990, 0.2020, 0.1880, 0.1770, -0.0020),
(299, 77, 195, 230.00, '1226', 0.00, '2025-07-02 11:02:09', 3680.00, 0.75, 13.00, 2.0750, 0.1800, 0.1650, 0.1580, -0.0030),
(300, 77, 196, 20.00, '1227', 0.00, '2025-07-02 11:02:09', 320.00, 2.25, 18.50, 2.2820, 0.2800, 0.2760, 0.2590, 0.0070),
(313, 79, 135, 7.00, '1173', 0.00, '2025-07-05 13:58:50', 111.44, 1.80, 18.00, 2.7190, 0.3760, 0.3800, 0.3600, 0.0130),
(314, 79, 200, 62.00, '1231', 0.00, '2025-07-05 13:58:50', 989.60, 0.60, 11.00, 2.0170, 0.1610, 0.1540, 0.1450, 0.0010),
(315, 79, 201, 10.00, '1232', 0.00, '2025-07-05 13:58:50', 160.50, 0.85, 9.50, 1.8400, 0.1510, 0.1380, 0.1290, -0.0030),
(316, 79, 203, 11.00, '1234', 0.00, '2025-07-05 13:58:50', 174.93, 0.50, 23.50, 2.1490, 0.1460, 0.1460, 0.1450, 0.0010),
(317, 79, 206, 227.00, '1237', 0.00, '2025-07-05 13:58:50', 3627.86, 0.70, 13.00, 1.9160, 0.1680, 0.1580, 0.1480, 0.0000),
(318, 79, 207, 9.00, '1238', 0.00, '2025-07-05 13:58:50', 143.83, 0.60, 15.00, 1.9010, 0.1380, 0.1280, 0.1200, -0.0010),
(445, 82, 198, 140.00, '1229', 0.00, '2025-07-14 07:40:09', 2240.00, 0.80, 12.00, 1.7860, 0.1550, 0.1490, 0.1440, 0.0000),
(446, 82, 216, 86.00, '1247', 0.00, '2025-07-14 07:40:09', 1376.00, 2.65, 32.00, 2.4010, 0.2070, 0.2020, 0.1900, 0.0040),
(447, 82, 221, 21.00, '1252', 0.00, '2025-07-14 07:40:09', 336.00, 1.20, 17.50, 2.2360, 0.1990, 0.1930, 0.1840, 0.0020),
(448, 82, 222, 75.00, '1253', 0.00, '2025-07-14 07:40:09', 1200.00, 0.85, 15.00, 1.8900, 0.1680, 0.1600, 0.1530, 0.0000),
(449, 82, 223, 500.00, '1254', 0.00, '2025-07-14 07:40:09', 8000.00, 1.70, 26.00, 2.7800, 0.2800, 0.2780, 0.2600, 0.0080),
(450, 82, 224, 256.00, '1255', 0.00, '2025-07-14 07:40:09', 4096.00, 1.55, 10.50, 2.0180, 0.1760, 0.1710, 0.1620, 0.0020),
(451, 82, 226, 98.00, '1257', 0.00, '2025-07-14 07:40:09', 1568.00, 1.50, 30.50, 2.0460, 0.1500, 0.1500, 0.1450, 0.0030),
(452, 82, 227, 53.00, '1258', 0.00, '2025-07-14 07:40:09', 848.00, 1.60, 13.50, 1.8460, 0.1330, 0.1300, 0.1220, 0.0020),
(453, 82, 228, 220.00, '1259', 0.00, '2025-07-14 07:40:09', 3520.00, 1.70, 25.50, 2.6740, 0.2560, 0.2540, 0.2390, 0.0060),
(454, 82, 229, 148.00, '1260', 0.00, '2025-07-14 07:40:09', 2368.00, 2.05, 23.50, 2.7070, 0.2940, 0.2930, 0.2760, 0.0070),
(455, 83, 230, 500.00, '1261', 0.00, '2025-07-15 08:31:12', 7995.00, 0.80, 17.00, 2.3200, 0.2030, 0.1930, 0.1860, -0.0010),
(456, 83, 231, 465.00, '1262', 0.00, '2025-07-15 08:31:12', 7445.00, 1.15, 17.50, 2.2060, 0.1970, 0.1880, 0.1790, 0.0000),
(457, 80, 135, 3.00, '1173', 0.00, '2025-07-15 13:50:36', 48.00, 1.80, 18.00, 2.7190, 0.3760, 0.3800, 0.3600, 0.0130),
(458, 80, 184, 65.00, '1214', 0.00, '2025-07-15 13:50:36', 1040.00, 1.85, 28.00, 2.4370, 0.2040, 0.2030, 0.1950, 0.0040),
(459, 80, 185, 83.00, '1215', 0.00, '2025-07-15 13:50:36', 1328.00, 1.20, 16.50, 2.1810, 0.2030, 0.1940, 0.1830, 0.0010),
(460, 80, 199, 60.00, '1230', 0.00, '2025-07-15 13:50:36', 960.00, 1.60, 12.50, 1.8800, 0.1720, 0.1680, 0.1630, 0.0000),
(461, 80, 208, 67.00, '1239', 0.00, '2025-07-15 13:50:36', 1072.00, 1.80, 26.00, 2.2090, 0.1700, 0.1660, 0.1590, 0.0020),
(522, 87, 233, 1415.00, '1264', 0.00, '2025-07-26 12:01:53', 22650.00, 0.95, 18.50, 2.2570, 0.1700, 0.1630, 0.1530, 0.0010),
(529, 89, 197, 160.00, '1228', 0.00, '2025-07-27 08:44:35', 2560.00, 0.80, 13.00, 1.9510, 0.1720, 0.1610, 0.1540, -0.0020),
(530, 89, 228, 280.00, '1259', 0.00, '2025-07-27 08:44:35', 4480.00, 1.70, 25.50, 2.6740, 0.2560, 0.2540, 0.2390, 0.0060),
(531, 89, 232, 10.00, '1263', 0.00, '2025-07-27 08:44:35', 160.00, 2.35, 28.50, 2.5020, 0.2060, 0.2020, 0.1940, 0.0030),
(542, 86, 135, 8.00, '1173', 0.00, '2025-07-27 14:34:17', 128.00, 1.80, 18.00, 2.7190, 0.3760, 0.3800, 0.3600, 0.0130),
(543, 86, 202, 111.00, '1233', 0.00, '2025-07-27 14:34:17', 1776.00, 0.50, 23.50, 2.1750, 0.1640, 0.1640, 0.1600, 0.0020),
(544, 86, 204, 156.00, '1235', 0.00, '2025-07-27 14:34:17', 2496.00, 0.90, 13.00, 2.1660, 0.2130, 0.2000, 0.1880, -0.0010),
(545, 86, 205, 80.00, '1236', 0.00, '2025-07-27 14:34:17', 1280.00, 0.50, 18.50, 1.9850, 0.1530, 0.1480, 0.1430, 0.0010),
(546, 86, 209, 154.00, '1240', 0.00, '2025-07-27 14:34:17', 2464.00, 0.55, 13.50, 2.1320, 0.2040, 0.1900, 0.1780, -0.0010),
(547, 86, 211, 47.00, '1242', 0.00, '2025-07-27 14:34:17', 752.00, 0.80, 1.80, 2.2280, 0.1510, 0.1560, 0.1540, 0.0030),
(548, 86, 217, 124.00, '1248', 0.00, '2025-07-27 14:34:17', 1984.00, 0.85, 14.00, 2.0010, 0.1800, 0.1720, 0.1640, 0.0000),
(549, 86, 218, 125.00, '1249', 0.00, '2025-07-27 14:34:17', 2000.00, 0.85, 13.00, 2.0240, 0.1940, 0.1860, 0.1800, -0.0010),
(550, 86, 219, 134.00, '1250', 0.00, '2025-07-27 14:34:17', 2144.00, 0.70, 12.50, 2.0420, 0.2040, 0.1940, 0.1870, -0.0010),
(551, 86, 220, 12.00, '1251', 0.00, '2025-07-27 14:34:17', 192.00, 0.50, 17.00, 1.9940, 0.1590, 0.1520, 0.1460, 0.0000),
(572, 91, 232, 35.00, '1263', 0.00, '2025-07-29 14:38:03', 560.00, 2.35, 28.50, 2.5020, 0.2060, 0.2020, 0.1940, 0.0030),
(573, 91, 235, 89.50, '1268', 0.00, '2025-07-29 14:38:03', 1432.00, 1.50, 17.00, 2.5810, 0.2360, 0.2300, 0.2190, 0.0030),
(574, 91, 236, 99.00, '1266', 0.00, '2025-07-29 14:38:03', 1584.00, 1.25, 12.50, 1.6800, 0.1690, 0.1720, 0.1690, 0.0030),
(575, 91, 237, 56.00, '1267', 0.00, '2025-07-29 14:38:03', 896.00, 1.95, 24.50, 2.4370, 0.1780, 0.1730, 0.1650, 0.0010),
(576, 91, 238, 15.50, '0', 0.00, '2025-07-29 14:38:03', 248.00, 1.35, 31.50, 2.8460, 0.4350, 0.4300, 0.4040, 0.0100),
(581, 94, 240, 100.00, '1270', 0.00, '2025-07-30 10:33:11', 1598.33, 1.50, 19.50, 2.1490, 0.1770, 0.1760, 0.1680, 0.0030),
(582, 94, 241, 100.00, '1271', 0.00, '2025-07-30 10:33:11', 1598.00, 1.15, 16.00, 2.0300, 0.1780, 0.1780, 0.1710, 0.0030),
(710, 101, 255, 51.00, '1285', 0.00, '2025-08-04 15:42:34', 816.05, 1.10, 13.00, 2.2020, 0.2250, 0.2170, 0.2060, 0.0010),
(711, 101, 263, 250.00, '1293', 0.00, '2025-08-04 15:42:34', 3996.80, 0.75, 12.00, 1.8940, 0.1690, 0.1600, 0.1530, -0.0010),
(712, 101, 264, 250.00, '1294', 0.00, '2025-08-04 15:42:34', 3993.20, 0.75, 13.50, 1.7050, 0.1490, 0.1410, 0.1360, -0.0010),
(713, 101, 273, 503.00, '1303', 0.00, '2025-08-04 15:42:34', 1.00, 0.90, 16.00, 2.1170, 0.2000, 0.1920, 0.1850, -0.0010),
(732, 102, 255, 36.00, '1285', 0.00, '2025-08-05 05:52:18', 576.04, 1.10, 13.00, 2.2020, 0.2250, 0.2170, 0.2060, 0.0010),
(733, 102, 258, 250.00, '1288', 0.00, '2025-08-05 05:52:18', 3976.80, 0.60, 13.50, 1.9870, 0.1510, 0.1410, 0.1350, -0.0020),
(734, 102, 259, 241.00, '1289', 0.00, '2025-08-05 05:52:18', 3857.50, 0.90, 13.50, 1.9450, 0.1420, 0.1380, 0.1330, 0.0000),
(735, 103, 255, 27.00, '1285', 0.00, '2025-08-05 06:00:12', 432.03, 1.10, 13.00, 2.2020, 0.2250, 0.2170, 0.2060, 0.0010),
(736, 103, 269, 250.00, '1299', 0.00, '2025-08-05 06:00:12', 4000.90, 0.80, 11.50, 1.8260, 0.1560, 0.1470, 0.1410, -0.0020),
(737, 103, 270, 250.00, '1300', 0.00, '2025-08-05 06:00:12', 3998.90, 0.90, 13.00, 1.8170, 0.1560, 0.1500, 0.1430, 0.0000),
(805, 106, 245, 180.00, '1275', 0.00, '2025-08-06 13:12:47', 2878.80, 0.80, 11.50, 1.8710, 0.1300, 0.1250, 0.1210, 0.0000),
(806, 106, 267, 100.00, '1297', 0.00, '2025-08-06 13:12:47', 1595.00, 1.15, 14.50, 2.0670, 0.1810, 0.1730, 0.1680, -0.0010),
(807, 106, 278, 184.00, '1310', 0.00, '2025-08-06 13:12:47', 2933.00, 0.55, 16.50, 2.0800, 0.2020, 0.1840, 0.1760, -0.0040),
(808, 106, 281, 36.00, '1313', 0.00, '2025-08-06 13:12:47', 572.19, 1.35, 19.00, 1.9680, 0.1970, 0.1930, 0.1850, 0.0020),
(809, 71, 135, 2.00, '1173', 0.00, '2025-08-06 14:12:47', 32.00, 1.80, 18.00, 2.7190, 0.3760, 0.3800, 0.3600, 0.0130),
(810, 71, 162, 1.00, '1196', 0.00, '2025-08-06 14:12:47', 16.00, 0.75, 14.00, 2.0440, 0.1630, 0.1560, 0.1520, -0.0010),
(811, 71, 167, 2.00, '1199', 0.00, '2025-08-06 14:12:47', 32.00, 1.80, 25.50, 2.5870, 0.2000, 0.1950, 0.1870, 0.0020),
(812, 71, 185, 2.00, '1215', 0.00, '2025-08-06 14:12:47', 32.00, 1.20, 16.50, 2.1810, 0.2030, 0.1940, 0.1830, 0.0010),
(813, 71, 217, 1.00, '1248', 0.00, '2025-08-06 14:12:47', 16.00, 0.85, 14.00, 2.0010, 0.1800, 0.1720, 0.1640, 0.0000),
(814, 71, 232, 1.00, '1263', 0.00, '2025-08-06 14:12:47', 16.00, 2.35, 28.50, 2.5020, 0.2060, 0.2020, 0.1940, 0.0030),
(815, 71, 261, 1.00, '1291', 0.00, '2025-08-06 14:12:47', 16.00, 0.60, 18.50, 1.7790, 0.1500, 0.1460, 0.1440, -0.0010),
(816, 71, 285, 1.00, '1315', 0.00, '2025-08-06 14:12:47', 16.00, 1.55, 18.00, 2.0030, 0.1690, 0.1680, 0.1620, 0.0030),
(832, 98, 178, 11.00, '1210', 0.00, '2025-08-07 07:47:39', 176.00, 3.00, 19.00, 2.5080, 0.3080, 0.3130, 0.2950, 0.0110),
(833, 98, 238, 10.00, '0', 0.00, '2025-08-07 07:47:39', 160.00, 1.35, 31.50, 2.8460, 0.4350, 0.4300, 0.4040, 0.0100),
(834, 98, 239, 106.00, '1269', 0.00, '2025-08-07 07:47:39', 1696.00, 0.70, 14.00, 2.0460, 0.1530, 0.1420, 0.1340, -0.0010),
(835, 98, 242, 186.00, '1272', 0.00, '2025-08-07 07:47:39', 2976.00, 0.80, 14.00, 2.1630, 0.1970, 0.1890, 0.1770, 0.0010),
(836, 98, 243, 158.00, '1273', 0.00, '2025-08-07 07:47:39', 2528.00, 0.80, 10.00, 1.9740, 0.1900, 0.1720, 0.1630, -0.0040),
(837, 98, 244, 6.00, '1274', 0.00, '2025-08-07 07:47:39', 96.00, 0.65, 11.00, 1.9560, 0.2060, 0.1920, 0.1830, -0.0020),
(838, 98, 247, 20.00, '1277', 0.00, '2025-08-07 07:47:39', 320.00, 2.20, 33.00, 2.6030, 0.1760, 0.1760, 0.1690, 0.0040),
(839, 98, 248, 230.00, '1278', 0.00, '2025-08-07 07:47:39', 3680.00, 0.70, 11.50, 1.8370, 0.1330, 0.1300, 0.1260, 0.0000),
(840, 98, 249, 60.00, '1279', 0.00, '2025-08-07 07:47:39', 960.00, 1.15, 14.00, 2.0770, 0.1760, 0.1700, 0.1640, 0.0000),
(841, 98, 250, 107.00, '1280', 0.00, '2025-08-07 07:47:39', 1712.00, 0.80, 12.00, 2.0070, 0.1960, 0.1850, 0.1760, -0.0010),
(842, 98, 251, 69.00, '1281', 0.00, '2025-08-07 07:47:39', 1104.00, 0.95, 23.50, 2.3030, 0.1650, 0.1630, 0.1600, 0.0010),
(843, 98, 252, 120.00, '1282', 0.00, '2025-08-07 07:47:39', 1920.00, 0.80, 18.00, 2.2160, 0.1550, 0.1570, 0.1540, 0.0020),
(844, 98, 254, 200.00, '1284', 0.00, '2025-08-07 07:47:39', 3200.00, 1.05, 10.50, 1.7180, 0.1490, 0.1450, 0.1390, 0.0010),
(845, 98, 257, 174.00, '1287', 0.00, '2025-08-07 07:47:39', 2784.00, 0.80, 15.50, 2.0060, 0.1470, 0.1400, 0.1340, 0.0000),
(846, 98, 260, 10.00, '1290', 0.00, '2025-08-07 07:47:39', 160.00, 2.55, 13.00, 1.8020, 0.2180, 0.2250, 0.2180, 0.0070),
(847, 98, 261, 15.00, '1291', 0.00, '2025-08-07 07:47:39', 240.00, 0.60, 18.50, 1.7790, 0.1500, 0.1460, 0.1440, -0.0010),
(848, 98, 262, 120.00, '1292', 0.00, '2025-08-07 07:47:39', 1920.00, 0.70, 16.50, 2.1440, 0.1780, 0.1740, 0.1680, 0.0020),
(849, 98, 271, 45.00, '1301', 0.00, '2025-08-07 07:47:39', 720.00, 0.70, 14.00, 1.8890, 0.1680, 0.1560, 0.1470, -0.0010),
(850, 98, 272, 47.00, '1302', 0.00, '2025-08-07 07:47:39', 752.00, 0.70, 18.50, 2.0470, 0.1570, 0.1610, 0.1610, 0.0030),
(851, 98, 275, 91.00, '1305', 0.00, '2025-08-07 07:47:39', 1456.00, 0.65, 21.50, 2.4910, 0.2490, 0.2340, 0.2220, -0.0010),
(852, 98, 280, 156.00, '1312', 0.00, '2025-08-07 07:47:39', 2496.00, 0.60, 12.00, 1.9490, 0.1810, 0.1730, 0.1680, -0.0020),
(853, 104, 234, 46.00, '1265', 0.00, '2025-08-07 11:15:29', 736.00, 2.10, 37.00, 2.5780, 0.2080, 0.2030, 0.1940, 0.0020),
(854, 104, 238, 7.50, '0', 0.00, '2025-08-07 11:15:29', 120.00, 1.35, 31.50, 2.8460, 0.4350, 0.4300, 0.4040, 0.0100),
(855, 104, 240, 20.00, '1270', 0.00, '2025-08-07 11:15:29', 320.00, 1.50, 19.50, 2.1490, 0.1770, 0.1760, 0.1680, 0.0030),
(856, 104, 246, 118.00, '1276', 0.00, '2025-08-07 11:15:29', 1888.00, 1.70, 15.00, 2.0300, 0.1470, 0.1450, 0.1370, 0.0030),
(857, 104, 265, 200.00, '1295', 0.00, '2025-08-07 11:15:29', 3200.00, 1.65, 14.50, 2.1360, 0.1770, 0.1750, 0.1670, 0.0030),
(858, 104, 266, 78.00, '1296', 0.00, '2025-08-07 11:15:29', 1248.00, 1.60, 16.50, 2.1460, 0.1780, 0.1720, 0.1640, 0.0010),
(859, 104, 268, 29.00, '1298', 0.00, '2025-08-07 11:15:29', 464.00, 2.15, 35.50, 2.6180, 0.2080, 0.2030, 0.1960, 0.0010),
(860, 108, 212, 10.00, '1243', 0.00, '2025-08-07 13:32:27', 160.00, 0.40, 9.50, 1.7800, 0.1680, 0.1610, 0.1580, -0.0020),
(861, 108, 255, 81.00, '1285', 0.00, '2025-08-07 13:32:27', 1296.00, 1.10, 13.00, 2.2020, 0.2250, 0.2170, 0.2060, 0.0010),
(862, 108, 282, 149.00, '1314', 0.00, '2025-08-07 13:32:27', 2384.00, 0.50, 14.00, 2.1240, 0.2040, 0.1900, 0.1810, -0.0030),
(863, 108, 285, 99.00, '1315', 0.00, '2025-08-07 13:32:27', 1584.00, 1.55, 18.00, 2.0030, 0.1690, 0.1680, 0.1620, 0.0030),
(864, 108, 286, 53.00, '1316', 0.00, '2025-08-07 13:32:27', 848.00, 0.45, 13.00, 1.7570, 0.1390, 0.1350, 0.1320, -0.0010),
(865, 108, 287, 2.00, '1317', 0.00, '2025-08-07 13:32:27', 32.00, 0.45, 10.00, 1.6050, 0.2180, 0.2320, 0.2280, 0.0090),
(912, 107, 212, 40.00, '1243', 0.00, '2025-08-14 11:38:22', 640.00, 0.40, 9.50, 1.7800, 0.1680, 0.1610, 0.1580, -0.0020),
(913, 107, 253, 191.00, '1283', 0.00, '2025-08-14 11:38:22', 3056.00, 0.45, 11.50, 2.0470, 0.1770, 0.1630, 0.1560, -0.0040),
(914, 107, 277, 198.00, '1309', 0.00, '2025-08-14 11:38:22', 3168.00, 0.85, 19.50, 2.1870, 0.1980, 0.1880, 0.1770, 0.0010),
(915, 107, 281, 49.00, '1313', 0.00, '2025-08-14 11:38:22', 784.00, 1.35, 19.00, 1.9680, 0.1970, 0.1930, 0.1850, 0.0020),
(916, 107, 282, 22.00, '1314', 0.00, '2025-08-14 11:38:22', 352.00, 0.50, 14.00, 2.1240, 0.2040, 0.1900, 0.1810, -0.0030),
(934, 111, 288, 36.00, '1318', 0.00, '2025-08-18 10:20:58', 574.58, 1.45, 17.50, 2.0370, 0.2100, 0.2070, 0.1990, 0.0030),
(935, 111, 300, 280.00, '1330', 0.00, '2025-08-18 10:20:58', 4476.30, 1.50, 14.50, 1.9310, 0.1710, 0.1650, 0.1580, 0.0010),
(936, 111, 301, 270.00, '1331', 0.00, '2025-08-18 10:20:58', 4315.00, 1.40, 15.50, 2.0380, 0.1770, 0.1720, 0.1630, 0.0010),
(968, 113, 308, 40.00, '1338', 0.00, '2025-08-21 07:13:34', 640.00, 0.95, 11.50, 2.1130, 0.1870, 0.1820, 0.1750, 0.0010),
(969, 113, 309, 14.00, '1339', 0.00, '2025-08-21 07:13:34', 224.00, 0.70, 28.50, 2.4630, 0.1780, 0.1730, 0.1640, 0.0020),
(970, 113, 312, 500.00, '1342', 0.00, '2025-08-21 07:13:34', 8000.00, 0.75, 11.50, 1.7870, 0.1470, 0.1390, 0.1330, 0.0000),
(971, 113, 313, 500.00, '1343', 0.00, '2025-08-21 07:13:34', 8000.00, 0.75, 11.00, 1.7910, 0.1450, 0.1380, 0.1320, -0.0010),
(981, 115, 307, 73.00, '1337', 0.00, '2025-08-21 08:29:03', 1168.00, 1.85, 13.00, 1.9960, 0.2060, 0.2090, 0.1980, 0.0070),
(982, 115, 317, 202.00, '1347', 0.00, '2025-08-21 08:29:03', 3232.00, 0.80, 13.00, 1.9840, 0.1650, 0.1590, 0.1510, 0.0020),
(983, 115, 318, 252.00, '1348', 0.00, '2025-08-21 08:29:03', 4032.00, 0.75, 11.00, 1.7620, 0.1440, 0.1380, 0.1320, 0.0000),
(984, 114, 307, 77.00, '1337', 0.00, '2025-08-21 08:29:24', 1232.00, 1.85, 13.00, 1.9960, 0.2060, 0.2090, 0.1980, 0.0070),
(985, 114, 311, 250.00, '1341', 0.00, '2025-08-21 08:29:24', 4000.00, 0.75, 12.00, 1.7790, 0.1500, 0.1440, 0.1380, 0.0000),
(986, 114, 314, 200.00, '1344', 0.00, '2025-08-21 08:29:24', 3200.00, 0.80, 11.50, 1.8140, 0.1420, 0.1360, 0.1310, -0.0010),
(1000, 117, 320, 500.00, '1350', 0.00, '2025-08-21 13:10:12', 1.00, 0.75, 12.50, 1.8570, 0.1500, 0.1430, 0.1360, 0.0000),
(1014, 116, 307, 46.00, '1337', 0.00, '2025-08-23 06:07:26', 736.00, 1.85, 13.00, 1.9960, 0.2060, 0.2090, 0.1980, 0.0070),
(1015, 116, 308, 42.00, '1338', 0.00, '2025-08-23 06:07:26', 672.00, 0.95, 11.50, 2.1130, 0.1870, 0.1820, 0.1750, 0.0010),
(1016, 116, 309, 3.00, '1339', 0.00, '2025-08-23 06:07:26', 48.00, 0.70, 28.50, 2.4630, 0.1780, 0.1730, 0.1640, 0.0020),
(1017, 116, 310, 250.00, '1340', 0.00, '2025-08-23 06:07:26', 4000.00, 0.80, 12.00, 1.7850, 0.1570, 0.1510, 0.1450, 0.0000),
(1018, 116, 315, 55.00, '1345', 0.00, '2025-08-23 06:07:26', 880.00, 0.85, 13.00, 1.9960, 0.1810, 0.1790, 0.1720, 0.0020),
(1019, 116, 316, 73.00, '1346', 0.00, '2025-08-23 06:07:26', 1168.00, 0.55, 8.50, 1.7120, 0.1240, 0.1180, 0.1130, -0.0010),
(1020, 116, 317, 58.00, '1347', 0.00, '2025-08-23 06:07:26', 928.00, 0.80, 13.00, 1.9840, 0.1650, 0.1590, 0.1510, 0.0020),
(1021, 118, 319, 8.00, '1349', 0.00, '2025-08-23 06:09:36', 128.03, 1.05, 13.00, 1.9460, 0.2520, 0.2540, 0.2410, 0.0070),
(1022, 118, 321, 250.00, '1351', 0.00, '2025-08-23 06:09:36', 3987.00, 0.65, 14.50, 2.1550, 0.1930, 0.1840, 0.1730, 0.0010),
(1023, 118, 324, 280.00, '1354', 0.00, '2025-08-23 06:09:36', 4466.70, 0.85, 13.00, 2.0850, 0.1960, 0.1860, 0.1750, 0.0000),
(1024, 118, 325, 62.00, '1355', 0.00, '2025-08-23 06:09:36', 989.61, 0.85, 13.00, 2.1300, 0.1940, 0.1830, 0.1710, 0.0010),
(1047, 122, 238, 9.00, '0', 0.00, '2025-08-26 11:43:51', 144.00, 1.35, 31.50, 2.8460, 0.4350, 0.4300, 0.4040, 0.0100),
(1048, 122, 276, 181.00, '1306', 0.00, '2025-08-26 11:43:51', 2888.10, 3.35, 0.00, 3.2200, 1.1900, 1.1750, 1.1120, 0.0250),
(1049, 122, 283, 134.00, '1307', 0.00, '2025-08-26 11:43:51', 2158.00, 3.35, 0.00, 2.8820, 0.6120, 0.6460, 0.6310, 0.0250),
(1050, 122, 284, 149.00, '1308', 0.00, '2025-08-26 11:43:51', 2383.00, 6.80, 0.00, 3.0530, 1.4770, 1.6020, 1.4010, 0.1630),
(1051, 122, 336, 52.00, '0', 0.00, '2025-08-26 11:43:51', 832.00, 3.00, 30.00, 2.1580, 0.2460, 0.2480, 0.2240, 0.0130),
(1052, 119, 334, 20.00, '1364', 0.00, '2025-08-26 11:45:36', 320.00, 1.00, 40.50, 2.5270, 0.1790, 0.1810, 0.1740, 0.0050),
(1053, 121, 334, 5.00, '1364', 0.00, '2025-08-26 11:46:01', 80.00, 1.00, 40.50, 2.5270, 0.1790, 0.1810, 0.1740, 0.0050),
(1054, 120, 322, 248.00, '1352', 0.00, '2025-08-26 11:46:13', 3968.00, 0.75, 12.50, 2.0820, 0.1770, 0.1720, 0.1630, 0.0010),
(1055, 120, 325, 203.00, '1355', 0.00, '2025-08-26 11:46:13', 3248.00, 0.85, 13.00, 2.1300, 0.1940, 0.1830, 0.1710, 0.0010),
(1056, 120, 327, 67.00, '1357', 0.00, '2025-08-26 11:46:13', 1072.00, 0.90, 15.50, 2.0180, 0.1840, 0.1790, 0.1730, 0.0010),
(1074, 109, 288, 2.00, '1318', 0.00, '2025-08-26 11:49:09', 32.00, 1.45, 17.50, 2.0370, 0.2100, 0.2070, 0.1990, 0.0030),
(1075, 109, 289, 215.00, '1319', 0.00, '2025-08-26 11:49:09', 3440.00, 0.60, 13.50, 2.0250, 0.1970, 0.1840, 0.1760, -0.0020),
(1076, 109, 290, 201.00, '1320', 0.00, '2025-08-26 11:49:09', 3216.00, 0.70, 12.00, 1.8730, 0.1540, 0.1470, 0.1410, 0.0000),
(1077, 109, 291, 220.00, '1321', 0.00, '2025-08-26 11:49:09', 3520.00, 0.70, 13.50, 1.9920, 0.1670, 0.1550, 0.1480, -0.0030),
(1078, 109, 292, 220.00, '1322', 0.00, '2025-08-26 11:49:09', 3520.00, 0.60, 12.50, 2.0500, 0.1810, 0.1730, 0.1670, -0.0010),
(1079, 109, 293, 66.00, '1323', 0.00, '2025-08-26 11:49:09', 1056.00, 0.55, 21.50, 2.4530, 0.2190, 0.2140, 0.2110, -0.0010),
(1080, 109, 294, 156.00, '1324', 0.00, '2025-08-26 11:49:09', 2496.00, 0.60, 15.50, 2.1770, 0.1770, 0.1650, 0.1580, -0.0020),
(1081, 109, 295, 250.00, '1325', 0.00, '2025-08-26 11:49:09', 4000.00, 0.55, 15.00, 2.1600, 0.1980, 0.1850, 0.1760, -0.0020),
(1082, 109, 296, 250.00, '1326', 0.00, '2025-08-26 11:49:09', 4000.00, 0.55, 12.50, 2.0460, 0.1780, 0.1660, 0.1580, -0.0020),
(1083, 109, 297, 172.00, '1327', 0.00, '2025-08-26 11:49:09', 2752.00, 0.67, 16.00, 2.3790, 0.2010, 0.1910, 0.1810, 0.0000),
(1084, 109, 298, 250.00, '1328', 0.00, '2025-08-26 11:49:09', 4000.00, 0.60, 14.00, 1.7650, 0.1430, 0.1360, 0.1310, -0.0010),
(1085, 109, 299, 250.00, '1329', 0.00, '2025-08-26 11:49:09', 4000.00, 0.65, 12.00, 1.8220, 0.1490, 0.1420, 0.1370, -0.0010),
(1086, 109, 302, 128.00, '1332', 0.00, '2025-08-26 11:49:09', 2048.00, 0.65, 11.00, 1.7800, 0.1510, 0.1480, 0.1430, 0.0010),
(1087, 109, 305, 250.00, '1335', 0.00, '2025-08-26 11:49:09', 4000.00, 0.45, 11.50, 1.8500, 0.1610, 0.1530, 0.1480, -0.0010),
(1088, 109, 329, 125.00, '1359', 0.00, '2025-08-26 11:49:09', 2000.00, 0.60, 15.00, 2.1670, 0.1710, 0.1570, 0.1480, -0.0030),
(1089, 109, 330, 238.00, '1360', 0.00, '2025-08-26 11:49:09', 3808.00, 0.60, 15.00, 2.0290, 0.1770, 0.1630, 0.1530, -0.0020),
(1090, 109, 331, 180.00, '1361', 0.00, '2025-08-26 11:49:09', 2880.00, 0.60, 15.50, 2.2040, 0.2010, 0.1880, 0.1780, -0.0020),
(1091, 112, 297, 2.00, '1327', 0.00, '2025-08-26 11:54:32', 32.00, 0.67, 16.00, 2.3790, 0.2010, 0.1910, 0.1810, 0.0000),
(1092, 112, 304, 2.00, '1334', 0.00, '2025-08-26 11:54:32', 32.00, 0.45, 11.50, 1.8420, 0.1590, 0.1500, 0.1440, -0.0020),
(1093, 123, 304, 3.00, '1334', 0.00, '2025-08-26 11:55:24', 47.97, 0.45, 11.50, 1.8420, 0.1590, 0.1500, 0.1440, -0.0020),
(1094, 124, 304, 1.00, '1334', 0.00, '2025-08-26 11:56:13', 15.99, 0.45, 11.50, 1.8420, 0.1590, 0.1500, 0.1440, -0.0020),
(1100, 125, 303, 67.00, '1333', 0.00, '2025-08-26 17:45:19', 1072.00, 1.20, 17.00, 2.0340, 0.1470, 0.1430, 0.1360, 0.0010),
(1101, 125, 306, 280.00, '1336', 0.00, '2025-08-26 17:45:19', 4480.00, 1.75, 13.50, 1.9890, 0.1700, 0.1650, 0.1550, 0.0030),
(1102, 125, 307, 74.00, '1337', 0.00, '2025-08-26 17:45:19', 1184.00, 1.85, 13.00, 1.9960, 0.2060, 0.2090, 0.1980, 0.0070),
(1103, 125, 333, 73.00, '1363', 0.00, '2025-08-26 17:45:19', 1168.00, 1.50, 1.65, 1.9350, 0.1620, 0.1620, 0.1550, 0.0030),
(1104, 125, 334, 3.00, '1364', 0.00, '2025-08-26 17:45:19', 48.00, 1.00, 40.50, 2.5270, 0.1790, 0.1810, 0.1740, 0.0050),
(1105, 125, 338, 3.00, '0', 0.00, '2025-08-26 17:45:19', 48.00, 1.10, 43.00, 2.7510, 0.3190, 0.3080, 0.2880, 0.0040),
(1112, 126, 304, 244.00, '1334', 0.00, '2025-09-01 15:42:48', 3904.00, 0.45, 11.50, 1.8420, 0.1590, 0.1500, 0.1440, -0.0020),
(1113, 126, 328, 115.00, '1358', 0.00, '2025-09-01 15:42:48', 1840.00, 0.80, 12.50, 2.0260, 0.2130, 0.2040, 0.1950, 0.0000),
(1114, 126, 332, 102.00, '1362', 0.00, '2025-09-01 15:42:48', 1632.00, 0.80, 11.50, 1.8600, 0.1360, 0.1350, 0.1340, 0.0010),
(1115, 126, 337, 56.00, '1366', 0.00, '2025-09-01 15:42:48', 896.00, 1.25, 14.50, 1.7550, 0.1530, 0.1510, 0.1460, 0.0010),
(1116, 126, 338, 9.00, '0', 0.00, '2025-09-01 15:42:48', 144.00, 1.10, 43.00, 2.7510, 0.3190, 0.3080, 0.2880, 0.0040),
(1117, 126, 339, 10.00, '1367', 0.00, '2025-09-01 15:42:48', 160.00, 0.70, 11.50, 1.9290, 0.2390, 0.2220, 0.2160, -0.0060),
(1118, 126, 340, 14.00, '1367', 0.00, '2025-09-01 15:42:48', 224.00, 1.05, 27.50, 2.7580, 0.2590, 0.2520, 0.2440, 0.0000),
(1119, 56, 147, 18.00, '1187', 0.00, '2025-09-02 12:57:36', 288.00, 0.80, 20.00, 2.5610, 0.3420, 0.3480, 0.3330, 0.0110),
(1120, 56, 157, 42.00, '1191', 0.00, '2025-09-02 12:57:36', 672.00, 3.10, 0.00, 2.6020, 0.3200, 0.3200, 0.3050, 0.0070),
(1121, 56, 159, 37.00, '1193', 0.00, '2025-09-02 12:57:36', 592.00, 0.90, 0.00, 2.1580, 0.2460, 0.2480, 0.2240, 0.0130),
(1122, 56, 210, 2.00, '1241', 0.00, '2025-09-02 12:57:36', 32.00, 1.00, 1.00, 2.9340, 0.6930, 0.7290, 0.6980, 0.0340),
(1123, 56, 213, 332.00, '1244', 0.00, '2025-09-02 12:57:36', 5312.00, 1.75, 18.50, 2.2700, 0.2210, 0.2150, 0.2040, 0.0030),
(1124, 56, 214, 250.00, '1245', 0.00, '2025-09-02 12:57:36', 4000.00, 1.70, 28.50, 2.0660, 0.1860, 0.1810, 0.1730, 0.0010),
(1125, 56, 215, 241.00, '1246', 0.00, '2025-09-02 12:57:36', 3856.00, 2.15, 30.00, 2.1880, 0.2110, 0.2080, 0.1980, 0.0040),
(1126, 56, 225, 11.00, '1256', 0.00, '2025-09-02 12:57:36', 176.00, 1.00, 0.00, 2.4910, 0.2870, 0.2860, 0.2720, 0.0070),
(1127, 56, 256, 3.00, '1286', 0.00, '2025-09-02 12:57:36', 48.00, 1.00, 1.00, 2.7020, 0.7340, 0.7680, 0.7300, 0.0360),
(1128, 56, 274, 5.00, '1304', 0.00, '2025-09-02 12:57:36', 80.00, 1.00, 1.00, 2.3740, 0.3910, 0.4050, 0.3890, 0.0150),
(1129, 56, 279, 2.00, '1311', 0.00, '2025-09-02 12:57:36', 32.00, 1.00, 1.00, 2.5980, 0.4750, 0.4930, 0.4720, 0.0190),
(1130, 56, 323, 2.00, '1353', 0.00, '2025-09-02 12:57:36', 32.00, 1.00, 1.00, 2.6840, 0.7210, 0.7630, 0.7290, 0.0380),
(1131, 56, 326, 5.00, '1356', 0.00, '2025-09-02 12:57:36', 80.00, 1.00, 1.00, 2.5790, 0.4570, 0.4660, 0.4430, 0.0160),
(1132, 56, 341, 1.00, '1368', 0.00, '2025-09-02 12:57:36', 16.00, 1.00, 1.00, 2.8970, 0.5560, 0.5400, 0.5280, -0.0020),
(1134, 127, 337, 4.00, '1366', 0.00, '2025-09-03 11:59:54', 64.00, 1.25, 14.50, 1.7550, 0.1530, 0.1510, 0.1460, 0.0010),
(1135, 128, 348, 1.00, '1375', 0.00, '2025-09-07 12:53:30', 15.99, 0.65, 11.00, 1.7690, 0.1660, 0.1650, 0.1610, 0.0010),
(1136, 128, 349, 1.00, '1376', 0.00, '2025-09-07 12:53:30', 15.99, 1.40, 14.50, 2.0090, 0.2070, 0.2060, 0.1990, 0.0030);

-- --------------------------------------------------------

--
-- Table structure for table `materials`
--

CREATE TABLE `materials` (
  `id` int(11) NOT NULL,
  `material_type` varchar(100) NOT NULL,
  `material_name` varchar(255) NOT NULL,
  `calculation_method` enum('traditional','components') NOT NULL DEFAULT 'traditional' COMMENT 'طريقة حساب المادة: تقليدية أم بالعناصر',
  `price_before_waste` decimal(10,4) DEFAULT NULL COMMENT 'السعر قبل الهدر (اختياري للمواد بالعناصر)',
  `price_before_waste_syp` decimal(15,2) DEFAULT NULL,
  `gross_weight` decimal(10,3) DEFAULT NULL COMMENT 'الوزن الإجمالي بالكيلو (اختياري للمواد بالعناصر)',
  `waste_percentage` decimal(5,2) NOT NULL,
  `packaging_unit` varchar(50) NOT NULL,
  `packaging_weight` decimal(15,3) NOT NULL,
  `packaging_unit_weight` decimal(15,3) DEFAULT NULL,
  `empty_package_price` decimal(15,2) NOT NULL,
  `empty_package_price_syp` decimal(15,2) DEFAULT NULL,
  `sticker_price` decimal(15,2) NOT NULL,
  `sticker_price_syp` decimal(15,2) DEFAULT NULL,
  `additional_expenses` decimal(15,2) NOT NULL,
  `additional_expenses_syp` decimal(15,2) DEFAULT NULL,
  `labor_cost` decimal(15,2) NOT NULL,
  `labor_cost_syp` decimal(15,2) DEFAULT NULL,
  `preservatives_cost` decimal(15,2) NOT NULL,
  `preservatives_cost_syp` decimal(15,2) DEFAULT NULL,
  `carton_price` decimal(15,2) NOT NULL,
  `carton_price_syp` decimal(15,2) DEFAULT NULL,
  `pieces_per_package` int(11) NOT NULL,
  `pallet_price` decimal(15,2) NOT NULL,
  `pallet_price_syp` decimal(15,2) DEFAULT NULL,
  `packages_per_pallet` int(11) NOT NULL,
  `unit_cost` decimal(15,2) NOT NULL,
  `unit_cost_syp` decimal(15,2) DEFAULT NULL,
  `package_cost` decimal(15,2) NOT NULL,
  `package_cost_syp` decimal(15,2) DEFAULT NULL,
  `extra_weights` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extra_weights`)),
  `gross_package_weight` decimal(15,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='جدول المواد - يدعم الحساب التقليدي والحساب بالعناصر الفرعية';

--
-- Dumping data for table `materials`
--

INSERT INTO `materials` (`id`, `material_type`, `material_name`, `calculation_method`, `price_before_waste`, `price_before_waste_syp`, `gross_weight`, `waste_percentage`, `packaging_unit`, `packaging_weight`, `packaging_unit_weight`, `empty_package_price`, `empty_package_price_syp`, `sticker_price`, `sticker_price_syp`, `additional_expenses`, `additional_expenses_syp`, `labor_cost`, `labor_cost_syp`, `preservatives_cost`, `preservatives_cost_syp`, `carton_price`, `carton_price_syp`, `pieces_per_package`, `pallet_price`, `pallet_price_syp`, `packages_per_pallet`, `unit_cost`, `unit_cost_syp`, `package_cost`, `package_cost_syp`, `extra_weights`, `gross_package_weight`, `created_at`, `updated_at`) VALUES
(13, 'زيتون', 'زيتون أخضر تفاحي ( 7 كغ ) ', 'traditional', 1.1000, 11550.00, 1.000, 1.00, '20.00', 20.000, 0.400, 1.36, 14280.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 0.15, 1575.00, 0.00, 0.00, 1, 10.00, 105000.00, 96, 9.44, 99097.00, 9.54, 100191.00, '[{\"name\":\"مياه حافظة\",\"weight\":4.6}]', 12.00, '2025-08-17 18:25:10', '2025-10-27 13:10:26'),
(14, 'زيتون', 'زيتون أخضر تفاحي ( 400 غ )', 'traditional', 1.1000, 11550.00, 1.000, 1.00, '20.00', 20.000, 0.100, 0.20, 2100.00, 0.05, 525.00, 0.05, 525.00, 0.15, 1575.00, 0.05, 525.00, 1.00, 10500.00, 12, 10.00, 105000.00, 100, 0.94, 9917.00, 1.04, 130554.00, '[{\"name\":\"مياه حافظة\",\"weight\":0.3}]', 6.30, '2025-08-17 18:42:40', '2025-10-27 13:10:26'),
(15, 'زيتون', 'زيتون  أخضر تفاحي  ( 800 غ )', 'traditional', 1.1000, 11550.00, 1.000, 1.00, '20.00', 20.000, 0.100, 0.25, 2625.00, 0.05, 525.00, 0.05, 525.00, 0.15, 1575.00, 0.05, 525.00, 1.00, 10500.00, 6, 10.00, 105000.00, 100, 1.44, 15108.00, 1.54, 102198.00, '[{\"name\":\"مياه حافظة\",\"weight\":0.4}]', 5.80, '2025-08-18 06:49:31', '2025-10-27 13:10:26'),
(16, 'زيتون', 'زيتون أخضر تفاحي ( 1800 غ )', 'traditional', 1.3000, 13650.00, 1.000, 1.00, '20.00', 20.000, 0.500, 0.75, 7875.00, 0.05, 525.00, 0.05, 525.00, 0.15, 1575.00, 0.10, 1050.00, 1.00, 10500.00, 4, 10.00, 105000.00, 100, 3.46, 36368.00, 3.56, 157022.00, '[{\"name\":\"مياه حافظة\",\"weight\":1}]', 10.20, '2025-08-18 06:51:07', '2025-10-27 13:10:26'),
(17, 'زيتون', 'زيتون أخضر جلط كالامتا ( 7 كغ )', 'traditional', 1.1000, 11550.00, 1.000, 1.00, '20.00', 20.000, 0.400, 1.40, 14700.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 0.15, 1575.00, 0.00, 0.00, 1, 10.00, 105000.00, 96, 9.48, 99517.00, 9.58, 100611.00, '[]', 7.40, '2025-08-18 06:53:08', '2025-10-27 13:10:26'),
(18, 'زيتون', 'زيتون أخضر جلط كالامتا ( 400 غ )', 'traditional', 1.1000, 11550.00, 1.000, 1.00, '20.00', 20.000, 0.100, 0.20, 2100.00, 0.05, 525.00, 0.05, 525.00, 0.10, 1050.00, 0.05, 525.00, 1.00, 10500.00, 12, 10.00, 105000.00, 100, 0.89, 9392.00, 0.99, 124254.00, '[{\"name\":\"مياه حافطة\",\"weight\":0.3}]', 6.30, '2025-08-18 06:54:30', '2025-10-27 13:10:26'),
(19, 'زيتون', 'زيتون أخضر جلط كالامتا ( 800 غ )', 'traditional', 1.1000, 11550.00, 1.000, 1.00, '20.00', 20.000, 0.200, 0.25, 2625.00, 0.05, 525.00, 0.05, 525.00, 0.10, 1050.00, 0.05, 525.00, 1.00, 10500.00, 6, 10.00, 105000.00, 100, 1.39, 14583.00, 1.49, 99048.00, '[{\"name\":\"مياه حافظة\",\"weight\":0.4}]', 6.40, '2025-08-18 06:56:45', '2025-10-27 13:10:26'),
(20, 'زيتون', 'زيتون أخضر جلط كالامتا ( 1800 غ )', 'traditional', 1.1000, 11550.00, 1.000, 1.00, '20.00', 20.000, 1.000, 0.75, 7875.00, 0.05, 525.00, 0.05, 525.00, 0.10, 1050.00, 0.05, 525.00, 1.00, 10500.00, 4, 10.00, 105000.00, 100, 3.00, 31500.00, 13.10, 137550.00, '[{\"name\":\"مياه حافظة\",\"weight\":1}]', 12.20, '2025-08-18 06:58:07', '2025-10-27 13:10:26'),
(21, 'زيتون', 'زيتون سلطة بالزيت ( 660 غ )', 'traditional', 1.1000, 11550.00, 1.000, 35.00, '20.00', 20.000, 0.100, 0.20, 2100.00, 0.05, 525.00, 0.20, 2100.00, 0.05, 525.00, 0.10, 1050.00, 1.00, 10500.00, 12, 10.00, 105000.00, 100, 1.72, 18028.00, 1.82, 227886.00, '[]', 9.12, '2025-08-18 07:02:18', '2025-10-27 13:10:26'),
(22, 'زيتون', 'زيتون أخضر مقطع ( 400 غ )', 'traditional', 1.1000, 11550.00, 1.000, 35.00, '20.00', 20.000, 0.100, 0.20, 2100.00, 0.05, 525.00, 0.05, 525.00, 0.10, 1050.00, 0.10, 1050.00, 1.00, 10500.00, 12, 10.00, 105000.00, 100, 1.18, 12358.00, 1.28, 159846.00, '[{\"name\":\"مياه حافظة\",\"weight\":0.3}]', 6.30, '2025-08-18 07:03:49', '2025-10-27 13:10:26'),
(23, 'زيتون', 'زيتون أسود مقطع ( 400 غ )', 'traditional', 1.1000, 11550.00, 1.000, 35.00, '20.00', 20.000, 0.100, 0.20, 2100.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 1.00, 10500.00, 12, 10.00, 105000.00, 100, 1.08, 11308.00, 1.18, 147246.00, '[{\"name\":\"مياه حافظة\",\"weight\":0.3}]', 6.30, '2025-08-18 07:05:24', '2025-10-27 13:10:26'),
(24, 'زيتون', 'زيتون أخضر مثقب محشو ليمون / جزر / فليفلة / زعتر  ( 400 غ )', 'traditional', 1.1000, 11550.00, 1.000, 28.00, '20.00', 20.000, 0.100, 0.20, 2100.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 1.00, 10500.00, 12, 10.00, 105000.00, 100, 1.01, 10617.00, 1.11, 138954.00, '[{\"name\":\"مياه حافطة\",\"weight\":0.4}]', 6.40, '2025-08-18 07:07:22', '2025-10-27 13:10:26'),
(25, 'زيتون', 'زيتون أخضر تفاحي مفرغ سادة ( 75 كغ )', 'traditional', 1.1000, 11550.00, 1.000, 30.00, '20.00', 75.000, 5.000, 0.00, 0.00, 0.00, 0.00, 0.05, 525.00, 0.05, 525.00, 0.10, 1050.00, 0.00, 0.00, 1, 0.00, 0.00, 1, 118.06, 1239600.00, 118.06, 1239600.00, '[{\"name\":\"مياه ومواد حافظة\",\"weight\":50}]', 130.00, '2025-08-18 10:38:34', '2025-10-27 13:08:22'),
(38, 'زيتون', 'زيتون أخضر تفاحي مفقش  ( 90 كغ )', 'traditional', 1.1000, 11550.00, 1.000, 0.00, '20.00', 90.000, 5.000, 0.00, 0.00, 0.00, 0.00, 0.05, 525.00, 0.05, 525.00, 0.10, 1050.00, 0.00, 0.00, 1, 0.00, 0.00, 1, 99.20, 1041600.00, 99.20, 1041600.00, '[{\"name\":\"مياه حافظة\",\"weight\":50}]', 145.00, '2025-08-18 10:41:31', '2025-10-27 13:08:22'),
(41, 'زيتون', 'زيتون أخضر مقطع شرائح ( 80 كغ )', 'traditional', 1.1000, 11550.00, 1.000, 30.00, '20.00', 80.000, 5.000, 0.00, 0.00, 0.00, 0.00, 0.15, 1575.00, 0.10, 1050.00, 0.15, 1575.00, 0.00, 0.00, 1, 0.00, 0.00, 1, 126.11, 1324200.00, 126.11, 1324200.00, '[{\"name\":\"مياه حافظة\",\"weight\":50}]', 135.00, '2025-08-18 10:47:30', '2025-10-27 13:08:22'),
(42, 'زيتون', 'زيتون أخضر جلط كالاماتا مفقش ( 90 كغ)', 'traditional', 1.1000, 11550.00, 1.000, 0.00, '20.00', 90.000, 5.000, 0.00, 0.00, 0.00, 0.00, 0.10, 1050.00, 0.10, 1050.00, 0.10, 1050.00, 0.00, 0.00, 1, 0.00, 0.00, 1, 99.30, 1042650.00, 99.30, 1042650.00, '[{\"name\":\"مياه حافظة\",\"weight\":50}]', 145.00, '2025-08-18 10:51:00', '2025-10-27 13:08:22'),
(44, 'زيت زيتون', 'زيت زيتون بلدي خام حموضة أقل من 0.7 ( 110 ) كغ', 'traditional', 75.0000, 787500.00, 16.000, 0.25, '20.00', 110.000, 4.500, 0.00, 0.00, 0.00, 0.00, 0.10, 1050.00, 0.10, 1050.00, 0.10, 1050.00, 0.00, 0.00, 1, 0.00, 0.00, 1, 517.22, 5430782.00, 517.22, 5430782.00, '[]', 114.50, '2025-08-18 11:12:57', '2025-10-27 13:08:22'),
(46, 'زيت زيتون', 'زيت زيتون مذاق الشام واحد لتر ', 'traditional', 75.0000, 787500.00, 16.000, 2.00, '20.00', 20.000, 0.050, 0.10, 1050.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 0.00, 0.00, 1.25, 13125.00, 12, 10.00, 105000.00, 80, 4.61, 48428.57, 56.72, 595580.36, '[]', 0.91, '2025-08-24 08:41:00', '2025-10-27 13:10:26'),
(47, 'زيتون زيتون', 'زيت زيتون عجاج واحد لتر ', 'traditional', 75.0000, 787500.00, 16.000, 2.00, '20.00', 20.000, 0.050, 0.10, 1050.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 0.00, 0.00, 1.25, 13125.00, 12, 10.00, 105000.00, 80, 4.61, 48428.57, 56.72, 595580.36, '[]', 0.91, '2025-08-24 08:42:58', '2025-10-27 13:10:26'),
(48, 'زيت زيتون ', 'زيت زيتون مذاق الشام 500 مل ', 'traditional', 75.0000, 787500.00, 16.000, 2.00, '20.00', 20.000, 0.100, 0.10, 1050.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 0.00, 0.00, 1.25, 13125.00, 24, 10.00, 105000.00, 80, 2.43, 25527.00, 2.56, 627086.00, '[]', 13.34, '2025-08-24 08:47:15', '2025-10-27 13:10:26'),
(49, 'زيت زيتون', 'زيت زيتون عجاج 500 مل ', 'traditional', 75.0000, 787500.00, 16.000, 2.00, '20.00', 20.000, 0.100, 0.10, 1050.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 0.00, 0.00, 1.25, 13125.00, 12, 10.00, 105000.00, 80, 2.45, 25728.00, 2.58, 323174.00, '[]', 6.72, '2025-08-24 08:48:28', '2025-10-27 13:10:26'),
(50, 'لوز بلدي ', 'لوز بلدي قلب حبة اسبانية', 'traditional', 15.0000, 157500.00, 1.000, 0.00, '20.00', 20.000, 0.000, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 0.00, 0.00, 1, 15.00, 157500.00, 15.00, 157500.00, '[]', 1.00, '2025-08-24 11:40:29', '2025-10-27 13:10:26'),
(51, 'جزر مخلل ', 'مخلل جزر بلدي', 'traditional', 0.2500, 2625.00, 1.000, 0.00, '20.00', 90.000, 0.000, 0.00, 0.00, 0.00, 0.00, 0.10, 1050.00, 0.10, 1050.00, 0.00, 0.00, 0.00, 0.00, 1, 0.00, 0.00, 1, 22.70, 238350.00, 22.70, 238350.00, '[]', 90.00, '2025-08-24 11:42:30', '2025-10-27 13:08:22'),
(52, 'زيتون', 'زيتون تفاحي مفقش حبة ناعمة ( 80 كغ )', 'traditional', 1.0000, 10500.00, 1.000, 0.00, '20.00', 80.000, 0.000, 0.00, 0.00, 0.00, 0.00, 0.10, 1050.00, 0.10, 1050.00, 0.10, 1050.00, 0.00, 0.00, 1, 0.00, 0.00, 1, 80.30, 843150.00, 80.30, 843150.00, '[]', 80.00, '2025-08-24 11:44:42', '2025-10-27 13:08:22'),
(53, 'زيت زيتون', 'زيت زيتون عجاج 5 لتر ', 'traditional', 75.0000, 787500.00, 16.000, 2.00, '20.00', 20.000, 0.100, 0.15, 1575.00, 0.05, 525.00, 0.10, 1050.00, 0.05, 525.00, 0.00, 0.00, 1.00, 10500.00, 2, 10.00, 105000.00, 80, 22.16, 232692.86, 45.45, 477198.21, '[]', 4.56, '2025-08-25 08:00:34', '2025-10-27 13:10:26'),
(54, 'زيتون', 'شرائح زيتون أسود', 'traditional', 1.1000, 11550.00, 1.000, 0.00, '20.00', 50.000, 0.000, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0.00, 0, 55.00, 577500.00, 0.00, 0.00, '[]', 50.00, '2025-08-26 11:20:47', '2025-10-27 13:08:22'),
(55, 'دبس فليفة بلدية', 'دبس فليفلة بلدية حارة', 'traditional', 1.3000, 13650.00, 1.000, 0.00, '20.00', 20.000, 0.000, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0, 0.00, 0.00, 0, 1.30, 13650.00, 0.00, 0.00, '[]', 1.00, '2025-08-26 11:22:13', '2025-10-27 13:10:26'),
(56, 'زيت زيتون', 'زيت زيتون بلدي خام ', 'traditional', 73.0000, 766500.00, 16.000, 0.00, '20.00', 16.000, 1.000, 0.00, 0.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 0.00, 0.00, 0.00, 0.00, 1, 0.00, 0.00, 1, 73.15, 768075.00, 73.15, 768075.00, '[]', 17.00, '2025-08-26 11:24:45', '2025-10-27 13:08:22'),
(57, 'زيتون', 'غتلا', 'traditional', 563.0000, 5911500.00, 5535.000, 10.00, '20.00', 55.000, 54.000, 1.00, 10500.00, 2.00, 21000.00, 22.00, 231000.00, 2.00, 21000.00, 2.00, 21000.00, 2.00, 21000.00, 0, 0.00, 0.00, 1, 35.22, 369767.99, 2.00, 21000.00, '[]', 0.00, '2025-09-06 16:16:04', '2025-10-27 13:08:22'),
(58, 'زيتون', 'يبيلبي', 'traditional', 3.0000, 31500.00, 1.000, 0.00, '20.00', 20.000, 1.000, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1.00, 10500.00, 4, 10.00, 105000.00, 100, 3.00, 31500.00, 13.10, 137550.00, '[]', 8.00, '2025-09-07 11:31:01', '2025-10-27 13:10:26'),
(59, 'زيتون123', 'يبيلبي', 'traditional', 3.0000, 31500.00, 1.000, 0.00, '20.00', 20.000, 1.100, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1.00, 10500.00, 4, 10.00, 105000.00, 1, 3.30, 34650.00, 24.20, 254100.00, '[]', 8.80, '2025-09-08 16:11:27', '2025-10-27 13:10:26'),
(60, 'زيتون', 'زيت زيتون', 'traditional', 5.0000, 52500.00, 2.000, 10.00, '20.00', 20.000, 0.500, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 5, 10.00, 105000.00, 10, 9.17, 96250.00, 47.83, 502250.00, '[]', 10.00, '2025-09-09 13:35:55', '2025-10-27 13:10:26'),
(61, 'زيتون', 'زيت زيتون', 'components', 0.8230, 8641.50, 1.000, 10.00, '20.00', 20.000, 0.500, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 5, 10.00, 105000.00, 1, 6.37, 66902.50, 42.86, 450012.50, '[]', 10.00, '2025-09-09 13:37:26', '2025-10-27 13:10:26'),
(62, 'زيتون', 'زيت زيتون', 'components', 1.0000, 10500.00, 1.000, 10.00, '20.00', 20.000, 0.500, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 5, 10.00, 105000.00, 1, 6.67, 70000.00, 44.33, 465500.00, '[{\"name\":\"تلاتلات\",\"weight\":0.5},{\"name\":\"32542542\",\"weight\":1}]', 11.50, '2025-09-11 10:53:16', '2025-10-27 13:10:26'),
(63, 'زيتون', 'زيت زيتون', 'components', 1.0000, 10500.00, 1.000, 10.00, '20.00', 20.000, 0.500, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 1.00, 10500.00, 5, 10.00, 105000.00, 1, 6.67, 70000.00, 44.33, 465500.00, '[{\"name\":\"البالابا\",\"weight\":1},{\"name\":\"لباتلبالا\",\"weight\":2}]', 13.00, '2025-09-11 11:01:06', '2025-10-27 13:10:26');

-- --------------------------------------------------------

--
-- Stand-in structure for view `materials_with_components`
-- (See below for the actual view)
--
CREATE TABLE `materials_with_components` (
`id` int(11)
,`material_type` varchar(100)
,`material_name` varchar(255)
,`calculation_method` enum('traditional','components')
,`price_before_waste` decimal(10,4)
,`price_before_waste_syp` decimal(15,2)
,`gross_weight` decimal(10,3)
,`waste_percentage` decimal(5,2)
,`packaging_unit` varchar(50)
,`packaging_weight` decimal(15,3)
,`packaging_unit_weight` decimal(15,3)
,`empty_package_price` decimal(15,2)
,`empty_package_price_syp` decimal(15,2)
,`sticker_price` decimal(15,2)
,`sticker_price_syp` decimal(15,2)
,`additional_expenses` decimal(15,2)
,`additional_expenses_syp` decimal(15,2)
,`labor_cost` decimal(15,2)
,`labor_cost_syp` decimal(15,2)
,`preservatives_cost` decimal(15,2)
,`preservatives_cost_syp` decimal(15,2)
,`carton_price` decimal(15,2)
,`carton_price_syp` decimal(15,2)
,`pieces_per_package` int(11)
,`pallet_price` decimal(15,2)
,`pallet_price_syp` decimal(15,2)
,`packages_per_pallet` int(11)
,`unit_cost` decimal(15,2)
,`unit_cost_syp` decimal(15,2)
,`package_cost` decimal(15,2)
,`package_cost_syp` decimal(15,2)
,`extra_weights` longtext
,`gross_package_weight` decimal(15,2)
,`created_at` timestamp
,`updated_at` timestamp
,`total_weight_grams` decimal(32,3)
,`total_price_usd` decimal(46,11)
,`components_count` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `material_components`
--

CREATE TABLE `material_components` (
  `id` int(11) NOT NULL,
  `material_id` int(11) NOT NULL,
  `component_name` varchar(255) NOT NULL COMMENT 'اسم العنصر الفرعي',
  `weight_grams` decimal(10,3) NOT NULL COMMENT 'وزن العنصر بالغرام',
  `price_per_kg` decimal(10,4) NOT NULL COMMENT 'سعر الكيلو للعنصر بالدولار',
  `price_per_kg_syp` decimal(15,2) DEFAULT NULL COMMENT 'سعر الكيلو للعنصر بالليرة السورية',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='جدول العناصر الفرعية للمواد';

--
-- Dumping data for table `material_components`
--

INSERT INTO `material_components` (`id`, `material_id`, `component_name`, `weight_grams`, `price_per_kg`, `price_per_kg_syp`, `created_at`, `updated_at`) VALUES
(1, 61, 'جزر', 670.000, 1.0000, 10500.00, '2025-09-09 13:37:26', '2025-09-09 13:37:26'),
(2, 61, 'ماء', 30.000, 0.1000, 1050.00, '2025-09-09 13:37:26', '2025-09-09 13:37:26'),
(3, 61, 'ملح', 300.000, 0.5000, 5250.00, '2025-09-09 13:37:26', '2025-09-09 13:37:26'),
(5, 63, 'جزر', 1000.000, 1.0000, 10500.00, '2025-09-11 11:01:06', '2025-09-11 11:01:06');

--
-- Triggers `material_components`
--
DELIMITER $$
CREATE TRIGGER `tr_material_components_update` AFTER INSERT ON `material_components` FOR EACH ROW BEGIN
    CALL CalculateMaterialCostFromComponents(NEW.material_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_material_components_update_after_delete` AFTER DELETE ON `material_components` FOR EACH ROW BEGIN
    CALL CalculateMaterialCostFromComponents(OLD.material_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_material_components_update_after_update` AFTER UPDATE ON `material_components` FOR EACH ROW BEGIN
    CALL CalculateMaterialCostFromComponents(NEW.material_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notes`
--

CREATE TABLE `notes` (
  `id` int(11) NOT NULL,
  `material_id` int(11) DEFAULT NULL,
  `material_name` varchar(255) DEFAULT NULL,
  `price` decimal(15,2) DEFAULT NULL,
  `weight` decimal(15,3) DEFAULT NULL,
  `note_date` date DEFAULT NULL,
  `note_text` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notes`
--

INSERT INTO `notes` (`id`, `material_id`, `material_name`, `price`, `weight`, `note_date`, `note_text`, `created_at`, `updated_at`) VALUES
(4, NULL, 'مطربان  640 غ', 0.14, NULL, '2025-08-17', NULL, '2025-08-17 18:31:20', NULL),
(5, NULL, 'مطربان  2600 مل', 0.60, NULL, '2025-08-17', NULL, '2025-08-17 18:31:48', NULL),
(6, NULL, 'برميل مكسر', NULL, 90.000, '2025-08-18', NULL, '2025-08-18 10:34:36', NULL),
(7, NULL, 'برميل مفرغ', NULL, 75.000, '2025-08-18', NULL, '2025-08-18 10:34:50', NULL),
(8, NULL, 'برميل شرائح', NULL, 80.000, '2025-08-18', NULL, '2025-08-18 10:34:55', '2025-08-18 10:35:15'),
(9, NULL, 'يلبلباب', 43.00, 44.000, '2025-09-08', 'بلبيليبلبي', '2025-09-08 15:24:19', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `order_number` varchar(50) NOT NULL,
  `client_name` varchar(255) NOT NULL,
  `client_phone` varchar(50) DEFAULT NULL,
  `client_address` text DEFAULT NULL,
  `delivery_date` date NOT NULL,
  `responsible_worker` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('pending','processing','completed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `order_date` date DEFAULT NULL,
  `quality_controller` varchar(255) DEFAULT NULL,
  `pallets_count` decimal(15,3) DEFAULT NULL,
  `container_number` varchar(100) DEFAULT NULL,
  `packages_count` decimal(15,3) DEFAULT NULL,
  `waybill_number` varchar(100) DEFAULT NULL,
  `accreditation_number` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `client_name`, `client_phone`, `client_address`, `delivery_date`, `responsible_worker`, `notes`, `status`, `created_at`, `updated_at`, `order_date`, `quality_controller`, `pallets_count`, `container_number`, `packages_count`, `waybill_number`, `accreditation_number`) VALUES
(6, 'ORD-002', 'نسيم رياض فرح', NULL, NULL, '2025-08-18', 'محمد عجاج & عمر حديد', NULL, 'completed', '2025-08-18 10:55:06', '2025-08-20 09:58:59', '2025-08-18', 'محمد عجاج', NULL, NULL, 380.000, NULL, NULL),
(7, 'ORD-003', 'نسيم رياض فرح', NULL, NULL, '2025-08-20', 'محمد عجاج & عمر حديد', NULL, 'completed', '2025-08-20 09:58:15', '2025-08-20 09:58:24', '2025-08-20', ' أحمد نور عجاج', NULL, NULL, 195.000, NULL, NULL),
(8, 'ORD-004', 'عبادة عطار', NULL, NULL, '2025-08-24', 'أحمد نور عجاج ', NULL, 'completed', '2025-08-24 11:54:10', '2025-08-24 11:57:11', '2025-08-24', 'محمد عجاج', NULL, NULL, NULL, NULL, NULL),
(10, 'ORD-005', 'fhgfdgf', NULL, NULL, '2025-09-06', NULL, NULL, 'pending', '2025-09-06 16:23:35', '2025-09-06 16:23:35', '2025-09-06', NULL, NULL, NULL, NULL, NULL, NULL),
(11, 'ORD-006', 'TYRT', NULL, NULL, '2025-09-27', 'يي', '3333', 'pending', '2025-09-27 12:37:26', '2025-09-27 12:37:26', '2025-09-27', 'يي', 3.000, '33', 3.000, '333', '3333'),
(12, 'ORD-007', 'TYRT', NULL, NULL, '2025-09-27', 'يي', NULL, 'pending', '2025-09-27 13:42:49', '2025-09-27 13:42:49', '2025-09-27', 'يي', 3.000, '33', 3.000, '333', '3333'),
(13, 'ORD-008', 'TYRT', NULL, NULL, '2025-09-27', 'يي', NULL, 'pending', '2025-09-27 13:50:35', '2025-09-27 13:50:35', '2025-09-27', 'يي', 3.000, '33', 3.000, '333', '3333'),
(14, 'ORD-009', 'TYRT', NULL, NULL, '2025-10-21', 'ييبي', NULL, 'pending', '2025-10-21 12:31:06', '2025-10-21 12:31:06', '2025-10-21', 'بييب', 3.000, '3', 3.000, '3', '3'),
(15, 'ORD-010', 'TYRT', NULL, NULL, '2025-10-25', 'ييبي', NULL, 'pending', '2025-10-25 15:28:35', '2025-10-25 15:28:35', '2025-10-25', 'بييب', 3.000, '3', 3.000, '3', '3');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `material_id` int(11) DEFAULT NULL,
  `material_name` varchar(255) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `quantity` decimal(10,3) DEFAULT NULL,
  `weight` decimal(15,3) DEFAULT NULL,
  `net_weight` decimal(10,3) DEFAULT NULL,
  `gross_weight` decimal(10,3) DEFAULT NULL,
  `volume` decimal(15,3) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `requested_quantity` decimal(15,3) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `unit_price_syp` decimal(15,2) DEFAULT NULL,
  `total_price` decimal(15,2) NOT NULL,
  `total_price_syp` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `material_id`, `material_name`, `unit`, `quantity`, `weight`, `net_weight`, `gross_weight`, `volume`, `notes`, `requested_quantity`, `unit_price`, `unit_price_syp`, `total_price`, `total_price_syp`) VALUES
(39, 7, 44, 'زيتون زيتون بلدي خام حموضة أقل من 0.7', 'برميل غذائي', NULL, 110.000, NULL, NULL, NULL, 'وزن صافي 110 كغ', 185.000, 0.00, 0.00, 0.00, 0.00),
(40, 7, 25, 'زيتون أخضر تفاحي مفرغ سادة', 'برميل غذائي ', NULL, 130.000, NULL, NULL, NULL, 'وزن صافي 75 كغ', 20.000, 0.00, 0.00, 0.00, 0.00),
(41, 6, 42, 'زيتون أخضر جلط كالاماتا مفقش', 'برميل غذائي', NULL, 145.000, NULL, NULL, NULL, 'وزن صافي 90 كغ', 26.000, 0.00, 0.00, 0.00, 0.00),
(42, 6, 38, 'زيتون أخضر تفاحي مفقش', 'برميل غذائي', NULL, 140.000, NULL, NULL, NULL, 'وزن صافي 90 كغ', 80.000, 0.00, 0.00, 0.00, 0.00),
(43, 6, 25, 'زيتون أخضر تفاحي مفرغ سادة', 'برميل غذائي ', NULL, 130.000, NULL, NULL, NULL, 'وزن صافي 75 كغ', 71.000, 0.00, 0.00, 0.00, 0.00),
(44, 6, 41, 'زيتون أخضر مقطع شرائح', 'برميل غذائي', NULL, 135.000, NULL, NULL, NULL, 'وزن صافي 80 كغ', 23.000, 0.00, 0.00, 0.00, 0.00),
(45, 6, 44, 'زيتون زيتون بلدي خام حموضة أقل من 0.7', 'برميل غذائي', NULL, 110.000, NULL, NULL, NULL, 'وزن صافي 110 كغ', 180.000, 0.00, 0.00, 0.00, 0.00),
(107, 8, 49, 'زيت زيتون عجاج 500 مل', 'PET', NULL, 0.910, NULL, NULL, NULL, NULL, 1.000, 31.00, 325500.00, 31.00, 325500.00),
(108, 8, 47, 'زيت زيتون عجاج واحد لتر', 'PET', NULL, 0.910, NULL, NULL, NULL, NULL, 1.000, 60.00, 630000.00, 60.00, 630000.00),
(109, 8, 48, 'زيت زيتون مذاق الشام 500 مل', 'PET', NULL, 13.340, NULL, NULL, NULL, NULL, 1.000, 31.00, 325500.00, 31.00, 325500.00),
(110, 8, 46, 'زيت زيتون مذاق الشام واحد لتر', 'PET', NULL, 0.910, NULL, NULL, NULL, NULL, 1.000, 60.00, 630000.00, 60.00, 630000.00),
(111, 8, 25, 'زيتون أخضر تفاحي مفرغ سادة ( 75 كغ )', 'برميل غذائي ', NULL, 130.000, NULL, NULL, NULL, NULL, 1.000, 165.00, 1732500.00, 165.00, 1732500.00),
(112, 8, 52, 'زيتون تفاحي مفقش حبة ناعمة ( 80 كغ )', 'برميل غذائي', NULL, 80.000, NULL, NULL, NULL, NULL, 8.000, 95.00, 997500.00, 760.00, 7980000.00),
(113, 8, 51, 'مخلل جزر بلدي', 'برميل غذائي ', NULL, 90.000, NULL, NULL, NULL, NULL, 1.000, 45.00, 472500.00, 45.00, 472500.00),
(114, 8, 13, 'زيتون أخضر تفاحي ( 7 كغ )', 'سطل غذائي', NULL, 12.000, NULL, NULL, NULL, NULL, 15.000, 15.00, 157500.00, 225.00, 2362500.00),
(115, 8, 20, 'زيتون أخضر جلط كالامتا ( 1800 غ )', 'زجاج 1800 غ', NULL, 12.200, NULL, NULL, NULL, NULL, 1.000, 17.00, 178500.00, 17.00, 178500.00),
(116, 8, 16, 'زيتون أخضر تفاحي ( 1800 غ )', 'زجاج 1800 غ', NULL, 10.200, NULL, NULL, NULL, NULL, 2.000, 19.00, 199500.00, 38.00, 399000.00),
(117, 8, 21, 'زيتون سلطة بالزيت ( 660 غ )', 'زجاج 660 غ', NULL, 9.120, NULL, NULL, NULL, NULL, 1.000, 15.00, 157500.00, 15.00, 157500.00),
(118, 8, 19, 'زيتون أخضر جلط كالامتا ( 800 غ )', 'زجاج 800 غ', NULL, 6.400, NULL, NULL, NULL, NULL, 1.000, 14.00, 147000.00, 14.00, 147000.00),
(119, 8, 15, 'زيتون  أخضر تفاحي  ( 800 غ )', 'زجاج 800 غ', NULL, 5.800, NULL, NULL, NULL, NULL, 1.000, 14.00, 147000.00, 14.00, 147000.00),
(120, 8, 50, 'لوز بلدي قلب حبة اسبانية', 'دوكما ', NULL, 1.000, NULL, NULL, NULL, NULL, 7.000, 15.00, 157500.00, 105.00, 1102500.00),
(121, 8, 14, 'زيتون أخضر تفاحي ( 400 غ )', 'زجاج 400 غ ', NULL, 6.300, NULL, NULL, NULL, NULL, 1.000, 14.00, 147000.00, 14.00, 147000.00),
(122, 8, 55, 'دبس فليفلة بلدية حارة', 'دوكما ', NULL, 1.000, NULL, NULL, NULL, NULL, 120.000, 1.80, 18900.00, 216.00, 2268000.00),
(123, 8, 54, 'شرائح زيتون أسود', 'برميل غذائي ', NULL, 50.000, NULL, NULL, NULL, NULL, 1.000, 2.00, 21000.00, 2.00, 21000.00),
(124, 8, 56, 'زيت زيتون بلدي خام', 'تنكة', NULL, 16.000, NULL, NULL, NULL, NULL, 5.000, 76.00, 798000.00, 380.00, 3990000.00),
(126, 10, 46, 'زيت زيتون مذاق الشام واحد لتر', 'PET', NULL, 0.910, NULL, NULL, NULL, NULL, 10.000, 56.72, 595560.00, 567.20, 5955600.00),
(127, 11, 53, 'زيت زيتون عجاج 5 لتر', 'pet', NULL, 4.560, NULL, NULL, 7.000, 'يييي', 2.000, 55.45, 582225.00, 110.90, 1164450.00),
(128, 11, 25, 'زيتون أخضر تفاحي مفرغ سادة ( 75 كغ )', 'برميل غذائي ', NULL, 130.000, NULL, NULL, 4.000, 'يييي', 4.000, 128.06, 1344630.00, 512.24, 5378520.00),
(131, 12, 53, 'زيت زيتون عجاج 5 لتر', 'pet', NULL, NULL, 16.000, 4.560, NULL, NULL, 2.000, 45.45, 477225.00, 90.90, 954450.00),
(133, 13, 53, 'زيت زيتون عجاج 5 لتر', 'pet', NULL, NULL, 15.680, 4.560, NULL, NULL, 2.000, 50.00, 525000.00, 100.00, 1050000.00),
(134, 14, 44, 'زيت زيتون بلدي خام حموضة أقل من 0.7 ( 110 ) كغ', 'برميل غذائي', NULL, NULL, 15.960, 114.500, NULL, NULL, 1.000, 0.00, 0.00, 0.00, 0.00),
(135, 14, 24, 'زيتون أخضر مثقب محشو ليمون / جزر / فليفلة / زعتر  ( 400 غ )', 'زجاج 400 غ', NULL, NULL, 0.720, 6.400, NULL, NULL, 1.000, 0.00, 0.00, 0.00, 0.00),
(136, 15, 60, 'زيت زيتون', 'سطل', NULL, NULL, NULL, 10.000, NULL, NULL, 1.000, 0.00, 0.00, 0.00, 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `quotations`
--

CREATE TABLE `quotations` (
  `id` int(11) NOT NULL,
  `quotation_number` varchar(50) NOT NULL,
  `client_id` int(11) DEFAULT NULL,
  `client_name` varchar(255) NOT NULL,
  `client_phone` varchar(50) DEFAULT NULL,
  `client_address` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `total_amount_syp` decimal(15,2) DEFAULT NULL,
  `general_profit_percentage` decimal(5,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quotations`
--

INSERT INTO `quotations` (`id`, `quotation_number`, `client_id`, `client_name`, `client_phone`, `client_address`, `notes`, `total_amount`, `total_amount_syp`, `general_profit_percentage`, `created_at`, `updated_at`) VALUES
(57, 'QT-001', NULL, 'fsgvfgvfs', '', '', '', 2232.49, 23441145.00, 0.00, '2025-09-06 16:25:21', '2025-09-08 15:53:12'),
(58, 'QT-002', NULL, 'يسبيبي', '', '', '', 0.00, 0.00, 0.00, '2025-09-08 15:55:01', '2025-09-08 15:55:01'),
(59, 'QT-003', NULL, 'يريسر', '', '', '', 13.10, 137550.00, 0.00, '2025-09-08 16:15:59', '2025-09-08 16:15:59'),
(60, 'QT-004', NULL, 'يبيسبيب', '', '', '', 47.83, 502215.00, 0.00, '2025-09-11 11:05:01', '2025-09-11 11:05:01'),
(61, 'QT-005', NULL, 'ييي', '', '', '', 44.33, 465465.00, 0.00, '2025-09-11 11:05:15', '2025-09-11 11:05:15'),
(62, 'QT-006', NULL, 'TYRTب', '', '', '', 650.00, 6825000.00, 0.00, '2025-10-25 15:21:45', '2025-10-25 15:21:45');

-- --------------------------------------------------------

--
-- Table structure for table `quotation_items`
--

CREATE TABLE `quotation_items` (
  `id` int(11) NOT NULL,
  `quotation_id` int(11) NOT NULL,
  `material_id` int(11) DEFAULT NULL,
  `material_name` varchar(255) NOT NULL,
  `unit_cost` decimal(15,2) NOT NULL,
  `unit_cost_syp` decimal(15,2) DEFAULT NULL,
  `profit_percentage` decimal(5,2) DEFAULT 0.00,
  `final_price` decimal(15,2) NOT NULL,
  `final_price_syp` decimal(15,2) DEFAULT NULL,
  `quantity` decimal(15,3) NOT NULL,
  `total_price` decimal(15,2) NOT NULL,
  `total_price_syp` decimal(15,2) DEFAULT NULL,
  `material_type` varchar(100) DEFAULT NULL,
  `packaging_unit` varchar(50) DEFAULT NULL,
  `packaging_weight` decimal(15,3) DEFAULT NULL,
  `pieces_per_package` decimal(15,3) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `package_cost` decimal(15,2) DEFAULT NULL,
  `item_notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quotation_items`
--

INSERT INTO `quotation_items` (`id`, `quotation_id`, `material_id`, `material_name`, `unit_cost`, `unit_cost_syp`, `profit_percentage`, `final_price`, `final_price_syp`, `quantity`, `total_price`, `total_price_syp`, `material_type`, `packaging_unit`, `packaging_weight`, `pieces_per_package`, `notes`, `package_cost`, `item_notes`) VALUES
(109, 57, 13, 'زيتون أخضر تفاحي ( 7 كغ )', 9.54, 100170.00, 0.00, 9.54, 100170.00, 2.000, 19.08, 200340.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(110, 57, 56, 'زيت زيتون بلدي خام', 73.15, 768075.00, 0.00, 73.15, 768075.00, 1.000, 73.15, 768075.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(111, 57, 44, 'زيت زيتون بلدي خام حموضة أقل من 0.7 ( 110 ) كغ', 517.22, 5430810.00, 0.00, 517.22, 5430810.00, 1.000, 517.22, 5430810.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(112, 57, 53, 'زيت زيتون عجاج 5 لتر', 45.45, 477225.00, 0.00, 45.45, 477225.00, 1.000, 45.45, 477225.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(113, 57, 16, 'زيتون أخضر تفاحي ( 1800 غ )', 3.56, 37380.00, 0.00, 3.56, 37380.00, 1.000, 3.56, 37380.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(114, 57, 14, 'زيتون أخضر تفاحي ( 400 غ )', 1.04, 10920.00, 0.00, 1.04, 10920.00, 1.000, 1.04, 10920.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(115, 57, 38, 'زيتون أخضر تفاحي مفقش  ( 90 كغ )', 99.20, 1041600.00, 0.00, 99.20, 1041600.00, 1.000, 99.20, 1041600.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(116, 57, 15, 'زيتون  أخضر تفاحي  ( 800 غ )', 1.54, 16170.00, 0.00, 1.54, 16170.00, 1.000, 1.54, 16170.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(117, 57, 48, 'زيت زيتون مذاق الشام 500 مل', 2.56, 26880.00, 0.00, 2.56, 26880.00, 1.000, 2.56, 26880.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(118, 57, 53, 'زيت زيتون عجاج 5 لتر', 45.45, 477225.00, 0.00, 45.45, 477225.00, 1.000, 45.45, 477225.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(119, 57, 44, 'زيت زيتون بلدي خام حموضة أقل من 0.7 ( 110 ) كغ', 517.22, 5430810.00, 0.00, 517.22, 5430810.00, 1.000, 517.22, 5430810.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(120, 57, 53, 'زيت زيتون عجاج 5 لتر', 45.45, 477225.00, 0.00, 45.45, 477225.00, 1.000, 45.45, 477225.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(121, 57, 53, 'زيت زيتون عجاج 5 لتر', 45.45, 477225.00, 999.99, 499.95, 5249475.00, 1.000, 499.95, 5249475.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(122, 57, 16, 'زيتون أخضر تفاحي ( 1800 غ )', 3.56, 37380.00, 0.00, 3.56, 37380.00, 1.000, 3.56, 37380.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(123, 57, 16, 'زيتون أخضر تفاحي ( 1800 غ )', 3.56, 37380.00, 0.00, 3.56, 37380.00, 1.000, 3.56, 37380.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(124, 57, 25, 'زيتون أخضر تفاحي مفرغ سادة ( 75 كغ )', 118.06, 1239630.00, 0.00, 118.06, 1239630.00, 1.000, 118.06, 1239630.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(125, 57, 13, 'زيتون أخضر تفاحي ( 7 كغ )', 9.54, 100170.00, 0.00, 9.54, 100170.00, 1.000, 9.54, 100170.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(126, 57, 25, 'زيتون أخضر تفاحي مفرغ سادة ( 75 كغ )', 118.06, 1239630.00, 0.00, 118.06, 1239630.00, 1.000, 118.06, 1239630.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(127, 57, 42, 'زيتون أخضر جلط كالاماتا مفقش ( 90 كغ)', 99.30, 1042650.00, 0.00, 99.30, 1042650.00, 1.000, 99.30, 1042650.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(128, 57, 38, 'زيتون أخضر تفاحي مفقش  ( 90 كغ )', 99.20, 1041600.00, -90.38, 9.54, 100170.00, 1.000, 9.54, 100170.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(129, 58, 55, 'دبس فليفلة بلدية حارة', 0.00, 0.00, 0.00, 0.00, 0.00, 1.000, 0.00, 0.00, 'دبس فليفة بلدية', 'دوكما ', 1.000, 1.000, NULL, NULL, NULL),
(130, 59, 58, 'يبيلبي', 13.10, 137550.00, 0.00, 13.10, 137550.00, 1.000, 13.10, 137550.00, 'زيتون', 'سطل', 1.000, 4.000, NULL, 13.10, NULL),
(131, 60, 60, 'زيت زيتون', 47.83, 502215.00, 0.00, 47.83, 502215.00, 1.000, 47.83, 502215.00, 'زيتون', 'سطل', 1.500, 5.000, NULL, 47.83, NULL),
(132, 61, 63, 'زيت زيتون', 44.33, 465465.00, 0.00, 44.33, 465465.00, 1.000, 44.33, 465465.00, 'زيتون', 'سطل', 1.500, 5.000, NULL, 44.33, NULL),
(133, 62, 44, 'زيت زيتون بلدي خام حموضة أقل من 0.7 ( 110 ) كغ', 517.22, 5430810.00, 16.00, 600.00, 6300000.00, 1.000, 600.00, 6300000.00, 'زيت زيتون', 'برميل غذائي', 110.000, 1.000, NULL, 517.22, NULL),
(134, 62, 62, 'زيت زيتون', 44.33, 465465.00, 12.79, 50.00, 525000.00, 1.000, 50.00, 525000.00, 'زيتون', 'سطل', 1.500, 5.000, NULL, 44.33, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `created_at`) VALUES
(2, 'editor', '2025-05-19 12:14:12'),
(3, 'viewer', '2025-05-19 12:14:12'),
(4, 'admin', '2025-06-01 14:58:41');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(128) NOT NULL,
  `expires` int(10) UNSIGNED NOT NULL,
  `data` mediumtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`session_id`, `expires`, `data`, `created_at`, `updated_at`) VALUES
('0aF9I2U8iBvu1HXDRw7JZGLIm6uYkyaz', 1761657582, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:19:41.788Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:19:41', '2025-10-27 13:19:41'),
('1bEoyXpLVNCjGIaHqMk-N2XVBaQQhJuO', 1761658239, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:30:38.992Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:30:38', '2025-10-27 13:30:38'),
('2IzTiMZD44H3u7aRYJga6EY5-qAVXCDW', 1761494741, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T16:05:40.865Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 16:05:40', '2025-10-25 16:05:40'),
('BlXTmp4d_WbTcrzqJbSJlNYNQVOclGOR', 1761494876, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T16:07:56.299Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 16:07:56', '2025-10-25 16:07:56'),
('BRI621dRNhLcvzov7Vzf2XUwy1Yt2XiF', 1761494260, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T15:57:39.631Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 15:57:39', '2025-10-25 15:57:39'),
('c310oA0GjXhEIkNaDHOoW43XgcMupgYD', 1761497160, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T13:06:01.849Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{},\"user\":{\"id\":20,\"username\":\"ADMIN2\",\"role\":\"admin\"}}', '2025-10-25 13:05:59', '2025-10-25 16:45:59'),
('DJ_3baqIRsqjtQFlPKNPzOupKTek0Xg4', 1761495145, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T16:12:25.276Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 16:12:25', '2025-10-25 16:12:25'),
('DL5Py4RgB1Cm7SA3gZqxXQ6mId8kJgSt', 1761657754, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:22:33.943Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:22:33', '2025-10-27 13:22:33'),
('eQJFvREOTjb8o6kHRWx-TFkC5lLPn6mj', 1761657790, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:23:09.754Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:23:09', '2025-10-27 13:23:09'),
('fjBhoBDgKB79LYHYXTGv3gc2awtdkUqb', 1761495737, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T16:22:16.965Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 16:22:16', '2025-10-25 16:22:16'),
('fQ3NFEyA9u0ftt7mzYwrIiEFzi4AmG62', 1761657606, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:20:05.763Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:20:05', '2025-10-27 13:20:05'),
('gya-Y0UR6vZoNUK_JnvuqJ9gJ82pbckU', 1761658181, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:29:41.293Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:29:41', '2025-10-27 13:29:41'),
('JTw_3lh2dhb3Nd78q_vZjOzkt3YQ_2nO', 1761658410, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:33:30.229Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:33:30', '2025-10-27 13:33:30'),
('JXW8nx0L8GKCb4aeFgSKYaF_PQoskQd7', 1761658331, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:32:10.820Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:32:10', '2025-10-27 13:32:10'),
('LEDfMt_7S5Zxdv23Qhlh6fXLcF-dZkTQ', 1761494661, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T16:04:21.118Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 16:04:21', '2025-10-25 16:04:21'),
('nA4pG3_U6KxAnzFnJXdmBe_AkZfZ3KLn', 1761495184, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T16:13:03.809Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 16:13:03', '2025-10-25 16:13:03'),
('Nble-O5oh-BKuGTKZ3__hxTwhCBx6VoQ', 1761494821, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T16:07:00.727Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 16:07:00', '2025-10-25 16:07:00'),
('ORsc0Eyp57DbjkVHXxtQB8BMjthtEO_J', 1761658682, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:01:47.652Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{},\"user\":{\"id\":20,\"username\":\"ADMIN2\",\"role\":\"admin\"}}', '2025-10-27 13:01:44', '2025-10-27 13:38:02'),
('PIUHBV4C6R5J6xGrJS7A4VsT996vsfrS', 1761494795, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T16:06:34.810Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 16:06:34', '2025-10-25 16:06:34'),
('qpWI9yArY5Gmi9fnI3-pE-_3LbMs2mCJ', 1761658027, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:27:07.299Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:27:07', '2025-10-27 13:27:07'),
('RFNJPFRw4xRZzWj2k-okvW-xND3nGzQt', 1761494544, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T16:02:23.861Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 16:02:23', '2025-10-25 16:02:23'),
('sRfFMfFWXJHdjgW5db6k1BTSdi71BSbp', 1761658646, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:37:25.530Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:37:25', '2025-10-27 13:37:25'),
('tLscWW6dV8s6kPRcKNc5LY_UHdJuOB4J', 1761494933, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T16:08:52.958Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 16:08:52', '2025-10-25 16:08:52'),
('U4gDQOjrpDns9QHz7DDtKNv0K5wJhNcF', 1761494548, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-26T16:02:28.415Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-25 16:02:28', '2025-10-25 16:02:28'),
('VXu0nRP82yS0bgxyfzS4mmHYS9JQkQgd', 1761658642, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:37:21.610Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:37:21', '2025-10-27 13:37:21'),
('w0BBA3z7xczSOIBLeZXkVHsTfhGSJZVb', 1761658108, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-10-28T13:28:27.855Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-10-27 13:28:27', '2025-10-27 13:28:27');

-- --------------------------------------------------------

--
-- Table structure for table `system_settings`
--

CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(50) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `system_settings`
--

INSERT INTO `system_settings` (`id`, `setting_key`, `setting_value`, `created_at`, `updated_at`) VALUES
(1, 'default_currency', 'USD', '2025-08-07 15:36:40', '2025-08-17 17:14:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `activity_status` enum('online','offline') NOT NULL DEFAULT 'offline',
  `last_seen_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password_hash`, `role_id`, `created_at`, `activity_status`, `last_seen_at`) VALUES
(3, 'MOHAMMED AJAJ', '$2a$10$7v4NDF3PcPxlmTogSe7zqOZq0cR9ANipFPe6Iu/DyULIbjQyEfTWm', 4, '2025-05-19 12:19:53', 'offline', NULL),
(13, 'LABRATORY', '$2a$10$yCCtJCDAHsPCC.eiIpD/eezWos2EEqUwzYdlA0NzQvEAkwR8TfXSy', 2, '2025-06-16 21:20:57', 'offline', NULL),
(16, 'AHMED NOOR', '$2a$10$bVCSlG0jmJ7sn4DR6cqsh.LGhuNNG/2cZQpxLULo.EUiY3xLIBVwi', 3, '2025-07-24 13:40:02', 'offline', NULL),
(18, 'admin', '$2a$10$vg90s.BKZwI.YHmA8hz8OuEvehsQvdQ4WS01ZVbrOybCtiOhZFkaq', 4, '2025-08-13 16:16:56', 'offline', '2025-09-08 18:33:02'),
(20, 'ADMIN2', '$2a$10$mXv7vDa9O397ogx8JC8yZe6qFSiahTfv16MVSjOUVB23ce.DcOGP6', 4, '2025-09-07 00:59:56', 'offline', '2025-10-27 16:38:47'),
(21, 'user', '$2a$10$.rfFymsCawygglPdiaU.k..BVFF4bHpDrPNVjRf2Q1pChDnaBvbmC', 3, '2025-09-07 01:13:07', 'offline', '2025-09-07 04:24:33');

-- --------------------------------------------------------

--
-- Structure for view `materials_with_components`
--
DROP TABLE IF EXISTS `materials_with_components`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `materials_with_components`  AS SELECT `m`.`id` AS `id`, `m`.`material_type` AS `material_type`, `m`.`material_name` AS `material_name`, `m`.`calculation_method` AS `calculation_method`, `m`.`price_before_waste` AS `price_before_waste`, `m`.`price_before_waste_syp` AS `price_before_waste_syp`, `m`.`gross_weight` AS `gross_weight`, `m`.`waste_percentage` AS `waste_percentage`, `m`.`packaging_unit` AS `packaging_unit`, `m`.`packaging_weight` AS `packaging_weight`, `m`.`packaging_unit_weight` AS `packaging_unit_weight`, `m`.`empty_package_price` AS `empty_package_price`, `m`.`empty_package_price_syp` AS `empty_package_price_syp`, `m`.`sticker_price` AS `sticker_price`, `m`.`sticker_price_syp` AS `sticker_price_syp`, `m`.`additional_expenses` AS `additional_expenses`, `m`.`additional_expenses_syp` AS `additional_expenses_syp`, `m`.`labor_cost` AS `labor_cost`, `m`.`labor_cost_syp` AS `labor_cost_syp`, `m`.`preservatives_cost` AS `preservatives_cost`, `m`.`preservatives_cost_syp` AS `preservatives_cost_syp`, `m`.`carton_price` AS `carton_price`, `m`.`carton_price_syp` AS `carton_price_syp`, `m`.`pieces_per_package` AS `pieces_per_package`, `m`.`pallet_price` AS `pallet_price`, `m`.`pallet_price_syp` AS `pallet_price_syp`, `m`.`packages_per_pallet` AS `packages_per_pallet`, `m`.`unit_cost` AS `unit_cost`, `m`.`unit_cost_syp` AS `unit_cost_syp`, `m`.`package_cost` AS `package_cost`, `m`.`package_cost_syp` AS `package_cost_syp`, `m`.`extra_weights` AS `extra_weights`, `m`.`gross_package_weight` AS `gross_package_weight`, `m`.`created_at` AS `created_at`, `m`.`updated_at` AS `updated_at`, coalesce((select sum(`mc`.`weight_grams`) from `material_components` `mc` where `mc`.`material_id` = `m`.`id`),`m`.`gross_weight` * 1000) AS `total_weight_grams`, coalesce((select sum(`mc`.`weight_grams` / 1000 * `mc`.`price_per_kg`) from `material_components` `mc` where `mc`.`material_id` = `m`.`id`),`m`.`price_before_waste`) AS `total_price_usd`, (select count(0) from `material_components` `mc` where `mc`.`material_id` = `m`.`id`) AS `components_count` FROM `materials` AS `m` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_actor_created` (`actor_id`,`created_at`),
  ADD KEY `idx_method_path` (`method`,`path`(100));

--
-- Indexes for table `certificates`
--
ALTER TABLE `certificates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_certificate_year` (`certificate_number`,`year`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `idx_certificates_deleted_at` (`deleted_at`);

--
-- Indexes for table `cost_logs`
--
ALTER TABLE `cost_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cost_logs_material` (`material_id`),
  ADD KEY `idx_cost_logs_date` (`calculation_date`);

--
-- Indexes for table `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_currencies_code` (`code`);

--
-- Indexes for table `exchange_rates`
--
ALTER TABLE `exchange_rates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_exchange_from` (`from_currency_id`),
  ADD KEY `idx_exchange_to` (`to_currency_id`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventory_id` (`inventory_id`),
  ADD KEY `invoice_items_ibfk_1` (`invoice_id`);

--
-- Indexes for table `materials`
--
ALTER TABLE `materials`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_materials_name` (`material_name`),
  ADD KEY `idx_materials_type` (`material_type`),
  ADD KEY `idx_materials_created_at` (`created_at`),
  ADD KEY `idx_materials_calculation_method` (`calculation_method`);

--
-- Indexes for table `material_components`
--
ALTER TABLE `material_components`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_material_id` (`material_id`);

--
-- Indexes for table `notes`
--
ALTER TABLE `notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notes_material` (`material_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_orders_number` (`order_number`),
  ADD KEY `idx_orders_number` (`order_number`),
  ADD KEY `idx_orders_client` (`client_name`),
  ADD KEY `idx_orders_date` (`order_date`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_oitems_order` (`order_id`),
  ADD KEY `idx_oitems_material` (`material_id`),
  ADD KEY `idx_order_items_order_id` (`order_id`),
  ADD KEY `idx_order_items_material_id` (`material_id`);

--
-- Indexes for table `quotations`
--
ALTER TABLE `quotations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_quotations_number` (`quotation_number`),
  ADD KEY `idx_quotations_number` (`quotation_number`),
  ADD KEY `idx_quotations_client` (`client_name`),
  ADD KEY `idx_quotations_created_at` (`created_at`);

--
-- Indexes for table `quotation_items`
--
ALTER TABLE `quotation_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_qitems_quotation` (`quotation_id`),
  ADD KEY `idx_qitems_material` (`material_id`),
  ADD KEY `idx_quotation_items_quotation_id` (`quotation_id`),
  ADD KEY `idx_quotation_items_material_id` (`material_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`session_id`);

--
-- Indexes for table `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_system_settings_key` (`setting_key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `idx_activity_status` (`activity_status`),
  ADD KEY `idx_last_seen_at` (`last_seen_at`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=827;

--
-- AUTO_INCREMENT for table `certificates`
--
ALTER TABLE `certificates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=156;

--
-- AUTO_INCREMENT for table `cost_logs`
--
ALTER TABLE `cost_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT for table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `exchange_rates`
--
ALTER TABLE `exchange_rates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=350;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1138;

--
-- AUTO_INCREMENT for table `materials`
--
ALTER TABLE `materials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `material_components`
--
ALTER TABLE `material_components`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `notes`
--
ALTER TABLE `notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

--
-- AUTO_INCREMENT for table `quotations`
--
ALTER TABLE `quotations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `quotation_items`
--
ALTER TABLE `quotation_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cost_logs`
--
ALTER TABLE `cost_logs`
  ADD CONSTRAINT `fk_cost_logs_material` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `exchange_rates`
--
ALTER TABLE `exchange_rates`
  ADD CONSTRAINT `fk_exchange_from_currency` FOREIGN KEY (`from_currency_id`) REFERENCES `currencies` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_exchange_to_currency` FOREIGN KEY (`to_currency_id`) REFERENCES `currencies` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD CONSTRAINT `invoice_items_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoice_items_ibfk_2` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`id`);

--
-- Constraints for table `material_components`
--
ALTER TABLE `material_components`
  ADD CONSTRAINT `fk_material_components_material` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `notes`
--
ALTER TABLE `notes`
  ADD CONSTRAINT `fk_notes_material` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_oitems_material` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_oitems_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `quotation_items`
--
ALTER TABLE `quotation_items`
  ADD CONSTRAINT `fk_qitems_material` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_qitems_quotation` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
