<?php  

include '../../config/connections/sqlconnect.php';

if($constatus){


    $arr_usuario = array();
    $sql = "
    SELECT  
    IDUSUARIO,
    NOMBRE,
    APELLIDOS,
    ESTADO,
    [USUARIO] AS USUARIO,
    [CONTRASEÑA] AS PASS
    FROM USUARIO";
    
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

    //print_r($arr_usuario);

    echo json_encode($arr_usuario);
    
 
}else{
	
    $arr_usuario = array();
    $arr_usuario['mensaje'] = 'Tenemos error de conexion';
    
    echo json_encode($arr_usuario);
}

?>