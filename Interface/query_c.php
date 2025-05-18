<?php
$username = 'user_test';
$password = 'mypass';
$connection_string = 'localhost/XE';

$conn = oci_connect($username, $password, $connection_string);

if (!$conn) {
    $e = oci_error();
    die("Connection error: " . htmlentities($e['message']));
}

$sql = "SELECT DISTINCT 
    p.nume AS nume_pilot,
    p.prenume AS prenume_pilot,
    i.nume AS nume_instructor,
    i.prenume AS prenume_instructor,
    pi.data_inceput AS data_start_pregatire
    FROM PILOT p
    JOIN LICENTA l ON p.id_pilot = l.id_pilot
    JOIN PILOT_INSTRUCTOR pi ON p.id_pilot = pi.id_pilot  
    JOIN INSTRUCTOR i ON pi.id_instructor = i.id_instructor
    WHERE l.tip_licenta = 'Licenta-A Internationala'
    AND i.salariu > 500000
    ORDER BY pi.data_inceput";

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
            <h3>Să se afișeze numele și prenumele piloților care au licență internațională tip A și sunt antrenați de instructori cu salariu peste 500000, împreună cu numele instructorilor lor și data de început a pregătirii.</h3>
            
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Nume pilot</th>
                            <th>Prenume pilot</th>
                            <th>Nume instructor</th>
                            <th>Prenume instructor</th>
                            <th>Data început</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        while ($row = oci_fetch_array($stmt, OCI_ASSOC)) {
                            $date = date_create_from_format('d-M-y', $row['DATA_START_PREGATIRE']);
                            $formatted_date = $date ? $date->format('Y-m-d') : $row['DATA_START_PREGATIRE'];
                        ?>
                            <tr>
                                <td><?php echo htmlspecialchars($row['NUME_PILOT']); ?></td>
                                <td><?php echo htmlspecialchars($row['PRENUME_PILOT']); ?></td>
                                <td><?php echo htmlspecialchars($row['NUME_INSTRUCTOR']); ?></td>
                                <td><?php echo htmlspecialchars($row['PRENUME_INSTRUCTOR']); ?></td>
                                <td><?php echo htmlspecialchars($formatted_date); ?></td>
                            </tr>
                        <?php
                        }
                        if (oci_num_rows($stmt) == 0) {
                            echo '<tr><td colspan="5">Nu au fost găsite rezultate.</td></tr>';
                        }
                        ?>
                    </tbody>
                </table>
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