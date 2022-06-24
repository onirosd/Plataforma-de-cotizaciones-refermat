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
$empresa = (String) $decoded_params['codEmpresa'];

// print_r($empresa);

//echo $empresa;

if($constatus){


    $arr_usuario = array();
    $sql = "
       
	 SELECT 
     cod_Customer codCustomer,
     num_RucCustomer numRucCustomer,
     num_RucCustomer numRut,
     str_Name strName,
     str_Celphone strCelphone,
     str_Mail strMail,
     str_Address strAddress,
     cod_TiCustomer codTiCustomer,
     cod_Company codCompany,
     1 asyncFlag
     FROM CUSTOMER  
     where cod_Company = ".$empresa;


    $comprobacion = 0;
    
    $arr_customer  = array();

    foreach ($conn->query($sql) as $row) {
     $arr = array(); 

     if(count($row) > 0){

     $arr['codCustomer'] = $row['codCustomer'];
     $arr['numRucCustomer'] = $row['numRucCustomer'];
     $arr['numRut'] = $row['numRut'];
     $arr['strName'] = $row['strName'];
     $arr['strCelphone'] = $row['strCelphone'];
     $arr['strMail'] = $row['strMail'];
     $arr['strAddress'] = $row['strAddress'];
    
     $arr['codTiCustomer'] = (int)$row['codTiCustomer'];
     $arr['codCompany'] = (int)$row['codCompany'];
     $arr['asyncFlag'] = (int)$row['asyncFlag'];

    // $arr['PASS'] = $row['PASS'];

     $arr_customer[] = $arr;

     }
    
    

     }

     echo json_encode($arr_customer); 

  //  $comprobacion            = count($arr_usuario);  
  //  $cadenaenviar['estado']  = $comprobacion;  
   // $cadenaenviar['datos']   = $arr_usuario;

 //   if($comprobacion > 0){
     
   //    $cadenaenviar['mensaje'] =  " Se Ingreso Correctamente.";    
     
   // }else{


     //  $cadenaenviar['mensaje'] = 'Usuario y/o Contraseña Incorrectas';

   // }

 
}
 ?>