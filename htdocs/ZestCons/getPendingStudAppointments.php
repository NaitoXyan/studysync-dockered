<?php

$servername = "localhost";
$username = "root";
$password = "";
$database_name = "zestcons";

$conn = mysqli_connect($servername, $username, $password, $database_name);

$ID = $_POST['teachID'];

$sql = "SELECT *, DATE_FORMAT(Y.date, '%M %e, %Y') AS formatted_date
        FROM teacher_pending_appointment AS X
        JOIN
        teacher_availability AS Y
        ON X.avail_id = Y.avail_id
        JOIN
        teacher ON teacher.teacher_id = Y.teacher_id
        WHERE X.student_id = '$ID'
        ";

$result = mysqli_query($conn, $sql);

$arrayResult = array();

while ($row = mysqli_fetch_assoc($result)) {
    
    $row['date'] = $row['formatted_date'];
    unset($row['formatted_date']); 

    $arrayResult[] = $row;
}

mysqli_close($conn);

echo json_encode($arrayResult);