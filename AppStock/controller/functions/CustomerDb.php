<?php
class CustomerDB {

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }


    public function insert(Array $customer)
    {
        $statement = "
        INSERT INTO Customer_Temp(
            codCustomer,
            numRucCustomer,
            strName,
            strCelphone,
            strMail,
            strAddress,
            codTiCustomer,
            codCompany,
            asyncFlag,
            latitude,
            longitude
         )
         VALUES(
            :codCustomer,
            :numRucCustomer,
            :strName,
            :strCelphone,
            :strMail,
            :strAddress,
            :codTiCustomer,
            :codCompany,
            :asyncFlag,
            :latitude,
            :longitude
         )
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(
                'codCustomer' => (String) $customer['codCustomer'],
                'numRucCustomer' => $customer['numRucCustomer'] ?? null,
                'strName' => $customer['strName'] ?? null,
                'strCelphone' => $customer['strCelphone'] ?? null,
                'strMail' => $customer['strMail'] ?? null,
                'strAddress' => $customer['strAddress'] ?? null,
                'codTiCustomer' => $customer['codTiCustomer'] ?? null,
                'codCompany' => $customer['codCompany'] ?? null,
                'asyncFlag'  =>  $customer['asyncFlag'],
                'latitude'  =>  (String) $customer['latitude'] ?? null,
                'longitude'  =>  (String) $customer['longitude'] ?? null,
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }    
    }

    

}
?>