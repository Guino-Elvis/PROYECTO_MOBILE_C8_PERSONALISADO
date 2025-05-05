-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 05-05-2025 a las 21:23:29
-- Versión del servidor: 8.0.30
-- Versión de PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ventas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `id` int NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `estado` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `tag` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id`, `created_at`, `estado`, `foto`, `nombre`, `tag`, `updated_at`) VALUES
(1, '2024-11-10 22:15:08.011121', 'Activo', '', 'Camas', 'sddsdsd', '2024-11-10 22:15:08.011121'),
(2, '2024-11-12 19:58:50.000000', 'Activo', NULL, 'Ropas', 'sdasd', '2024-11-12 19:59:08.000000'),
(3, '2024-11-12 19:59:13.000000', 'Activo', NULL, 'Mesas', 'asa', '2024-11-12 19:59:27.000000'),
(4, '2024-11-12 20:01:58.000000', 'Activo', NULL, 'Casacas', 'asdas', '2024-11-12 20:02:12.000000'),
(5, '2024-11-12 20:02:16.000000', 'Activo', NULL, 'Zapatos', 'asdas', '2024-11-12 20:02:30.000000');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `id` int NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `materno` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `paterno` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `postal` varchar(255) DEFAULT NULL,
  `tdatos` varchar(255) DEFAULT NULL,
  `tdocumento` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `user_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`id`, `created_at`, `direccion`, `email`, `materno`, `name`, `paterno`, `phone`, `postal`, `tdatos`, `tdocumento`, `updated_at`, `user_id`) VALUES
