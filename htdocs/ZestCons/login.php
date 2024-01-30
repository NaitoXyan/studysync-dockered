<?php 
    $servername="localhost";
    $username="root";
    $password="";
    $database_name="zestcons";

    
    $return["error"] = false;
    $return["message"] = "";
    $return["success"] = false;
    
    $conn=mysqli_connect($servername, $username, $password, $database_name);


    if(isset($_POST["username"]) && isset($_POST["password"])){
        //checking if there is POST data
 
        $username = $_POST["username"];
        $password = $_POST["password"];
 
        $username = mysqli_real_escape_string($conn, $username);
        //escape inverted comma query conflict from string
 
        $sql = "SELECT * FROM accounts  WHERE username = '$username'";
        //building SQL query
        $res = mysqli_query($conn, $sql);
        $numrows = mysqli_num_rows($res);
        //check if there is any row
        if($numrows > 0){
            //is there is any data with that username
            $obj = mysqli_fetch_object($res);
            //get row as object
            if($password == $obj->password){
                $return["success"] = true;
                if($obj->student_id){
                    $return["id"] = $obj->student_id;
                    $return["position"] = "student";
                }else{
                    $return["id"] = $obj->teacher_id;
                    $return["position"] = "teacher";
                }
            }else{
                $return["error"] = true;
                $return["message"] = "Your Password is Incorrect.";
            }
        }else{
            $return["error"] = true;
            $return["message"] = 'No username found.';
        }
   }else{
       $return["error"] = true;
       $return["message"] = 'Send all parameters.';
   }
 
   mysqli_close($conn);

   echo json_encode($return);