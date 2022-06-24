<?php 


include '../../config/connections/sqlconnect.php';

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
$company = $decoded_params['company'];




if($constatus){

    $arr_usuario = array();
    $sql = "
       
    SELECT 
    cast(cod_User as int) cod_User,
    str_NameUser,
    str_PassUser,
    cast(cod_Company as int) cod_Company,
    cast(cod_Person as int) cod_Person,
    cast(cod_List  as int) cod_List,
    cast(flg_State as int) flg_State,
    cast(Cod_TiAlmacen as int) cod_TiAlmacen
    FROM AUTENTICATION  
    WHERE  cod_Company = ".$company."

    ";

    $comprobacion = 0;
    $arr_autentication  = array();

    foreach ($conn->query($sql) as $row) {
     $arr = array(); 

     if(count($row) > 0){

     $arr['codUser'] = (int)$row['cod_User'];
     $arr['strNameUser'] = $row['str_NameUser'];
     $arr['strPassUser'] = $row['str_PassUser'];
     $arr['codCompany'] = (int)$row['cod_Company'];
     $arr['codPerson'] = (int)$row['cod_Person'];
     $arr['codList'] = (int)$row['cod_List'];
     $arr['flgState'] = (int)$row['flg_State'];
     $arr['strPosition'] = "";
     $arr['codTiAlmacen'] = (int)$row['cod_TiAlmacen'];

     $arr_autentication[] = $arr;

     }
    
    

    }

     echo json_encode($arr_autentication);

 
}
 ?>