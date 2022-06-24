<?php 


include '../../config/connections/sqlconnect.php';
if($constatus){

    $arr_usuario = array();
    $sql = "
       
    SELECT 
    cod_User,
    str_NameUser,
    str_PassUser,
    cod_Company,
    cod_Person,
    cod_List  
    FROM AUTENTICATION  
   

    ";

    $comprobacion = 0;
    $arr_autentication  = array();

    foreach ($conn->query($sql) as $row) {
     $arr = array(); 

     if(count($row) > 0){

     $arr['codUser'] = $row['cod_User'];
     $arr['strNameUser'] = $row['str_NameUser'];
     $arr['strPassUser'] = $row['str_PassUser'];
     $arr['codCompany'] = $row['cod_Company'];
     $arr['codPerson'] = $row['cod_Person'];
     $arr['codList'] = $row['cod_List'];
    // $arr['PASS'] = $row['PASS'];

     $arr_autentication[] = $arr;

     }
    
    

    }

     echo json_encode($arr_autentication);

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