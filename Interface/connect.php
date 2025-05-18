<?php
$username = 'user_test';
$password = 'mypass';
$connection_string = 'localhost/XE';
$conn = oci_connect($username, $password, $connection_string);

if (!$conn) {
    $e = oci_error();
    die("Connection error: " . htmlentities($e['message']));
}

function getPrimaryKey($conn, $table) {
    $sql = "SELECT cols.column_name
            FROM all_constraints cons, all_cons_columns cols
            WHERE cols.table_name = :table_name
            AND cons.constraint_type = 'P'
            AND cons.constraint_name = cols.constraint_name
            AND cons.owner = cols.owner
            AND cons.owner = USER";
    
    $stmt = oci_parse($conn, $sql);
    oci_bind_by_name($stmt, ":table_name", $table);
    oci_execute($stmt);
    $row = oci_fetch_array($stmt, OCI_ASSOC);
    return $row ? $row['COLUMN_NAME'] : null;
}

$sql = "SELECT table_name FROM user_tables ORDER BY table_name";
$stmt = oci_parse($conn, $sql);
oci_execute($stmt);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Academie de Karting</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Cambria', sans-serif;
            background-image: url('INDEX_BG.jpg');
            background-color: #f4f4f4;
            margin: 0;
            background-size: cover;
            background-position: center;
            background-position-y:5%;
            background-repeat: no-repeat;
        }
        table { 
            width: 100%;
            margin-top: 20px;
            background: white;
        }
        th, td { 
            padding: 8px;
            text-align: left;
        }
        .nav-item {
            margin: 0 10px;
        }
        .select-table {
            margin: 20px 0;
        }
        .container {
            background: rgba(255, 255, 255, 0.95);
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
            max-width: 95%;
            width: 95%;
        }
        th a {
    text-decoration: none;
        }
        th a:hover {
            text-decoration: none;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Selectați un tabel
                        </a>
                        <ul class="dropdown-menu">
                            <?php
                            while ($row = oci_fetch_array($stmt, OCI_ASSOC)) {
                                echo "<li><a class='dropdown-item' href='?table={$row['TABLE_NAME']}'>{$row['TABLE_NAME']}</a></li>";
                            }
                            ?>
                        </ul>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="query_c.php">Cerere</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="query_d.php">Cerere funcții grup</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="query_f_compusa.php">Vizualizare compusă </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="query_f_complexa.php">Vizualizare Complexă</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <?php
        if (isset($_GET['table'])) {
            $table = strtoupper($_GET['table']);
            $primary_key = getPrimaryKey($conn, $table);

            if (isset($_GET['delete'])) {
                $id = $_GET['delete'];
                $delete_sql = "DELETE FROM $table WHERE $primary_key = :id";
                $delete_stmt = oci_parse($conn, $delete_sql);
                oci_bind_by_name($delete_stmt, ":id", $id);
                oci_execute($delete_stmt);
                oci_commit($conn);
            }
            if (isset($_POST['edit'])) {
                $updates = [];
                $bind_params = [];
                
                $types_sql = "SELECT column_name, data_type 
                            FROM user_tab_columns 
                            WHERE table_name = :table_name";
                $types_stmt = oci_parse($conn, $types_sql);
                oci_bind_by_name($types_stmt, ":table_name", $table);
                oci_execute($types_stmt);
                
                $column_types = [];
                while ($row = oci_fetch_array($types_stmt, OCI_ASSOC)) {
                    $column_types[$row['COLUMN_NAME']] = $row['DATA_TYPE'];
                }
                
                foreach ($_POST as $key => $value) {
                    if ($key != 'edit' && $key != $primary_key) {
                        if ($value === '') {
                            $updates[] = "$key = NULL";
                        } else {
                            if ($column_types[$key] == 'DATE' && $value) {
                                $updates[] = "$key = TO_DATE(:$key, 'YYYY-MM-DD')";
                                $bind_params[$key] = $value;
                            } else {
                                $updates[] = "$key = :$key";
                                $bind_params[$key] = $value;
                            }
                        }
                    }
                }
                
                if (!empty($updates)) {
                    $sql = "UPDATE $table SET " . implode(', ', $updates) . " WHERE $primary_key = :id";
                    $stmt = oci_parse($conn, $sql);
                    
                    foreach ($bind_params as $key => $value) {
                        oci_bind_by_name($stmt, ":$key", $bind_params[$key]);
                    }
                    oci_bind_by_name($stmt, ":id", $_POST[$primary_key]);
                    
                    $execute_result = oci_execute($stmt);
                    if (!$execute_result) {
                        $e = oci_error($stmt);
                        echo "Error: " . htmlentities($e['message']);
                    } else {
                        oci_commit($conn);
                    }
                }
            }
            $columns_sql = "SELECT column_name, data_type 
                           FROM user_tab_columns 
                           WHERE table_name = :table_name 
                           ORDER BY column_id";
            $columns_stmt = oci_parse($conn, $columns_sql);
            oci_bind_by_name($columns_stmt, ":table_name", $table);
            oci_execute($columns_stmt);
            
            $columns = [];
            $column_types = [];
            while ($row = oci_fetch_array($columns_stmt, OCI_ASSOC)) {
                $columns[] = $row['COLUMN_NAME'];
                $column_types[$row['COLUMN_NAME']] = $row['DATA_TYPE'];
            }

            $sort = isset($_GET['sort']) ? $_GET['sort'] : $columns[0];
            $order = isset($_GET['order']) ? $_GET['order'] : 'ASC';
            
            $sql = "SELECT * FROM $table ORDER BY $sort $order";
            $stmt = oci_parse($conn, $sql);
            oci_execute($stmt);
            
            echo "<h2>$table</h2>";
            echo "<table class='table table-striped'>";
            echo "<thead><tr>";
            foreach ($columns as $column) {
                $sort_url = "?table=$table&sort=$column&order=" . ($sort == $column && $order == 'ASC' ? 'DESC' : 'ASC');
                echo "<th><a href='$sort_url' class='text-dark'>$column";
                if ($sort == $column) {
                    echo $order == 'ASC' ? ' ↑' : ' ↓';
                }
                echo "</a></th>";
            }
            echo "<th>Actions</th></tr></thead>";
            
            echo "<tbody>";
            while ($row = oci_fetch_array($stmt, OCI_ASSOC)) {
                echo "<tr>";
                echo "<form method='post'>";
                
                foreach ($columns as $column) {
                    echo "<td>";
                    if ($column == $primary_key) {
                        echo "<input type='hidden' name='$column' value='" . htmlspecialchars($row[$column]) . "'>";
                        echo htmlspecialchars($row[$column]);
                    } else {
                        $value = isset($row[$column]) ? $row[$column] : '';
                        if ($column_types[$column] == 'DATE' && $value) {
                            $date = date_create_from_format('d-M-y', $value);
                            $value = $date ? $date->format('Y-m-d') : '';
                        }
                        if ($column_types[$column] == 'DATE') {
                            echo "<input type='date' class='form-control' name='$column' value='" . htmlspecialchars($value) . "'>";
                        } else {
                            echo "<input type='text' class='form-control' name='$column' value='" . htmlspecialchars($value) . "'>";
                        }
                    }
                    echo "</td>";
                }
                
                echo "<td>";
                echo "<button type='submit' name='edit' class='btn btn-primary btn-sm'>Update</button> ";
                echo "<a href='?table=$table&delete={$row[$primary_key]}' class='btn btn-danger btn-sm' onclick='return confirm(\"Sunteți sigur?\")'>Delete</a>";
                echo "</td>";
                echo "</form>";
                echo "</tr>";
            }
            echo "</tbody></table>";
        }
        ?>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<?php
oci_close($conn);
?>