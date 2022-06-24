<?php  
include '../../config/connections/sqlconnect.php';

$usuario = "";
if(isset($_GET['codUser'])){

  $usuario = trim($_GET['codUser']);

}else{

    return false;
}



if($constatus){



    $arr_config = array();
    $sql = "
       
	 SELECT 
     codconfigGeneral,
     strCodOperation,
     strDescription,
     flgEnabled,
     pivot1,
     pivot2,
     pivote3 pivot3,
     codUser,
     flg_sync
     FROM Conf_General  
     WHERE  codUser = ".$usuario." and flg_sync = 1
    ";

    
    //$arr_customer  = array();

    foreach ($conn->query($sql) as $row) {
     $arr = array(); 

     $arr['codconfigGeneral'] = (int)$row['codconfigGeneral'];
     $arr['strCodOperation'] = $row['strCodOperation'];
     $arr['strCodOperation'] = $row['strCodOperation'];
     $arr['flgEnabled'] = (int)$row['flgEnabled'];
     $arr['pivot1'] = $row['pivot1'];
     $arr['pivot2'] = $row['pivot2'];
     $arr['pivot3'] = $row['pivot3'];
    
     $arr['codUser'] = (int)$row['codUser'];
     $arr['flgSync'] = (int)$row['flg_sync'];
    // $arr['PASS'] = $row['PASS'];

     $arr_config[] = $arr;

    

    }

     echo json_encode($arr_config); 




}



?>