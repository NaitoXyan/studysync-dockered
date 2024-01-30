<?php

$servername = "localhost";
$username = "root";
$password = "";
$database_name = "zestcons";

$conn = mysqli_connect($servername, $username, $password, $database_name);

$ID = $_POST['ID'];

$sql = "DELETE FROM teacher_availability 
        WHERE avail_id = '$ID'
        ";

if (mysqli_query($conn, $sql)) {
    echo "Deleted Successfully";
} else {
    echo "Error: " . $sql . " " . mysqli_error($conn);
}

mysqli_close($conn);