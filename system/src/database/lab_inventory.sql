-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 29, 2026 at 05:58 PM
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
  `numeric_raw` longtext DEFAULT NULL,
  `public_id` varchar(36) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL COMMENT 'Timestamp of soft-delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `numeric_raw` longtext DEFAULT NULL,
  `calculation_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `numeric_raw` longtext DEFAULT NULL CHECK (json_valid(`numeric_raw`)),
  `analyst` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_rejected` tinyint(1) DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL COMMENT 'Timestamp of soft-delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `numeric_raw` longtext DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL COMMENT 'Timestamp of soft-delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  `delta_k` decimal(10,4) DEFAULT NULL,
  `numeric_raw` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `materials`
--

CREATE TABLE `materials` (
  `id` int(11) NOT NULL,
  `material_type` varchar(100) NOT NULL,
  `material_name` varchar(255) NOT NULL,
  `material_origin` enum('internal','external') NOT NULL DEFAULT 'internal',
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
  `additional_expense_items` longtext DEFAULT NULL CHECK (json_valid(`additional_expense_items`)),
  `external_notes` text DEFAULT NULL,
  `numeric_raw` longtext DEFAULT NULL CHECK (json_valid(`numeric_raw`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='جدول المواد - يدعم الحساب التقليدي والحساب بالعناصر الفرعية';

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
  `numeric_raw` longtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='جدول العناصر الفرعية للمواد';

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
  `numeric_raw` longtext DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `numeric_raw` longtext DEFAULT NULL CHECK (json_valid(`numeric_raw`)),
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
  `numeric_raw` longtext DEFAULT NULL CHECK (json_valid(`numeric_raw`)),
  `volume` decimal(15,3) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `requested_quantity` decimal(15,3) NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `unit_price_syp` decimal(15,2) DEFAULT NULL,
  `total_price` decimal(15,2) NOT NULL,
  `total_price_syp` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `sale_description` varchar(255) DEFAULT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `total_amount_syp` decimal(15,2) DEFAULT NULL,
  `general_profit_percentage` decimal(5,2) DEFAULT 0.00,
  `numeric_raw` longtext DEFAULT NULL CHECK (json_valid(`numeric_raw`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `item_notes` text DEFAULT NULL,
  `numeric_raw` longtext DEFAULT NULL CHECK (json_valid(`numeric_raw`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- --------------------------------------------------------

--
-- Table structure for table `website_contact_attachments`
--

CREATE TABLE `website_contact_attachments` (
  `id` int(11) NOT NULL,
  `message_id` int(11) NOT NULL,
  `file_url` varchar(500) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `website_contact_messages`
--

CREATE TABLE `website_contact_messages` (
  `id` int(11) NOT NULL,
  `sender_name` varchar(191) NOT NULL,
  `sender_phone` varchar(100) NOT NULL,
  `message_text` text NOT NULL,
  `sender_ip` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `website_content`
--

CREATE TABLE `website_content` (
  `id` int(11) NOT NULL,
  `content_name` varchar(255) NOT NULL,
  `site_id` varchar(191) DEFAULT NULL,
  `content_json` longtext NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ;

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
  ADD KEY `idx_materials_calculation_method` (`calculation_method`),
  ADD KEY `idx_materials_deleted_at` (`deleted_at`);

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
-- Indexes for table `website_contact_attachments`
--
ALTER TABLE `website_contact_attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_wca_message_id` (`message_id`);

--
-- Indexes for table `website_contact_messages`
--
ALTER TABLE `website_contact_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_wcm_created_at` (`created_at`),
  ADD KEY `idx_wcm_sender_phone` (`sender_phone`);

--
-- Indexes for table `website_content`
--
ALTER TABLE `website_content`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_website_content_site_id` (`site_id`),
  ADD KEY `idx_website_content_deleted_at` (`deleted_at`),
  ADD KEY `idx_website_content_created_by` (`created_by`),
  ADD KEY `idx_website_content_updated_by` (`updated_by`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `certificates`
--
ALTER TABLE `certificates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cost_logs`
--
ALTER TABLE `cost_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `exchange_rates`
--
ALTER TABLE `exchange_rates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `materials`
--
ALTER TABLE `materials`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `material_components`
--
ALTER TABLE `material_components`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notes`
--
ALTER TABLE `notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quotations`
--
ALTER TABLE `quotations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quotation_items`
--
ALTER TABLE `quotation_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `system_settings`
--
ALTER TABLE `system_settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `website_contact_attachments`
--
ALTER TABLE `website_contact_attachments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `website_contact_messages`
--
ALTER TABLE `website_contact_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `website_content`
--
ALTER TABLE `website_content`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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

--
-- Constraints for table `website_contact_attachments`
--
ALTER TABLE `website_contact_attachments`
  ADD CONSTRAINT `fk_wca_message_id` FOREIGN KEY (`message_id`) REFERENCES `website_contact_messages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `website_content`
--
ALTER TABLE `website_content`
  ADD CONSTRAINT `fk_website_content_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_website_content_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
