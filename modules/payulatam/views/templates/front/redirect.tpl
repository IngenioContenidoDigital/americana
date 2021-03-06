<style>
	.payu-button {
cursor:pointer;
    background-image: url("./img/payu-btn.gif");
    background-position: center top;
    background-repeat: repeat-x;
    border-radius: 4px 4px 4px 4px;
    color: #FFFFFF;
    font-size: 16px;
    height: 45px;
    line-height: 45px;
    text-align: center;
    text-shadow: 0 1px 1px #1B5C8B;
    vertical-align: middle;
    width: 280px;
}
.payu-button:hover, a.payu-button:active { background-position: center bottom; color: #FFF; text-decoration: none; }

</style>
<link href="{$css|escape:'htmlall':'UTF-8'}payu.css" rel="stylesheet" type="text/css">
<div class="div-redirect">
{if isset($error)}
<p class="md-error">{l s='An error occured, please try again later.' mod='payulatam'}</p>
{else}
<p class="tx-redirect">{l s='You are going to be redirected to PayU\'s website for your payment.' mod='payulatam'}</p>
<form action="{$formLink|escape:'htmlall':'UTF-8'}" method="POST" id="formPayU">
  {foreach from=$payURedirection item=value}
  <input type="hidden" value="{$value.value|escape:'htmlall':'UTF-8'}" name="{$value.name|escape:'htmlall':'UTF-8'}"/>
  {/foreach}
  <input class="payu-button" id="payuSubmit" type="button" value="{l s='Please click here' mod='payulatam'}" />
</form>
</div>
{literal}
<script type="text/javascript">
$('#payuSubmit').click(
  function()
  {
    $.ajax(
	{
	    type : 'GET',
	    url : './payment.php?create-pending-order',
	    dataType: 'html',
	    success: function(data)
	    {
	    	$('#formPayU').submit();
	    }
	});

  }
);
</script>
{/literal}
{/if}
