-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 05-05-2025 a las 21:23:24
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
-- Base de datos: `auth`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int NOT NULL,
  `apellido_m` varchar(255) DEFAULT NULL,
  `apellido_p` varchar(255) DEFAULT NULL,
  `codigo` varchar(255) DEFAULT NULL,
  `confirm_password` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `dni` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `auth_user`
--

INSERT INTO `auth_user` (`id`, `apellido_m`, `apellido_p`, `codigo`, `confirm_password`, `created_at`, `dni`, `email`, `foto`, `name`, `password`, `role`, `updated_at`) VALUES
(1, 'no hay apellido m', 'no hay apellido p', 'no hay codigo', NULL, '2024-11-10 18:42:11.753766', 'no hay dni', 'adminccccc@gmail.com', 'https://firebasestorage.googleapis.com/v0/b/proyectoc6-3a55f.appspot.com/o/venta%2F1-no%20hay%20nombre.png?alt=media&token=3cb68b50-8cb8-4d59-9303-bc3616b8afa0', 'no hay nombre', '$2a$10$unsUJ0fMfXclKZVFFRfeu.UGvBJAPUhDfPTu8.D4I7QuCYpVRoOiG', 'user', '2024-11-19 12:57:36.399218'),
(2, 'Vargas', 'Yujra', '922167530', NULL, '2024-11-12 15:02:01.899195', '74349846', 'ginoyujra38@gmail.com', 'https://firebasestorage.googleapis.com/v0/b/proyectoc6-3a55f.appspot.com/o/venta%2F2-Guino%20Elvis%20.png?alt=media&token=7172c96b-40eb-494d-b803-a32beed7b190', 'Guino Elvis', '$2a$10$Z6u2WQ6il2fsG9Pcd6yEO.QhXE/JB2Bc/wCR83dmcFX4s9IzLkSTa', 'user', '2024-11-19 18:24:50.552646'),
(3, NULL, NULL, NULL, NULL, '2024-11-15 23:12:29.321494', NULL, 'usuario2@gmail.com', NULL, NULL, '$2a$10$CocK72RhH2j2a6abHVCKVeHnJEMX2h7R3d0n/F1dk5jMdXyTU2uOy', 'user', '2024-11-15 23:12:29.321494'),
(4, NULL, NULL, NULL, NULL, '2024-11-15 23:12:56.056029', NULL, 'usuario3@gmail.com', NULL, NULL, '$2a$10$zqGjZyqmucm89jtDM4oqtOCeGITnyyQ/TKwWjbrE17U.nBBP4GIFO', 'user', '2024-11-15 23:12:56.056029'),
(5, NULL, NULL, NULL, NULL, '2024-11-15 23:18:03.180780', NULL, 'usuario8@gmail.com', NULL, NULL, '$2a$10$auVxqhsJuAhpjMCL5ygXOe7W7JM7hUXurB6cLdQfxdeeQwD3Ffy9.', 'user', '2024-11-15 23:18:03.180780'),
(6, NULL, NULL, NULL, NULL, '2024-11-15 23:21:12.019257', NULL, 'usuario10@gmail.com', NULL, NULL, '$2a$10$PwlRBSjts8wLoMZfBwSApefV6ziDmO/s/Z5.6MWAVrHGIVd.wxHQi', 'user', '2024-11-15 23:21:12.019257'),
(7, NULL, NULL, NULL, NULL, '2024-11-15 23:25:40.906715', NULL, 'usuario20@gmail.com', NULL, NULL, '$2a$10$LHOFYgmbYpoDE38rI1a.eOrkvsAPKJdkGX/p41HScyIlpComxcp9W', 'user', '2024-11-15 23:25:40.906715'),
(8, NULL, NULL, NULL, NULL, '2024-11-29 03:10:54.386547', NULL, 'admin2@gmail.com', NULL, NULL, '$2a$10$Zy1tUximja4hNgP5L7I1wOobwsBDWNgscrCoOdAYw.9julpv9QOWe', 'user', '2024-11-29 03:10:54.386547'),
(9, NULL, NULL, NULL, NULL, '2025-05-05 15:18:59.374574', NULL, 'admin@gmail.com', NULL, NULL, '$2a$10$R0ueRlkwuMMVOvBbZqnXJuWglEJQS.hNyISuG6G/isUzAgJ3wjP1K', 'user', '2025-05-05 15:18:59.374574');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
