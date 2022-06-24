<?php
class QuotationDB {

    private $db = null;

    public function __construct($db)
    {
        $this->db = $db;
    }


    public function insert(Array $quotation)
    {
        $statement = "
        INSERT INTO Quotation_Temp(
            cod_Quotation,
            cod_Currency,
            cod_PayCondition,
            cod_DeliveryType,
            cod_DeliveryTime,
            cod_Customer,
            cod_User,
            dte_DateQuotation,
            str_NameBusiness,
            str_Observation,
            num_SubTotal,
            num_Total,
            num_Igv,
            dte_CreateDate,
            str_CreateUser,
            dte_UpdateDate,
            str_UpdateUser,
            flg_State,
            cod_QuotationParents,
            cod_Company,
            flg_update,
            latitude,
            longitude
         )
         VALUES(
            :cod_Quotation,
            :cod_Currency,
            :cod_PayCondition,
            :cod_DeliveryType,
            :cod_DeliveryTime,
            :cod_Customer,
            :cod_User,
            :dte_DateQuotation,
            :str_NameBusiness,
            :str_Observation,
            :num_SubTotal,
            :num_Total,
            :num_Igv,
            :dte_CreateDate,
            :str_CreateUser,
            :dte_UpdateDate,
            :str_UpdateUser,
            :flg_State,
            :cod_QuotationParents,
            :cod_Company,
            :flg_update,
            :latitude,
            :longitude
         )
        ";

        try {
            $statement = $this->db->prepare($statement);
            $statement->execute(array(

            'cod_Quotation' => (String) $quotation['id'],
            'cod_Currency' => (int)$quotation['currencyId'],
            'cod_PayCondition' => (int)$quotation['payId'],
            'cod_DeliveryType' => (int)$quotation['deliveryTypeId'],
            'cod_DeliveryTime' => (int)$quotation['deliveryTimeId'],
            'cod_Customer' => (String)$quotation['customerId'],
            'cod_User' => (int)$quotation['userId'],
            'dte_DateQuotation' => (String)$quotation['dateQuotation'],
            'str_NameBusiness' => (String)$quotation['nameBusiness'],
            'str_Observation' => (String)$quotation['observation'],
            'num_SubTotal' => (String)$quotation['subTotal'],
            'num_Total' => (String)$quotation['total'],
            'num_Igv' => (String)$quotation['lgv'],
            'dte_CreateDate' => (String)$quotation['createDate'],
            'str_CreateUser' => (String)$quotation['createUser'],
            'dte_UpdateDate' => (String)$quotation['updateDate'],
            'str_UpdateUser' => (String)$quotation['updateUser'],
            'flg_State' => trim($quotation['state']) == '1' ? '2' : trim($quotation['state']),
            'cod_QuotationParents' => (String)$quotation['quotationParents'],
            'cod_Company' => (String)$quotation['company'],
            'flg_update'  =>  (int) $quotation['updateflg'],
            'latitude'  =>  (String) $quotation['latitude'],
            'longitude'  =>  (String) $quotation['longitude']
            
            ));
            
            return $statement->rowCount();
        
        } catch (\PDOException $e) {
            exit($e->getMessage());
        }    
    }

    

}
?>