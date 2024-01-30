<?php

$servername = "localhost";
$username = "root";
$password = "";
$database_name = "zestcons";

$conn = mysqli_connect($servername, $username, $password, $database_name);

$teachID = $_POST['teachID'];

$sql = "SELECT * 
        FROM student AS X
        JOIN
        student_profile AS Y
        ON X.student_id = Y.stud_id
        WHERE Y.stud_id = '$teachID'
        ";

$res = mysqli_query($conn, $sql);
$numrows = mysqli_num_rows($res);

if($numrows > 0){
    $obj = mysqli_fetch_object($res); //convert as object
    
    $return["fname"] = $obj -> name;
    $return["lname"] = $obj->last_name;
    $return["course"] = $obj->program;
    $return["section"] = $obj->section;
    $return["dob"] = $obj->dob;
    $return["about"] = $obj->about;
    
}
mysqli_close($conn);

echo json_encode($return);