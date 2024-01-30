<?php

$servername = "localhost";
$username = "root";
$password = "";
$database_name = "zestcons";

$conn = mysqli_connect($servername, $username, $password, $database_name);

$sql = "SELECT *, DATE_FORMAT(A.date, '%M %e, %Y') AS formatted_date
        FROM teacher_availability AS A
        JOIN teacher AS T ON A.teacher_id = T.teacher_id
        WHERE A.status = 'FREE'";

$result = mysqli_query($conn, $sql);

$arrayResult = array();

while ($row = mysqli_fetch_assoc($result)) {
    
    $row['date'] = $row['formatted_date'];
    unset($row['formatted_date']); 

    $arrayResult[] = $row;
}

mysqli_close($conn);

echo json_encode($arrayResult);