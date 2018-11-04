
{**
* AccountPdfQuotationIndex Template
* 
* @author Empty
* @copyright  Empty
* @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*}

{capture name=path}<a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}">{l s='My account' mod='pdfquotation'}</a><span class="navigation-pipe">{$navigationPipe|escape:'html':'UTF-8'}</span><span class="navigation_page">{l s='My Quotations' mod='pdfquotation'}</span>{/capture}

<h1 class="page-heading">{l s='My Quotations' mod='pdfquotation'}</h1>
<p>{l s='You find here a page who permit to manage all your quotation' mod='pdfquotation'}</p><br />

{if $errors}
    <div class="error alert alert-danger">
        {foreach from=$errors item=error}
            <p>{$error|escape:'html':'UTF-8'}</p>
        {/foreach} 
    </div>
{/if}

{if $messages}
    <div class="warning alert alert-warning">
        {foreach from=$messages item=message}
            <p>{$message|escape:'html':'UTF-8'}</p>
        {/foreach} 
    </div>
{/if}

    
{if $quotationList}
    <table id="quotation-list" class="std table table-bordered footab default footable-loaded footable">
        <thead>
            <tr>
                <th>{l s='Reference' mod='pdfquotation'}</th>
                <th>{l s='Products' mod='pdfquotation'}</th>
                <th>{l s='Total' mod='pdfquotation'}</th>
                <th>{l s='Date Add' mod='pdfquotation'}</th>
                <th>{l s='Action' mod='pdfquotation'}</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$quotationList item=quotation}
                <tr>
                    <td>{$quotation.ref_quotation|escape:'html':'UTF-8'}</td>
                    <td>
                        <ul>
                            {foreach from=$quotation.products item=product}
                                <li>- <strong>{$product.name|escape:'html':'UTF-8'}</strong> ({$product.attributes|escape:'html':'UTF-8'})</li>
                            {/foreach}
                        </ul>
                    </td>
                    <td>{$quotation.total|escape:'html':'UTF-8'}</td>
                    <td>{$quotation.date_add|escape:'html':'UTF-8'}</td>
                    <td>
                        <a class="btn btn-default button button-small" href="{$link->getModuleLink('pdfquotation', 'accountpdfquotation', ['action' => 'see', 'id_quotation' => $quotation.id_quotation])|escape:'html':'UTF-8'}">
                            <span>
                                {l s='See Quotation' mod='pdfquotation'}
                                <i class="icon-chevron-right right"></i>
                            </span>
                        </a>&nbsp;&nbsp;
                        <a class="btn btn-default button button-small" href="{$link->getModuleLink('pdfquotation', 'accountpdfquotation', ['action' => 'delete', 'id_quotation' => $quotation.id_quotation])|escape:'html':'UTF-8'}">
                            <span>
                                {l s='Delete Quotation' mod='pdfquotation'}
                                <i class="icon-chevron-right right"></i>
                            </span>
                        </a>&nbsp;&nbsp;
                        <a class="btn btn-default button button-small" href="{$link->getModuleLink('pdfquotation', 'accountpdfquotation', ['action' => 'add', 'id_quotation' => $quotation.id_quotation])|escape:'html':'UTF-8'}">
                            <span>
                                {l s='Add Product to cart' mod='pdfquotation'}
                                <i class="icon-chevron-right right"></i>
                            </span>
                        </a>&nbsp;&nbsp;
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
{/if}

<script type="text/javascript">
    ajaxCart.refresh();
</script>
