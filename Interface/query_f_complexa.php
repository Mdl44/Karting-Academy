<?php
$username = 'user_test';
$password = 'mypass';
$connection_string = 'localhost/XE';

$conn = oci_connect($username, $password, $connection_string);

if (!$conn) {
    $e = oci_error();
    die("Connection error: " . htmlentities($e['message']));
}

$create_view = "CREATE OR REPLACE VIEW v_instructor_statistici AS
SELECT 
    i.id_instructor,
    i.nume,
    i.prenume,
    COUNT(DISTINCT pi.id_pilot) as total_piloti,
    COUNT(DISTINCT l_normal.id_pilot) as piloti_licenta_normala,
    COUNT(DISTINCT l_intl.id_pilot) as piloti_licenta_internationala,
    ROUND(COUNT(DISTINCT l_normal.id_pilot) * 100.0 / NULLIF(COUNT(DISTINCT pi.id_pilot), 0), 2) as rata_succes_normal,
    ROUND(COUNT(DISTINCT l_intl.id_pilot) * 100.0 / NULLIF(COUNT(DISTINCT pi.id_pilot), 0), 2) as rata_succes_international
    FROM INSTRUCTOR i
    LEFT JOIN PILOT_INSTRUCTOR pi ON i.id_instructor = pi.id_instructor
    LEFT JOIN LICENTA l_normal ON pi.id_pilot = l_normal.id_pilot 
        AND l_normal.tip_licenta IN ('Licenta-A', 'Licenta-B')
        AND l_normal.data_eliberare > pi.data_inceput
    LEFT JOIN LICENTA l_intl ON pi.id_pilot = l_intl.id_pilot 
        AND l_intl.tip_licenta IN ('Licenta-A Internationala', 'Licenta-B Internationala')
        AND l_intl.data_eliberare > pi.data_inceput
    GROUP BY i.id_instructor, i.nume, i.prenume
    HAVING COUNT(DISTINCT pi.id_pilot) > 0
    ORDER BY rata_succes_international DESC";

$stmt = oci_parse($conn, $create_view);
oci_execute($stmt);

// Query the view
$sql = "SELECT * FROM v_instructor_statistici";
$stmt = oci_parse($conn, $sql);
oci_execute($stmt);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Vizualizare Complexă - Statistici Instructori</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-image: url('INDEX_BG.jpg'); background-size: cover; }
        .container { background-color: rgba(255, 255, 255, 0.9); padding: 20px; margin-top: 20px; border-radius: 8px; }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <div class="collapse navbar-collapse justify-content-center">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="connect.php">Back to Tables</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <h3>Să se afișeze pentru fiecare instructor următoarele statistici: numărul de piloți instruiți, numărul de piloți care au obținut licențe normale, numărul de piloți care au obținut licențe internaționale, rata de succes pentru licența normală și rata de succes pentru licența internațională.</h3>
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID Instructor</th>
                        <th>Nume</th>
                        <th>Prenume</th>
                        <th>Total Piloți</th>
                        <th>Piloți cu Licență Normală</th>
                        <th>Piloți cu Licență Internațională</th>
                        <th>Rată Succes Normal (%)</th>
                        <th>Rată Succes Internațional (%)</th>
                    </tr>
                </thead>
                <tbody>
                <?php
                while ($row = oci_fetch_array($stmt, OCI_ASSOC)) {
                    echo "<tr>";
                    echo "<td>" . htmlspecialchars($row['ID_INSTRUCTOR']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['NUME']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['PRENUME']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['TOTAL_PILOTI']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['PILOTI_LICENTA_NORMALA']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['PILOTI_LICENTA_INTERNATIONALA']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['RATA_SUCCES_NORMAL']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['RATA_SUCCES_INTERNATIONAL']) . "</td>";
                    echo "</tr>";
                }
                ?>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<?php
oci_free_statement($stmt);
oci_close($conn);
?>