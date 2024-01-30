<?php
$servername = "localhost";
$username = "root";
$password = "";
$database_name = "zestcons";

$conn = mysqli_connect($servername, $username, $password, $database_name);

if (!$conn) {
    die("Connection Failed: " . mysqli_connect_error());
}

$ID = mysqli_real_escape_string($conn, $_POST['ID']);
$date = mysqli_real_escape_string($conn, $_POST['date']);
$time = mysqli_real_escape_string($conn, $_POST['time']);



    $sql_query = "INSERT INTO teacher_availability (date, time, teacher_id) 
                VALUES (
                    '$date',
                    '$time',
                    '$ID'
                )";

    if (mysqli_query($conn, $sql_query)) {
        echo "Data Successfully Inserted";
    } else {
        echo "Error: " . $sql_query . " " . mysqli_error($conn);
    }


mysqli_close($conn);

