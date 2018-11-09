<?php

if (!defined('_PS_VERSION_'))
	exit;

require_once(_PS_ROOT_DIR_.'/modules/mercadopago/sdk/vendor/autoload.php');

class MercadoPago extends PaymentModuleCore {

public function __construct(){
	$this->name = 'mercadopago';
	$this->tab = 'payments_gateways';
	$this->version = '1.0.0';
	$this->author = 'Ingenio Contenido Digital SAS';
	$this->need_instance = 0;
	$this->currencies = true;
	$this->currencies_mode = 'checkbox';
	parent::__construct();

	$this->displayName = $this->l('Integracion API Mercadopago');
	$this->description = $this->l('Pagos a través de Mercadopago sin Salir de tu pagina Web');

	$this->confirmUninstall = $this->l('Seguro quieres desinstalar el modulo?');

}

public function install(){
        $this->_createStates();
        $this->_saveConfiguration();
	if (!parent::install()
		|| !$this->registerHook('payment')
		|| !$this->registerHook('paymentReturn'))
		return false;
	return true;
}

public function uninstall(){
	if (!parent::uninstall() 
                || !Configuration::deleteByName('MERCADOPAGO_PUBLIC_KEY')
                || !Configuration::deleteByName('MERCADOPAGO_ACCESS_TOKEN')
                || !Configuration::deleteByName('MERCADOPAGO_TEST'))
		return false;
	return true;
}

public function hookPayment($params){
    if (!$this->active)
        return;
    
    $this->context->controller->addJquery();
    $this->context->controller->addJqueryUI('ui.accordion');
    $this->context->controller->addJS('https://secure.mlstatic.com/sdk/javascript/v1/mercadopago.js');
    $this->context->controller->addJS(_PS_MODULE_DIR_.'mercadopago/js/mercadopago.js');
    $this->context->controller->addCSS(_PS_MODULE_DIR_.'mercadopago/css/mercadopago.css');
    $this->context->smarty->assign('email',$this->context->customer->email);
    $this->context->smarty->assign('customer',$this->context->customer->firstname.' '.$this->context->customer->lastname);
    $this->context->smarty->assign('public',Configuration::get('MERCADOPAGO_PUBLIC_KEY'));
    MercadoPago\SDK::setAccessToken(Configuration::get('MERCADOPAGO_ACCESS_TOKEN'));
    $payment_methods = MercadoPago\SDK::get("/v1/payment_methods");
    $banks = array();
    foreach($payment_methods['body'] as $value){
        if ($value['id']=='pse'){
            foreach($value['financial_institutions'] as $banco){
                array_push($banks, array('id' => $banco['id'], 'description' => $banco['description']));
            }
        }
    }
    $this->context->smarty->assign('banks',$banks);
    return $this->display(__FILE__, 'views/templates/hook/mercadopago.tpl');
}

private function _saveConfiguration(){
    Configuration::updateValue('MERCADOPAGO_PUBLIC_KEY', 'APP_USR-78f7b97a-213f-46ab-87c5-02cbbc331789');
    Configuration::updateValue('MERCADOPAGO_ACCESS_TOKEN', 'APP_USR-1245382542995241-101614-876137f3648d5f59d4823e2ca18341da-331950504');
    Configuration::updateValue('MERCADOPAGO_LIVE', 1);
}

private function _testConfiguration(){
    Configuration::updateValue('MERCADOPAGO_PUBLIC_KEY', 'TEST-9fded50a-4c41-4fef-9d30-53ad504b3f65');
    Configuration::updateValue('MERCADOPAGO_ACCESS_TOKEN', 'TEST-1245382542995241-101614-6b0708d18fbb4d8e703b0c330c12b9c2-331950504');
    Configuration::updateValue('MERCADOPAGO_LIVE', 0);
}

private function _createStates(){
	if (!Configuration::get('MERCADOPAGO_PENDING'))
	{
		$order_state = new OrderState();
		$order_state->name = array();
		foreach (Language::getLanguages() as $language)
			$order_state->name[$language['id_lang']] = 'Pending';

		$order_state->send_email = false;
		$order_state->color = '#FEFF64';
		$order_state->hidden = false;
		$order_state->delivery = false;
		$order_state->logable = false;
		$order_state->invoice = false;

		if ($order_state->add())
		{
			$source = dirname(__FILE__).'/img/logo.jpg';
			$destination = dirname(__FILE__).'/../../img/os/'.(int)$order_state->id.'.gif';
			copy($source, $destination);
		}
		Configuration::updateValue('MERCADOPAGO_PENDING', (int)$order_state->id);
	}

	if (!Configuration::get('MERCADOPAGO_FAILED'))
	{
		$order_state = new OrderState();
		$order_state->name = array();
		foreach (Language::getLanguages() as $language)
			$order_state->name[$language['id_lang']] = 'Failed Payment';

		$order_state->send_email = false;
		$order_state->color = '#8F0621';
		$order_state->hidden = false;
		$order_state->delivery = false;
		$order_state->logable = false;
		$order_state->invoice = false;

		if ($order_state->add())
		{
			$source = dirname(__FILE__).'/img/logo.jpg';
			$destination = dirname(__FILE__).'/../../img/os/'.(int)$order_state->id.'.gif';
			copy($source, $destination);
		}
		Configuration::updateValue('MERCADOPAGO_FAILED', (int)$order_state->id);
	}

	if (!Configuration::get('MERCADOPAGO_REJECTED'))
	{
		$order_state = new OrderState();
		$order_state->name = array();
		foreach (Language::getLanguages() as $language)
			$order_state->name[$language['id_lang']] = 'Rejected Payment';

		$order_state->send_email = false;
		$order_state->color = '#8F0621';
		$order_state->hidden = false;
		$order_state->delivery = false;
		$order_state->logable = false;
		$order_state->invoice = false;

		if ($order_state->add())
		{
			$source = dirname(__FILE__).'/img/logo.jpg';
			$destination = dirname(__FILE__).'/../../img/os/'.(int)$order_state->id.'.gif';
			copy($source, $destination);
		}
		Configuration::updateValue('MERCADOPAGO_REJECTED', (int)$order_state->id);
	}
}

}
?>
