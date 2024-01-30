<?php

$servername = "localhost";
$username = "root";
$password = "";
$database_name = "zestcons";

$conn = mysqli_connect($servername, $username, $password, $database_name);

$pendID = (int)$_POST['pendID'];
$details = $_POST['details'];

$sql = "CALL acceptAppointment($pendID, '$details')";

if (mysqli_query($conn, $sql)) {
    echo "Data Successfully Inserted";
} 
 else {
    echo "Invalid or missing POST parameters";
}

mysqli_close($conn);


