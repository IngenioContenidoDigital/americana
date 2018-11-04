<?php

$useSSL = true;
require_once(dirname(__FILE__) . '/../../config/config.inc.php');
require_once(dirname(__FILE__) . '/../../init.php');
require_once('payulatam.php');
require_once('config.php');
require_once('paymentws.php');


class PayuPse extends PayUControllerWS{

    public $ssl = true;

    public function setMedia() {
        parent::setMedia();
    }

    public function process() {
        if (empty($this->context->cart->id)) {
            Tools::redirect('/');
        }

        //parent::process();

        $url_reintento=$_SERVER['HTTP_REFERER'];
        if(!strpos($_SERVER['HTTP_REFERER'], 'step=')){
          $url_reintento.='?step=3';
        }
        

        // vaciar errores en el intento de pago anterior
        if (isset($this->context->cookie->{'error_pay'})) {
            unset($this->context->cookie->{'error_pay'});
        }

        if (isset($_POST['pse_bank'])){
            $payulatam = new PayULatam();
            $params = $this->initParams();
            $conf = new ConfPayu();
            $keysPayu = $conf->keys();

            $customer = new Customer((int) $this->context->cart->id_customer);
            $id_cart = $this->context->cart->id;
            $id_address = $this->context->cart->id_address_delivery;
            $id_order = 0;

            $varRandn = $conf->randString();
            $varRandc = $conf->randString();
            setcookie($varRandn, $varRandc, time() + 900);


            $browser = array('ipAddress' => $_SERVER['SERVER_ADDR'],
                             'userAgent' => $_SERVER['HTTP_USER_AGENT']
                            );

            $addressdni = $customer->getAddresses(0);
            $billin_dni = $addressdni[0]['dni'];
            if ( $addressdni[0]['checkdigit'] != "" ) {
                $billin_dni .= "-".$addressdni[0]['checkdigit'];
            }
            $billingAddress = new Address($addressdni[0]['id_address']);

            
            $currency=$params[9]['currency'];

            $reference_code = $params[2]['referenceCode'];
            $token_orden = md5($reference_code);
            
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
                         "emailAddress"=> $customer->email
                      ]
                   ],
                   "payer"=> [
                      "fullName"=> $customer->firstname.' '.$customer->lastname,
                      "emailAddress"=> $customer->email,
                      "contactPhone"=> ((!empty($address->phone_mobile)) ? $address->phone_mobile : $address->phone)
                   ],
                   "extraParameters"=> [
                      "RESPONSE_URL"=> _PS_BASE_URL_."/response",
                      "PSE_REFERENCE1"=> $_SERVER['REMOTE_ADDR'],
                      "FINANCIAL_INSTITUTION_CODE"=> Tools::getValue('pse_bank'),
                      "USER_TYPE"=> Tools::getValue('pse_tipoCliente'),
                      "PSE_REFERENCE2"=> Tools::getValue('pse_docType'),
                      "PSE_REFERENCE3"=> Tools::getValue('pse_docNumber')
                   ],
                   "type"=> "AUTHORIZATION_AND_CAPTURE",
                   "paymentMethod"=> "PSE",
                   "paymentCountry"=> $this->context->country->iso_code,
                   "ipAddress"=> $_SERVER['REMOTE_ADDR'],
                   "cookie"=> md5($this->context->cookie->timestamp),
                   "userAgent"=> $_SERVER['HTTP_USER_AGENT']
                ],
                "test"=> false
             ];

            $response = $conf->sendJson(json_encode($request));
            
            $tx = $conf->logTransaction($id_cart, json_encode($request), json_encode($response));
            
            switch ($response['code']){
                case 'ERROR':
                    $conf->error_payu($id_order, $customer->id, $data, $response, 'PSE', $response['transactionResponse']['state'], $this->context->cart->id, $id_address);
                    $error_pay[]=$response;
                    $this->context->cookie->{'error_pay'} = json_encode(array('ERROR'=>'Error interno pasarela de pago, no disponible.'));
                    Tools::redirectLink($url_reintento); 
                case 'SUCCESS':
                    if ($response['transactionResponse']['state'] === 'PENDING'){
                    $orderst = 'PAYU_OS_PENDING';
                    $ordermsg='El sistema esta en espera de la confirmación de la pasarela de pago.';
                }
                
                if($response['transactionResponse']['state'] === 'APPROVED'){
                    $orderst = 'PAYU_OS_PAYMENT';
                    $ordermsg='La Transacción ha sido aprobada por la pasarela de pagos.';
                }
                //$response['transactionResponse']['responseCode']
                
                $this->createPendingOrder(array(), 'PSE',$ordermsg, $orderst);
                $order = $conf->get_order($id_cart);
                $id_order = $order['id_order'];
                //$conf->pago_payu($id_order, $customer->id, $data, $response, 'Pse',$response['code'], $id_cart, $id_address);
                //$url_base64 = strtr(base64_encode($response['transactionResponse']['extraParameters']['BANK_URL']), '+/=', '-_,');
                //$url_base64 = $response['transactionResponse']['extraParameters']['entry']['0']['string']['1'];
                //$string_send = __PS_BASE_URI__ . 'order-confirmation.php?key=' . $customer->secure_key . '&id_cart=' . (int) $id_cart . '&id_module='.(int)$payulatam->id.'&id_order=' . (int) $order['id_order'] . '&bankdest2=' . $url_base64;
                //$conf->url_confirm_payu($token_orden,__PS_BASE_URI__ . 'order-confirmation.php?key=' . $customer->secure_key . '&id_cart=' . (int) $id_cart . '&id_module='.(int)$payulatam->id.'&id_order=' . (int) $order['id_order']);
                
                if($tx!=false){
                    $upd = "UPDATE "._DB_PREFIX_."log_payu SET id_order=".$id_order." WHERE id_log_payu=".$tx;
                    Db::getInstance()->execute($upd);
                }
                
                Tools::redirectLink($response['transactionResponse']['extraParameters']['entry']['0']['string']['1']);
                default:
                    $this->context->cookie->{'error_pay'} = json_encode(array('ERROR'=>'Valida tus datos he intenta de nuevo.'));
                    Tools::redirectLink($url_reintento);
            }
            

        }
    }

    public function displayContent() {
        parent::displayContent();
        self::$smarty->display(_PS_MODULE_DIR_ . 'payulatam/tpl/success.tpl');
    }
}

$payuPse = new PayuPse();
$payuPse->run();
