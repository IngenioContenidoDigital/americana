<?php

if (!defined('_PS_VERSION_'))
    exit;

class GKRating extends Module {

    public function __construct() {
        $this->name = 'gkrating';
        $this->tab = 'front_office_features';
        $this->need_instance = 0;

//        $this->controllers = array('guardarranking');

        $this->bootstrap = true;
        parent::__construct();

        $this->displayName = $this->l('GK Rating');
        $this->description = $this->l('Calificar con estrellas los productos.');
        $this->ps_versions_compliancy = array('min' => '1.6', 'max' => '1.6.99.99');

        $this->version = '1.0';
        $this->author = 'Grafikamos';
    }

    public function install() {
        if (Shop::isFeatureActive())
            Shop::setContext(Shop::CONTEXT_ALL);


        if (!parent::install() || !$this->registerHook(array('header', 'gkrating')))
            return false;

        return Db::getInstance()->execute('
		CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'gkrating` (
			`id` INT(10) unsigned NOT NULL,
			`total_votes` INT(10) unsigned NOT NULL default 0,
  			`total_value` INT(10) unsigned NOT NULL default 0,
			PRIMARY KEY(`id`)
		) ENGINE=' . _MYSQL_ENGINE_ . ' default CHARSET=utf8');
    }

    public function uninstall() {
        Db::getInstance()->execute('DROP TABLE ' . _DB_PREFIX_ . 'gkrating');
        return parent::uninstall();
    }

    public function hookGkrating($params) {
        if (Tools::isSubmit('gkrankingSubmitStart')) {
            ob_clean();

            if (isset($this->context->cookie->gk_rating_calified) && $this->context->cookie->gk_rating_calified == sha1($_SERVER['REMOTE_ADDR'] . '-' . $_SERVER['HTTP_REFERER'])) {
                die('Ya has calificado éste producto. Muchas gracias.');
            }
            
            $id = (int) Tools::getValue('id');
            $cal = (int) Tools::getValue('estrellas');

            $sql = 'SELECT * FROM ' . _DB_PREFIX_ . 'gkrating WHERE id = ' . $id;
            if (!$dats = Db::getInstance()->getRow($sql)) {
                $ins = 'INSERT INTO ' . _DB_PREFIX_ . 'gkrating VALUES(' . $id . ', 1, ' . $cal . ')';
                Db::getInstance()->execute($ins);
                die('Gracias por calificar nuestro producto.');
            } else {
                $estrellas = (int) $dats['total_value'] + $cal;
                $votos = (int) $dats['total_votes'] + 1;

                $upd = 'UPDATE ' . _DB_PREFIX_ . 'gkrating SET total_value = ' . $estrellas . ', total_votes = ' . $votos . ' WHERE id = ' . $id;
                Db::getInstance()->execute($upd);
                die('Gracias por calificar nuestro producto.');
            }

            $this->context->cookie->__set('gk_rating_calified', sha1($_SERVER['REMOTE_ADDR'] . '-' . $_SERVER['HTTP_REFERER']));
//            setcookie('gk_rating_calified', sha1($_SERVER['REMOTE_ADDR'] . '-' . $_SERVER['HTTP_REFERER']), time() + (86400 * 30), $_SERVER['REQUEST_URI']);
        }

        $sql = 'SELECT * FROM ' . _DB_PREFIX_ . 'gkrating WHERE id = ' . pSQL($params['product_id']);
        $product_rating = Db::getInstance()->getRow($sql);

        $calificacion_producto = 5;

        if (isset($product_rating['id']) && !empty($product_rating['id'])) {
            $calificacion_producto = floor($product_rating['total_value'] / $product_rating['total_votes']);
        }

        $this->context->smarty->assign(
                array(
                    'gk_prueba' => 'Prueba de GK Rating',
                    'gk_product_id' => $params['product_id'],
                    'gk_product_rating' => $calificacion_producto,
                )
        );

        return $this->display(__FILE__, 'gkrating.tpl');
    }

    public function hookHeader($params) {
        $this->context->controller->addCSS(($this->_path) . 'css/gkrating.css', 'all');
        $this->context->controller->addJS(($this->_path) . 'js/gkrating.js');
    }

}
