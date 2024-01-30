<?php

    $servername="localhost";
    $username="root";
    $password="";
    $database_name="zestcons";

    $ID = $_POST['teachID'];
    
    
    $conn=mysqli_connect($servername, $username, $password, $database_name);
    $sql = "SELECT * FROM accounts JOIN teacher ON accounts.teacher_id = teacher.teacher_id WHERE accounts.teacher_id = '$ID'";
    //building SQL query
    $res = mysqli_query($conn, $sql);
    $numrows = mysqli_num_rows($res);

    if($numrows > 0){
        $obj = mysqli_fetch_object($res); //convert as object
        
        $return["tID"] = $obj -> teacher_id;
        $return["name"] = $obj->name . " " . $obj->last_name;
        $return["email"] = $obj->email;
        $return["background"] = $obj->background;
        
    }

    
    mysqli_close($conn);

    
    echo json_encode($return);