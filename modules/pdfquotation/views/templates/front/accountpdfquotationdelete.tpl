
{**
* AccountPdfQuotationDelete Template
* 
* @author Empty
* @copyright  Empty
* @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*}

{capture name=path}<a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">{l s='My account' mod='pdfquotation'}</a><span class="navigation-pipe">{$navigationPipe}</span><span class="navigation_page">{l s='My Quotations' mod='pdfquotation'}</span>{/capture}

<h1 class="page-heading">{l s='My Quotations' mod='pdfquotation'}</h1>
<p>{l s='Are you sure, you want to delete this quotation' mod='pdfquotation'} : {$quotationObj->ref_quotation|escape:'html':'UTF-8'}?</p>

<div id="action-quotation">
    <a class="cancel-quotation btn btn-default button button-medium exclusive" href="{$link->getModuleLink('pdfquotation', 'accountpdfquotation', ['action' => 'index'])|escape:'html':'UTF-8'}">
        <span>{l s='Cancel' mod='pdfquotation'}</span>
    </a>
    <a class="validate-quotation btn btn-default button red button-medium" href="{$link->getModuleLink('pdfquotation', 'accountpdfquotation', ['action' => 'deleteConfirm', 'id_quotation' => $quotationObj->id_quotation])|escape:'html':'UTF-8'}">
        <span>{l s='Validate' mod='pdfquotation'}</span>
    </a>
</div>