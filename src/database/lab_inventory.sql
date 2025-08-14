-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 13, 2025 at 07:20 PM
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
(111, '23', 2025, 'external', '2025-07-10', 'علاء أباظة', NULL, 'حمص-تلبيسة', 'محمد خالد العثمانلي', 'تنك', '[{\"sample_number\":null,\"quantity\":332,\"packaging_unit\":\"تنك\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":1.75,\"peroxide\":18.5,\"abs_232\":2.27,\"abs_270\":0.215,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.204,\"abs_266\":0.221,\"k_232\":null,\"k_270\":null,\"delta_k\":0.003,\"stigmastadiene\":null}]', 332.00, 0.00, '0060e630', 13, '2025-07-10 12:04:53', '2025-07-10 12:05:16', '2025-07-10 12:05:16'),
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
(131, '43', 2025, 'external', '2025-08-03', 'حكيم ناصر', NULL, NULL, 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":null,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":6.1,\"peroxide\":79.5,\"abs_232\":3.084,\"abs_270\":1.723,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.628,\"abs_266\":1.755,\"k_232\":null,\"k_270\":null,\"delta_k\":0.031,\"stigmastadiene\":null},{\"sample_number\":null,\"quantity\":null,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":5.35,\"peroxide\":47.5,\"abs_232\":3.034,\"abs_270\":1.167,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.098,\"abs_266\":1.152,\"k_232\":null,\"k_270\":null,\"delta_k\":0.042,\"stigmastadiene\":null},{\"sample_number\":null,\"quantity\":null,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":7,\"peroxide\":515,\"abs_232\":3.045,\"abs_270\":1.155,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.104,\"abs_266\":1.137,\"k_232\":null,\"k_270\":null,\"delta_k\":0.035,\"stigmastadiene\":null}]', 0.00, 0.00, '08fa8466', 13, '2025-08-03 15:48:06', '2025-08-03 15:48:40', '2025-08-03 15:48:40'),
(132, '44', 2025, 'external', '2025-08-03', 'حكيم ناصر', NULL, NULL, 'محمد خالد العثمانلي', NULL, '[{\"sample_number\":null,\"quantity\":1,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":6.1,\"peroxide\":79.5,\"abs_232\":3.084,\"abs_270\":1.723,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.628,\"abs_266\":1.755,\"k_232\":null,\"k_270\":null,\"delta_k\":0.031,\"stigmastadiene\":null},{\"sample_number\":null,\"quantity\":2,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":5.35,\"peroxide\":47.5,\"abs_232\":3.034,\"abs_270\":1.167,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.098,\"abs_266\":1.152,\"k_232\":null,\"k_270\":null,\"delta_k\":0.042,\"stigmastadiene\":null},{\"sample_number\":null,\"quantity\":3,\"packaging_unit\":\"0\",\"packaging_weight\":0,\"total_weight\":0,\"ph\":7,\"peroxide\":51.5,\"abs_232\":3.045,\"abs_270\":1.155,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.104,\"abs_266\":1.137,\"k_232\":null,\"k_270\":null,\"delta_k\":0.035,\"stigmastadiene\":null}]', 6.00, 0.00, '40d5d133', 13, '2025-08-03 15:49:47', '2025-08-03 15:49:47', NULL),
(133, '45', 2025, 'internal', '2025-08-04', 'السيد عبدو فهيم المحترم', NULL, 'حلب - عفرين', 'محمد خالد العثمانلي', 'نتيجة تحليل زيت وارد', '[{\"sample_number\":\"1299\",\"quantity\":250,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":0.8,\"peroxide\":11.5,\"abs_232\":1.826,\"abs_270\":0.147,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.141,\"abs_266\":0.156,\"k_232\":null,\"k_270\":null,\"delta_k\":-0.002,\"stigmastadiene\":0},{\"sample_number\":\"1300\",\"quantity\":250,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.1,\"total_weight\":1,\"ph\":0.9,\"peroxide\":13,\"abs_232\":1.817,\"abs_270\":0.15,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.143,\"abs_266\":0.156,\"k_232\":null,\"k_270\":null,\"delta_k\":0,\"stigmastadiene\":0}]', 500.00, 2.00, 'dad5eeab', 13, '2025-08-04 10:42:01', '2025-08-04 10:42:01', NULL),
(134, '46', 2025, 'internal', '2025-08-04', 'محمود نورس', NULL, 'ادلب-كورين', 'محمد خالد العثمانلي', 'تنك فرز (تحليل الحموضة والبروكسيد وهمي)', '[{\"sample_number\":\"1304\",\"quantity\":5,\"packaging_unit\":\"تنك\",\"packaging_weight\":0.101,\"total_weight\":1,\"ph\":1,\"peroxide\":1,\"abs_232\":2.374,\"abs_270\":0.405,\"abs_268\":null,\"abs_262\":null,\"abs_274\":0.389,\"abs_266\":0.391,\"k_232\":null,\"k_270\":null,\"delta_k\":0.015,\"stigmastadiene\":0}]', 5.00, 1.00, '32828b18', 13, '2025-08-04 12:49:24', '2025-08-04 12:49:24', NULL),
(135, '47', 2025, 'internal', '2025-08-04', 'السيد ابراهيم ياسر الابراهيم', NULL, 'ادلب - كورين', 'محمد خالد صفوان عثمانلي', 'عينة داخلية زيت جورة مخالفة', '[{\"sample_number\":\"1306\",\"quantity\":181,\"packaging_unit\":\"تنكة\",\"packaging_weight\":0.101,\"total_weight\":2888.1,\"ph\":3.35,\"peroxide\":0,\"abs_232\":3.22,\"abs_270\":1.175,\"abs_268\":null,\"abs_262\":null,\"abs_274\":1.112,\"abs_266\":1.19,\"k_232\":null,\"k_270\":null,\"delta_k\":0.025,\"stigmastadiene\":0}]', 181.00, 2888.10, '2dec3fb9', 3, '2025-08-04 20:30:10', '2025-08-04 20:30:10', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cost_logs`
--

CREATE TABLE `cost_logs` (
  `id` int(11) NOT NULL,
  `material_id` int(11) DEFAULT NULL,
  `material_name` varchar(255) NOT NULL,
  `unit_cost` decimal(10,2) NOT NULL,
  `unit_cost_syp` decimal(10,2) DEFAULT NULL,
  `package_cost` decimal(10,2) NOT NULL,
  `package_cost_syp` decimal(10,2) DEFAULT NULL,
  `calculation_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cost_logs`
--

INSERT INTO `cost_logs` (`id`, `material_id`, `material_name`, `unit_cost`, `unit_cost_syp`, `package_cost`, `package_cost_syp`, `calculation_date`) VALUES
(1, NULL, 'زيت الزيتون', 981793.75, 99999999.99, 19635875.00, 99999999.99, '2025-08-07 12:09:54'),
(2, NULL, 'زيت الزيتون', 981793.75, 99999999.99, 19635875.00, 99999999.99, '2025-08-07 12:22:14'),
(3, NULL, 'زيت الزيتون', 981793.00, 99999999.99, 19635860.00, 99999999.99, '2025-08-07 12:51:33'),
(4, NULL, 'تفاحي مكسر', 2.76, 35880.00, 2.86, 37180.00, '2025-08-07 13:40:32'),
(5, NULL, 'تفاحي مكسر', 9.36, 121680.00, 9.46, 122980.00, '2025-08-07 14:45:52'),
(6, NULL, 'تفاحي مكسر', 9.36, 121680.00, 9.46, 122980.00, '2025-08-07 14:50:11'),
(7, NULL, 'تفاحي مكسر2', 9.36, 121680.00, 9.46, 122980.00, '2025-08-07 14:53:11'),
(8, NULL, 'تفاحي مكسر3', 9.36, 121680.00, 9.46, 122980.00, '2025-08-07 14:53:40'),
(9, NULL, 'تفاحي مكسر', 9.36, 98280.00, 9.46, 99373.75, '2025-08-07 16:24:24'),
(10, NULL, 'تفاحي مكسر', 7.01, 73605.00, 7.09, 74488.75, '2025-08-09 10:09:09'),
(11, NULL, 'تفاحي مكسر', 6.75, 70875.00, 6.82, 71589.22, '2025-08-09 10:09:36'),
(12, NULL, 'تفاحي مكسر', 8.08, 84840.00, 8.15, 85554.22, '2025-08-09 10:19:10'),
(13, NULL, 'تفاحي مكسر', 8.08, 84840.00, 8.15, 85569.53, '2025-08-09 10:20:07'),
(14, NULL, 'تفاحي مكسر', 8.08, 84840.00, 8.15, 85569.53, '2025-08-09 10:20:37'),
(15, NULL, 'تفاحي مكسر', 8.08, 84840.00, 8.15, 85569.17, '2025-08-09 10:32:37'),
(16, NULL, 'تفاحي مكسر', 9.36, 98280.00, 9.46, 99373.75, '2025-08-09 10:36:09'),
(17, NULL, 'تفاحي مكسر', 9.36, 98280.00, 9.47, 99483.13, '2025-08-09 10:36:50'),
(18, NULL, 'زيت زيتون واحد ليتر ', 69.94, 727405.71, 70.04, 728445.71, '2025-08-09 11:31:42'),
(19, NULL, 'زيت زيتون واحد ليتر ', 4.65, 48315.43, 4.75, 49355.43, '2025-08-09 11:33:32'),
(20, NULL, 'زيت زيتون واحد ليتر ', 9.36, 98280.00, 18.82, 197653.75, '2025-08-11 16:43:57'),
(21, NULL, 'زيت زيتون واحد ليتر ', 9.36, 98280.00, 9.46, 99373.75, '2025-08-11 17:06:02'),
(22, NULL, 'زيت زيتون واحد ليتر ', 9.36, 98280.00, 9.46, 99373.75, '2025-08-11 17:06:02'),
(23, 11, ' زيتون اخضر تفاحي', 9.36, 98280.00, 9.46, 99373.75, '2025-08-12 11:11:25'),
(24, 12, 'زيت زيتون عجاج قياس 5 ليتر', 22.04, 231376.71, 44.67, 469053.43, '2025-08-12 11:17:29'),
(25, 13, 'تفاحي مكسر', 5.00, 52500.00, 6.00, 63000.00, '2025-08-12 12:34:12'),
(26, 14, 'تفاحي مكسر', 5.00, 52500.00, 6.00, 63000.00, '2025-08-12 13:05:22'),
(27, 15, 'تفاحي مكسر', 5.00, 52500.00, 6.00, 63000.00, '2025-08-12 13:19:49'),
(28, 15, 'تفاحي مكسر', 5.00, 52500.00, 6.00, 63000.00, '2025-08-12 13:52:40'),
(29, 15, 'تفاحي مكسر', 5.00, 52500.00, 6.00, 63000.00, '2025-08-12 13:53:04'),
(30, 15, 'تفاحي مكسر', 5.00, 52500.00, 6.00, 63000.00, '2025-08-12 13:57:40'),
(31, 15, 'تفاحي مكسر', 5.00, 52500.00, 6.00, 63000.00, '2025-08-12 13:59:59'),
(32, 15, 'تفاحي مكسر', 5.00, 52500.00, 6.00, 63000.00, '2025-08-12 14:00:38'),
(33, 15, 'تفاحي مكسر', 5.00, 52500.00, 6.00, 63000.00, '2025-08-12 14:00:44');

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
(135, '2025-06-19', '1173', 'سالم ابراهيم المحمد ', 31.00, 0.00, NULL, 493.50, 1.80, 18.00, '2.719 0.376 0.380 0.360 0.013', NULL, 'تنك  علام اسود ', 'محمد خالد عثمانلي ', '2025-06-19 09:48:26', '2025-08-04 15:38:17', 0, NULL),
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
(147, '2025-06-19', '1187', 'سالم ابراهيم المحمد ', 18.00, 0.00, 0.100, 288.00, 0.80, 20.00, '2.561 0.342 0.348 0.333 0.011', NULL, 'تنك مفروز من الزمة 1186 ( مرفوض مرتجع )', 'محمد خالد عثمانلي ', '2025-06-19 10:13:12', '2025-08-05 10:08:37', 1, NULL),
(148, '2025-06-19', '1188', 'محمد حسام الأبراهيم', 266.00, 0.00, 0.100, 4251.30, 0.75, 18.00, '1.963 0.153 0.146 0.139 0.000', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 10:15:11', '2025-06-25 06:08:00', 0, NULL),
(155, '2025-06-19', '1189', 'محمد حسام الابراهيم', 208.00, 0.00, 0.100, 3314.80, 0.70, 10.50, '1.963 0.153 0.146 0.139 0.000', NULL, '190تنك+18بيدون', 'محمد خالد العثمانلي', '2025-06-19 13:37:55', '2025-06-25 06:08:00', 0, NULL),
(156, '2025-06-19', '1190', 'محمود نورس الأبراهيم', 158.00, 0.00, 0.100, 2542.00, 1.35, 19.00, '2.108 0.255 0.247 0.240 -0.001', 0.030, 'تنك', 'محمد خالد العثمانلي', '2025-06-19 13:43:14', '2025-06-26 09:46:28', 0, NULL),
(157, '2025-06-19', '1191', 'محمود نورس الأبراهيم', 42.00, 0.00, 0.100, 1.00, 3.10, NULL, '2.602 0.320 0.320 0.305 0.007', NULL, 'تنك ', 'محمد خالد العثمانلي', '2025-06-19 13:45:02', '2025-08-05 10:08:37', 1, NULL),
(158, '2025-06-19', '1192', 'سالم المحمد', 101.00, 0.00, 0.102, 1610.40, 1.45, 17.50, '2.221 0.248 0.236 0.224 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-06-19 13:49:25', '2025-06-21 15:18:34', 0, NULL),
(159, '2025-06-19', '1193', 'سالم ابراهيم المحمد ', 37.00, 0.00, 0.101, 1.00, 0.90, NULL, '2.158 0.246 0.248 0.224 0.013', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 14:01:11', '2025-08-05 10:08:37', 1, NULL),
(160, '2025-06-19', '1194', 'سالم ابراهيم المحمد ', 315.00, 0.00, 0.100, 5042.30, 0.80, 16.00, '2.125 0.207 0.193 0.183 -0.003', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 14:02:31', '2025-06-25 06:08:00', 0, NULL),
(161, '2025-06-19', '1195', 'سالم ابراهيم المحمد ', 47.00, 0.00, 0.100, 807.90, 0.60, 29.50, '2.686 0.240 0.222 0.208 -0.002', NULL, 'بيدون', 'محمد خالد عثمانلي ', '2025-06-19 14:03:44', '2025-06-25 06:08:00', 0, NULL),
(162, '2025-06-19', '1196', 'مهدي العادل', 230.00, 0.00, 0.100, 3679.80, 0.75, 14.00, '2.044 0.163 0.156 0.152 -0.001', NULL, '222تنك+8بيدون', 'محمد خالد عثمانلي ', '2025-06-19 14:06:30', '2025-08-04 15:38:17', 0, NULL),
(163, '2025-06-19', '1197', 'مهدي العادل', 207.00, 0.00, 0.100, 3306.90, 1.10, 14.50, '2.041 0.173 0.167 0.162 -0.001', NULL, 'تنك', 'محمد خالد عثمانلي ', '2025-06-19 14:08:32', '2025-06-22 12:52:26', 0, NULL),
(164, '2025-06-19', '1198', 'محمد حسام الأبراهيم', 108.00, 0.00, 0.100, 1721.00, 0.50, 14.00, '2.072 0.177 0.159 0.149 -0.004', NULL, 'تنك95+13بيدون', 'م . زاهر عبد الكريم صبوح ', '2025-06-19 14:10:03', '2025-06-26 09:46:28', 0, NULL),
(167, '2025-06-21', '1199', 'نورس حماد ', 61.00, 0.00, 0.103, 976.75, 1.80, 25.50, '2.587 0.200 0.195 0.187 0.002', NULL, 'بيدون أبيض سعة 16 كغ', 'م.زاهر عبدالكريم صبوح', '2025-06-21 08:17:33', '2025-08-04 15:38:17', 0, NULL),
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
(178, '2025-06-25', '1210', 'علاء أباظة', 11.00, 0.00, 0.105, 176.00, 3.00, 19.00, '2.508 0.308 0.313 0.295 0.011', NULL, 'تنك فرز', 'م . زاهر عبد الكريم صبوح ', '2025-06-25 13:14:46', '2025-08-05 11:38:47', 0, NULL),
(179, '2025-06-26', '0', 'تصافي زمة 2', 9.00, 0.00, 0.101, 144.00, 1.30, NULL, '2.785 0.317 0.306 0.287 0.004', NULL, 'تصافي تنك ', 'محمد خالد العثمانلي', '2025-06-26 07:48:13', '2025-06-26 08:23:03', 0, NULL),
(181, '2025-06-26', '1211', 'حكيم ناصر', 250.00, 0.00, 0.100, 3988.00, 1.45, 19.00, '1.862 0.158 0.151 0.144 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-06-26 07:56:38', '2025-06-28 09:03:58', 0, NULL),
(182, '2025-06-26', '1212', 'حكيم ناصر', 221.00, 0.00, 0.101, 3526.14, 1.30, 16.50, '1.914 0.165 0.157 0.148 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-06-26 07:57:47', '2025-06-28 09:03:58', 0, NULL),
(183, '2025-06-26', '1213', 'حكيم ناصر', 39.00, 0.00, 0.102, 622.26, 3.20, 18.50, '2.290 0.308 0.314 0.297 0.011', NULL, 'تنك فرز طعمة سيئة ', 'محمد خالد العثمانلي', '2025-06-26 07:58:53', '2025-06-28 09:03:58', 0, NULL),
(184, '2025-06-28', '1214', 'نورس الحماد', 65.00, 0.00, 0.099, 1041.65, 1.85, 28.00, '2.437 0.204 0.203 0.195 0.004', NULL, 'بيدون', 'م . زاهر عبد الكريم صبوح ', '2025-06-28 07:12:32', '2025-07-15 13:50:36', 0, NULL),
(185, '2025-06-28', '1215', 'حسن البدر', 85.00, 0.00, 0.103, 1360.30, 1.20, 16.50, '2.181 0.203 0.194 0.183 0.001', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-06-28 13:03:15', '2025-08-04 15:38:17', 0, NULL),
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
(210, '2025-07-07', '1241', 'أبراهيم أبو ياسر', 2.00, 0.00, 0.101, 1.00, 1.00, 1.00, '2.934 0.693 0.729 0.698 0.034', NULL, 'أسيد بيروكسيد غير محلل تنك فرز', 'محمد خالد العثمانلي', '2025-07-07 08:47:01', '2025-08-05 10:08:37', 1, NULL),
(211, '2025-07-07', '1242', 'محمود نورس', 47.00, 0.00, 0.100, 755.00, 0.80, 1.80, '2.228 0.151 0.156 0.154 0.003', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-07 13:10:08', '2025-07-27 14:34:17', 0, NULL),
(212, '2025-07-09', '1243', 'عبدالرزاق نصر', 50.00, 50.00, 0.100, 803.50, 0.40, 9.50, '1.780 0.168 0.161 0.158 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-09 07:42:18', '2025-07-27 08:23:56', 0, NULL),
(213, '2025-07-10', '1244', 'علاء أباظة', 332.00, 0.00, 0.100, 1.00, 1.75, 18.50, '2.270 0.221 0.215 0.204 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-10 11:49:32', '2025-08-05 10:08:37', 1, NULL),
(214, '2025-07-10', '1245', 'حكيم ناصر', 250.00, 0.00, 0.100, 3983.80, 1.70, 28.50, '2.066 0.186 0.181 0.173 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-10 12:46:32', '2025-08-05 10:08:37', 1, NULL),
(215, '2025-07-10', '1246', 'حكيم ناصر', 241.00, 0.00, 0.100, 3837.00, 2.15, 30.00, '2.188 0.211 0.208 0.198 0.004', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-10 13:12:44', '2025-08-05 10:08:37', 1, NULL),
(216, '2025-07-12', '1247', 'نورس الحماد', 86.00, 0.00, 0.100, 1375.20, 2.65, 32.00, '2.401 0.207 0.202 0.190 0.004', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-12 08:52:38', '2025-07-14 07:40:09', 0, NULL),
(217, '2025-07-12', '1248', 'محمد صلاح العمر', 125.00, 0.00, 0.100, 1994.10, 0.85, 14.00, '2.001 0.180 0.172 0.164 0.000', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-07-12 10:10:12', '2025-08-04 15:38:17', 0, NULL),
(218, '2025-07-12', '1249', 'محمد صلاح العمر', 125.00, 0.00, 0.100, 2001.20, 0.85, 13.00, '2.024 0.194 0.186 0.180 -0.001', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-07-12 11:44:11', '2025-07-27 14:34:17', 0, NULL),
(219, '2025-07-12', '1250', 'قاسم عرابي', 134.00, 0.00, 0.101, 2141.10, 0.70, 12.50, '2.042 0.204 0.194 0.187 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-12 12:50:57', '2025-07-27 14:34:17', 0, NULL),
(220, '2025-07-12', '1251', 'قاسم عرابي', 12.00, 0.00, 0.100, 192.00, 0.50, 17.00, '1.994 0.159 0.152 0.146 0.000', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-12 14:07:00', '2025-07-27 14:34:17', 0, NULL),
(221, '2025-07-12', '1252', 'قاسم عرابي', 21.00, 0.00, 0.100, 331.55, 1.20, 17.50, '2.236 0.199 0.193 0.184 0.002', NULL, '', 'محمد خالد العثمانلي', '2025-07-12 14:10:07', '2025-07-14 07:40:09', 0, NULL),
(222, '2025-07-12', '1253', 'محمد صلاح العمر', 75.00, 0.00, 0.101, 1199.60, 0.85, 15.00, '1.890 0.168 0.160 0.153 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-12 14:11:25', '2025-07-14 07:40:09', 0, NULL),
(223, '2025-07-13', '1254', 'الشرق الأدنى', 500.00, 0.00, 0.102, 8050.00, 1.70, 26.00, '2.780 0.280 0.278 0.260 0.008', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-07-13 07:54:52', '2025-07-14 07:40:09', 0, NULL),
(224, '2025-07-13', '1255', 'محمد حسام الابراهيم', 256.00, 0.00, 0.100, 4094.40, 1.55, 10.50, '2.018 0.176 0.171 0.162 0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-13 12:02:36', '2025-07-14 07:40:09', 0, NULL),
(225, '2025-07-13', '1256', 'محمد حسام الابراهيم', 11.00, 0.00, 0.101, 1.00, 1.00, NULL, '2.491 0.287 0.286 0.272 0.007', NULL, 'تنك فرز رفض (تحليل الاسيد وهمي)', 'محمد خالد العثمانلي', '2025-07-13 12:09:10', '2025-08-05 10:08:37', 1, NULL),
(226, '2025-07-13', '1257', 'محمد حسام الابراهيم', 98.00, 0.00, 0.101, 1554.50, 1.50, 30.50, '2.046 0.150 0.150 0.145 0.003', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-13 12:48:14', '2025-07-14 13:07:41', 0, NULL),
(227, '2025-07-13', '1258', 'محمد حسام الابراهيم', 53.00, 0.00, 0.100, 849.90, 1.60, 13.50, '1.846 0.133 0.130 0.122 0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-13 12:50:24', '2025-07-14 07:40:09', 0, NULL),
(228, '2025-07-13', '1259', 'الشرق الأدنى', 500.00, 0.00, 0.100, 8020.00, 1.70, 25.50, '2.674 0.256 0.254 0.239 0.006', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-13 13:36:01', '2025-07-27 08:44:35', 0, NULL),
(229, '2025-07-13', '1260', 'الشرق الأدنى', 148.00, 0.00, 0.101, 2357.00, 2.05, 23.50, '2.707 0.294 0.293 0.276 0.007', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-13 13:57:03', '2025-07-14 07:40:09', 0, NULL),
(230, '2025-07-14', '1261', 'الشرق الأدنى', 500.00, 0.00, 0.100, 7995.00, 0.80, 17.00, '2.320 0.203 0.193 0.186 -0.001', NULL, 'تنك', 'م . زاهر عبد الكريم صبوح ', '2025-07-14 10:51:38', '2025-07-15 08:31:12', 0, NULL),
(231, '2025-07-14', '1262', 'الشرق الأدنى', 465.00, 0.00, 0.100, 7445.00, 1.15, 17.50, '2.206 0.197 0.188 0.179 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-14 13:03:41', '2025-07-15 08:31:12', 0, NULL),
(232, '2025-07-15', '1263', 'نورس الحماد', 46.00, 0.00, 0.101, 738.70, 2.35, 28.50, '2.502 0.206 0.202 0.194 0.003', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-15 06:52:51', '2025-08-04 15:38:17', 0, NULL),
(233, '2025-07-26', '1264', 'الشرق الأدنى', 1415.00, 0.00, 0.100, 22650.00, 0.95, 18.50, '2.257 0.170 0.163 0.153 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-26 11:58:30', '2025-07-26 12:01:53', 0, NULL),
(234, '2025-07-28', '1265', 'نورس الحماد', 46.00, 46.00, 0.100, 734.10, 2.10, 37.00, '2.578 0.208 0.203 0.194 0.002', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-28 06:49:09', '2025-07-28 12:47:54', 0, NULL),
(235, '2025-07-28', '1268', 'تجميع الخزانات', 89.50, 0.00, 0.101, 1430.00, 1.55, 21.50, '2.581 0.236 0.230 0.219 0.003', NULL, '13 برميل وزن 110 كغ', 'محمد خالد عثمانلي ', '2025-07-28 12:40:39', '2025-07-29 15:06:25', 0, NULL),
(236, '2025-07-28', '1266', 'محمود نورس الأبراهيم', 99.00, 0.00, 0.101, 1582.40, 1.25, 12.50, '1.680 0.169 0.172 0.169 0.003', NULL, '', 'محمد خالد عثمانلي ', '2025-07-28 12:44:14', '2025-07-29 14:38:03', 0, NULL),
(237, '2025-07-28', '1267', 'محمود نورس الأبراهيم', 56.00, 0.00, 0.100, 896.50, 1.95, 24.50, '2.437 0.178 0.173 0.165 0.001', NULL, 'بيدون', 'محمد خالد عثمانلي ', '2025-07-28 12:46:21', '2025-07-29 14:38:03', 0, NULL),
(238, '2025-07-29', '0', 'تصافي ذمة 3', 42.00, 16.50, 0.102, 672.00, 1.35, 31.50, '2.846 0.435 0.430 0.404 0.010', NULL, 'تصافي ذمة 3', 'محمد خالد العثمانلي', '2025-07-29 14:24:00', '2025-08-05 11:38:47', 0, NULL),
(239, '2025-07-29', '1269', 'علاء أباظة', 106.00, 0.00, 0.100, 1694.00, 0.70, 14.00, '2.046 0.153 0.142 0.134 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-29 15:43:48', '2025-08-05 11:38:47', 0, NULL),
(240, '2025-07-29', '1270', 'علاء أباظة', 120.00, 20.00, 0.101, 1918.00, 1.50, 19.50, '2.149 0.177 0.176 0.168 0.003', NULL, 'تنك116+4بيدون', 'محمد خالد العثمانلي', '2025-07-29 15:44:47', '2025-07-30 10:33:11', 0, NULL),
(241, '2025-07-29', '1271', 'علاء أباظة', 100.00, 0.00, 0.100, 1598.00, 1.15, 16.00, '2.030 0.178 0.178 0.171 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-29 15:46:00', '2025-07-30 10:33:11', 0, NULL),
(242, '2025-07-30', '1272', 'ابراهيم أبو ياسر', 186.00, 0.00, 0.101, 2964.50, 0.80, 14.00, '2.163 0.197 0.189 0.177 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-30 14:46:05', '2025-08-05 11:38:47', 0, NULL),
(243, '2025-07-31', '1273', 'ابراهيم أبو ياسر', 158.00, 0.00, 0.100, 2526.40, 0.80, 10.00, '1.974 0.190 0.172 0.163 -0.004', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-31 13:11:12', '2025-08-05 11:38:47', 0, NULL),
(244, '2025-07-31', '1274', 'ابراهيم أبو ياسر', 6.00, 0.00, 0.100, 95.50, 0.65, 11.00, '1.956 0.206 0.192 0.183 -0.002', NULL, 'تنك فرز', 'محمد خالد العثمانلي', '2025-07-31 13:12:22', '2025-08-05 11:38:47', 0, NULL),
(245, '2025-07-31', '1275', 'محمود نورس', 180.00, 180.00, 0.100, 2878.80, 0.80, 11.50, '1.871 0.130 0.125 0.121 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-31 13:23:36', '2025-08-02 08:28:50', 0, NULL),
(246, '2025-07-31', '1276', 'ابراهيم أبو ياسر', 118.00, 118.00, 0.100, 1863.50, 1.70, 15.00, '2.030 0.147 0.145 0.137 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-07-31 13:54:13', '2025-07-31 14:04:14', 0, NULL),
(247, '2025-07-31', '1277', 'ابراهيم أبو ياسر', 20.00, 20.00, 0.101, 339.70, 2.20, 33.00, '2.603 0.176 0.176 0.169 0.004', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-07-31 13:56:08', '2025-07-31 14:04:34', 0, NULL),
(248, '2025-08-02', '1278', 'محمد حسام الابراهيم', 230.00, 0.00, 0.100, 3709.00, 0.70, 11.50, '1.837 0.133 0.130 0.126 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-02 07:18:33', '2025-08-05 11:38:47', 0, NULL),
(249, '2025-08-02', '1279', 'محمد حسام الابراهيم', 60.00, 0.00, 0.100, 913.00, 1.15, 14.00, '2.077 0.176 0.170 0.164 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-02 07:20:24', '2025-08-05 11:38:47', 0, NULL),
(250, '2025-08-02', '1280', 'ابراهيم أبو ياسر', 107.00, 0.00, 0.100, 1712.00, 0.80, 12.00, '2.007 0.196 0.185 0.176 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-02 08:07:11', '2025-08-05 11:38:47', 0, NULL),
(251, '2025-08-02', '1281', 'ابراهيم أبو ياسر', 69.00, 0.00, 0.100, 1097.00, 0.95, 23.50, '2.303 0.165 0.163 0.160 0.001', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-08-02 08:22:28', '2025-08-05 11:38:47', 0, NULL),
(252, '2025-08-02', '1282', 'نورس الحماد', 120.00, 0.00, 0.101, 1920.80, 0.80, 18.00, '2.216 0.155 0.157 0.154 0.002', NULL, 'بيدون', 'محمد حالد العثمانلي', '2025-08-02 09:09:56', '2025-08-05 11:38:47', 0, NULL),
(253, '2025-08-02', '1283', 'ابراهيم أبو ياسر', 191.00, 191.00, 0.100, 3051.60, 0.45, 11.50, '2.047 0.177 0.163 0.156 -0.004', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-02 14:04:53', '2025-08-02 14:05:44', 0, NULL),
(254, '2025-08-03', '1284', 'محمد حسام الابراهيم', 200.00, 0.00, 0.100, 3203.40, 1.05, 10.50, '1.718 0.149 0.145 0.139 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-03 07:43:09', '2025-08-05 11:38:47', 0, NULL),
(255, '2025-08-03', '1285', 'حسن البدر', 195.00, 82.00, 0.104, 3120.20, 1.10, 13.00, '2.202 0.225 0.217 0.206 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-03 10:02:08', '2025-08-07 11:33:28', 0, NULL),
(256, '2025-08-03', '1286', 'حسن البدر', 3.00, 0.00, NULL, 48.50, 1.00, 1.00, '2.702 0.734 0.768 0.730 0.036', NULL, 'تنك فرز', 'محمد خالد العثمانلي', '2025-08-03 10:03:30', '2025-08-05 10:08:37', 1, NULL),
(257, '2025-08-03', '1287', 'ابراهيم أبو ياسر', 174.00, 0.00, 0.100, 2774.60, 0.80, 15.50, '2.006 0.147 0.140 0.134 0.000', NULL, '170تنك+4بيدون', 'محمد خالد العثمانلي', '2025-08-03 10:04:48', '2025-08-05 11:38:47', 0, NULL),
(258, '2025-08-03', '1288', 'حكيم ناصر', 250.00, 0.00, 0.101, 3976.80, 0.60, 13.50, '1.987 0.151 0.141 0.135 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-03 17:23:45', '2025-08-05 05:52:18', 0, NULL),
(259, '2025-08-03', '1289', 'حكيم ناصر', 241.00, 0.00, 0.111, 3857.50, 0.90, 13.50, '1.945 0.142 0.138 0.133 0.000', NULL, 'تنك', 'محمد عجاج', '2025-08-03 17:25:14', '2025-08-05 05:52:18', 0, NULL),
(260, '2025-08-03', '1290', 'حكيم ناصر', 10.00, 0.00, 0.096, 160.00, 2.55, 13.00, '1.802 0.218 0.225 0.218 0.007', NULL, 'تنك فرز', 'محمد عجاج', '2025-08-03 17:27:01', '2025-08-05 11:38:47', 0, NULL),
(261, '2025-08-03', '1291', 'عبدالرزاق نصر', 16.00, 0.00, 0.100, 256.00, 0.60, 18.50, '1.779 0.150 0.146 0.144 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-03 17:27:54', '2025-08-05 11:38:47', 0, NULL),
(262, '2025-08-03', '1292', 'رياض عبد القادر', 120.00, 0.00, 0.100, 2793.80, 0.70, 16.50, '2.144 0.178 0.174 0.168 0.002', NULL, 'جركل', 'محمد خالد العثمانلي', '2025-08-03 17:29:34', '2025-08-05 11:38:47', 0, NULL),
(263, '2025-08-04', '1293', 'حكيم ناصر', 250.00, 0.00, 0.101, 3996.80, 0.75, 12.00, '1.894 0.169 0.160 0.153 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 07:48:51', '2025-08-04 15:42:34', 0, NULL),
(264, '2025-08-04', '1294', 'حكيم ناصر', 250.00, 0.00, 0.100, 3993.20, 0.75, 13.50, '1.705 0.149 0.141 0.136 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 07:49:34', '2025-08-04 15:42:34', 0, NULL),
(265, '2025-08-04', '1295', 'محمد حسام الابراهيم', 200.00, 200.00, 0.101, 3196.70, 1.65, 14.50, '2.136 0.177 0.175 0.167 0.003', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 10:07:51', '2025-08-04 15:24:19', 0, NULL),
(266, '2025-08-04', '1296', 'محمد حسام الابراهيم', 78.00, 78.00, 0.100, 1319.80, 1.60, 16.50, '2.146 0.178 0.172 0.164 0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 10:08:52', '2025-08-04 15:24:01', 0, NULL),
(267, '2025-08-04', '1297', 'محمد حسام الابراهيم', 69.00, 69.00, 0.100, 1.00, 1.75, 31.50, '2.339 0.168 0.164 0.158 0.002', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-08-04 10:10:18', '2025-08-04 11:02:26', 1, NULL),
(268, '2025-08-04', '1298', 'نورس الحماد', 29.00, 29.00, 0.100, 463.15, 2.15, 35.50, '2.618 0.208 0.203 0.196 0.001', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-08-04 10:11:18', '2025-08-04 15:25:48', 0, NULL),
(269, '2025-08-04', '1299', 'عبدالرحمن فهمي سيدو', 250.00, 0.00, 0.100, 4000.90, 0.80, 11.50, '1.826 0.156 0.147 0.141 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 10:12:21', '2025-08-07 11:33:28', 0, NULL),
(270, '2025-08-04', '1300', 'عبدالرحمن فهمي سيدو', 250.00, 0.00, 0.100, 3998.90, 0.90, 13.00, '1.817 0.156 0.150 0.143 0.000', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 10:40:26', '2025-08-07 11:33:28', 0, NULL),
(271, '2025-08-04', '1301', 'محمود نورس', 45.00, 0.00, 0.100, 721.60, 0.70, 14.00, '1.889 0.168 0.156 0.147 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 11:13:04', '2025-08-05 11:38:47', 0, NULL),
(272, '2025-08-04', '1302', 'محمود نورس', 47.00, 0.00, 0.100, 751.05, 0.70, 18.50, '2.047 0.157 0.161 0.161 0.003', NULL, 'بيدون', 'محمد خالد العثمانلي', '2025-08-04 11:15:10', '2025-08-05 11:38:47', 0, NULL),
(273, '2025-08-04', '1303', 'محمود نورس', 503.00, 0.00, 0.100, 8004.00, 0.90, 16.00, '2.117 0.200 0.192 0.185 -0.001', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-04 12:45:45', '2025-08-05 08:51:46', 0, NULL),
(274, '2025-08-04', '1304', 'محمود نورس', 5.00, 0.00, 0.101, 1.00, 1.00, 1.00, '2.374 0.391 0.405 0.389 0.015', NULL, 'تنك فرز (تحليل اسيد بيروكسيد وهمي)', 'محمد خالد العثمانلي', '2025-08-04 12:46:33', '2025-08-05 10:08:37', 1, NULL),
(275, '2025-08-04', '1305', 'رياض عبد القادر', 91.00, 0.00, 0.101, 1969.65, 0.65, 21.50, '2.491 0.249 0.234 0.222 -0.001', NULL, 'جركل', 'محمد خالد عثمانلي ', '2025-08-04 15:12:19', '2025-08-05 11:38:47', 0, NULL),
(276, '2025-08-04', '1306', 'ابراهيم ابو ياسر', 181.00, 181.00, 0.101, 2888.10, 3.35, NULL, '3.220 1.190 1.175 1.112 0.025', NULL, 'جورة', 'محمد خالد عثمانلي ', '2025-08-04 15:14:08', '2025-08-04 15:14:52', 0, NULL),
(277, '2025-08-05', '1309', 'حسن البدر', 198.00, 198.00, 0.100, 1.00, 0.85, 19.50, '2.187 0.198 0.188 0.177 0.001', NULL, 'تنك197+1بيدون', 'محمد خالد العثمانلي', '2025-08-05 09:22:32', '2025-08-05 09:22:32', 0, NULL),
(278, '2025-08-05', '1310', 'محمود نورس', 184.00, 184.00, 0.100, 1.00, 0.55, 16.50, '2.080 0.202 0.184 0.176 -0.004', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-05 09:36:00', '2025-08-05 09:36:00', 0, NULL),
(279, '2025-08-05', '1311', 'محمود نورس', 2.00, 0.00, 0.102, 1.00, 1.00, 1.00, '2.598 0.475 0.493 0.472 0.019', NULL, 'تنك فرز(اسيد بيروكسيد تحليل وهمي)', 'محمد خالد العثمانلي', '2025-08-05 09:37:10', '2025-08-05 10:08:37', 1, NULL),
(280, '2025-08-05', '1312', 'محمود نورس', 156.00, 0.00, 0.101, 1.00, 0.60, 12.00, '1.949 0.181 0.173 0.168 -0.002', NULL, 'تنك', 'محمد خالد العثمانلي', '2025-08-05 10:07:47', '2025-08-05 11:38:47', 0, NULL),
(281, '2025-08-05', '1313', 'مرتجع ', 85.00, 85.00, NULL, 1.00, 1.36, 19.00, '1.968 0.197 0.193 0.185 0.002', NULL, 'مرتجع من شركة ش.ا', 'محمد خالد العثمانلي', '2025-08-05 11:42:23', '2025-08-07 11:33:48', 0, NULL);

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
  `status` enum('paid','unpaid') DEFAULT 'unpaid',
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
(56, '0001', '2025-06-19', 'مرفوض مخرج من المستودع ( مرتجع  )', 'الزيت المرفوض', 'فاتورة للزيت المرفوض والمخرج الى أصحابه', NULL, NULL, 288.00, 'unpaid', 3, '2025-06-19 10:17:19', '2025-08-05 10:08:37', 1.83, 22.13, 2.22, 0.00, 0.00, 943.00, 15088.00, NULL),
(61, '221', '2025-06-21', 'مؤسسة اليسر', 'خالد طنب', 'تنك ', NULL, NULL, 8000.00, 'unpaid', 3, '2025-06-21 15:09:00', '2025-06-21 15:09:00', 1.61, 17.15, 1.89, 0.00, 0.00, 500.00, 8000.00, NULL),
(62, '222', '2025-06-21', 'مؤسسة اليسر', 'خالد طنب', 'تنك', NULL, NULL, 5600.00, 'unpaid', 3, '2025-06-21 15:18:34', '2025-06-21 15:18:34', 1.60, 16.11, 2.05, 0.00, 0.00, 350.00, 5600.00, NULL),
(65, '223', '2025-06-22', '( نسيم فرح ) ضخ للخزانات', 'عمر حديد ( ضخ خزانات )', 'طلبية 350 برميل وزن 110 كغ صافي ( خام)', NULL, NULL, 38640.00, 'unpaid', 3, '2025-06-22 10:42:28', '2025-06-25 06:08:00', 0.74, 16.65, 2.13, 0.00, 0.00, 2415.00, 38640.00, NULL),
(67, '224', '2025-06-22', 'شركة أصالة', 'خالد طنب', 'تنك ', NULL, NULL, 8432.00, 'unpaid', 13, '2025-06-22 12:52:26', '2025-06-22 12:52:26', 0.80, 12.68, 2.02, 0.00, 0.00, 527.00, 8432.00, NULL),
(68, '225', '2025-06-23', 'شركة أصالة', 'خالد طنب -عبدالستار طنب', '13 بيدون 307 تنك', NULL, NULL, 5120.00, 'unpaid', 3, '2025-06-23 05:33:37', '2025-06-23 05:33:37', 0.71, 13.92, 2.03, 0.00, 0.00, 320.00, 5120.00, NULL),
(71, '0002', '2025-06-25', 'مبيعات متفرقة', 'مبيعات متفرقة', 'خاص بالمبيعات المتفرقة', NULL, NULL, 16.00, 'unpaid', 3, '2025-06-24 21:11:48', '2025-08-04 15:38:17', 1.41, 19.50, 2.33, 0.00, 0.00, 10.00, 160.00, NULL),
(73, '226', '2025-06-26', 'مؤسسة اليسر', 'أويس خلوف', 'زيت زيتون بلدي - تنك كل حمل 100 تنكة ', NULL, NULL, 8153.32, 'unpaid', 3, '2025-06-26 08:21:35', '2025-06-26 08:23:03', 1.56, 17.32, 2.06, 0.00, 0.00, 1000.00, 16000.00, NULL),
(74, '227', '2025-06-26', '( نسيم فرح ) ضخ للخزانات', 'عمر حديد ( ضخ خزانات )', 'طلبية 350 برميل اكسترا ', NULL, NULL, 14405.99, 'unpaid', 3, '2025-06-26 09:41:19', '2025-06-26 09:46:28', 0.80, 15.55, 2.08, 0.00, 0.00, 983.00, 15728.00, NULL),
(75, '228', '2025-06-28', 'مؤسسة اليسر', 'أويس خلوف', 'عفريني ', NULL, NULL, 7577.96, 'unpaid', 3, '2025-06-28 09:03:58', '2025-06-28 09:03:58', 1.39, 17.83, 1.89, 0.00, 0.00, 475.00, 7577.96, NULL),
(76, '229', '2025-06-30', 'شركة أصالة', 'عوض منصور', '139بيدون+111تنك', NULL, NULL, 3990.52, 'unpaid', 13, '2025-06-30 14:02:41', '2025-06-30 14:02:41', 0.66, 15.95, 2.24, 0.00, 0.00, 250.00, 3990.52, NULL),
(77, '227', '2025-07-02', 'طلبية نسيم فرح الضخة الثانية', 'محمد مهدي', 'الضخة الثانية لطلبية نسيم رقم 227 عدد 350 برميل وزن 110 كغ', NULL, NULL, 17741.70, 'unpaid', 3, '2025-07-02 10:52:56', '2025-07-02 11:02:09', 0.81, 15.28, 2.12, 0.00, 0.00, 1102.00, 17632.00, NULL),
(79, '227', '2025-07-05', '( نسيم فرح ) ضخ للخزانات', 'عمر حديد ( ضخ خزانات )', 'الضخة (3)', NULL, NULL, 5208.16, 'unpaid', 3, '2025-07-05 13:58:50', '2025-07-05 13:58:50', 0.70, 13.03, 1.96, 0.00, 0.00, 326.00, 5208.16, NULL),
(80, '230', '2025-07-10', 'مؤسسة اليسر التجارية', 'أويس خلوف', '', NULL, NULL, 4439.30, 'unpaid', 3, '2025-07-10 06:25:19', '2025-07-15 13:50:36', 1.59, 20.63, 2.19, 0.00, 0.00, 278.00, 4448.00, NULL),
(82, '231', '2025-07-13', 'طلبية نسيم فرح — ضخ للخزانات', 'محمد مهدي', 'طلبية 220 برميل وزن 110 كغ', NULL, NULL, 14319.40, 'unpaid', 3, '2025-07-13 14:07:00', '2025-07-14 07:40:09', 1.62, 21.54, 2.40, 0.00, 0.00, 1597.00, 25552.00, NULL),
(83, '232', '2025-07-15', 'سيرجيلا - للتعبئة', 'محمد مهدي - احمد نور', 'الانتباه لتفريغ الخزنات قبل الضخ \nوعدم اضافة اي تنكة فوق العينات المرفقة\nالتعبئة محكمة بكيسين مع بعض والربط المحكم والتاكد من نظافة البراميل قبل تعبئة وعدم السماح للعمال بالتدخين اثناء تعبئة', NULL, NULL, 15440.00, 'unpaid', 3, '2025-07-15 08:31:12', '2025-07-15 08:31:12', 0.97, 17.24, 2.27, 0.00, 0.00, 965.00, 15440.00, NULL),
(86, '233', '2025-07-22', '( نسيم فرح ) ضخ للخزانات', 'محمد مهدي', '141 برميل وزن 110 كغ\nستيغماستاديين = 0.07', NULL, NULL, 15638.17, 'unpaid', 3, '2025-07-22 06:14:31', '2025-07-27 14:34:17', 0.72, 14.37, 2.09, 0.00, 0.00, 951.00, 15216.00, NULL),
(87, '233', '2025-07-26', 'نسيم رياض فرح', 'محمد مهدي', 'ضخة للخزانات (تعبئة براميل بوزن  110*206)', NULL, NULL, 22650.00, 'unpaid', 13, '2025-07-26 12:01:53', '2025-07-26 12:01:53', 0.95, 18.50, 2.26, 0.00, 0.00, 1415.00, 22650.00, NULL),
(88, '0123', '2025-07-27', 'محمد عجاج', 'محمد عجاج', 'عينة  شاملة ', NULL, NULL, 8014.89, 'unpaid', 3, '2025-07-27 08:22:26', '2025-07-27 08:23:56', 1.43, 21.29, 2.40, 0.00, 0.00, 500.00, 8014.89, '2025-07-27 08:23:56'),
(89, '234', '2025-07-27', 'مؤسسة أصالة التجاربة', 'خالد طنب أبوعلي', 'أول ', NULL, NULL, 6539.20, 'unpaid', 3, '2025-07-27 08:43:49', '2025-07-27 08:44:35', 1.39, 21.12, 2.41, 0.00, 0.00, 450.00, 7200.00, NULL),
(91, '235', '2025-07-29', 'مؤسسة أصالة التجارية', 'خالدطنب', '', NULL, NULL, 4471.31, 'unpaid', 3, '2025-07-29 14:31:29', '2025-07-29 14:38:03', 1.59, 19.04, 2.26, 0.00, 0.00, 295.00, 4720.00, NULL),
(93, '236', '2025-07-30', 'مؤسسة أصالة التجارية', 'خالد طنب', 'تنك', NULL, NULL, 3183.33, 'unpaid', 3, '2025-07-30 10:24:12', '2025-07-30 10:32:12', 1.33, 17.75, 2.09, 0.00, 0.00, 200.00, 3183.33, '2025-07-30 10:32:12'),
(94, '236', '2025-07-30', 'مؤسسة أصالة التجارية', 'خالد طنب', 'تنك-هونداي', NULL, NULL, 3196.33, 'unpaid', 3, '2025-07-30 10:33:11', '2025-07-30 10:33:11', 1.33, 17.75, 2.09, 0.00, 0.00, 200.00, 3196.33, NULL),
(98, '237', '2025-08-02', 'نسيم رياض فرح', 'محمد مهدي', '', NULL, NULL, 16904.20, 'unpaid', 3, '2025-08-02 14:14:42', '2025-08-05 11:38:47', 0.81, 14.22, 2.03, 0.00, 0.00, 1921.00, 30736.00, NULL),
(101, '238', '2025-08-04', 'الشرق الادنى لمنتجات زيتون', 'خالد طنب - علاء الاحمد', 'تنك سيارتين مع علام الزمة رقم 1285 بالبخاخ ', NULL, NULL, 8807.05, 'unpaid', 3, '2025-08-04 15:42:34', '2025-08-04 15:42:34', 0.84, 14.31, 1.97, 0.00, 0.00, 1054.00, 8807.05, NULL),
(102, '239', '2025-08-05', 'الشرق الادنى لمنتجات الزيتون', 'خالد طنب', 'حمل خالد طنب رقم 2 مع التاكيد على علامة زمة  قم 1285', NULL, NULL, 8410.34, 'unpaid', 3, '2025-08-05 05:52:18', '2025-08-05 05:52:18', 0.77, 13.47, 1.98, 0.00, 0.00, 527.00, 8410.34, NULL),
(103, '240', '2025-08-05', 'الشرق الادنى لمنتجات الزيتون', 'علاء الاحمد', 'سيارة رقم 2 للسائق علاء مع التاكيد على علام الزمة رقم 1285', NULL, NULL, 8431.83, 'unpaid', 3, '2025-08-05 06:00:12', '2025-08-07 11:33:28', 0.86, 12.29, 1.84, 0.00, 0.00, 526.00, 8416.00, NULL);

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
(523, 88, 197, 160.00, '1228', 0.00, '2025-07-27 08:22:26', 2560.00, 0.80, 13.00, 1.9510, 0.1720, 0.1610, 0.1540, -0.0020),
(524, 88, 212, 15.00, '1243', 0.00, '2025-07-27 08:22:26', 241.05, 0.40, 9.50, 1.7800, 0.1680, 0.1610, 0.1580, -0.0020),
(525, 88, 228, 280.00, '1259', 0.00, '2025-07-27 08:22:26', 4491.20, 1.70, 25.50, 2.6740, 0.2560, 0.2540, 0.2390, 0.0060),
(526, 88, 232, 45.00, '1263', 0.00, '2025-07-27 08:22:26', 722.64, 2.35, 28.50, 2.5020, 0.2060, 0.2020, 0.1940, 0.0030),
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
(579, 93, 240, 100.00, '1270', 0.00, '2025-07-30 10:24:12', 1583.33, 1.50, 19.50, 2.1490, 0.1770, 0.1760, 0.1680, 0.0030),
(580, 93, 241, 100.00, '1271', 0.00, '2025-07-30 10:24:12', 1600.00, 1.15, 16.00, 2.0300, 0.1780, 0.1780, 0.1710, 0.0030),
(581, 94, 240, 100.00, '1270', 0.00, '2025-07-30 10:33:11', 1598.33, 1.50, 19.50, 2.1490, 0.1770, 0.1760, 0.1680, 0.0030),
(582, 94, 241, 100.00, '1271', 0.00, '2025-07-30 10:33:11', 1598.00, 1.15, 16.00, 2.0300, 0.1780, 0.1780, 0.1710, 0.0030),
(688, 71, 135, 2.00, '1173', 0.00, '2025-08-04 15:38:17', 32.00, 1.80, 18.00, 2.7190, 0.3760, 0.3800, 0.3600, 0.0130),
(689, 71, 162, 1.00, '1196', 0.00, '2025-08-04 15:38:17', 16.00, 0.75, 14.00, 2.0440, 0.1630, 0.1560, 0.1520, -0.0010),
(690, 71, 167, 2.00, '1199', 0.00, '2025-08-04 15:38:17', 32.00, 1.80, 25.50, 2.5870, 0.2000, 0.1950, 0.1870, 0.0020),
(691, 71, 185, 2.00, '1215', 0.00, '2025-08-04 15:38:17', 32.00, 1.20, 16.50, 2.1810, 0.2030, 0.1940, 0.1830, 0.0010),
(692, 71, 217, 1.00, '1248', 0.00, '2025-08-04 15:38:17', 16.00, 0.85, 14.00, 2.0010, 0.1800, 0.1720, 0.1640, 0.0000),
(693, 71, 232, 1.00, '1263', 0.00, '2025-08-04 15:38:17', 16.00, 2.35, 28.50, 2.5020, 0.2060, 0.2020, 0.1940, 0.0030),
(694, 71, 261, 1.00, '1291', 0.00, '2025-08-04 15:38:17', 16.00, 0.60, 18.50, 1.7790, 0.1500, 0.1460, 0.1440, -0.0010),
(710, 101, 255, 51.00, '1285', 0.00, '2025-08-04 15:42:34', 816.05, 1.10, 13.00, 2.2020, 0.2250, 0.2170, 0.2060, 0.0010),
(711, 101, 263, 250.00, '1293', 0.00, '2025-08-04 15:42:34', 3996.80, 0.75, 12.00, 1.8940, 0.1690, 0.1600, 0.1530, -0.0010),
(712, 101, 264, 250.00, '1294', 0.00, '2025-08-04 15:42:34', 3993.20, 0.75, 13.50, 1.7050, 0.1490, 0.1410, 0.1360, -0.0010),
(713, 101, 273, 503.00, '1303', 0.00, '2025-08-04 15:42:34', 1.00, 0.90, 16.00, 2.1170, 0.2000, 0.1920, 0.1850, -0.0010),
(732, 102, 255, 36.00, '1285', 0.00, '2025-08-05 05:52:18', 576.04, 1.10, 13.00, 2.2020, 0.2250, 0.2170, 0.2060, 0.0010),
(733, 102, 258, 250.00, '1288', 0.00, '2025-08-05 05:52:18', 3976.80, 0.60, 13.50, 1.9870, 0.1510, 0.1410, 0.1350, -0.0020),
(734, 102, 259, 241.00, '1289', 0.00, '2025-08-05 05:52:18', 3857.50, 0.90, 13.50, 1.9450, 0.1420, 0.1380, 0.1330, 0.0000),
(738, 56, 147, 18.00, '1187', 0.00, '2025-08-05 10:08:37', 288.00, 0.80, 20.00, 2.5610, 0.3420, 0.3480, 0.3330, 0.0110),
(739, 56, 157, 42.00, '1191', 0.00, '2025-08-05 10:08:37', 672.00, 3.10, 0.00, 2.6020, 0.3200, 0.3200, 0.3050, 0.0070),
(740, 56, 159, 37.00, '1193', 0.00, '2025-08-05 10:08:37', 592.00, 0.90, 0.00, 2.1580, 0.2460, 0.2480, 0.2240, 0.0130),
(741, 56, 210, 2.00, '1241', 0.00, '2025-08-05 10:08:37', 32.00, 1.00, 1.00, 2.9340, 0.6930, 0.7290, 0.6980, 0.0340),
(742, 56, 213, 332.00, '1244', 0.00, '2025-08-05 10:08:37', 5312.00, 1.75, 18.50, 2.2700, 0.2210, 0.2150, 0.2040, 0.0030),
(743, 56, 214, 250.00, '1245', 0.00, '2025-08-05 10:08:37', 4000.00, 1.70, 28.50, 2.0660, 0.1860, 0.1810, 0.1730, 0.0010),
(744, 56, 215, 241.00, '1246', 0.00, '2025-08-05 10:08:37', 3856.00, 2.15, 30.00, 2.1880, 0.2110, 0.2080, 0.1980, 0.0040),
(745, 56, 225, 11.00, '1256', 0.00, '2025-08-05 10:08:37', 176.00, 1.00, 0.00, 2.4910, 0.2870, 0.2860, 0.2720, 0.0070),
(746, 56, 256, 3.00, '1286', 0.00, '2025-08-05 10:08:37', 48.00, 1.00, 1.00, 2.7020, 0.7340, 0.7680, 0.7300, 0.0360),
(747, 56, 274, 5.00, '1304', 0.00, '2025-08-05 10:08:37', 80.00, 1.00, 1.00, 2.3740, 0.3910, 0.4050, 0.3890, 0.0150),
(748, 56, 279, 2.00, '1311', 0.00, '2025-08-05 10:08:37', 32.00, 1.00, 1.00, 2.5980, 0.4750, 0.4930, 0.4720, 0.0190),
(749, 98, 178, 11.00, '1210', 0.00, '2025-08-05 11:38:47', 176.00, 3.00, 19.00, 2.5080, 0.3080, 0.3130, 0.2950, 0.0110),
(750, 98, 238, 10.00, '0', 0.00, '2025-08-05 11:38:47', 160.00, 1.35, 31.50, 2.8460, 0.4350, 0.4300, 0.4040, 0.0100),
(751, 98, 239, 106.00, '1269', 0.00, '2025-08-05 11:38:47', 1696.00, 0.70, 14.00, 2.0460, 0.1530, 0.1420, 0.1340, -0.0010),
(752, 98, 242, 186.00, '1272', 0.00, '2025-08-05 11:38:47', 2976.00, 0.80, 14.00, 2.1630, 0.1970, 0.1890, 0.1770, 0.0010),
(753, 98, 243, 158.00, '1273', 0.00, '2025-08-05 11:38:47', 2528.00, 0.80, 10.00, 1.9740, 0.1900, 0.1720, 0.1630, -0.0040),
(754, 98, 244, 6.00, '1274', 0.00, '2025-08-05 11:38:47', 96.00, 0.65, 11.00, 1.9560, 0.2060, 0.1920, 0.1830, -0.0020),
(755, 98, 248, 230.00, '1278', 0.00, '2025-08-05 11:38:47', 3680.00, 0.70, 11.50, 1.8370, 0.1330, 0.1300, 0.1260, 0.0000),
(756, 98, 249, 60.00, '1279', 0.00, '2025-08-05 11:38:47', 960.00, 1.15, 14.00, 2.0770, 0.1760, 0.1700, 0.1640, 0.0000),
(757, 98, 250, 107.00, '1280', 0.00, '2025-08-05 11:38:47', 1712.00, 0.80, 12.00, 2.0070, 0.1960, 0.1850, 0.1760, -0.0010),
(758, 98, 251, 69.00, '1281', 0.00, '2025-08-05 11:38:47', 1104.00, 0.95, 23.50, 2.3030, 0.1650, 0.1630, 0.1600, 0.0010),
(759, 98, 252, 120.00, '1282', 0.00, '2025-08-05 11:38:47', 1920.00, 0.80, 18.00, 2.2160, 0.1550, 0.1570, 0.1540, 0.0020),
(760, 98, 254, 200.00, '1284', 0.00, '2025-08-05 11:38:47', 3200.00, 1.05, 10.50, 1.7180, 0.1490, 0.1450, 0.1390, 0.0010),
(761, 98, 257, 174.00, '1287', 0.00, '2025-08-05 11:38:47', 2784.00, 0.80, 15.50, 2.0060, 0.1470, 0.1400, 0.1340, 0.0000),
(762, 98, 260, 10.00, '1290', 0.00, '2025-08-05 11:38:47', 160.00, 2.55, 13.00, 1.8020, 0.2180, 0.2250, 0.2180, 0.0070),
(763, 98, 261, 15.00, '1291', 0.00, '2025-08-05 11:38:47', 240.00, 0.60, 18.50, 1.7790, 0.1500, 0.1460, 0.1440, -0.0010),
(764, 98, 262, 120.00, '1292', 0.00, '2025-08-05 11:38:47', 1920.00, 0.70, 16.50, 2.1440, 0.1780, 0.1740, 0.1680, 0.0020),
(765, 98, 271, 45.00, '1301', 0.00, '2025-08-05 11:38:47', 720.00, 0.70, 14.00, 1.8890, 0.1680, 0.1560, 0.1470, -0.0010),
(766, 98, 272, 47.00, '1302', 0.00, '2025-08-05 11:38:47', 752.00, 0.70, 18.50, 2.0470, 0.1570, 0.1610, 0.1610, 0.0030),
(767, 98, 275, 91.00, '1305', 0.00, '2025-08-05 11:38:47', 1456.00, 0.65, 21.50, 2.4910, 0.2490, 0.2340, 0.2220, -0.0010),
(768, 98, 280, 156.00, '1312', 0.00, '2025-08-05 11:38:47', 2496.00, 0.60, 12.00, 1.9490, 0.1810, 0.1730, 0.1680, -0.0020),
(769, 103, 255, 26.00, '1285', 0.00, '2025-08-07 11:33:28', 416.00, 1.10, 13.00, 2.2020, 0.2250, 0.2170, 0.2060, 0.0010),
(770, 103, 269, 250.00, '1299', 0.00, '2025-08-07 11:33:28', 4000.00, 0.80, 11.50, 1.8260, 0.1560, 0.1470, 0.1410, -0.0020),
(771, 103, 270, 250.00, '1300', 0.00, '2025-08-07 11:33:28', 4000.00, 0.90, 13.00, 1.8170, 0.1560, 0.1500, 0.1430, 0.0000);

-- --------------------------------------------------------

--
-- Table structure for table `materials`
--

CREATE TABLE `materials` (
  `id` int(11) NOT NULL,
  `material_type` varchar(100) NOT NULL,
  `material_name` varchar(255) NOT NULL,
  `price_before_waste` decimal(10,2) NOT NULL,
  `price_before_waste_syp` decimal(10,2) DEFAULT NULL,
  `gross_weight` decimal(10,2) NOT NULL,
  `waste_percentage` decimal(5,2) NOT NULL,
  `packaging_unit` varchar(50) NOT NULL,
  `packaging_weight` decimal(10,2) NOT NULL,
  `packaging_unit_weight` float DEFAULT NULL,
  `empty_package_price` decimal(10,2) NOT NULL,
  `empty_package_price_syp` decimal(10,2) DEFAULT NULL,
  `sticker_price` decimal(10,2) NOT NULL,
  `sticker_price_syp` decimal(10,2) DEFAULT NULL,
  `additional_expenses` decimal(10,2) NOT NULL,
  `additional_expenses_syp` decimal(10,2) DEFAULT NULL,
  `labor_cost` decimal(10,2) NOT NULL,
  `labor_cost_syp` decimal(10,2) DEFAULT NULL,
  `preservatives_cost` decimal(10,2) NOT NULL,
  `preservatives_cost_syp` decimal(10,2) DEFAULT NULL,
  `carton_price` decimal(10,2) NOT NULL,
  `carton_price_syp` decimal(10,2) DEFAULT NULL,
  `pieces_per_package` int(11) NOT NULL,
  `pallet_price` decimal(10,2) NOT NULL,
  `pallet_price_syp` decimal(10,2) DEFAULT NULL,
  `packages_per_pallet` int(11) NOT NULL,
  `unit_cost` decimal(10,2) NOT NULL,
  `unit_cost_syp` decimal(10,2) DEFAULT NULL,
  `package_cost` decimal(10,2) NOT NULL,
  `package_cost_syp` decimal(10,2) DEFAULT NULL,
  `extra_weights` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extra_weights`)),
  `gross_package_weight` float DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `materials`
