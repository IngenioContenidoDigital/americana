<?php
/**
* Class AdminPdfQuotationController
* 
* @author    Empty
* @copyright Empty
* @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*/

class AdminPdfQuotationController extends ModuleAdminController {
    
    /**
	 * AdminController::__construct() override
	 * @see AdminController::__construct()
	 */
    public function __construct() {
 
        $this->table = 'quotation';
        $this->bootstrap = true;
        $this->lang = false;
        $this->className = 'QuotationObject';
        $this->identifier = 'id_quotation';
        $this->context = Context::getContext();

        $this->addRowAction('previewQuotation');
        $this->addRowAction('previewCart');

        $this->_defaultOrderBy = 'id_quotation';
        $this->position_identifier = 'id_quotation';

        $this->fields_list = array(
			'id_quotation' => array(
				'title'   => $this->l('Id'),
                'width' => 50,
			), 
            'ref_quotation' => array(
                'title' => $this->l('Ref Quotation'),
            ),
			'first_name' => array(
				'title' => $this->l('First Name'),
			),
            'last_name' => array(
                'title' => $this->l('Last Name'),
            ),
            'email' => array(
                'title' => $this->l('Email'),
            ),
			'phone' => array(
				'title' 	=> $this->l('Phone'),
                'orderby' => false,
			),
            'contacted' => array(
                'title' 	=> $this->l('To be contacted again'),
                'width' => 50,
                'callback' => 'printStatusText',
                'orderby' => false,
                'type' => 'bool'
            ),
            'deleted' => array(
                'title' 	=> $this->l('Deleted by customer'),
                'width' => 50,
                //'callback' => 'printStatusText',
                'active' => 'deleted',
                'orderby' => false,
                'type' => 'bool'
            ),
            'date_add' => array(
                'title' => $this->l('Date'),
                'align' => 'text-right',
                'type' => 'datetime',
                'filter_key' => 'a!date_add'
            )
		);
        
        parent:: __construct();
    }

    public function printStatusText($echo, $row)
    {
        if ($echo == 0) {
            return $this->l('No');
        }
        else {
            return $this->l('Yes');
        }
    }

    public function displayPreviewQuotationLink($token = null, $id, $name = null)
    {
        $shop = new Shop(Context::getContext()->shop->id);
        $quotationObj = new QuotationObject($id);
        return '<a target="_blank" href="'.$shop->getBaseURL().'img/quotation/'.$quotationObj->ref_quotation.'.pdf">'.$this->l('See Quotation')."</a>";
    }

    public function displayPreviewCartLink($token = null, $id, $name = null)
    {
        $link = new Link();
        $quotationObj = new QuotationObject($id);
        return '<a href="'.$link->getAdminLink("AdminCarts").'&id_cart='.$quotationObj->id_cart.'&viewcart">'.$this->l('See Cart').'</a>';
    }
}
