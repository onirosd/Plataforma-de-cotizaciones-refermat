
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pagina de carga de Archivos</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<body>
<div class="container-fluid">

  
  <div class="row">
<div class="col-lg-2">
  	  	
</div>  	
<div class="col-lg-8
	<div class="alert alert-success" role="alert">
  <h4 class="alert-heading">MODULO DE CARGA </h4>
  <b style="font-weight: lighter;">  Primero : Descargar la plantilla de conversion en el icono <img style="width: 2em;" src="<?php echo BASE_URL; ?>resources/images/icon-excel.png" class="img-fluid img-thumbnail" alt="Responsive image"/> </b><br>
  <b style="font-weight: lighter;">  Segundo : Copiar el nuevo stock en la plantilla y generar la data formateada.</b><br>
  <b style="font-weight: lighter;">  Tercero : Copiar la data formateada en el cuadro que dice "Ingresar".</b><br>
  <b style="font-weight: lighter;">  Cuarto  : Click en el botón, Actualizar Stock. </b>

  <hr>
	  <p class="mb-0">Importante : El checkbox de limpiar registros,  elimina toda la información de los productos. Esto con la intencion de volver a cargar toda la lista de stock.</p>



<form action="<?php echo BASE_URL; ?>controller/AppController.php" method="post" enctype="multipart/form-data">


<?php 

$lista = "";
//print_r($arr_productos);
if(isset($arr_productos['estado'] ) && $arr_productos['estado']){

  foreach ($arr_productos['datos'] as $key => $value) {
    
    $lista .= '<option value= "'.$value['idusuario'].'">'.$value['ncompleto'].'</option>';
  }

}else{

  echo '<div class="alert alert-warning" role="alert">'.$arr_productos['mensaje'].'</div>';
}


?>


<div class="input-group mb-3">
  <div class="input-group-prepend">
    <label class="input-group-text" for="inputGroupSelect01">Seleccionar </label>
  </div>
  <select class="custom-select" id="nselect" name="cargausuario">
    <option value=0 selected>Subida Masiva</option>

    <?php echo $lista; ?>

  </select>
</div>

<div class="input-group">
  <div class="input-group-prepend">
    <span class="input-group-text">Ingresar </span>
  </div>
  <textarea class="form-control" aria-label="With textarea" name="fcarga" style="height: 300px;"></textarea>
</div>

 <button type="submit" class="btn btn-primary btn-lg btn-block"> Actualizar valores </button>
 <div class="container">
 	<div class="row">
 
 		<div class="col-md-6">
				
				<a href="<?php echo BASE_URL; ?>resources/files/muestracarga.xlsx">
				<h6><em>Descargar plantilla de conversión <img style="width: 3em;" src="<?php echo BASE_URL; ?>resources/images/icon-excel.png" class="img-fluid img-thumbnail" alt="Responsive image"/></em></h6>
				</a>
 			
 		</div>

 		<div class="col-md-6">

 			    <div class="col-md-12" style="
        margin-top: 2px;
        font-weight: bold;
        text-align: center;
    ">

            <div class="form-group row">
                    <label class="col" style="
        color: #dc3545;
    ">¿ Desseas Limpiar Todo ?</label>
                <label>
                                <input onchange="cTrig('btnlimpieza')" type="checkbox" id="btnlimpieza" name="limpieza">(Click)
                            </label>

                    <div <="" div="">
     </div></div></div>

 	    </div>

 

</form>  
</div>	
</div>


  </div>

</div>
 
</body>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<script src="<?php echo BASE_URL; ?>resources/js/main.js?v1=2" type="text/javascript"></script>

</html>