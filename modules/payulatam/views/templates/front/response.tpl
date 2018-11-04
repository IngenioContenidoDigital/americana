<!--<link rel="stylesheet" href="{$css_dir}global.css" type="text/css" media="all">
<link href="{$css|escape:'htmlall':'UTF-8'}payu.css" rel="stylesheet" type="text/css">-->
{if $valid}
	<center>
		<table class="table-response">
			<tr align="center">
				<th colspan="2"><h1 class="md-h1">{l s='Purchase Data' mod='payulatam'}</h1></th>
			</tr>
			<tr align="left">
				<td>{l s='Transaction State' mod='payulatam'}</td>
				<td>{$estadoTx|escape:'htmlall':'UTF-8'}</td>
			</tr>
			<tr align="left">
				<td>{l s='Transaction ID' mod='payulatam'}</td>
				<td>{$transactionId|escape:'htmlall':'UTF-8'}</td>
			</tr>		
			<tr align="left">
				<td>{l s='Purchase Reference' mod='payulatam'}</td>
				<td>{$reference_pol|escape:'htmlall':'UTF-8'}</td>
			</tr>		
			<tr align="left">
				<td>{l s='Transaction Reference' mod='payulatam'}</td>
				<td>{$referenceCode|escape:'htmlall':'UTF-8'}</td>
			</tr>	
			{if $pseBank!=null}
				<tr align="left">
					<td>CUS</td>
					<td>{$cus|escape:'htmlall':'UTF-8'}</td>
				</tr>
				<tr align="left">
					<td>{l s='Bank' mod='payulatam'}</td>
					<td>{$pseBank|escape:'htmlall':'UTF-8'}</td>
				</tr>
			{/if}
			<tr align="left">
				<td>{l s='Total Value' mod='payulatam'}</td>
				<td>${$value|escape:'htmlall':'UTF-8'}</td>
			</tr>
			<tr align="left">
				<td>{l s='Currency' mod='payulatam'}</td>
				<td>{$currency|escape:'htmlall':'UTF-8'}</td>
			</tr>
			<tr align="left">
				<td>{l s='Description' mod='payulatam'}</td>
				<td>{$description|escape:'htmlall':'UTF-8'}</td>
			</tr>
			<tr align="left">
				<td>{l s='Entity' mod='payulatam'}</td>
				<td>{$lapPaymentMethod|escape:'htmlall':'UTF-8'}</td>
			</tr>
		</table>
		<p/>
		<h1>{$messageApproved|escape:'htmlall':'UTF-8'}</h1>
	</center>
{else}
	<h1><center>{l s='The request is incorrect! There is an error in the digital signature.' mod='payulatam'}</center></h1>
        <br>
{/if}