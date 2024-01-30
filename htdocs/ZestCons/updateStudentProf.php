<?php

$servername = "localhost";
$username = "root";
$password = "";
$database_name = "zestcons";

$conn = mysqli_connect($servername, $username, $password, $database_name);

$studID = $_POST['ID'];
$fname = $_POST['firstName'];
$lname = $_POST['lastName'];
$course = $_POST['course'];
$section = $_POST['section'];
$dob = $_POST['dob'];
$about = $_POST['about'];

$sql = "UPDATE student AS S
        JOIN
        student_profile AS P
        ON S.student_id = P.stud_id
        SET S.name = '$fname',
        S.last_name = '$lname',
        S.program = '$course',
        P.section = '$section',
        P.dob = '$dob',
        P.about = '$about'
        WHERE P.stud_id = '$studID'
        ";

if (mysqli_query($conn, $sql)) {
    echo "Data Successfully Inserted";
} else {
    echo "Error: " . $sql . " " . mysqli_error($conn);
}

mysqli_close($conn);