<?php
$username = 'user_test';
$password = 'mypass';
$connection_string = 'localhost/XE';

$conn = oci_connect($username, $password, $connection_string);

if (!$conn) {
    $e = oci_error();
    die("Connection error: " . htmlentities($e['message']));
}

$create_view = "CREATE OR REPLACE VIEW v_pilot_echipament AS
    SELECT p.id_pilot,
           p.nume,
           p.prenume,
           p.numar_competitie,
           e.tip as tip_echipament,
           e.marime,
           e.data_achizitie
    FROM PILOT p
    JOIN ECHIPAMENT e ON p.id_pilot = e.id_pilot";

$stmt = oci_parse($conn, $create_view);
oci_execute($stmt);

$sql = "SELECT * FROM v_pilot_echipament ORDER BY id_pilot";
$stmt = oci_parse($conn, $sql);
oci_execute($stmt);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Vizualizare Compusă - Piloți și Echipamente</title>
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
        <h3>Să se afișeze toți piloții, împreună cu echipamentele lor.</h3>
        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nume</th>
                        <th>Prenume</th>
                        <th>Număr competiție</th>
                        <th>Tip echipament</th>
                        <th>Mărime</th>
                        <th>Data achiziție</th>
                    </tr>
                </thead>
                <tbody>
                <?php
                while ($row = oci_fetch_array($stmt, OCI_ASSOC)) {
                    $date = date_create_from_format('d-M-y', $row['DATA_ACHIZITIE']);
                    $formatted_date = $date ? $date->format('Y-m-d') : $row['DATA_ACHIZITIE'];
                    echo "<tr>";
                    echo "<td>" . htmlspecialchars($row['ID_PILOT']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['NUME']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['PRENUME']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['NUMAR_COMPETITIE']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['TIP_ECHIPAMENT']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['MARIME']) . "</td>";
                    echo "<td>" . htmlspecialchars($formatted_date) . "</td>";
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