<?php

require_once(_PS_ROOT_DIR_.'/modules/mercadopago/sdk/vendor/autoload.php');

class MercadoPagoCreditCardModuleFrontController extends ModuleFrontController{
    
    public function initContent(){
        parent::initContent();
        
        MercadoPago\SDK::setAccessToken(Configuration::get('MERCADOPAGO_ACCESS_TOKEN'));
        
        $currency = new Currency($this->context->cart->id_currency);
    
        $payment = new MercadoPago\Payment();
        $payment->transaction_amount = $this->context->cart->getOrderTotal();
        $payment->token = Tools::getValue('token');
        $payment->description = 'Americana_' . (int)$this->context->cart->id;
        $payment->installments = 1;
        $payment->issuer_id = Tools::getValue('issuer');
        $payment->payment_method_id = Tools::getValue('paymentMethodId');
        $payment->notification_url =_PS_BASE_URL_.'/modules/mercadopago/controllers/front/confirmation.php';
        $payment->external_reference = 'Americana_' . (int)$this->context->cart->id;
        $payment->statement_descriptor = 'AMER_COLC';
        $payment->payer = array(
            "email" => Tools::getValue('email'),
            "identification" => array(
                "type" => Tools::getValue('docType'),
                "number" => Tools::getValue('docNumber')
            ),
            "first_name" => $this->context->customer->firstname,
            "last_name" => $this->context->customer->lastname
        );
        
        $result = $payment->save();
        $status = $result['body']['status'];
        
        //$status = 'approved';
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
        $mercadopago->validateOrder($this->context->cart->id, (int)Configuration::get($order_state), $this->context->cart->getOrderTotal(), 'Mercadopago_TC', $mensaje, NULL, NULL, false, false);
        Tools::redirect('index.php?controller=history');
    }
    
}
