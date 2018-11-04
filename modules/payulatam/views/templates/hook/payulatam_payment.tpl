
<style type="text/css">
    .panel-heading a:after {
       font-family: "FontAwesome";
       content: "\f078";
       float: right;
       color: grey;
    }
    .panel-heading a.collapsed:after {
        content:"\f054";
    }
    .control-label {
        text-align: left;
    }
</style>
<div class="row">
    <div class="col-xs-12">
        {if isset($errors_pay) && $errors_pay == 'true'}
            <div class="alert alert-danger">
                {foreach name=outer_p item=error_p from=$errors_msgs}
                    {foreach key=key_p item=item_p from=$error_p}
                        {$item_p}&nbsp;&nbsp; 
                    {/foreach} 
                {/foreach}
                <p>Verifica tus datos e intenta de nuevo o utiliza otro medio de pago.</p>
            </div>
        {/if} 
    </div>
    <div class="col-xs-12" style="padding-left: 0px;padding-right: 0px;">
        <div class="panel-group" id="accordion">
            <div class="panel panel-default" id="payment_creditCard">
                <div class="panel-heading" style="background:#fff;">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne"><span>Tarjeta de Cr&eacute;dito</span><img style="padding-left: 66px;" src="/modules/payulatam/img/credit_card.jpg" /></a>
                        &nbsp;
                    </h4>
                </div>
                <div id="collapseOne" class="panel-collapse collapse">
                    <div class="panel-body" style="background: #F9F9F8;">
                            {include file="$tpl_dir../../modules/payulatam/views/templates/hook/credit_card.tpl"}
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading" style="background:#fff;">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"><span>Cuenta Ahorros / Corriente</span><img style="padding-left: 5px;" src="/modules/payulatam/img/pago_pse.jpg" /></a>
                    </h4>
                </div>
                <div id="collapseTwo" class="panel-collapse collapse">
                    <div class="panel-body" style="background: #F9F9F8;">
                        <div class="container">      
                            <div class="row">
                                 <div class="col-lg-10 col-xs-12 col-sm-10 col-md-7"> 
                                    <form  method="POST" class="form-horizontal" action="{$base_dir|regex_replace:"/[http://]/":""|escape:'htmlall':'UTF-8'}/modules/payulatam/payuPse.php" id="formPayUPse" name="formPayUPse" autocomplete="off" >

                                             <div class="form-group">
                                                <label for="pse_bank" class="control-label col-xs-12 col-sm-6 text-left" style="text-align: left;">Banco</label>
                                                <div class="col-xs-12 col-sm-6">
                                                    <select id="pse_bank" name="pse_bank" onchange="bank();" class="form-control">
                                                        {foreach from=$arrayBank item=bank}
                                                        <option value="{$bank.pseCode}">{$bank.description}</option>
                                                        {/foreach}
                                                    </select> 
                                                    <input type="hidden" value="" name="name_bank" id="name_bank"/>
                                                </div>
                                            </div>

                                             <div class="form-group">
                                                <label for="pse_tipoCliente" class="control-label col-xs-12 col-sm-6 text-left" style="text-align: left;">Tipo de cliente</label>
                                                <div class="radio-inline">
                                                    <label>
                                                        <input type="radio" name="pse_tipoCliente" id="pse_tipoCliente" checked value="N">
                                                        Natural
                                                    </label>
                                                </div>
                                                <div class="radio-inline">
                                                    <label>
                                                        <input type="radio" name="pse_tipoCliente" id="pse_tipoCliente"  value="J">
                                                        Juridico
                                                    </label>
                                                </div>
                                            </div> 

                                             <div class="form-group">
                                                <label for="pse_docType" class="control-label col-xs-12 col-sm-6 text-left" style="text-align: left;">Tipo de documento</label>
                                                <div class="col-xs-12 col-sm-6">
                                                        <select id="pse_docType" name="pse_docType" class="form-control">
                                                                <option value="">Seleccione un tipo de documento</option>
                                                                <option value="CC">Cédula de ciudadanía.</option>
                                                                <option value="CE">Cédula de extranjería.</option>
                                                                <option value="NIT">NIT, en caso de ser una empresa.</option>
                                                                <option value="TI">Tarjeta de Identidad.</option>
                                                                <option value="PP">Pasaporte.</option>
                                                                <!--<option value="IDC">Identificador único de cliente, para el caso de ID’s únicos de clientes/usuarios de servicios públicos.</option>
                                                                <option value="CEL">Número Móvil, en caso de identificar a través de la línea del móvil.</option>
                                                                <option value="RC">Registro civil de nacimiento.</option>-->
                                                                <option value="DE">Documento de identificación Extranjero.</option>
                                                        </select> 
                                                </div>
                                            </div>   

                                             <div class="form-group">
                                                <label for="pse_docNumber" class="control-label col-xs-12 col-sm-6 text-left" style="text-align: left;">Número de documento</label>
                                                <div class="col-xs-12 col-sm-6">
                                                      <input type="text" id="pse_docNumber" name="pse_docNumber" class="form-control" autocomplete="off">
                                                </div>
                                            </div>

                                           <div class="form-group btnpayment">
                                                <label for="submitPSE" class="control-label hidden-xs col-sm-6 " style="text-align: left;"></label>
                                                <div class="col-xs-12 col-sm-12 div-button-pay pse-pay">
                                                    <button btn btn-default standard-checkout button-medium type="submit" id="submitPSE" class="button btn btn-default standard-checkout button-medium">
                                                        <span> Pagar Ahora
                                                            <i class="icon-chevron-right right"></i>
                                                        </span>
                                                    </button>
                                                </div>
                                            </div>         

                                            <div class="">
                                                <p><br> Recuerda tener habilitada tu cuenta corriente/ahorros para realizar compras  vía  internet. 
                                                   <br> No  olvides desbloquear las ventanas emergentes de tu navegador para evitar inconvenientes a la hora de realizar el pago.
                                                </p>
                                            </div>
                                    </form>
                                 </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            {*<div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">Pagar con Baloto</a>
                    </h4>
                </div>
                <div id="collapseThree" class="panel-collapse collapse">
                    <div class="panel-body">
                        {include file="$tpl_dir../../modules/payulatam/views/templates/hook/payuBaloto.tpl"}
                    </div>
                </div>
            </div>
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseFour">Pagar con Efecty</a>
                    </h4>
                </div>
                <div id="collapseFour" class="panel-collapse collapse">
                    <div class="panel-body">
                        {include file="$tpl_dir../../modules/payulatam/views/templates/hook/payuEfecty.tpl"}
                    </div>
                </div>
            </div>*}
        </div>
    </div>
</div>
<script>
    $('#submitPSE').click(function(e){
        e.preventDefault();
        var pse_bank = $("#pse_bank").val();
        var pse_docType = $("#pse_docType").val();
        var pse_docNumber = $("#pse_docNumber").val();
        
        if(pse_bank== "") $("#pse_bank").addClass('error');
        if(pse_docType== "") $("#pse_docType").addClass('error');
        if(pse_docNumber== "") $("#pse_docNumber").addClass('error');
        
        if( pse_bank != "" && pse_docType != "" && pse_docNumber != "" ) {
            $("#pse_bank").removeClass('error');
            $("#pse_docType").removeClass('error');
            $("#pse_docNumber").removeClass('error');
            $('#formPayUPse').submit();
        }
    })
                
    
    function bank(){
      $("#name_bank").val($("#pse_bank :selected").text()); 
    }
</script>