<?php
/*
* 2007-2016 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Open Software License (OSL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/osl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2016 PrestaShop SA
*  @license    http://opensource.org/licenses/osl-3.0.php  Open Software License (OSL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*/

class AddressController extends AddressControllerCore
{
    /**
     * Assign template vars related to page content
     * @see FrontController::initContent()
     */
    public function initContent()
    {
        //parent::initContent();

        $this->assignCountries();
        $this->assignVatNumber();
        $this->assignAddressFormat();

        // Assign common vars
        $this->context->smarty->assign(array(
            'address_validation' => Address::$definition['fields'],
            'one_phone_at_least' => (int)Configuration::get('PS_ONE_PHONE_AT_LEAST'),
            'onr_phone_at_least' => (int)Configuration::get('PS_ONE_PHONE_AT_LEAST'), //retro compat
            'ajaxurl' => _MODULE_DIR_,
            'errors' => $this->errors,
            'token' => Tools::getToken(false),
            'select_address' => (int)Tools::getValue('select_address'),
            'address' => $this->_address,
            'id_address' => (Validate::isLoadedObject($this->_address)) ? $this->_address->id : 0
        ));

        if ($back = Tools::getValue('back')) {
            $this->context->smarty->assign('back', Tools::safeOutput($back));
        }
        if ($mod = Tools::getValue('mod')) {
            $this->context->smarty->assign('mod', Tools::safeOutput($mod));
        }
        if (isset($this->context->cookie->account_created)) {
            $this->context->smarty->assign('account_created', 1);
            unset($this->context->cookie->account_created);
        }

        $this->setTemplate(_PS_THEME_DIR_.'address.tpl');
    }

}
