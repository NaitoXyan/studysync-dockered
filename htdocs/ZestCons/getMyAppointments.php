<?php

$servername = "localhost";
$username = "root";
$password = "";
$database_name = "zestcons";

$conn = mysqli_connect($servername, $username, $password, $database_name);

$teachID = $_POST['teachID'];

$sql = "SELECT *, DATE_FORMAT(T.date, '%M %e, %Y') AS formatted_date
        FROM appointment_table AS A
        JOIN
        teacher_availability AS T ON A.avail_id = T.avail_id
        JOIN 
        student AS S ON A.student_id = S.student_id
        WHERE T.teacher_id = '$teachID'
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