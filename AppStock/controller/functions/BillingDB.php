<?php
class BillingDB {

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }


    public function insert(Array $billing)
    {
        $statement = "
        INSERT INTO Billing_Temp(
            codBillingUniq,
            codUser,
            codCustomer,
            codBillingType,
            codPaymentMethod,
            strOperation,
            dteBillingDate,
            codBank,
            codCurrency,
            numAmountOperation,
            strComments,
            flgState,
            strCreateUser,
            dteCreateDate,
            codCompany,
            flgSync,
            flgCodRealSystem,
            latitude,
            longitude
         )
         VALUES(
            :codBillingUniq,
            :codUser,
            :codCustomer,
            :codBillingType,
            :codPaymentMethod,
            :strOperation,
            :dteBillingDate,
            :codBank,
            :codCurrency,
            :numAmountOperation,
            :strComments,
            :flgState,
            :strCreateUser,
            :dteCreateDate,
            :codCompany,
            :flgSync,
            :flgCodRealSystem,
            :latitude,
            :longitude
         )
        ";

       // print_r($billing);

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(

            'codBillingUniq' => (String) trim($billing['codBillingUniq']),
            'codUser' => (String)trim($billing['codUser']),
            'codCustomer' => (String)trim($billing['codCustomer']),
            'codBillingType' => (String)trim($billing['codBillingType']),
            'codPaymentMethod' => (String)trim($billing['codPaymentMethod']),
            'strOperation' => (String)trim($billing['strOperation']),
            'dteBillingDate' => (String)trim($billing['dteBillingDate']),
            'codBank' => (String)trim($billing['codBank']),
            'codCurrency' => (String)trim($billing['codCurrency']),
            'numAmountOperation' => (String)trim($billing['numAmountOperation']),
            'strComments' => (String)trim($billing['strComments']),
            'flgState' => (String)  trim($billing['flgState']) == '1' ? '2' : trim($billing['flgState']), 
            'strCreateUser' => (String)trim($billing['strCreateUser']),
            'dteCreateDate' => (String)trim($billing['dteCreateDate']),
            'codCompany' => (String)trim($billing['codCompany']),
            'flgSync'    => 0, //(int)$billing['flgSync'],
            'flgCodRealSystem' => (int)$billing['flgCodRealSystem'],
            'latitude' => (String)$billing['latitude'],
            'longitude' => (String)$billing['longitude']
               
            ));
            return $statement->rowCount();
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }    
    }

    

}
?>