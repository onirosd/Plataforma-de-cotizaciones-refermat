<?php

include '../../config/config.php';
//echo BASE_URL.'controller/functions/CustomerDb.php';

//require_once(__DIR__.'/controller/functions/CustomerDb.php');
//include $_SERVER['DOCUMENT_ROOT']
//include BASE_URL.'controller/functions/CustomerDb.php';
//include '../functions/CustomerDb.php';
//require_once ( '../functions/CustomerDb.php');
//require_once ( 'config/connections/sqlconnect.php');
//include '../functions/CustomerDb.php';
require '../../config/connections/sqlconnect.php';

 $errordescription = '';
 $code_error  = 1;
 $json_params = file_get_contents("php://input");
 $num_inserts = 0;


function isValidJSON($str) {
    $valid = false;
    json_decode($str);
    if (json_last_error() == 0) {
        $valid  = true;
    }

    return $valid;
   // return json_last_error() == JSON_ERROR_NONE;
 }

 

 if(!$constatus){
    $errordescription = 'No se tiene conexion a la BD der servicio.';
    $code_error = 0;
 }

 if(!isValidJSON($json_params) || strlen($json_params) == 0){
    $errordescription = 'Error al enviar los registros al servidor.';
    $code_error = 0;
}

if($code_error == 0){
    echo json_encode(['error' => $code_error , 'description' => $errordescription ,  'cant'=> 0]);
    return false;
}


$decoded_params = (array) json_decode(json_decode($json_params));
$user = $decoded_params['user'];


$arr_consult = array(); 
$sql_consult = "
      
SELECT 
str_Descripcion AS strDescription,
str_Value AS strValue,
cod_User AS codUser
FROM Ti_IndicatorsUser
WHERE  cod_User = ".$user."

   ";



foreach ($conn->query($sql_consult) as $row) {
 $arr = array(); 

 if(count($row) > 0){

 $arr['strDescription'] = (String)$row['strDescription'];
 $arr['strValue'] = (String)$row['strValue'];
 $arr['codUser']        = (int)$row['codUser'];


 $arr_consult[] = $arr;

 }



}

 echo json_encode($arr_consult);



?>