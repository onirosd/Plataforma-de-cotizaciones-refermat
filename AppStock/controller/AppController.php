<?php
    include '../config/config.php';
    include '../config/connections/sqlconnect.php';
    include '../controller/functions/funciones.php';

    echo '  
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

    <div class="container-fluid">

    ';

    $currentDir = DIRECTORY;
    $uploadDirectory = "/uploadFiles/";
    $numcolumnas   =  7;
    $mensaje_error = "";
    $conteo_filas  = 1; 
    $conteo_columnas = 1;
    $limpieza_total  = 0;
    $codigo_usuario   = 0;
    $valores_columnas = array(
                                 1 => 'str',
                                 2 => 'str',
                                 3 => 'str',
                                 4 => 'num',
                                 5 => 'num', 
                                 6 => 'num', 
                                 7 => 'str',    
                             );
    
    if(isset($_POST['fcarga'])){

        $limpieza_total = isset($_POST['limpieza']) &&  $_POST['limpieza'] = 'ON' ? 1 : 0;
        $codigo_usuario = isset($_POST['cargausuario']) &&  $_POST['cargausuario'] > 0 ? $_POST['cargausuario']  : 0;

       /*Borramos los datos */
       if($limpieza_total == 1){

        if($codigo_usuario > 0){
         
         $sql0 = "
      
        DELETE FROM Listaproductos where usuario = (select usuario from usuario where idusuario = $codigo_usuario)
     
        ";

        }else{


        $sql0 = "
      
         TRUNCATE TABLE ListaProductos 
     
        ";

        }

        

         $stmt0 = $conn->prepare($sql0);
         $stmt0->execute();

       }   
      // echo $codigo_usuario."-----<br>";
     //  echo "llegamos hasta aqui";
    
        $valores = $_POST['fcarga'];
        $arreglo = explode(";", $valores);
        $filas_afectadas = 0;
            foreach ($arreglo as $key => $value) {
            $datos_interno = explode("|",$value);
            
            
            if(count($datos_interno) == 7){
                
                $insercion       = "";
                $conteo_columnas = 1;
                $codigo_sku      = "";
                $usuario_registro = "";
                foreach ($datos_interno as $key1  => $value1) {
                if($conteo_columnas == 1){   $codigo_sku = trim(trim($value1,"'")); }
                $limp      =  limpieza($valores_columnas[$conteo_columnas], $value1);
                $insercion =  trim($insercion) == "" ? $limp : $insercion.",".$limp;
                
                $conteo_columnas++; 
                $usuario_registro = trim(trim($limp,"'"));
                }

             //   echo $codigo_usuario."--".$usuario_registro."--".$codigo_sku."---".$insercion;
                
                $retur =  buscar_eliminar_insertar($codigo_usuario,$usuario_registro,$codigo_sku,$insercion,$conn);
              
                $filas_afectadas = $filas_afectadas + $retur['result'];
                // $sql = "
                
                // INSERT INTO ListaProductos (CODIGO, CODIGOPROV, DESCRIPCION, INVENTARIO, PRECIO_FULL, PRECIO_DESC, USUARIO)
                // VALUES ($insercion)
                
                // ";
                
                // $stmt = $conn->prepare($sql);
                // $stmt->execute();
                
                // if ($stmt->rowCount() > 0){
                // $filas_afectadas++;
                
                // }
                
                
            }else{
            
                $mensaje_error .= "* Error en la fila numero ".$conteo_filas. ", cada fila debe tener ".$numcolumnas." columnas, favor de revisar nuevamente lo ingresado. <br>"; 
                
            }
            
            
                $conteo_filas++;
            }

      echo '   
        
        <div class="card text-center">
        <div class="card-header">
        Cuadro de Resultados 
        </div>
        <div class="card-body">
        <h5 class="card-title"> Se Insertarón / Actualizarón </h5>
        <p class="card-text">'.$filas_afectadas.' registros nuevos en la base de datos.</p>
        <a href="AppSubida.php" class="btn btn-primary">Volver Al Inicio</a>
        </div>
        <div class="card-footer text-muted">
        
        </div>
        </div>
   
      ';
    
    if($mensaje_error != ""){


        echo '   
        
        <div class="card text-center bg-danger">
        <div class="card-header">
        Cuadro de Errores 
        </div>
        <div class="card-body">
        <h5 class="card-title"> Se encontro lo siguiente </h5>
        <p class="card-text">'.$mensaje_error.'</p>
        
        </div>
        <div class="card-footer text-muted">
        
        </div>
        </div>
   
      ';

      // echo "<h2> Errores Encontrados :: </h2> <br>";
      // echo  $mensaje_error;
   

    }

     


    }
     

echo ' </div>
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>


    ';

?>