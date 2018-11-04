<?php

require_once(dirname(__FILE__) . '/../../config/config.inc.php');
class ConfPayu {

 private $credentials=  NULL;
 private $test= false;
 private $url_service = NULL;

 public function __construct($url_service = NULL,$test=TRUE) {
  if(Configuration::get('PAYU_LATAM_TEST') == 'true'){
    $this->test = TRUE;
    $this->credentials = array('apiKey'=>'4Vj8eK4rloUd272L48hsrarnUA',
                          'apiLogin'=>'pRRXKOl8ikMmt9u',
                          'merchantId'=>'508029',
                          'accountId'=>'512321',
                          'pse-CO'=>'512321',
                          'publicKey'=>'');
    $this->url_service = "https://sandbox.api.payulatam.com/payments-api/4.0/service.cgi";
  }else{
    $this->test = FALSE;
    $this->credentials=  array('apiKey'=>Configuration::get('PAYU_LATAM_API_KEY'),
                          'apiLogin'=>Configuration::get('PAYU_LATAM_API_LOGIN'),
                          'merchantId'=>Configuration::get('PAYU_LATAM_MERCHANT_ID'),
                          'accountId'=>Configuration::get('PAYU_LATAM_ACCOUNT_ID'),
                          'pse-CO'=>Configuration::get('PAYU_LATAM_ACCOUNT_ID'),
                          'publicKey'=>Configuration::get('PAYU_LATAM_PUBLIC_KEY'));
    $this->url_service = "https://api.payulatam.com/payments-api/4.0/service.cgi";
  }
}

public function keys(){
    return $this->credentials;
}

public function sendJson($request){
   /* $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $this->url_service);
    curl_setopt($ch, CURLOPT_POST, TRUE);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, FALSE);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, FALSE);
    curl_setopt($ch, CURLOPT_HEADER, "Content-Type: application/json");
    curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    
    $response = curl_exec($ch); 
    $info = curl_getinfo($ch);*/
    
    
    $opts = array('http' =>
        array(
            'method'  => 'POST',
            'timeout' => 60,
            'header'  => "Content-type: application/json",
            'content' => $request
        )
    );

    $context = stream_context_create($opts);
    $result = file_get_contents($this->url_service,false,$context);
    
    $xml=simplexml_load_string($result);
    $response = json_encode($xml);
    
    return json_decode($response,TRUE);
  
}

public function logTransaction($id_cart,$request, $response){
    $rq = json_decode($request, true); 
    
    $sql ="INSERT INTO "._DB_PREFIX_."log_payu (fecha, id_customer, id_cart, json_request, json_response, method,"
            . "transactionId, signature, valor) "
            . "VALUES ('".date('Y-m-d h:i:s', time())."' ,".$rq['transaction']['order']['buyer']['merchantBuyerId'].",$id_cart,'".$request."', '".$response."', '".$rq['transaction']['paymentMethod']."','".$rq['transaction']['order']['referenceCode']."','".$rq['transaction']['order']['signature']."','".$rq['transaction']['order']['additionalValues']['TX_VALUE']['value']."')";
    
    try{
        Db::getInstance()->execute($sql);
        return Db::getInstance()->Insert_ID();  
    }catch(Exception $e){
        return false;
    }
}

public function randString ($length = 32){
 $string = "";
 $possible = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXY";
 $i = 0;
 while ($i < $length){
  $char = substr($possible, mt_rand(0, strlen($possible)-1), 1);
  $string .= $char;
  $i++;
 }
 return $string;
}

public function sing($str){
  $keys=$this->keys();
  return md5($keys['apiKey'].'~'.$keys['merchantId'].'~'.$str);
}

public function urlv() {
  $protocolo=NULL;
  if(Utilities::is_ssl()){
    $protocolo='https://';
  }else{
    $protocolo='http://';
  }

// Url archivo de verificaciÃ³n webservice
  $nombre_archivo = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
  $nombre_archivo = explode('/', $nombre_archivo);
  $var = array_pop($nombre_archivo);
  $nombre_archivo = implode('/', $nombre_archivo);
  return $urlValidation = $protocolo.$_SERVER['HTTP_HOST'] . $nombre_archivo . '/validationws.php';
}

public function pago_payu($id_order, $id_customer, $json_request, $json_response, $method, $extras, $id_cart, $id_address) {
  $array_rq = json_decode($json_request, TRUE);
  try {

    $mysqldate = date("Y-m-d H:i:s");

    $log = 'Fecha de transaccion-WS: ' . $mysqldate . '\r\nRequest: \r\n' . $json_request . '\r\nResponse: \r\n' . json_encode($json_response);
    $this->logtxt($log);


    if (isset($json_response['transactionResponse']['extraParameters']['BAR_CODE'])) {
      $extras = $json_response['transactionResponse']['extraParameters']['REFERENCE'].';'.date('d/m/Y', substr($json_response['transactionResponse']['extraParameters']['EXPIRATION_DATE'], 0, -3)).';'.$json_response['transactionResponse']['extraParameters']['BAR_CODE'];

    }elseif (isset($json_response['transactionResponse']['extraParameters']['URL_PAYMENT_RECEIPT_HTML'])) {
      $extras = $json_response['transactionResponse']['extraParameters']['REFERENCE'].';'.date('d/m/Y', substr($json_response['transactionResponse']['extraParameters']['EXPIRATION_DATE'], 0, -3));

    }

    Db::getInstance()->autoExecute(_DB_PREFIX_.'pagos_payu', array(
                                   'id_pagos_payu' => (int) 0,
                                   'fecha' => pSQL($mysqldate),
                                   'id_order' => (int) $id_order,
                                   'id_customer' => (int) $id_customer,
                                   'json_request' => pSQL(addslashes($json_request)),
                                   'json_response' => pSQL(addslashes(json_encode($json_response))),
                                   'method' => pSQL($method),
                                   'extras' => pSQL($extras),
                                   'id_cart' => (int) $id_cart,
                                   'id_address' => (int) $id_address,
                                   'transactionId' => PSQL($json_response['transactionResponse']['transactionId']),
                                   'valor' => (int) $array_rq['transaction']['order']['additionalValues']['TX_VALUE']['value'],
                                   'orderIdPayu' => (int) $json_response['transactionResponse']['orderId'],
                                   'message'=>PSQL($json_response['transactionResponse']['responseCode']),
                                   ), 'INSERT');
} catch (Exception $exc) {
  Logger::AddLog('payulatam [config.php] pago_payu() error: ' . $exc->getTraceAsString(), 2, null, null, null, true);
}
}

public function error_payu($id_order, $id_customer, $json_request, $json_response, $method, $extras, $id_cart, $id_address) {
  $array_rq = json_decode($json_request, TRUE);
  try {

    $mysqldate = date("Y-m-d H:i:s");

    $log = 'Fecha de transaccion-WS: ' . $mysqldate . '\r\nRequest: \r\n' . $json_request . '\r\nResponse: \r\n' . json_encode($json_response);
    $this->logtxt($log);

    Db::getInstance()->autoExecute('ps_error_payu', array(
                                   'id_pagos_payu' => (int) 0,
                                   'fecha' => pSQL($mysqldate),
                                   'id_order' => (int) $id_order,
                                   'id_customer' => (int) $id_customer,
                                   'json_request' => pSQL(addslashes($json_request)),
                                   'json_response' => pSQL(addslashes(json_encode($json_response))),
                                   'method' => pSQL($method),
                                   'extras' => pSQL($extras),
                                   'id_cart' => (int) $id_cart,
                                   'id_address' => (int) $id_address,
                                   'transactionId' => PSQL($json_response['transactionResponse']['transactionId']),
                                   'valor' => (int) $array_rq['transaction']['order']['additionalValues']['TX_VALUE']['value'],
                                   'orderIdPayu' => (int) $json_response['transactionResponse']['orderId'],
                                   'message'=>PSQL($json_response['transactionResponse']['responseCode']),
                                   ), 'INSERT');
} catch (Exception $exc) {
  Logger::AddLog('payulatam [config.php] pago_payu() error: ' . $exc->getTraceAsString(), 2, null, null, null, true);
}
}

public function log_response_ws($array_rs) {


  $reference_code = explode("_", $array_rs['description']);

  try {
    $mysqldate = date("Y-m-d H:i:s");

    Db::getInstance()->autoExecute('ps_log_payu_response', array(
                                   'id_log_payu_response' => (int) 0,
                                   'date' => pSQL($mysqldate),
                                   'reponse' => pSQL(var_export($array_rs,TRUE)),
                                   'id_order' => (int) $reference_code[2],
                                   'id_customer' => (int) $reference_code[0],
                                   'id_cart' => (int) $reference_code[1],
                                   'id_address' => (int) $reference_code[3],
                                   'transactionId' => PSQL($array_rs['transaction_id']),
                                   'valor' => (int) $array_rs['value'],
                                   'orderIdPayu' => (int) $array_rs['reference_pol'],
                                   'message'=>PSQL($array_rs['response_message_pol']),
                                   ), 'INSERT');
  } catch (Exception $exc) {
    Logger::AddLog('payulatam [config.php] pago_payu() error: ' . $exc->getTraceAsString(), 2, null, null, null, true);
  }
}

public function failed_transaction($id_order, $id_customer, $json_request, $json_response, $method, $extras, $id_cart, $id_address) {
  $array_rq = json_decode($json_request, TRUE);

  try {

    if (!isset($json_response['transactionResponse']['responseCode'])){
      $errortransaction = explode(",", $json_response['error']);
      $json_response['transactionResponse']['responseCode'] = $errortransaction[0];
    }

    $mysqldate = date("Y-m-d H:i:s");

    Db::getInstance()->autoExecute('ps_pagos_payu', array(
                                   'id_pagos_payu' => (int) 0,
                                   'fecha' => pSQL($mysqldate),
                                   'id_order' => (int) $id_order,
                                   'id_customer' => (int) $id_customer,
                                   'json_request' => pSQL(addslashes($json_request)),
                                   'json_response' => pSQL(addslashes(json_encode($json_response))),
                                   'method' => pSQL($method),
                                   'extras' => pSQL($extras),
                                   'status' => pSQL('0'),
                                   'id_cart' => (int) $id_cart,
                                   'id_address' => (int) $id_address,
                                   'transactionId' => PSQL($json_response['transactionResponse']['transactionId']),
                                   'valor' => (int) $array_rq['transaction']['order']['additionalValues']['TX_VALUE']['value'],
                                   'orderIdPayu' => (int) $json_response['transactionResponse']['orderId'],
                                   'message'=>PSQL($json_response['transactionResponse']['responseCode']),
                                   ), 'INSERT');
} catch (Exception $exc) {
  Logger::AddLog('payulatam [config.php] pago_payu() error: ' . $exc->getTraceAsString(), 2, null, null, null, true);
}
}

public function get_order($id_cart) {
  try {
    $sql = 'select ord.*
    from ps_orders ord INNER JOIN ps_cart car ON(ord.id_cart=car.id_cart)
    WHERE  ord.id_cart=' . $id_cart . ' Limit 1';

    if ($results = Db::getInstance()->ExecuteS($sql)) {
      foreach ($results as $row) {
        return $row;
      }
    }
    return null;
  } catch (Exception $exc) {
    Logger::AddLog('payulatam [config.php] get_order() error: ' . $exc->getTraceAsString(), 2, null, null, null, true);
    return null;
  }
}

public function logtxt ($text=""){

/*$fp=fopen("/home/ubuntu/log_payu/log_payu.txt","a+");
fwrite($fp,$text."\r\n");
fclose($fp) ;
            */
}

public function get_state($id_state){
  $query="select state.`name` FROM "._DB_PREFIX_."state state
  WHERE state.id_state=".(int)$id_state.' limit 1;';

  if ($results = Db::getInstance()->ExecuteS($query)) {
   if(count($results)>0){
     return $results[0]['name'];
   }
 }
 return null;
}

public function get_address($id_customer, $id_address_delivery) {


  $sql = 'select ad.address1,city,phone_mobile,phone,dni, st.`name` as state, co.iso_code
  from ps_address ad, ps_state st, ps_country co  where ad.id_customer=' . $id_customer . ''
  . ' and ad.id_address=' . $id_address_delivery . ' and ad.id_state= st.id_state and
  co.id_country =ad.id_country';


  if ($results = Db::getInstance()->ExecuteS($sql)) {
    if (count($results) > 0) {
      return $results[0];
    }
  }
  return FALSE;
}

public function get_dni($id_address) {

  $sql = 'select cus.identification, adr.dni
  from ps_address adr INNER JOIN ps_customer cus ON (adr.id_customer = cus.id_customer)
  WHERE adr.id_address=' . (int) $id_address . ';';

  $dni =  'N/A';

  if ($results = Db::getInstance()->ExecuteS($sql)) {

    foreach ($results as $row) {



      if ($row['identification'] != NULL && $row['identification'] != '0') {
        $dni = $row['identification'];
      } else if ($row['dni'] != '1111' && $row['dni'] != '') {
        $dni = $row['dni'];
      } else {
        $dni = 'N/A';
      }
    }
  }
  return $dni;
}

public function isTest() {
  return $this->test;
}

public function addTables($delete = FALSE){
    
    $engine="MyISAM";
    $drops= array("DROP TABLE IF EXISTS "._DB_PREFIX_."log_payu");
    
    if(!$delete){
            $creates= array("CREATE TABLE "._DB_PREFIX_."log_payu (
          id_log_payu int(11) NOT NULL AUTO_INCREMENT,
          fecha datetime NOT NULL,
          id_order int(11) NOT NULL,
          id_customer int(11) NOT NULL,
          id_cart int(11) DEFAULT NULL,
          json_request varchar(4096) DEFAULT NULL,
          json_response varchar(4096) DEFAULT NULL,
          method varchar(256) DEFAULT NULL,
          transactionId varchar(200) DEFAULT NULL,
          signature varchar(255) DEFAULT NULL,
          valor int(11) DEFAULT NULL,
          PRIMARY KEY (id_log_payu)
        ) ENGINE=".$engine." DEFAULT CHARSET=utf8;");
    }
    
    try{
        foreach($drops as $key => $drop ){
            $dr = Db::getInstance()->Execute($drop);
        }
        if(!$delete){
            foreach($creates as $key => $create ){
                $cr = Db::getInstance()->Execute($create);
            }
        }    
        return TRUE;
    }  catch (Exception $e){
        return $e->getMessage();
    }
 }

public function get_intentos($id_cart){
  $query=  "SELECT id_cart,contador
  FROM "._DB_PREFIX_."count_pay_cart
  WHERE id_cart = ".(int)$id_cart;

  $row = Db::getInstance()->getRow($query);
  if(isset($row['contador'])){
    return $row['contador'];
  }else{
    return false;
  }

}

public function existe_transaccion($id_cart){
  $sql ="SELECT id_cart
          FROM "._DB_PREFIX_."pagos_payu
          WHERE id_cart = ".(int)$id_cart;
  $row = Db::getInstance()->getRow($sql);
  if(isset($row['id_cart']) && !empty($row['id_cart'])){
            return TRUE;
  }else{
          return FALSE;
  }
}

}