--

INSERT INTO `materials` (`id`, `material_type`, `material_name`, `price_before_waste`, `price_before_waste_syp`, `gross_weight`, `waste_percentage`, `packaging_unit`, `packaging_weight`, `packaging_unit_weight`, `empty_package_price`, `empty_package_price_syp`, `sticker_price`, `sticker_price_syp`, `additional_expenses`, `additional_expenses_syp`, `labor_cost`, `labor_cost_syp`, `preservatives_cost`, `preservatives_cost_syp`, `carton_price`, `carton_price_syp`, `pieces_per_package`, `pallet_price`, `pallet_price_syp`, `packages_per_pallet`, `unit_cost`, `unit_cost_syp`, `package_cost`, `package_cost_syp`, `extra_weights`, `gross_package_weight`, `created_at`, `updated_at`) VALUES
(11, 'زيتون', ' زيتون اخضر تفاحي', 1.10, 11550.00, 1.00, 0.00, 'سطل', 7.00, NULL, 1.36, 14280.00, 0.05, 525.00, 0.05, 525.00, 0.05, 525.00, 0.15, 1575.00, 0.00, 0.00, 1, 10.00, 105000.00, 96, 9.36, 98280.00, 9.46, 99373.75, NULL, NULL, '2025-08-12 11:11:25', '2025-08-12 11:11:25'),
(12, 'زيت زيتون ', 'زيت زيتون عجاج قياس 5 ليتر', 4.68, 49140.00, 1.00, 2.00, 'pet', 4.56, NULL, 0.15, 1575.00, 0.05, 525.00, 0.00, 0.00, 0.05, 525.00, 0.00, 0.00, 0.50, 5250.00, 2, 10.00, 105000.00, 100, 22.04, 231376.71, 44.67, 469053.43, NULL, NULL, '2025-08-12 11:17:29', '2025-08-12 11:17:29'),
(13, 'زيتون', 'تفاحي مكسر', 50.00, 525000.00, 10.00, 0.00, 'سطل', 1.00, NULL, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 1.00, 10500.00, 1, 5.00, 52500.00, 6.00, 63000.00, NULL, NULL, '2025-08-12 12:34:12', '2025-08-12 12:34:12'),
(14, 'زيتون', 'تفاحي مكسر', 50.00, 525000.00, 10.00, 0.00, 'سطل', 1.00, 0.1, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 1.00, 10500.00, 1, 5.00, 52500.00, 6.00, 63000.00, '[{\"name\":\"بلب\",\"weight\":0.1},{\"name\":\"بلببلبل\",\"weight\":0.2}]', 1.4, '2025-08-12 13:05:22', '2025-08-12 13:05:22'),
(15, 'زيتون', 'تفاحي مكسر', 50.00, 525000.00, 10.00, 0.00, 'سطل', 1.00, 0, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1, 1.00, 10500.00, 1, 5.00, 52500.00, 6.00, 63000.00, '[]', 1, '2025-08-12 13:19:49', '2025-08-12 14:00:44');

