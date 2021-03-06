
{**
* Quotation Template
* 
* @author Empty
* @copyright  Empty
* @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*}

<table style="width: 100%;">
    <tr>
        <td style="width: 100%; font-size: 9pt; font-color: #404040;">{$before|unescape:'htmlall'}<br /><br />
            
            <table style="width: 100%" border="1" cellpadding="5">
                <thead>
                    <tr>
                        <td width="13%" valign="middle" style="font-weight: bold; color: #fff; background-color: #595959; text-align: center;">
                            Réf
                        </td>
                        <td width="41%" valign="middle" style="font-weight: bold; color: #fff; background-color: #595959; text-align: center;">
                            Désignation
                        </td>
                        <td width="6%" valign="middle" style="font-weight: bold; color: #fff; background-color: #595959; text-align: center;">
                            Qté
                        </td>
                        <td width="10%" valign="middle" style="font-weight: bold; color: #fff; background-color: #595959; text-align: center;">
                            P.U H.T
                        </td>
                        <td width="10%" valign="middle" style="font-weight: bold; color: #fff; background-color: #595959; text-align: center;">
                            Remise
                        </td>
                        <td width="10%" valign="middle" style="font-weight: bold; color: #fff; background-color: #595959; text-align: center;">
                            P.U H.T Remisé
                        </td>
                        <td width="10%" valign="middle" style="font-weight: bold; color: #fff; background-color: #595959; text-align: center;">
                            Total H.T
                        </td>
                    </tr>
                </thead>
                <tbody height="1000">
                    {foreach $products as $product}
                        <tr>
                            <td>{$product['reference']|escape:'htmlall':'UTF-8'}</td>
                            <td>{$product['name']|escape:'htmlall':'UTF-8'}{if !empty($product['features_name'])} ({$product['features_name']|escape:'htmlall':'UTF-8'}) {/if}{if !empty($product['combination'])} ({$product['combination']|escape:'htmlall':'UTF-8'}) {/if}</td>
                            <td>{$product['quantity']|escape:'htmlall':'UTF-8'}</td>
                            <td>{displayPrice price=$product['price_without_reduction']}</td>
                            <td>{displayPrice price=$product['reduction']}</td>
                            <td>{displayPrice price=$product['price']}</td>
                            <td>{displayPrice price=$product['total']}</td>
                        </tr>
                    {/foreach}
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3" rowspan="4">&nbsp;</td>
                        <td colspan="3">SOUS-TOTAL H.T</td>
                        <td>{displayPrice price=$cart_info['total_products']}</td>
                    </tr>
                    <tr>
                        <td colspan="3">FRAIS DE PORT</td>
                        <td>{displayPrice price=$cart_info['total_shipping_tax_exc']}</td>
                    </tr>
                    <tr>
                        <td colspan="3">TVA 20%</td>
                        <td>{displayPrice price=$cart_info['total_tax']}</td>
                    </tr>
                    <tr>
                        <td colspan="3" style="font-weight: bold; color: #fff; background-color: #595959;">TOTAL T.T.C</td>
                        <td>{displayPrice price=$cart_info['total_price']}</td>
                    </tr>
                </tfoot>
            </table>
            {$after|unescape:'htmlall'}{* HTML CONTENT *}
        </td>
    </tr>
</table>

