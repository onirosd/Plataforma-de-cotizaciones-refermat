<?php 


include '../../config/connections/sqlconnect.php';
if($constatus){

    $arr_usuario = array();
    $sql = "
       
    select 
    a.cod_company codCompany,
    a.str_DesCompany strDesCompany,
	a.str_IdCompany strRucCompany,
	a.str_Address strAddress,
	a.str_Phone strPhone,
	isnull(a.str_Logo,'') strLogo,
    a.str_PrintFormat strPrintFormat,
    a.cod_Currency codCurrency,
    convert(varchar(20),a.num_impuesto) numImpuesto,
	isnull(b.campo1,'') campo1,
	isnull(b.campo2,'') campo2,
	isnull(b.campo3,'') campo3,
	isnull(b.campo4,'') campo4,
	isnull(b.campo5,'') campo5,
	isnull(b.campo6,'') campo6,
	isnull(b.campo7,'') campo7,
	isnull(b.campo8,'') campo8,
	isnull(b.campo9,'') campo9,
	isnull(b.campo10,'') campo10,
    a.str_image
    from Company a
	left join CompanyVarReports b on a.cod_Company = b.cod_Company
    where a.flg_async = 0  
   

    ";

    $comprobacion = 0;
    $arr_autentication  = array();

    foreach ($conn->query($sql) as $row) {
     $arr = array(); 

     if(count($row) > 0){

     $arr['codCompany'] = (int)$row['codCompany'];
     $arr['strDesCompany'] = $row['strDesCompany'];
     $arr['strRucCompany'] = $row['strRucCompany'];
     $arr['strAddress'] = $row['strAddress'];
     $arr['strPhone'] = $row['strPhone'];
     $arr['strLogo'] = $row['strLogo'];
     $arr['strPrintFormat'] = $row['strPrintFormat'];
     $arr['codCurrency'] = $row['codCurrency'];
     $arr['numImpuesto'] = $row['numImpuesto'];
     $arr['campo1'] = $row['campo1'];
     $arr['campo2'] = $row['campo2'];
     $arr['campo3'] = $row['campo3'];
     $arr['campo4'] = $row['campo4'];
     $arr['campo5'] = $row['campo5'];
     $arr['campo6'] = $row['campo6'];
     $arr['campo7'] = $row['campo7'];
     $arr['campo8'] = $row['campo8'];
     $arr['campo9'] = $row['campo9'];
     $arr['campo10'] = $row['campo10'];
     $arr['str_image'] = $row['str_image'];

     $arr_company[] = $arr;

     }
    
    

    }

     echo json_encode($arr_company);

 
}
 ?>