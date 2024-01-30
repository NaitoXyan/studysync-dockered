<?php
$servername = "localhost";
$username = "root";
$password = "";
$database_name = "zestcons";

$conn = mysqli_connect($servername, $username, $password, $database_name);

if (!$conn) {
    die("Connection Failed: " . mysqli_connect_error());
}

if (isset($_POST['studID'], $_POST['availID'], $_POST['reason'])) {
    $studID = (int)$_POST['studID'];
    $availID = (int)$_POST['availID'];
    $reason = mysqli_real_escape_string($conn, $_POST['reason']);  // Sanitize the input

    $sql_query = "INSERT INTO teacher_pending_appointment (student_name, reason, student_id, avail_id) 
                VALUES (
                    (SELECT CONCAT(student.name, ' ', student.last_name) FROM student WHERE student.student_id = $studID),
                    '$reason',
                    $studID,
                    $availID
                )";

    if (mysqli_query($conn, $sql_query)) {
        echo "Data Successfully Inserted";
    } else {
        echo "Error: " . $sql_query . " " . mysqli_error($conn);
    }
} else {
    echo "Invalid or missing POST parameters";
}

mysqli_close($conn);
?>
