<?php 
  
  $conn       = "";
  $constatus  = true;
  $server     = "sql5092.site4now.net";
  $port       = "1433";
  $bd         = "db_a2e5d1_qarefermatapp";
  $user       = "db_a2e5d1_qarefermatapp_admin";
  $pass       = "uu@ZXMT2H6gCrAX";

try {

    $conn = new PDO("sqlsrv:server = $server,$port; Database = $bd", "$user", "$pass");
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
   
    }
    catch (PDOException $e) {
    $constatus = false;
    echo  $e;
    //$arr_productos['estado']   = false; 
}


?>