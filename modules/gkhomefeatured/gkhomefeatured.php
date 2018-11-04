<?php

/*
 * 2007-2015 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
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
 *  @copyright  2007-2015 PrestaShop SA
 *  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *  International Registered Trademark & Property of PrestaShop SA
 */

if (!defined('_PS_VERSION_'))
    exit;

class GKHomeFeatured extends Module {

    protected static $cache_products;

    public function __construct() {
        $this->name = 'gkhomefeatured';
        $this->tab = 'front_office_features';
        $this->version = '1.8.0';
        $this->author = 'PrestaShop';
        $this->need_instance = 0;

        $this->bootstrap = true;
        parent::__construct();

        $this->displayName = $this->l('Featured products on the homepage');
        $this->description = $this->l('Displays featured products in the central column of your homepage.');
    }

    public function install() {
        $this->_clearCache('*');
        Configuration::updateValue('GKHOME_FEATURED_NBR', 5);

        if (!parent::install() || !$this->registerHook('gkhomefeatured') || !$this->registerHook('header')
        )
            return false;

        return true;
    }

    public function uninstall() {
        $this->_clearCache('*');

        return parent::uninstall();
    }

    public function getContent() {
        $output = '';
        $errors = array();
        if (Tools::isSubmit('submitGKHomeFeatured')) {
            $nbr = Tools::getValue('GKHOME_FEATURED_NBR');
            if (!Validate::isInt($nbr) || $nbr <= 0)
                $errors[] = $this->l('The number of products is invalid. Please enter a positive number.');

            if (isset($errors) && count($errors))
                $output = $this->displayError(implode('<br />', $errors));
            else {
                Configuration::updateValue('GKHOME_FEATURED_NBR', (int) $nbr);
                Tools::clearCache(Context::getContext()->smarty, $this->getTemplatePath('gkhomefeatured.tpl'));
                $output = $this->displayConfirmation($this->l('Your settings have been updated.'));
            }
        }

        return $output . $this->renderForm();
    }

    public function hookDisplayHeader($params) {
        $this->hookHeader($params);
    }

    public function hookHeader($params) {
        if (isset($this->context->controller->php_self) && $this->context->controller->php_self == 'index')
            $this->context->controller->addCSS(_THEME_CSS_DIR_ . 'product_list.css');
        $this->context->controller->addCSS(($this->_path) . 'css/gkhomefeatured.css', 'all');
    }

    public function _cacheProducts($params) {
        if (!isset(GKHomeFeatured::$cache_products)) {
            $nb = (int) Configuration::get('GKHOME_FEATURED_NBR');

            $gk_more_views = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS('SELECT * FROM ' . _DB_PREFIX_ . 'gkfeatured ORDER BY views DESC LIMIT 0,5');
            $productsViewed = array();

            foreach($gk_more_views as $gkmv) {
                $productsViewed[] = $gkmv['id_product'];                
            }
            //$productsViewed = (isset($params['cookie']->viewed) && !empty($params['cookie']->viewed)) ? array_slice(array_reverse(explode(',', $params['cookie']->viewed)), 0, $nb) : array();

            if (count($productsViewed)) {
                $defaultCover = Language::getIsoById($params['cookie']->id_lang) . '-default';

                $productIds = implode(',', array_map('intval', $productsViewed));
                $productsImages = Db::getInstance(_PS_USE_SQL_SLAVE_)->executeS('
			SELECT MAX(image_shop.id_image) id_image, p.id_product, il.legend, product_shop.active, pl.name, pl.description_short, pl.link_rewrite, cl.link_rewrite AS category_rewrite
			FROM ' . _DB_PREFIX_ . 'product p
			' . Shop::addSqlAssociation('product', 'p') . '
			LEFT JOIN ' . _DB_PREFIX_ . 'product_lang pl ON (pl.id_product = p.id_product' . Shop::addSqlRestrictionOnLang('pl') . ')
			LEFT JOIN ' . _DB_PREFIX_ . 'image i ON (i.id_product = p.id_product)' .
                        Shop::addSqlAssociation('image', 'i', false, 'image_shop.cover=1') . '
			LEFT JOIN ' . _DB_PREFIX_ . 'image_lang il ON (il.id_image = image_shop.id_image AND il.id_lang = ' . (int) ($params['cookie']->id_lang) . ')
			LEFT JOIN ' . _DB_PREFIX_ . 'category_lang cl ON (cl.id_category = product_shop.id_category_default' . Shop::addSqlRestrictionOnLang('cl') . ')
			WHERE p.id_product IN (' . $productIds . ')
			AND pl.id_lang = ' . (int) ($params['cookie']->id_lang) . '
			AND cl.id_lang = ' . (int) ($params['cookie']->id_lang) . '
			GROUP BY product_shop.id_product'
                );

                $productsImagesArray = array();
                foreach ($productsImages as $pi)
                    $productsImagesArray[$pi['id_product']] = $pi;

                $productsViewedObj = array();
                foreach ($productsViewed as $productViewed) {
                    $obj = (object) 'Product';
                    if (!isset($productsImagesArray[$productViewed]) || (!$obj->active = $productsImagesArray[$productViewed]['active']))
                        continue;
                    else {
                        $obj->id = (int) ($productsImagesArray[$productViewed]['id_product']);
                        $obj->id_image = (int) $productsImagesArray[$productViewed]['id_image'];
                        $obj->cover = (int) ($productsImagesArray[$productViewed]['id_product']) . '-' . (int) ($productsImagesArray[$productViewed]['id_image']);
                        $obj->legend = $productsImagesArray[$productViewed]['legend'];
                        $obj->name = $productsImagesArray[$productViewed]['name'];
                        $obj->description_short = $productsImagesArray[$productViewed]['description_short'];
                        $obj->link_rewrite = $productsImagesArray[$productViewed]['link_rewrite'];
                        $obj->category_rewrite = $productsImagesArray[$productViewed]['category_rewrite'];
                        // $obj is not a real product so it cannot be used as argument for getProductLink()
                        $obj->product_link = $this->context->link->getProductLink($obj->id, $obj->link_rewrite, $obj->category_rewrite);

                        if (!isset($obj->cover) || !$productsImagesArray[$productViewed]['id_image']) {
                            $obj->cover = $defaultCover;
                            $obj->legend = '';
                        }
                        $productsViewedObj[] = $obj;
                    }
                }

                GKHomeFeatured::$cache_products = $productsViewedObj;
            }
//            HomeFeatured::$cache_products = $category->getProducts((int) Context::getContext()->language->id, 1, ($nb ? $nb : 8), 'position');
        }

        if (GKHomeFeatured::$cache_products === false || empty(GKHomeFeatured::$cache_products))
            return false;
    }

