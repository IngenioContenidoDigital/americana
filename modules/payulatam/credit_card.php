<?php

ini_set('max_execution_time', 300);
$useSSL = true;
require_once(dirname(__FILE__) . '/../../config/config.inc.php');
require_once(dirname(__FILE__) . '/../../init.php');
require_once(_PS_MODULE_DIR_ . 'payulatam/payulatam.php');
require_once(_PS_MODULE_DIR_ . 'payulatam/config.php');
require_once(_PS_MODULE_DIR_ . 'payulatam/paymentws.php');
require_once(_PS_MODULE_DIR_ . 'payulatam/classes/creditcards.class.php');


class PayuCreditCard extends PayUControllerWS {

    public $ssl = true;

    public function setMedia() {
      parent::setMedia();
    }

    public function process() {
        if (empty($this->context->cart->id)) {
          $context = Context::getContext();

          if(isset($context->cookie->{'page_confirmation'})){
            $redirect = json_decode($context->cookie->{'page_confirmation'});
            Tools::redirectLink($redirect);
            exit();
          }
          $redirectLink = 'index.php?controller=history';
          Tools::redirect($redirectLink);
          exit();

        }
        
        $url_reintento=$_SERVER['HTTP_REFERER'];
        if(!strpos($_SERVER['HTTP_REFERER'], 'step=')){
          $url_reintento.='?step=3';
        }
        
        //parent::process();

        $conf = new ConfPayu();
        $id_cart = $this->context->cart->id;

        
        $arraypaymentMethod =  array("VISA"=>'VISA','DISCOVER'=>'DINERS','AMERICAN EXPRESS'=>'AMEX','MASTERCARD'=>'MASTERCARD');        

        $CCV = new CreditCardValidator();
        $CCV->Validate(Tools::getValue('numerot'));
        $key = $CCV->GetCardName($CCV->GetCardInfo()['type']); 
        
        
        if($CCV->GetCardInfo()['status'] == 'invalid'){
            $this->context->cookie->{'error_pay'} = json_encode(array('ERROR'=>'El numero de la tarjeta no es valido.'));
            Tools::redirectLink($url_reintento); 
        }
        
        if (array_key_exists(strtoupper($key), $arraypaymentMethod)) {
            $paymentMethod = $arraypaymentMethod[strtoupper($key)];
        }
        
        $params = $this->initParams();

        $post = array('nombre'  =>  (Tools::getValue('nombre')) ? Tools::getValue('nombre') : Tools::getValue('holder'),
                      'numerot' =>  (Tools::getValue('numerot')) ? Tools::getValue('numerot') : Tools::getValue('card'),
                      'codigot' =>  (Tools::getValue('codigot')) ? Tools::getValue('codigot') : Tools::getValue('cvv'),
                      'date'    =>  Tools::getValue('datepicker'),
                      'cuotas'  =>  Tools::getValue('cuotas'),
                      'Month'   =>  Tools::getValue('Month'),
                      'Year'    =>  Tools::getValue('year'));
        
        $customer = new Customer((int) $this->context->cart->id_customer);
        
        $conf = new ConfPayu();
        $keysPayu = $conf->keys();

        $dni = $conf->get_dni($this->context->cart->id_address_delivery);

        $address = new Address($this->context->cart->id_address_delivery); 
        $id_order = 0;
        $id_address = $this->context->cart->id_address_delivery;
        $reference_code = $customer->id . '_' . $id_cart . '_' . $id_order . '_' . $id_address;
        $_deviceSessionId = NULL;
        
        
        if (isset($this->context->cookie->deviceSessionId) && !empty($this->context->cookie->deviceSessionId) && strlen($this->context->cookie->deviceSessionId) === 32) {
          $_deviceSessionId = $this->context->cookie->deviceSessionId;
        } elseif (isset($_POST['deviceSessionId']) && !empty($_POST['deviceSessionId']) && strlen($_POST['deviceSessionId']) === 32) {
          $_deviceSessionId = $_POST['deviceSessionId'];
        } else {
          $_deviceSessionId = md5($this->context->cookie->timestamp);
        }

        
        $currency=$params[9]['currency'];
        
        
        $request = [
            "language"=> $params[10]['lng'],
            "command"=> "SUBMIT_TRANSACTION",
            "merchant"=> [
               "apiKey"=> $keysPayu['apiKey'],
               "apiLogin"=> $keysPayu['apiLogin']
            ],
            "transaction"=> [
               "order"=> [
                  "accountId"=> $keysPayu['accountId'],
                  "referenceCode"=> $params[2]['referenceCode'],
                  "description"=> $reference_code,
                  "language"=> $params[10]['lng'],
                  "signature"=> $conf->sing($params[2]['referenceCode'].'~' . $params[4]['amount'] . '~'.$currency),
                  "notifyUrl"=> _PS_BASE_URL_."/confirmation",
                  "additionalValues"=> [
                     "TX_VALUE"=> [
                        "value"=> $params[4]['amount'],
                        "currency"=> $currency
                  ],
                     "TX_TAX"=> [
                        "value"=> $params[6]['tax'],
                        "currency"=> $currency
                  ],
                     "TX_TAX_RETURN_BASE"=> [
                        "value"=> ($params[6]['tax'] == 0 ? 0 : ($params[4]['amount']-$params[6]['tax'])),
                        "currency"=> $currency
                  ]
                  ],
                  "buyer"=> [
                     "merchantBuyerId"=> $customer->id,
                     "fullName"=> $customer->firstname.' '.$customer->lastname,
                     "emailAddress"=> $customer->email,
                     "contactPhone"=> ((!empty($address->phone_mobile)) ? $address->phone_mobile : $address->phone),
                     "dniNumber"=> $customer->dni,
                     "shippingAddress"=> [
                        "street1"=> $address->address1,
                        "street2"=> $address->address2,
                        "city"=> $address->city,
                        "state"=> $conf->get_state($address->id_state),
                        "country"=> $this->context->country->iso_code,
                        "postalCode"=> "000000",
                        "phone"=> ((!empty($address->phone_mobile)) ? $address->phone_mobile : $address->phone)
                     ]
                  ],
                  "shippingAddress"=> [
                      "street1"=> $address->address1,
                      "street2"=> $address->address2,
                      "city"=> $address->city,
                      "state"=> $conf->get_state($address->id_state),
                      "country"=> $this->context->country->iso_code,
                      "postalCode"=> "000000",
                      "phone"=> ((!empty($address->phone_mobile)) ? $address->phone_mobile : $address->phone)
                  ]
               ],
               "payer"=> [
                  "merchantPayerId"=> $customer->id,
                  "fullName"=> $customer->firstname.' '.$customer->lastname,
                  "emailAddress"=> $customer->email,
                  "contactPhone"=> ((!empty($address->phone_mobile)) ? $address->phone_mobile : $address->phone),
                  "dniNumber"=> $customer->dni,
                  "billingAddress"=> [
                     "street1"=> $address->address1,
                     "street2"=> $address->address2,
                     "city"=> $address->city,
                     "state"=> $conf->get_state($address->id_state),
                     "country"=> $this->context->country->iso_code,
                     "postalCode"=> "000000",
                     "phone"=> ((!empty($address->phone_mobile)) ? $address->phone_mobile : $address->phone)
                  ]
               ],
               "creditCard"=> [
                  "number"=> $post['numerot'],
                  "securityCode"=> $post['codigot'],
                  "expirationDate"=> $post['Year']."/".$post['Month'],
                  "name"=> $post['nombre']
               ],
               "extraParameters"=> [
                  "INSTALLMENTS_NUMBER"=> (int)$post['cuotas']
               ],
               "type"=> "AUTHORIZATION_AND_CAPTURE",
               "paymentMethod"=> $paymentMethod,
               "paymentCountry"=> $this->context->country->iso_code,
               "deviceSessionId"=> $_deviceSessionId,
               "ipAddress"=> $_SERVER['REMOTE_ADDR'],
               "cookie"=> md5($this->context->cookie->timestamp),
               "userAgent"=> $_SERVER['HTTP_USER_AGENT']//"Mozilla/5.0 (Windows NT 5.1; rv=>18.0) Gecko/20100101 Firefox/18.0"
            ],
            "test"=> false
         ];
        
        $response = $conf->sendJson(json_encode($request));

        $error_pay = array();
        
        $tx = $conf->logTransaction($id_cart, json_encode($request), json_encode($response));

        switch($response['code']){
            case 'ERROR':
                $conf->error_payu($id_order, $customer->id, $data, $response, 'Tarjeta_credito', $response['transactionResponse']['state'], $this->context->cart->id, $id_address); 
                $error_pay[]=$response;
                $this->context->cookie->{'error_pay'} = json_encode(array('ERROR'=>'Error interno pasarela de pago, no disponible.'));
                Tools::redirectLink($url_reintento);
            case 'SUCCESS':
                if($response['transactionResponse']['state'] === 'PENDING'){
                    $orderst = 'PAYU_OS_PENDING';
                    $ordermsg='El sistema esta en espera de la confirmación de la pasarela de pago.';
                }
            
                if($response['transactionResponse']['state'] === 'APPROVED'){
                    $orderst = 'PS_OS_PAYMENT';
                    $ordermsg='La Transacción ha sido aprobada por la pasarela de pagos.';
                }

                $this->createPendingOrder(array(), 'Tarjeta_credito', $ordermsg, $orderst);

                $order = $conf->get_order($id_cart);
                $id_order = $order['id_order'];
                if($tx!=false){
                    $upd = "UPDATE "._DB_PREFIX_."log_payu SET id_order=".$id_order." WHERE id_log_payu=".$tx;
                    Db::getInstance()->execute($upd);
                }

                $page_confirmation = __PS_BASE_URI__ . 'order-confirmation.php?key=' . $customer->secure_key . '&id_cart=' . (int) $this->context->cart->id . '&id_module=105&id_order=' . (int) $order['id_order']; 
                $this->context->cookie->{'page_confirmation'} = json_encode($page_confirmation);
                Tools::redirectLink($page_confirmation);
            default:
                $conf->error_payu($id_order, $customer->id, $data, $response, 'Tarjeta_credito', $response['transactionResponse']['state'], $this->context->cart->id, $id_address); 
                $error_pay[]=array('ERROR'=>'La entidad financiera rechazo la transacción. <b>Status: '.$response['transactionResponse']['state'].'</b>.');
                $this->context->cookie->{'error_pay'} = json_encode(array('ERROR'=>'Error interno pasarela de pago, no disponible.'));
                Tools::redirectLink($url_reintento);
        }
    }
    
    public function displayContent() {
      parent::displayContent();
      self::$smarty->display(_PS_MODULE_DIR_ . 'payulatam/views/templates/front/response.tpl');
    }

}

    $cc = new  PayuCreditCard();
    $cc->process();