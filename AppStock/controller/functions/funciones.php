<?php 


function redirect($url, $permanent = false)
{
    if (headers_sent() === false)
    {
        header('Location: ' . $url, true, ($permanent === true) ? 301 : 302);
    }

    exit();
}


function view($path) {

    include_once $path;
}


function buscar_eliminar_insertar($idusuario ,$usuario_registro, $codigosku, $insercion, $conn){
        $mensaje = "";
        $exito   = 0;
        $avance1 = 0;
        $usuario_validacion = "";

        // echo $idusuario."----".$usuario_registro."----".$codigosku."------";
        if((int)$idusuario > 0){

				$sql0    = "
				SELECT USUARIO, IDUSUARIO FROM dbo.USUARIO WHERE IDUSUARIO = $idusuario				
				";
				
			
				$stmt0 = $conn->prepare($sql0);
				$stmt0->execute();
				$ref = $stmt0->fetch(PDO::FETCH_ASSOC);

				 if(count($ref) > 0 ){

			             $usuario_validacion = $ref['USUARIO'];	
			         
						 if((String)trim($usuario_registro) != (String)trim($usuario_validacion)){
                           
                           $avance1 = 0;
				    
				         }else{

				     

                            $sql5 = " 

                            SELECT b.USUARIO, a.CODIGO from usuario b
			            	inner join  Listaproductos a on b.usuario = a.usuario
			            	where b.idusuario = $idusuario and a.codigo = '$codigosku'  

                            ";

                           // echo $sql5."------<br>"; ;
				         	$stmt5 = $conn->prepare($sql5);
				            $stmt5->execute();
				           // $ref1  = $stmt5->fetch(PDO::FETCH_ASSOC);

                               ///  echo "::::::".$stmt5->rowCount()." -------- ".count($ref1)."::::::";
				            if($stmt5->rowCount() == 0){

                              $avance1 = 2;

				            }else{

                              $avance1 = 1;

				            }

				         }
						
						
				}else{
                        
                       
                       $avance1  = 0;
				    
				}
         
         }else{

         	$avance1 = 2;
         }
         
         
         /* Analizamos eliminamos e insertamos */

         if($avance1 == 1){
            
				$sql1 = "
				delete from Listaproductos 
				where usuario  = (select usuario from usuario where idusuario = $idusuario)
				and   codigo = '$codigosku';
				";
				
				$stmt1 = $conn->prepare($sql1);
				$stmt1->execute();
				if($stmt1->rowCount() > 0){
				
				$avance1   = 2;
				
				}else{
				
				$mensaje .= "* No se pudo eliminar registro anterior.<br>";
				}

           

         }

         if($avance1 == 2){
				
				$sql2 = "
				INSERT INTO ListaProductos (CODIGO, CODIGOPROV, DESCRIPCION, INVENTARIO, PRECIO_FULL, PRECIO_DESC, USUARIO)
				VALUES ($insercion)
				";
				
				
				$stmt2 = $conn->prepare($sql2);
				$stmt2->execute();
				
				if($stmt2->rowCount() > 0){
				
				$exito = 1;
				
				
				}else{
				
				$mensaje .= "* No se pudo hacer insercion. <br>";
				
				}
          


         }


  
 return array('result' => $exito , 'mensaje'=> $mensaje);

}




function validar_numeros($string) {
  // $string = str_replace(' ', '-', $string); // Replaces all spaces with hyphens.

   $limpiar1 =  preg_replace("/[^0-9,.]/","", $string); // Removes special chars.
   return trim(str_replace(",",".",$limpiar1),".");
}

function validar_texto($string) {
  // $string = str_replace(' ', '-', $string); // Replaces all spaces with hyphens.

 $limpiar1 = preg_replace("/[^a-zA-Z0-9À-ÿ\s\,\/;)\(+=._-]/","", $string); // Removes special chars.

 return trim($limpiar1);
}



function limpieza($codigo, $valor){
$limpiar = "";

if($codigo == "str"){
  $limpiar = "'".validar_texto($valor)."'";
}else{
  $limpiar = validar_numeros($valor);
}

return $limpiar;
}


?>