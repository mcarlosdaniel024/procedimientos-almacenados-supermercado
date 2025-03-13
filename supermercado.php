<?php
$servername = "localhost";
$username = "root";
$password = "";
$database = "supermercado-clase";

$conn = new mysqli($servername, $username, $password, $database);

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}

function ejecutarProcedimiento($conn, $query) {
    $resultados = [];
    if ($conn->multi_query($query)) {
        do {
            if ($result = $conn->store_result()) {
                $resultados = $result->fetch_all(MYSQLI_ASSOC);
                $result->free();
            }
        } while ($conn->more_results() && $conn->next_result());
    }
    return $resultados;
}

$accion = $_POST['accion'] ?? '';
$resultado = [];

if ($accion) {
    switch ($accion) {
        case "agotados":
            $resultado = ejecutarProcedimiento($conn, "CALL NumeroProductosAgotados()");
            break;
        case "disponibles":
            $resultado = ejecutarProcedimiento($conn, "CALL NumeroProductosDisponibles()");
            break;
        case "listaAgotados":
            $resultado = ejecutarProcedimiento($conn, "CALL obtenerProductosAgotados()");
            break;
        case "listaDisponibles":
            $resultado = ejecutarProcedimiento($conn, "CALL ObtenerProductosDisponibles()");
            break;
        case "totalProductos":
            $resultado = ejecutarProcedimiento($conn, "CALL TotalProductos()");
            break;
        case "agregarProducto":
            $id = $_POST['id'] ?? 0;
            $nombre = $_POST['nombre'] ?? '';
            $estado = $_POST['estado'] ?? 'disponible';
            $precio = $_POST['precio'] ?? 0;

            $stmt = $conn->prepare("CALL AgregarProducto(?, ?, ?, ?)");
            $stmt->bind_param("issi", $id, $nombre, $estado, $precio);

            if ($stmt->execute()) {
                echo "<p>Producto agregado con éxito.</p>";
            } else {
                echo "<p>Error al agregar producto: " . $stmt->error . "</p>";
            }
            $stmt->close();
            break;
        case "eliminarProducto":
            $id = $_POST['id'] ?? 0;

            $stmt = $conn->prepare("CALL EliminarProducto(?)");
            $stmt->bind_param("i", $id);

            if ($stmt->execute()) {
                echo "<p>Producto eliminado con éxito.</p>";
            } else {
                echo "<p>Error al eliminar producto: " . $stmt->error . "</p>";
            }
            $stmt->close();
            break;
        case "cambiarEstado":
            $id = $_POST['id'] ?? 0;

            $stmt = $conn->prepare("CALL CambiarEstadoProducto(?)");
            $stmt->bind_param("i", $id);

            if ($stmt->execute()) {
                echo "<p>Estado del producto actualizado con éxito.</p>";
            } else {
                echo "<p>Error al actualizar estado del producto: " . $stmt->error . "</p>";
            }
            $stmt->close();
            break;
        case "cambiarPrecio":
            $id = $_POST['id'] ?? 0;
            $nuevo_precio = $_POST['nuevo_precio'] ?? 0;

            $stmt = $conn->prepare("CALL CambiarPrecioProducto(?, ?)");
            $stmt->bind_param("id", $id, $nuevo_precio);

            if ($stmt->execute()) {
                echo "<p>Precio actualizado con éxito.</p>";
            } else {
                echo "<p>Error al actualizar precio: " . $stmt->error . "</p>";
            }
            $stmt->close();
            break;
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Procedimientos Almacenados</title>
</head>
<body>
    <h1>Procedimientos Almacenados</h1>
    <form method="POST">
        <button name="accion" value="agotados">Productos Agotados</button>
        <button name="accion" value="disponibles">Productos Disponibles</button>
        <button name="accion" value="listaAgotados">Lista de Productos Agotados</button>
        <button name="accion" value="listaDisponibles">Lista de Productos Disponibles</button>
        <button name="accion" value="totalProductos">Total de Productos</button>
    </form>
    <br>

    <h2>Agregar Producto</h2>
    <form method="POST">
        <input type="hidden" name="accion" value="agregarProducto">
        <label>ID: <input type="number" name="id" required></label><br>
        <label>Nombre: <input type="text" name="nombre" required></label><br>
        <label>Estado: 
            <select name="estado">
                <option value="disponible">Disponible</option>
                <option value="agotado">Agotado</option>
            </select>
        </label><br>
        <label>Precio: <input type="number" step="0.01" name="precio" required></label><br>
        <button type="submit">Agregar Producto</button>
    </form>

    <br>

    <h2>Eliminar Producto</h2>
    <form method="POST">
        <input type="hidden" name="accion" value="eliminarProducto">
        <label>ID del Producto: <input type="number" name="id" required></label><br>
        <button type="submit">Eliminar Producto</button>
    </form>

    <br>

    <h2>Cambiar Estado del Producto</h2>
    <form method="POST">
        <input type="hidden" name="accion" value="cambiarEstado">
        <label>ID del Producto: <input type="number" name="id" required></label><br>
        <button type="submit">Cambiar Estado</button>
    </form>

    <br>

    <h2>Cambiar Precio de un Producto</h2>
    <form method="POST">
        <input type="hidden" name="accion" value="cambiarPrecio">
        <label>ID del Producto: <input type="number" name="id" required></label><br>
        <label>Nuevo Precio: <input type="number" step="0.01" name="nuevo_precio" required></label><br>
        <button type="submit">Actualizar Precio</button>
    </form>

    <br>

    <?php if (!empty($resultado)): ?>
        <h2>Resultado</h2>
        <ul>
            <?php foreach ($resultado as $row): ?>
                <li><?php echo implode(" - ", $row); ?></li>
            <?php endforeach; ?>
        </ul>
    <?php endif; ?>
</body>
</html>

<?php
$conn->close();
?>
