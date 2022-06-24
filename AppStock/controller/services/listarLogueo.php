<?php 
include '../../config/connections/sqlconnect.php';

$cadenaenviar =  array( 
                     'usuario' => null , 
                     'mensaje' => '', 
                     'usuario' => '',
                     'estado'  => 0
                 );

if (!(isset($_GET['usuario']) && isset($_GET['pass']))) {
  

$cadenaenviar['mensaje'] = 'Campos requeridos no encontrados.';
 

}else{

$usuario = $_GET['usuario'];
$pass    = $_GET['pass']; 


if($constatus){

    $arr_usuario = array();
    $sql = "
       
    SELECT *  FROM USUARIO  
    WHERE usuario = '".$usuario."' and CONTRASEÑA = '".$pass."'

    ";

    $comprobacion = 0;
    $arr_usuario  = array();

    foreach ($conn->query($sql) as $row) {
     $arr = array(); 

     if(count($row) > 0){

     $arr['IDUSUARIO'] = $row['IDUSUARIO'];
     $arr['NOMBRE'] = $row['NOMBRE'];
     $arr['APELLIDOS'] = $row['APELLIDOS'];
     $arr['ESTADO'] = $row['ESTADO'];
     $arr['USUARIO'] = $row['USUARIO'];
     $arr['PASS'] = $row['PASS'];

     $arr_usuario[] = $arr;

     }
    
    

    }

    $comprobacion            = count($arr_usuario);  
    $cadenaenviar['estado']  = $comprobacion;  
    $cadenaenviar['datos']   = $arr_usuario;

    if($comprobacion > 0){
     
       $cadenaenviar['mensaje'] =  " Se Ingreso Correctamente.";    
     
    }else{


       $cadenaenviar['mensaje'] = 'Usuario y/o Contraseña Incorrectas';

    }

 
} else {
    
     $cadenaenviar['mensaje'] =  " Error de Conexion, verifique que tenga Internet.";  
}

}



echo json_encode($cadenaenviar);



 ?>