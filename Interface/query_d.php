<?php
$username = 'user_test';
$password = 'mypass';
$connection_string = 'localhost/XE';

$conn = oci_connect($username, $password, $connection_string);

if (!$conn) {
    $e = oci_error();
    die("Connection error: " . htmlentities($e['message']));
}

$sql = "SELECT i.nume, 
               i.prenume, 
               COUNT(DISTINCT pi.id_pilot) as numar_piloti, 
               TO_CHAR(i.salariu, '999,999.00') as salariu
        FROM INSTRUCTOR i 
        JOIN PILOT_INSTRUCTOR pi ON i.id_instructor = pi.id_instructor
        GROUP BY i.id_instructor, i.nume, i.prenume, i.salariu
        HAVING COUNT(DISTINCT pi.id_pilot) > 2 
        AND i.salariu > (SELECT AVG(salariu) FROM INSTRUCTOR)
        ORDER BY numar_piloti DESC";

$stmt = oci_parse($conn, $sql);
oci_execute($stmt);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complex Query Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Cambria', sans-serif;
            background-image: url('INDEX_BG.jpg');
            background-color: #f4f4f4;
            margin: 0;
            background-size: cover;
            background-position: center;
            background-position-y: 5%;
            background-repeat: no-repeat;
        }

        .navbar {
            background-color: #343a40;
            padding: 10px;
            text-align: center;
            color: #fff;
        }

        .navbar a {
            color: #fff;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }

        .navbar a:hover {
            background-color: #0056b3;
        }

        #content {
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            margin-top: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #343a40;
            color: #000;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="connect.php">Back to Tables</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div id="content">
            <h3>Să se afișeze instructorii care au pregătit mai mult de 2 piloți și au un salariu peste medie, afișând numele instructorului, numărul de piloți pregătiți și salariul acestuia</h3>
            
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Nume instructor</th>
                            <th>Prenume instructor</th>
                            <th>Numar piloți</th>
                            <th>Salariu</th>
                        </tr>
                    </thead>
                    <tbody>
    <?php
    while ($row = oci_fetch_array($stmt, OCI_ASSOC)) {
    ?>
        <tr>
            <td><?php echo htmlspecialchars($row['NUME']); ?></td>
            <td><?php echo htmlspecialchars($row['PRENUME']); ?></td>
            <td><?php echo htmlspecialchars($row['NUMAR_PILOTI']); ?></td>
            <td><?php echo htmlspecialchars($row['SALARIU']); ?></td>
        </tr>
    <?php
    }
    if (oci_num_rows($stmt) == 0) {
        echo '<tr><td colspan="4">Nu au fost găsite rezultate.</td></tr>';
    }
    ?>
    </tbody>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
    </html>

    <?php
    oci_free_statement($stmt);
    oci_close($conn);
    ?>