(6, '2024-11-19 22:16:26.625754', 'adasd', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '915688265', '2100', '1', '74349846', '2024-11-19 22:16:26.625754', 2),
(8, '2024-11-19 22:33:45.332311', '45645', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '91263412', '45645', '1', '74349846', '2024-11-19 22:33:45.332311', 2),
(9, '2024-11-19 22:35:13.852111', '456456', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '56456', '456456', '1', '74349846', '2024-11-19 22:35:13.852111', 2),
(10, '2024-11-20 04:08:49.007904', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 04:08:49.007904', 2),
(11, '2024-11-20 04:11:02.137211', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 04:11:02.137211', 2),
(12, '2024-11-20 04:11:35.418889', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 04:11:35.418889', 2),
(13, '2024-11-20 04:12:57.601587', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 04:12:57.601587', 2),
(14, '2024-11-20 04:14:38.225138', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 04:14:38.226152', 2),
(15, '2024-11-20 04:16:10.921080', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 04:16:10.921080', 2),
(16, '2024-11-20 04:20:20.704598', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 04:20:20.704598', 2),
(17, '2024-11-20 04:23:22.705415', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 04:23:22.705415', 2),
(18, '2024-11-20 04:29:35.928825', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 04:29:35.928825', 2),
(19, '2024-11-20 04:32:57.191197', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 04:32:57.191197', 2),
(20, '2024-11-20 05:16:39.509949', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 05:16:39.509949', 2),
(21, '2024-11-20 05:18:09.854882', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 05:18:09.854882', 2),
(22, '2024-11-20 05:18:35.061302', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 05:18:35.061302', 2),
(23, '2024-11-20 05:21:33.560170', 'ghghj', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '65', '2100', '1', '74349846', '2024-11-20 05:21:33.560170', 2),
(24, '2024-11-20 05:30:14.324049', '4564565', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '916564', '654', '1', '74349846', '2024-11-20 05:30:14.324049', 2),
(25, '2024-11-20 05:33:12.432476', '4564565', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '916564', '654', '1', '74349846', '2024-11-20 05:33:12.432476', 2),
(26, '2024-11-20 05:37:16.743821', '4564565', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '916564', '654', '1', '74349846', '2024-11-20 05:37:16.743821', 2),
(27, '2024-11-20 05:37:41.205390', '4564565', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '916564', '654', '1', '74349846', '2024-11-20 05:37:41.205390', 2),
(28, '2024-11-20 06:24:55.361973', '44', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '456456', '545', '1', '74349846', '2024-11-20 06:24:55.361973', 2),
(29, '2024-11-20 06:29:42.746076', '44', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '456456', '545', '1', '74349846', '2024-11-20 06:29:42.746076', 2),
(30, '2024-11-20 06:30:43.268087', '44', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '456456', '545', '1', '74349846', '2024-11-20 06:30:43.268087', 2),
(31, '2024-11-20 06:33:49.301264', '44', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '456456', '545', '1', '74349846', '2024-11-20 06:33:49.301264', 2),
(32, '2024-11-20 06:38:32.881447', '44', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '456456', '545', '1', '74349846', '2024-11-20 06:38:32.881447', 2),
(33, '2024-11-20 06:56:38.501304', '44', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '456456', '545', '1', '74349846', '2024-11-20 06:56:38.501304', 2),
(34, '2024-11-20 07:02:58.331427', '456456', 'ginoyujra38@gmail.com', 'Vargas', 'Guino Elvis', 'Yujra', '456456', '456', '1', '74349846', '2024-11-20 07:02:58.331427', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa`
--

CREATE TABLE `empresa` (
  `id` int NOT NULL,
  `marca` varchar(255) DEFAULT NULL,
  `numero` varchar(255) DEFAULT NULL,
  `ra_social` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entrega`
--

CREATE TABLE `entrega` (
  `id` int NOT NULL,
  `auth_user_id` int DEFAULT NULL,
  `departamento` varchar(255) DEFAULT NULL,
  `distrito` varchar(255) DEFAULT NULL,
  `provincia` varchar(255) DEFAULT NULL,
  `referencia` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `entrega`
--

INSERT INTO `entrega` (`id`, `auth_user_id`, `departamento`, `distrito`, `provincia`, `referencia`) VALUES
(1, 2, 'puno', 'juliaca', 'san roman', 'av tambopata'),
(2, NULL, 'asdasd', 'asdasd', 'asdasdasdasd', 'asdasd'),
(3, NULL, 'puno', 'juliaca', 'san roman', 'av tambopata casa de 8 pisoss'),
(4, NULL, '4564', '4566', '456', '456456'),
(5, NULL, 'ssdsd', 'sdsddsd', 'sdsdsd', 'sdsd'),
(6, NULL, '123123', '123', '123123', '12312'),
(7, NULL, '123123', '123', '123123', '12312'),
(8, NULL, '123123', '123', '123123', '12312'),
(9, NULL, '123123', '123', '123123', '12312'),
(10, NULL, '123123', '123', '123123', '12312'),
(11, NULL, '123123', '123', '123123', '12312'),
(12, NULL, '123123', '123', '123123', '12312'),
(13, NULL, '123123', '123', '123123', '12312'),
(14, NULL, '123123', '123', '123123', '12312'),
(15, NULL, '123123', '123', '123123', '12312'),
(16, NULL, '123123', '123', '123123', '12312'),
(17, NULL, '123123', '123', '123123', '12312'),
(18, NULL, '123123', '123', '123123', '12312'),
(19, NULL, '123123', '123', '123123', '12312'),
(20, NULL, '4564545', '5631', '56456', '563456'),
(21, NULL, '4564545', '5631', '56456', '563456'),
(22, NULL, '4564545', '5631', '56456', '563456'),
(23, NULL, '4564545', '5631', '56456', '563456'),
(24, NULL, '456456', '456456', '6456', '44');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `imagen`
--

CREATE TABLE `imagen` (
  `id` int NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `producto_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `imagen`
--

INSERT INTO `imagen` (`id`, `url`, `producto_id`) VALUES
(64, 'https://firebasestorage.googleapis.com/v0/b/proyectoc6-3a55f.appspot.com/o/imagenes%2Fproducto%20nuevo-1731375825098.png?alt=media&token=cb9b1e9b-ee0c-4c0f-b8eb-285a506756f6', 4),
(65, 'https://firebasestorage.googleapis.com/v0/b/proyectoc6-3a55f.appspot.com/o/imagenes%2Fproducto%20nuevo-1731375828351.png?alt=media&token=13a4facd-61f5-46fd-a1e9-8ab79faea8f4', 4),
(66, 'https://firebasestorage.googleapis.com/v0/b/proyectoc6-3a55f.appspot.com/o/imagenes%2Fproducto%20nuevo-1731375851331.png?alt=media&token=503807b0-845c-4525-9314-591055c32092', 4),
(67, 'https://firebasestorage.googleapis.com/v0/b/proyectoc6-3a55f.appspot.com/o/imagenes%2Fproducto%20nuevo-1731375854470.png?alt=media&token=285d3ceb-b274-4a18-a8e0-6c34e563f6ca', 4),
(68, 'https://firebasestorage.googleapis.com/v0/b/proyectoc6-3a55f.appspot.com/o/imagenes%2Fproducto%20nuevo-1731375857448.png?alt=media&token=3b17153e-1445-4225-8126-8d3e7cd951e2', 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `id` int NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `descrip` varchar(255) DEFAULT NULL,
  `estado` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `precio` double DEFAULT NULL,
  `stock` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `sub_categoria_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`id`, `created_at`, `descrip`, `estado`, `foto`, `nombre`, `precio`, `stock`, `updated_at`, `sub_categoria_id`) VALUES
(1, '2024-11-16 12:01:44.304560', 'jghjghjghjgjghjghjghjghjghjghj', 'Activo', 'https://firebasestorage.googleapis.com/v0/b/proyectoc6-3a55f.appspot.com/o/venta%2F1-chompa.png?alt=media&token=167e5008-8868-417e-8d7d-dc89d915aa7a', 'chompa', 50, '20', '2024-11-16 12:02:14.329207', 1),
(2, '2024-11-16 12:02:44.157605', 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh', 'Activo', 'https://firebasestorage.googleapis.com/v0/b/proyectoc6-3a55f.appspot.com/o/venta%2Fproducto2-2024-11-16%2017%3A02%3A35.920941.png?alt=media&token=abea4894-de50-459b-bf83-4a746f57e187', 'producto2', 1, '005', '2024-11-16 12:02:44.157605', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sub_categoria`
--

CREATE TABLE `sub_categoria` (
  `id` int NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `estado` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `tag` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `categoria_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `sub_categoria`
--

INSERT INTO `sub_categoria` (`id`, `created_at`, `estado`, `foto`, `nombre`, `tag`, `updated_at`, `categoria_id`) VALUES
(1, '2024-11-10 22:15:20.874475', 'Activo', '', 'aaaa', 'aaaaa', '2024-11-10 22:15:20.874475', 1),
(2, '2024-11-12 23:04:57.000000', 'Activo', NULL, 'categoria2', 'asdasd', '2024-11-12 23:05:08.000000', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `turno`
--

CREATE TABLE `turno` (
  `id` int NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `marca` varchar(255) DEFAULT NULL,
  `numero` varchar(255) DEFAULT NULL,
  `ra_social` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `voucher`
--

CREATE TABLE `voucher` (
  `id` int NOT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `metodo_pago` varchar(255) DEFAULT NULL,
  `numero` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `tipo` varchar(255) DEFAULT NULL,
  `total` double DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `cliente_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `voucher`
--

INSERT INTO `voucher` (`id`, `created_at`, `fecha`, `metodo_pago`, `numero`, `status`, `tipo`, `total`, `updated_at`, `cliente_id`) VALUES
(7, '2024-11-19 22:16:26.757652', '2024-11-19', 'paypal', 'VC000001', 'PA', 'TICKET DE COMPRA', 100, '2024-11-19 22:16:26.757652', 6),
(8, '2024-11-19 22:33:45.408825', '2024-11-19', 'paypal', 'VC000002', 'PA', 'TICKET DE COMPRA', 51, '2024-11-19 22:33:45.408825', 8),
(9, '2024-11-19 22:35:13.965391', '2024-11-19', 'paypal', 'VC000003', 'PA', 'TICKET DE COMPRA', 57, '2024-11-19 22:35:13.966401', 9),
(10, '2024-11-20 04:08:49.161080', '2024-11-19', 'paypal', 'VC000004', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 04:08:49.161080', 10),
(11, '2024-11-20 04:11:02.267421', '2024-11-19', 'paypal', 'VC000005', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 04:11:02.267421', 11),
(12, '2024-11-20 04:11:35.515420', '2024-11-19', 'paypal', 'VC000006', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 04:11:35.515420', 12),
(13, '2024-11-20 04:12:57.720323', '2024-11-19', 'paypal', 'VC000007', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 04:12:57.720323', 13),
(14, '2024-11-20 04:14:38.332522', '2024-11-19', 'paypal', 'VC000008', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 04:14:38.332522', 14),
(15, '2024-11-20 04:16:11.069199', '2024-11-19', 'paypal', 'VC000009', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 04:16:11.069199', 15),
(16, '2024-11-20 04:20:20.838522', '2024-11-19', 'paypal', 'VC000010', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 04:20:20.838522', 16),
(17, '2024-11-20 04:23:22.825436', '2024-11-19', 'paypal', 'VC000011', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 04:23:22.825436', 17),
(18, '2024-11-20 04:29:36.099428', '2024-11-19', 'paypal', 'VC000012', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 04:29:36.099428', 18),
(19, '2024-11-20 04:32:57.318526', '2024-11-19', 'paypal', 'VC000013', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 04:32:57.318526', 19),
(20, '2024-11-20 05:16:39.694235', '2024-11-19', 'paypal', 'VC000014', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 05:16:39.694235', 20),
(21, '2024-11-20 05:18:10.052721', '2024-11-19', 'paypal', 'VC000015', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 05:18:10.052721', 21),
(22, '2024-11-20 05:18:35.224012', '2024-11-19', 'paypal', 'VC000016', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 05:18:35.225014', 22),
(23, '2024-11-20 05:21:33.705964', '2024-11-19', 'paypal', 'VC000017', 'PA', 'TICKET DE COMPRA', 50, '2024-11-20 05:21:33.705964', 23),
(24, '2024-11-20 05:30:14.607148', '2024-11-19', 'paypal', 'VC000018', 'PA', 'TICKET DE COMPRA', 51, '2024-11-20 05:30:14.607148', 24),
(25, '2024-11-20 05:33:12.598212', '2024-11-19', 'paypal', 'VC000019', 'PA', 'TICKET DE COMPRA', 51, '2024-11-20 05:33:12.598212', 25),
(26, '2024-11-20 05:37:16.898535', '2024-11-19', 'paypal', 'VC000020', 'PA', 'TICKET DE COMPRA', 51, '2024-11-20 05:37:16.898535', 26),
(27, '2024-11-20 05:37:41.355891', '2024-11-19', 'paypal', 'VC000021', 'PA', 'TICKET DE COMPRA', 51, '2024-11-20 05:37:41.355891', 27),
(28, '2024-11-20 06:24:55.630168', '2024-11-19', 'paypal', 'VC000022', 'PA', 'TICKET DE COMPRA', 51, '2024-11-20 06:24:55.630168', 28),
(29, '2024-11-20 06:29:42.943122', '2024-11-19', 'paypal', 'VC000023', 'PA', 'TICKET DE COMPRA', 51, '2024-11-20 06:29:42.943122', 29),
(30, '2024-11-20 06:30:43.474233', '2024-11-19', 'paypal', 'VC000024', 'PA', 'TICKET DE COMPRA', 51, '2024-11-20 06:30:43.475228', 30),
(31, '2024-11-20 06:33:49.540372', '2024-11-19', 'paypal', 'VC000025', 'PA', 'TICKET DE COMPRA', 51, '2024-11-20 06:33:49.540372', 31),
(32, '2024-11-20 06:38:33.084138', '2024-11-19', 'paypal', 'VC000026', 'PA', 'TICKET DE COMPRA', 51, '2024-11-20 06:38:33.084138', 32),
(33, '2024-11-20 06:56:38.679808', '2024-11-19', 'paypal', 'VC000027', 'PA', 'TICKET DE COMPRA', 51, '2024-11-20 06:56:38.679808', 33),
(34, '2024-11-20 07:02:58.506298', '2024-11-19', 'paypal', 'VC000028', 'PA', 'TICKET DE COMPRA', 51, '2024-11-20 07:02:58.506298', 34);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `voucher_detail`
--

CREATE TABLE `voucher_detail` (
  `id` int NOT NULL,
  `cantidad` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `importe` varchar(255) DEFAULT NULL,
  `punitario` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `voucher_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `voucher_detail`
--

INSERT INTO `voucher_detail` (`id`, `cantidad`, `created_at`, `descripcion`, `importe`, `punitario`, `updated_at`, `voucher_id`) VALUES
(8, '2', '2024-11-19 22:16:26.809071', 'chompa', '50.050.0', '50.0', '2024-11-19 22:16:26.809071', 7),
(9, '1', '2024-11-19 22:33:45.450804', 'producto2', '1.00', '1.0', '2024-11-19 22:33:45.450804', 8),
(10, '1', '2024-11-19 22:33:45.505472', 'chompa', '50.00', '50.0', '2024-11-19 22:33:45.505472', 8),
(11, '1', '2024-11-19 22:35:14.042709', 'chompa', '50.00', '50.0', '2024-11-19 22:35:14.042709', 9),
(12, '7', '2024-11-19 22:35:14.128351', 'producto2', '7.00', '1.0', '2024-11-19 22:35:14.128351', 9),
(13, '1', '2024-11-20 04:08:49.216839', 'chompa', '50.00', '50.0', '2024-11-20 04:08:49.216839', 10),
(14, '1', '2024-11-20 05:30:14.751233', 'chompa', '50.00', '50.0', '2024-11-20 05:30:14.751233', 24),
(15, '1', '2024-11-20 05:30:14.847855', 'producto2', '1.00', '1.0', '2024-11-20 05:30:14.847855', 24),
(16, '1', '2024-11-20 06:24:55.724699', 'chompa', '50.00', '50.0', '2024-11-20 06:24:55.724699', 28),
(17, '1', '2024-11-20 06:24:55.786328', 'producto2', '1.00', '1.0', '2024-11-20 06:24:55.786328', 28),
(18, '1', '2024-11-20 06:29:43.032822', 'chompa', '50.00', '50.0', '2024-11-20 06:29:43.032822', 29),
(19, '1', '2024-11-20 06:29:43.136244', 'producto2', '1.00', '1.0', '2024-11-20 06:29:43.136244', 29),
(20, '1', '2024-11-20 06:30:43.542635', 'chompa', '50.00', '50.0', '2024-11-20 06:30:43.542635', 30),
(21, '1', '2024-11-20 06:30:43.602469', 'producto2', '1.00', '1.0', '2024-11-20 06:30:43.602469', 30),
(22, '1', '2024-11-20 06:33:49.691616', 'chompa', '50.00', '50.0', '2024-11-20 06:33:49.691616', 31),
(23, '1', '2024-11-20 06:33:49.803012', 'producto2', '1.00', '1.0', '2024-11-20 06:33:49.803012', 31),
(24, '1', '2024-11-20 06:38:33.145677', 'chompa', '50.00', '50.0', '2024-11-20 06:38:33.145677', 32),
(25, '1', '2024-11-20 06:38:33.194356', 'producto2', '1.00', '1.0', '2024-11-20 06:38:33.194356', 32),
(26, '1', '2024-11-20 06:56:38.745420', 'chompa', '50.00', '50.0', '2024-11-20 06:56:38.745420', 33),
(27, '1', '2024-11-20 06:56:38.811775', 'producto2', '1.00', '1.0', '2024-11-20 06:56:38.811775', 33),
(28, '1', '2024-11-20 07:02:58.576103', 'chompa', '50.00', '50.0', '2024-11-20 07:02:58.576103', 34),
(29, '1', '2024-11-20 07:02:58.627757', 'producto2', '1.00', '1.0', '2024-11-20 07:02:58.627757', 34);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `entrega`
--
ALTER TABLE `entrega`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `imagen`
--
ALTER TABLE `imagen`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_producto_imagen` (`producto_id`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK4r0th2p0ohg6uqqfoamvdb3q6` (`sub_categoria_id`);

--
-- Indices de la tabla `sub_categoria`
--
ALTER TABLE `sub_categoria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKqyd18s33yesrwpl5mvk2uswtp` (`categoria_id`);

--
-- Indices de la tabla `turno`
--
ALTER TABLE `turno`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `voucher`
--
ALTER TABLE `voucher`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKnbvec12whov90qb9frx006u9l` (`cliente_id`);

--
-- Indices de la tabla `voucher_detail`
--
ALTER TABLE `voucher_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKq2bwpsy6xqko0o5oakc1lmj46` (`voucher_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de la tabla `empresa`
--
ALTER TABLE `empresa`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `entrega`
--
ALTER TABLE `entrega`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `imagen`
--
ALTER TABLE `imagen`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `sub_categoria`
--
ALTER TABLE `sub_categoria`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `turno`
--
ALTER TABLE `turno`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `voucher`
--
ALTER TABLE `voucher`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de la tabla `voucher_detail`
--
ALTER TABLE `voucher_detail`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `imagen`
--
ALTER TABLE `imagen`
  ADD CONSTRAINT `fk_producto_imagen` FOREIGN KEY (`producto_id`) REFERENCES `producto` (`id`);

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `FK4r0th2p0ohg6uqqfoamvdb3q6` FOREIGN KEY (`sub_categoria_id`) REFERENCES `sub_categoria` (`id`);

--
-- Filtros para la tabla `sub_categoria`
--
ALTER TABLE `sub_categoria`
  ADD CONSTRAINT `FKqyd18s33yesrwpl5mvk2uswtp` FOREIGN KEY (`categoria_id`) REFERENCES `categoria` (`id`);

--
-- Filtros para la tabla `voucher`
--
ALTER TABLE `voucher`
  ADD CONSTRAINT `FKnbvec12whov90qb9frx006u9l` FOREIGN KEY (`cliente_id`) REFERENCES `cliente` (`id`);

--
-- Filtros para la tabla `voucher_detail`
--
ALTER TABLE `voucher_detail`
  ADD CONSTRAINT `FKq2bwpsy6xqko0o5oakc1lmj46` FOREIGN KEY (`voucher_id`) REFERENCES `voucher` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
