-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-03-2025 a las 05:33:36
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `supermercado-clase`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AgregarProducto` (IN `p_id` INT, IN `p_nombre` VARCHAR(50), IN `p_estado` VARCHAR(20), IN `p_precio` FLOAT)   BEGIN
    INSERT INTO productos (id, nombre, estado, precio)
    VALUES (p_id, p_nombre, p_estado, p_precio);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CambiarEstadoProducto` (IN `p_id` INT)   BEGIN
    DECLARE v_estado_actual VARCHAR(20);

    -- Obtener el estado actual del producto
    SELECT estado INTO v_estado_actual FROM productos WHERE id = p_id;

    -- Cambiar el estado
    IF v_estado_actual = 'disponible' THEN
        UPDATE productos SET estado = 'agotado' WHERE id = p_id;
    ELSE
        UPDATE productos SET estado = 'disponible' WHERE id = p_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CambiarPrecioProducto` (IN `p_id` INT, IN `p_nuevo_precio` DECIMAL(10,2))   BEGIN
    -- Verificar si el producto existe
    IF EXISTS (SELECT 1 FROM productos WHERE id = p_id) THEN
        -- Actualizar el precio del producto
        UPDATE productos SET precio = p_nuevo_precio WHERE id = p_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EliminarProducto` (IN `p_id` INT)   BEGIN
    DELETE FROM productos WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NumeroProductosAgotados` ()   BEGIN
    SELECT COUNT(*) AS total_agotados
    FROM productos
    WHERE estado = 'agotado';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `NumeroProductosDisponibles` ()   BEGIN
    SELECT COUNT(*) AS total_disponibles 
    FROM productos 
    WHERE estado = 'disponible';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerProductosAgotados` ()   BEGIN
    SELECT * FROM productos WHERE estado = 'agotado';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerProductosDisponibles` ()   BEGIN
    SELECT id, nombre, precio
    FROM productos 
    WHERE estado = 'disponible';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObtenerProductosOrdenadosPorPrecio` ()   BEGIN
    SELECT id, nombre, estado, precio 
    FROM productos 
    ORDER BY precio DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtenerProductosPorEstado` (IN `nombre_estado` VARCHAR(255))   BEGIN SELECT * FROM productos WHERE estado =
nombre_estado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TotalProductos` ()   BEGIN
    SELECT COUNT(*) AS total FROM productos;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `estado` varchar(20) NOT NULL DEFAULT 'disponible',
  `precio` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `nombre`, `estado`, `precio`) VALUES
(1, 'producto a', 'disponible', 3),
(2, 'producto b', 'disponible', 4),
(3, 'producto c', 'agotado', 7),
(4, 'producto d', 'disponible', 7),
(5, 'producto e', 'agotado', 5),
(6, 'producto f', 'disponible', 2),
(7, 'producto g', 'disponible', 2000),
(8, 'producto h', 'agotado', 4),
(9, 'producto i', 'disponible', 3),
(10, 'producto j', 'disponible', 2),
(11, 'producto k', 'disponible', 7),
(20, 'producto z', 'disponible', 5000),
(30, 'producto 12', 'disponible', 4300);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
