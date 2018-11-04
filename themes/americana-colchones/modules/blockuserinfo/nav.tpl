<!-- Block user information module NAV  -->
{if $is_logged}
    <div class="header_user_info">
        <a href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}" title="{l s='View my customer account' mod='blockuserinfo'}" class="account" rel="nofollow"><span>{$cookie->customer_firstname} {$cookie->customer_lastname}</span></a>
    </div>
{/if}
<div class="header_user_info">
<!--
  <a href="http://americanadecolchones.com/content/28-beneficios-mayo" rel="nofollow" title="" style="color:#ffe002"> 
        <i class="fa fa-star"></i>BENEFICIOS
    </a>-->

    {if $is_logged}
        <a class="logout" href="{$link->getPageLink('index', true, NULL, "mylogout")|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Log me out' mod='blockuserinfo'}">
            {l s='Sign out' mod='blockuserinfo'}
        </a>
    {else}
        <a class="login" href="{$link->getPageLink('my-account', true)|escape:'html':'UTF-8'}" rel="nofollow" title="{l s='Log in to your customer account' mod='blockuserinfo'}">
            <i class="fa fa-user"> </i> <span class="hidden-xs">{l s='Sign in' mod='blockuserinfo'}</span>
        </a>
    {/if}
    <a href="{$link->getPageLink($order_process, true)|escape:'html':'UTF-8'}" title="{l s='View my shopping cart' mod='blockcart'}" rel="nofollow">
        <b><i class="fa fa-shopping-cart"> </i> <span class="hidden-xs">{l s='CARRITO' mod='blockcart'}</span></b>
        {*        <span class="ajax_cart_quantity{if $cart_qties == 0} unvisible{/if}">{$cart_qties}</span>*}
        <span class="ajax_cart_product_txt{if $cart_qties != 1} unvisible{/if}">{* l s='Product' mod='blockcart' *}</span>
        <span class="ajax_cart_product_txt_s{if $cart_qties < 2} unvisible{/if}">{* l s='Products' mod='blockcart' *}</span>
        {*<span class="ajax_cart_total{if $cart_qties == 0} unvisible{/if}">
        {if $cart_qties > 0}
        {if $priceDisplay == 1}
        {assign var='blockcart_cart_flag' value='Cart::BOTH_WITHOUT_SHIPPING'|constant}
        {convertPrice price=$cart->getOrderTotal(false, $blockcart_cart_flag)}
        {else}
        {assign var='blockcart_cart_flag' value='Cart::BOTH_WITHOUT_SHIPPING'|constant}
        {convertPrice price=$cart->getOrderTotal(true, $blockcart_cart_flag)}
        {/if}
        {/if}
        </span>*}
        <span class="ajax_cart_no_product{if $cart_qties > 0} unvisible{/if}"></span>
        {if $ajax_allowed && isset($blockcart_top) && !$blockcart_top}
            <span class="block_cart_expand{if !isset($colapseExpandStatus) || (isset($colapseExpandStatus) && $colapseExpandStatus eq 'expanded')} unvisible{/if}">&nbsp;</span>
            <span class="block_cart_collapse{if isset($colapseExpandStatus) && $colapseExpandStatus eq 'collapsed'} unvisible{/if}">&nbsp;</span>
        {/if}
    </a>
    <a {if $cart_qties == 0}class="hidden"{/if} style="padding: 32px 15px 32px 15px; background: #007ab7;" href="{$link->getPageLink($order_process, true)|escape:'html':'UTF-8'}" title="{l s='View my shopping cart' mod='blockcart'}" rel="nofollow">
        <span class="ajax_cart_quantity{if $cart_qties == 0} unvisible{/if}">{$cart_qties}</span>
    </a>
</div>
<!-- /Block usmodule NAV -->
