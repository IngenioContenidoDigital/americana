<?php

require_once(_PS_ROOT_DIR_.'/modules/mercadopago/sdk/vendor/autoload.php');

class MercadoPagoPseModuleFrontController extends ModuleFrontController{
    
    public function initContent(){
        parent::initContent();
        
        MercadoPago\SDK::setAccessToken(Configuration::get('MERCADOPAGO_ACCESS_TOKEN'));
        
        $currency = new Currency($this->context->cart->id_currency);
    
        $payment = new MercadoPago\Payment();
        $payment->transaction_amount = $this->context->cart->getOrderTotal();
        $payment->description = 'Americana_' . (int)$this->context->cart->id;
        $payment->external_reference = 'Americana_' . (int)$this->context->cart->id;
        $payment->payment_method_id = 'pse';
        $payment->payer = array(
            "email" => $this->context->customer->email,
            "identification" => array(
                "type" => Tools::getValue('docType1'),
                "number" => Tools::getValue('docNumber1')
            ),
            "first_name" => $this->context->customer->firstname,
            "last_name" => $this->context->customer->lastname,
            "entity_type" => Tools::getValue('entity_type')
        );
        $payment->additional_info = array(
            "ip_address" => $_SERVER['REMOTE_ADDR']
        );
        $payment->transaction_details = array(
            "financial_institution" => (int)Tools::getValue('banks')
        );
        $payment->callback_url = _PS_BASE_URL_.'/modules/mercadopago/controllers/front/response.php';
        
        $result = $payment->save();
        $status = $result['body']['status'];
        $redirect_url = $result['body']['transaction_details']['external_resource_url'];
        if(($redirect_url=='') || ($redirect_url == NULL) || !isset($redirect_url)) $redirect_url = '/index.php?controller=history';
        
        $mercadopago = new MercadoPago();
        switch($status){
            case 'approved':
                $order_state ="PS_OS_PAYMENT";
                $mensaje="El Pago ha sido aprobado y acreditado";
                break;
            case 'pending' || 'authorized' || 'in_process':
                $order_state ="MERCADOPAGO_PENDING";
                $mensaje ="El Pago se encuentra Pendiente de Validación";
                break;
            case 'rejected':
                 $order_state ="MERCADOPAGO_REJECTED";
                $mensaje ="El Pago ha sido rechazado.";
                break;
            default:
                $order_state ="MERCADOPAGO_FAILED";
                $mensaje ="El proceso de pago ha fallado.";
                break;                
        }
        
        $mercadopago->validateOrder($this->context->cart->id, (int)Configuration::get($order_state), $this->context->cart->getOrderTotal(), 'Mercadopago_PSE', $mensaje, NULL, NULL, false, false);
        
        Tools::redirect($redirect_url);
    }
    
}