-- --------------------------------------------------------

--
-- Table structure for table `notes`
--

CREATE TABLE `notes` (
  `id` int(11) NOT NULL,
  `material_id` int(11) DEFAULT NULL,
  `material_name` varchar(255) DEFAULT NULL,
  `price` decimal(18,2) DEFAULT NULL,
  `weight` decimal(18,3) DEFAULT NULL,
  `note_date` date DEFAULT NULL,
  `note_text` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notes`
--

INSERT INTO `notes` (`id`, `material_id`, `material_name`, `price`, `weight`, `note_date`, `note_text`, `created_at`, `updated_at`) VALUES
(6, 14, NULL, 500.00, 4.000, '2025-08-12', 'hhhhh', '2025-08-12 15:27:22', '2025-08-12 15:32:51'),
(7, 14, NULL, 354.00, 4564.000, '2025-08-12', 'gjhgfhgfhgfhty4t645trg', '2025-08-12 15:32:38', NULL),
(8, NULL, 'fdgtrrgre', NULL, NULL, '2025-08-13', 'gfggfg', '2025-08-13 17:18:37', NULL),
(9, 11, 'fgfgf', NULL, NULL, '2025-08-13', NULL, '2025-08-13 17:18:59', NULL);

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
  `pallets_count` int(11) DEFAULT NULL,
  `container_number` varchar(100) DEFAULT NULL,
  `packages_count` int(11) DEFAULT NULL,
  `waybill_number` varchar(100) DEFAULT NULL,
  `accreditation_number` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `client_name`, `client_phone`, `client_address`, `delivery_date`, `responsible_worker`, `notes`, `status`, `created_at`, `updated_at`, `order_date`, `quality_controller`, `pallets_count`, `container_number`, `packages_count`, `waybill_number`, `accreditation_number`) VALUES
(4, 'ORD-001', 'محمد عجاج', NULL, NULL, '2025-08-12', 'أحمد نور عجاج', NULL, 'completed', '2025-08-12 11:24:29', '2025-08-12 11:42:18', '2025-08-12', 'محمد عثمانلي', 22, NULL, NULL, NULL, NULL),
(5, 'ORD-002', 'محمد عجاج', NULL, NULL, '2025-08-12', 'أحمد نور عجاج', NULL, 'pending', '2025-08-12 14:21:17', '2025-08-12 14:21:17', '2025-08-12', 'محمد عثمانلي', 22, NULL, NULL, NULL, NULL),
(6, 'ORD-003', 'محمد عجاج', NULL, NULL, '2025-08-12', 'أحمد نور عجاج', NULL, 'pending', '2025-08-12 14:54:51', '2025-08-12 14:54:51', '2025-08-12', 'محمد عثمانلي', 22, NULL, NULL, NULL, NULL),
(7, 'ORD-004', 'محمد عجاج', NULL, NULL, '2025-08-12', 'أحمد نور عجاج', NULL, 'pending', '2025-08-12 14:55:16', '2025-08-12 14:55:16', '2025-08-12', 'محمد عثمانلي', 22, NULL, NULL, NULL, NULL),
(8, 'ORD-005', 'محمد عجاج', NULL, NULL, '2025-08-12', 'أحمد نور عجاج', NULL, 'pending', '2025-08-12 15:01:25', '2025-08-12 15:01:25', '2025-08-12', 'محمد عثمانلي', 22, NULL, NULL, NULL, NULL),
(9, 'ORD-006', 'محمد عجاج', NULL, NULL, '2025-08-12', 'أحمد نور عجاج', '22', 'pending', '2025-08-12 15:03:17', '2025-08-12 15:03:17', '2025-08-12', 'محمد عثمانلي', 22, '1', 1, '1', '1');

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
  `weight` decimal(10,3) DEFAULT NULL,
  `volume` decimal(10,3) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `requested_quantity` decimal(10,3) DEFAULT NULL,
  `unit_price` decimal(18,2) DEFAULT NULL,
  `total_price` decimal(18,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `material_id`, `material_name`, `unit`, `quantity`, `weight`, `volume`, `notes`, `requested_quantity`, `unit_price`, `total_price`) VALUES
(4, 4, 11, 'زيتون اخضر تفاحي', 'سطل', NULL, NULL, NULL, NULL, 1000.000, NULL, NULL),
(5, 4, 12, 'زيت زيتون عجاج قياس 5 ليتر', 'pet', NULL, NULL, NULL, NULL, 1000.000, NULL, NULL),
(6, 5, 14, 'تفاحي مكسر', 'سطل', NULL, 1.400, 50.000, 'ملاحظة', 50.000, 50.00, 2500.00),
(7, 5, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, 40.000, NULL, 40.000, NULL, NULL),
(8, 6, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, 2.000, 'ملاحظة', 10.000, NULL, NULL),
(9, 7, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, NULL, 10.000, 50.00, 500.00),
(10, 8, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, 4.000, NULL, 50.000, NULL, NULL),
(13, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, 50.000, '22', 50.000, 50.00, 2500.00),
(14, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(15, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(16, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(17, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(18, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(19, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(20, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(21, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(22, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(23, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(24, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(25, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(26, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(27, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(28, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(29, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(30, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(31, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(32, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(33, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(34, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(35, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(36, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(37, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(38, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(39, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(40, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(41, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(42, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(43, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(44, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(45, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(46, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(47, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(48, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(49, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(50, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(51, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(52, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(53, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(54, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(55, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(56, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(57, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(58, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(59, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(60, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(61, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(62, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(63, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(64, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(65, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(66, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(67, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(68, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(69, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(70, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(71, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(72, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(73, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(74, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(75, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(76, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(77, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(78, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(79, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(80, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(81, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(82, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(83, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(84, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(85, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(86, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(87, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(88, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(89, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(90, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(91, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(92, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(93, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(94, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(95, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(96, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(97, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(98, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(99, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(100, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(101, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(102, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(103, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(104, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(105, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(106, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(107, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(108, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(109, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(110, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(111, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(112, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(113, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(114, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(115, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(116, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(117, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(118, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(119, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(120, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(121, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(122, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(123, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(124, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(125, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(126, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(127, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(128, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(129, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(130, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(131, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(132, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(133, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(134, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(135, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(136, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(137, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(138, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(139, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(140, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(141, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(142, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(143, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(144, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(145, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(146, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(147, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(148, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(149, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(150, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(151, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(152, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(153, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(154, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(155, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(156, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(157, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(158, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(159, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(160, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(161, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(162, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(163, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(164, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(165, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(166, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(167, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(168, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(169, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(170, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(171, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(172, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(173, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(174, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(175, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(176, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(177, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(178, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(179, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL),
(180, 9, 15, 'تفاحي مكسر', 'سطل', NULL, 1.000, NULL, '22', 40.000, NULL, NULL);

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
  `total_amount` decimal(10,2) NOT NULL,
  `total_amount_syp` decimal(10,2) DEFAULT NULL,
  `general_profit_percentage` decimal(5,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quotations`
--

INSERT INTO `quotations` (`id`, `quotation_number`, `client_id`, `client_name`, `client_phone`, `client_address`, `notes`, `total_amount`, `total_amount_syp`, `general_profit_percentage`, `created_at`, `updated_at`) VALUES
(17, 'QT-001', NULL, 'محمد عجاج', '0988111127', 'حماه ', 'عرض سعر لمدة أسبوع من تاريخ تقديم العرض', 335.84, 3526301.53, 0.00, '2025-08-12 11:20:28', '2025-08-13 13:14:21');

-- --------------------------------------------------------

--
-- Table structure for table `quotation_items`
--

CREATE TABLE `quotation_items` (
  `id` int(11) NOT NULL,
  `quotation_id` int(11) NOT NULL,
  `material_id` int(11) DEFAULT NULL,
  `material_name` varchar(255) NOT NULL,
  `unit_cost` decimal(10,2) NOT NULL,
  `unit_cost_syp` decimal(10,2) DEFAULT NULL,
  `profit_percentage` decimal(5,2) DEFAULT 0.00,
  `final_price` decimal(10,2) NOT NULL,
  `final_price_syp` decimal(10,2) DEFAULT NULL,
  `quantity` int(11) DEFAULT 1,
  `total_price` decimal(10,2) NOT NULL,
  `total_price_syp` decimal(10,2) DEFAULT NULL,
  `material_type` varchar(100) DEFAULT NULL,
  `packaging_unit` varchar(50) DEFAULT NULL,
  `packaging_weight` decimal(10,2) DEFAULT 0.00,
  `pieces_per_package` int(11) DEFAULT 0,
  `notes` text DEFAULT NULL,
  `package_cost` decimal(10,2) DEFAULT NULL,
  `item_notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quotation_items`
--

INSERT INTO `quotation_items` (`id`, `quotation_id`, `material_id`, `material_name`, `unit_cost`, `unit_cost_syp`, `profit_percentage`, `final_price`, `final_price_syp`, `quantity`, `total_price`, `total_price_syp`, `material_type`, `packaging_unit`, `packaging_weight`, `pieces_per_package`, `notes`, `package_cost`, `item_notes`) VALUES
(39, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 35.31, 12.80, 134403.42, 1, 12.80, 134403.42, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(40, 17, 12, 'زيت زيتون عجاج قياس 5 ليتر', 44.67, 469035.00, 7.45, 48.00, 503978.11, 1, 48.00, 503978.11, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(41, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(42, 17, 13, 'تفاحي مكسر', 6.00, 63000.00, 0.00, 6.00, 63000.00, 1, 6.00, 63000.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(43, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(44, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(45, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(46, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(47, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(48, 17, 13, 'تفاحي مكسر', 6.00, 63000.00, 0.00, 6.00, 63000.00, 1, 6.00, 63000.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(49, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(50, 17, 13, 'تفاحي مكسر', 6.00, 63000.00, 0.00, 6.00, 63000.00, 1, 6.00, 63000.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(51, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(52, 17, 13, 'تفاحي مكسر', 6.00, 63000.00, 0.00, 6.00, 63000.00, 1, 6.00, 63000.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(53, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(54, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(55, 17, 13, 'تفاحي مكسر', 6.00, 63000.00, 0.00, 6.00, 63000.00, 1, 6.00, 63000.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(56, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(57, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(58, 17, 14, 'تفاحي مكسر', 6.00, 63000.00, 0.00, 6.00, 63000.00, 1, 6.00, 63000.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(59, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(60, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(61, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(62, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(63, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(64, 17, 13, 'تفاحي مكسر', 6.00, 63000.00, 0.00, 6.00, 63000.00, 1, 6.00, 63000.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(65, 17, 13, 'تفاحي مكسر', 6.00, 63000.00, 0.00, 6.00, 63000.00, 1, 6.00, 63000.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(66, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(67, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(68, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(69, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(70, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(71, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(72, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(73, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(74, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(75, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(76, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(77, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(78, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(79, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(80, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(81, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(82, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(83, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(84, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(85, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(86, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(87, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(88, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(89, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(90, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(91, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(92, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(93, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(94, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(95, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(96, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(97, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(98, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(99, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(100, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(101, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(102, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(103, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(104, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(105, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(106, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(107, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(108, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(109, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(110, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(111, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(112, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(113, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(114, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(115, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(116, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(117, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(118, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(119, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(120, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(121, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(122, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(123, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(124, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(125, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(126, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(127, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(128, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(129, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(130, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(131, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(132, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(133, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(134, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(135, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(136, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(137, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(138, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(139, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(140, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(141, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(142, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(143, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(144, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(145, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(146, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(147, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(148, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(149, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(150, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(151, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(152, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(153, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(154, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(155, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(156, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(157, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(158, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(159, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(160, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(161, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(162, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(163, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(164, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(165, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(166, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(167, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(168, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(169, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(170, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(171, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(172, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(173, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(174, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(175, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(176, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(177, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(178, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(179, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(180, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(181, 17, 11, 'زيتون اخضر تفاحي', 9.46, 99330.00, 0.00, 9.46, 99330.00, 1, 9.46, 99330.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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
('57uoqKQ4OLHX34wEtv_fgvQV3B7BWf1E', 1755183812, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-08-14T15:03:32.035Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-08-13 15:03:32', '2025-08-13 15:03:32'),
('5htjK1AFWOlySVDHeMhMmGf1lnGum18K', 1755183762, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-08-14T15:02:42.105Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-08-13 15:02:42', '2025-08-13 15:02:42'),
('8WVg43-nT-8Xy9AAfVU6OXFVAjKt8G5u', 1755183970, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-08-14T15:06:09.556Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-08-13 15:06:09', '2025-08-13 15:06:09'),
('AgaZinS3I1bmn4yh5M3L63JPy69AOxEY', 1755184844, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-08-14T15:20:44.248Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-08-13 15:20:44', '2025-08-13 15:20:44'),
('bZ7cn84iBWcBJQ4IjS7foa2FvZimSln8', 1755184649, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-08-14T15:17:29.415Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-08-13 15:17:29', '2025-08-13 15:17:29'),
('den4cU9ywMnDvHqMcwS1U6KZpLfMxX8Q', 1755184605, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-08-14T15:16:44.937Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-08-13 15:16:44', '2025-08-13 15:16:44'),
('EA07p9qkXIur7jUVf7lwtv322Qc2hZmI', 1755191939, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-08-14T13:03:04.503Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{},\"user\":{\"id\":20,\"username\":\"admin\",\"role\":\"admin\"}}', '2025-08-13 13:02:59', '2025-08-13 17:18:59'),
('rPNnSaG46l0AnPlbuM_LOrhFjUiRVrGX', 1755183836, '{\"cookie\":{\"originalMaxAge\":86400000,\"expires\":\"2025-08-14T15:03:56.050Z\",\"secure\":false,\"httpOnly\":true,\"path\":\"/\",\"sameSite\":\"lax\"},\"flash\":{}}', '2025-08-13 15:03:56', '2025-08-13 15:03:56');

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
(1, 'default_currency', 'USD', '2025-08-07 15:36:40', '2025-08-12 11:10:05');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password_hash`, `role_id`, `created_at`) VALUES
(3, 'MOHAMMED AJAJ', '$2a$10$hY3xu/P/TRo58F0AJOgUxOKR/vO5wKQYHKQjWWJe/4hTRUew2Bvkq', 2, '2025-05-19 12:19:53'),
(13, 'LABRATORY', '$2a$10$yCCtJCDAHsPCC.eiIpD/eezWos2EEqUwzYdlA0NzQvEAkwR8TfXSy', 2, '2025-06-16 21:20:57'),
(16, 'AHMED NOOR', '$2a$10$bVCSlG0jmJ7sn4DR6cqsh.LGhuNNG/2cZQpxLULo.EUiY3xLIBVwi', 3, '2025-07-24 13:40:02'),
(17, 'anas', '$2a$10$mzQ7XbXuBf8o2fwnC89lP.7F4qQndtufHGNMyrg24IGvk4myA1QGC', 2, '2025-08-05 12:02:52'),
(18, 'editor', '$2a$10$mzQ7XbXuBf8o2fwnC89lP.7F4qQndtufHGNMyrg24IGvk4myA1QGC', 2, '2025-08-05 12:02:52'),
(19, 'viewer', '$2a$10$mzQ7XbXuBf8o2fwnC89lP.7F4qQndtufHGNMyrg24IGvk4myA1QGC', 3, '2025-08-05 12:02:52'),
(20, 'admin', '$2a$10$ONNAaSyypOQM9vPCSphlE.LowbY/.Th7L9aQQaHM7TQ/2QCaPaWj2', 4, '2025-08-05 12:02:52'),
(21, 'admin2', '$2a$10$k/Y1XQiyfb9OcGgnog2ClujnphduIByyMomfT.n4xkIyiKx5rc.yK', 4, '2025-08-13 13:02:30');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `certificates`
--
ALTER TABLE `certificates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_certificate_year` (`certificate_number`,`year`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `idx_certificates_deleted_at` (`deleted_at`);

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cost_logs`
--
ALTER TABLE `cost_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cost_logs_material` (`material_id`),
  ADD KEY `idx_cost_logs_date` (`calculation_date`),
  ADD KEY `idx_cost_logs_currency` (`unit_cost`,`unit_cost_syp`,`package_cost`,`package_cost_syp`);

--
-- Indexes for table `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `exchange_rates`
--
ALTER TABLE `exchange_rates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_rate` (`from_currency_id`,`to_currency_id`),
  ADD KEY `to_currency_id` (`to_currency_id`);

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
  ADD KEY `idx_materials_currency` (`unit_cost`,`unit_cost_syp`);

--
-- Indexes for table `notes`
--
ALTER TABLE `notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_notes_material` (`material_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `idx_orders_number` (`order_number`),
  ADD KEY `idx_orders_client` (`client_name`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `material_id` (`material_id`);

--
-- Indexes for table `quotations`
--
ALTER TABLE `quotations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `quotation_number` (`quotation_number`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `idx_quotations_number` (`quotation_number`),
  ADD KEY `idx_quotations_client` (`client_name`),
  ADD KEY `idx_quotations_currency` (`total_amount`,`total_amount_syp`);

--
-- Indexes for table `quotation_items`
--
ALTER TABLE `quotation_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quotation_id` (`quotation_id`),
  ADD KEY `material_id` (`material_id`),
  ADD KEY `idx_quotation_items_currency` (`unit_cost`,`unit_cost_syp`,`final_price`,`final_price_syp`);

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
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `certificates`
--
ALTER TABLE `certificates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;

--
-- AUTO_INCREMENT for table `clients`
--
ALTER TABLE `clients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cost_logs`
--
ALTER TABLE `cost_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `exchange_rates`
--
ALTER TABLE `exchange_rates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=282;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=772;

--
-- AUTO_INCREMENT for table `materials`
--
ALTER TABLE `materials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `notes`
--
ALTER TABLE `notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=181;

--
-- AUTO_INCREMENT for table `quotations`
--
ALTER TABLE `quotations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `quotation_items`
--
ALTER TABLE `quotation_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=182;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

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
  ADD CONSTRAINT `cost_logs_ibfk_1` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `exchange_rates`
--
ALTER TABLE `exchange_rates`
  ADD CONSTRAINT `exchange_rates_ibfk_1` FOREIGN KEY (`from_currency_id`) REFERENCES `currencies` (`id`),
  ADD CONSTRAINT `exchange_rates_ibfk_2` FOREIGN KEY (`to_currency_id`) REFERENCES `currencies` (`id`);

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
-- Constraints for table `notes`
--
ALTER TABLE `notes`
  ADD CONSTRAINT `fk_notes_material` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `quotations`
--
ALTER TABLE `quotations`
  ADD CONSTRAINT `quotations_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `quotation_items`
--
ALTER TABLE `quotation_items`
  ADD CONSTRAINT `quotation_items_ibfk_1` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `quotation_items_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