    public function hookDisplayHomeTab($params) {
        return $this->hookDisplayHome($params);
    }

    public function hookDisplayHome($params) {
        $this->_clearCache('*');
        parent::_clearCache('gkhomefeatured.tpl');
        parent::_clearCache('gktab.tpl', 'gkhomefeatured-tab');

        if (isset($_GET['id_product']) && !empty($_GET['id_product']) && isset($_GET['controller']) && $_GET['controller'] == 'product') {
  		//die('seee' .  $_GET['id_product']);
            $id_p = (int) $_GET['id_product'];

            if (!$dats = Db::getInstance()->getRow('SELECT * FROM ' . _DB_PREFIX_ . 'gkfeatured WHERE id_product = ' . pSQL($id_p))) {
                Db::getInstance()->executeS('INSERT INTO ' . _DB_PREFIX_ . 'gkfeatured VALUES(' . pSQL($id_p) . ', 1)');
            } else {
                Db::getInstance()->executeS('UPDATE ' . _DB_PREFIX_ . 'gkfeatured SET views = ' . ((int) $dats['views'] + 1) . ' WHERE id_product = ' . pSQL($id_p));
            }
        }

        if (!$this->isCached('gkhomefeatured.tpl', $this->getCacheId()) || true) {
            $this->_cacheProducts($params);
            $this->smarty->assign(
                    array(
                        'productsViewedObj' => GKHomeFeatured::$cache_products,
                        'add_prod_display' => Configuration::get('PS_ATTRIBUTE_CATEGORY_DISPLAY'),
                        'homeSize' => Image::getSize(ImageType::getFormatedName('home')),
                    )
            );
        }

        return $this->display(__FILE__, 'gkhomefeatured.tpl', $this->getCacheId());
    }

    public function hookDisplayHomeTabContent($params) {
        return $this->hookDisplayHome($params);
    }

    public function hookAddProduct($params) {
        $this->_clearCache('*');
    }

    public function hookGkhomefeatured($params) {
        return $this->hookDisplayHome($params);
    }

    public function hookUpdateProduct($params) {
        $this->_clearCache('*');
    }

    public function hookDeleteProduct($params) {
        $this->_clearCache('*');
    }

    public function hookCategoryUpdate($params) {
        $this->_clearCache('*');
    }

    public function _clearCache($template, $cache_id = NULL, $compile_id = NULL) {
        parent::_clearCache('gkhomefeatured.tpl');
        parent::_clearCache('gktab.tpl', 'gkhomefeatured-tab');
    }

    public function renderForm() {
        $fields_form = array(
            'form' => array(
                'legend' => array(
                    'title' => $this->l('Settings'),
                    'icon' => 'icon-cogs'
                ),
                'description' => $this->l('To add products to your homepage, simply add them to the corresponding product category (default: "Home").'),
                'input' => array(
                    array(
                        'type' => 'text',
                        'label' => $this->l('Number of products to be displayed'),
                        'name' => 'GKHOME_FEATURED_NBR',
                        'class' => 'fixed-width-xs',
                        'desc' => $this->l('Set the number of products that you would like to display on homepage (default: 8).'),
                    )
                ),
                'submit' => array(
                    'title' => $this->l('Save'),
                )
            ),
        );

        $helper = new HelperForm();
        $helper->show_toolbar = false;
        $helper->table = $this->table;
        $lang = new Language((int) Configuration::get('PS_LANG_DEFAULT'));
        $helper->default_form_language = $lang->id;
        $helper->allow_employee_form_lang = Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG') ? Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG') : 0;
        $this->fields_form = array();
        $helper->id = (int) Tools::getValue('id_carrier');
        $helper->identifier = $this->identifier;
        $helper->submit_action = 'submitGKHomeFeatured';
        $helper->currentIndex = $this->context->link->getAdminLink('AdminModules', false) . '&configure=' . $this->name . '&tab_module=' . $this->tab . '&module_name=' . $this->name;
        $helper->token = Tools::getAdminTokenLite('AdminModules');
        $helper->tpl_vars = array(
            'fields_value' => $this->getConfigFieldsValues(),
            'languages' => $this->context->controller->getLanguages(),
            'id_language' => $this->context->language->id
        );

        return $helper->generateForm(array($fields_form));
    }

    public function getConfigFieldsValues() {
        return array(
            'GKHOME_FEATURED_NBR' => Tools::getValue('GKHOME_FEATURED_NBR', (int) Configuration::get('GKHOME_FEATURED_NBR')),
        );
    }

}

