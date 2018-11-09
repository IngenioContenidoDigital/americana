<div id="accordion" class="mercadopago">
    <h3>Pagar con Tarjeta de Cr&eacute;dito</h3>
    <div>
        <input type="hidden" id="public" value="{$public}" />
        <form action="{$link->getModuleLink('mercadopago', 'creditcard')|escape:'html'}" method="post" id="pay" name="pay" >
            <div class="col-xs-12 col-sm-12 col-md-5 col-lg-5">
                <div class="identificacion">
                    <div class="nombre">{$customer}</div>
                    <br>
                    <select class="form-control" id="docType" name="docType" data-checkout="docType"></select>
                    <br>
                    <input type="text" id="docNumber" name="docNumber" data-checkout="docNumber" placeholder="12345678" />
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-5 col-lg-5">
            <fieldset>
                <img id="franquicia" src="" />
                <input type="hidden" name="paymentMethodId" />
                <input type="hidden" id="paymentMethodId" name="paymentMethodId" value="" />
                <input type="hidden" id="token" name="token" value="" />
                <input type="hidden" id="issuer" name="issuer" value="" />
                <input id="email" name="email" value="{$email}" type="hidden" placeholder="your email"/>
                <div class="row">
                    <div class="col-xs-7 col-sm-7 col-md-7 col-lg-7">
                        <label for="cardNumber">N&uacute;mero de la tarjeta</label>
                        <input type="text" id="cardNumber" data-checkout="cardNumber" placeholder="4509953566233704" onselectstart="return false" onpaste="return false" onCopy="return false" onCut="return false" onDrag="return false" onDrop="return false" autocomplete=off />
                    </div>
                    <div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
                        <label for="cardExpirationMonth">Fecha MM / AAAA</label>
                        <br>
                        <input type="text" id="cardExpirationMonth" maxlength="2" data-checkout="cardExpirationMonth" placeholder="MM" onselectstart="return false" onpaste="return false" onCopy="return false" onCut="return false" onDrag="return false" onDrop="return false" autocomplete=off /><span>/</span>
                        <input type="text" id="cardExpirationYear" maxlength="4" data-checkout="cardExpirationYear" placeholder="AAAA" onselectstart="return false" onpaste="return false" onCopy="return false" onCut="return false" onDrag="return false" onDrop="return false" autocomplete=off />
                    </div>
                </div>
                <div class="row">
                    <div class="col-xs-7 col-sm-7 col-md-7 col-lg-7">
                        <label for="cardExpirationMonth">Nombre</label><br>
                        <input type="text" id="cardholderName" data-checkout="cardholderName" placeholder="como en la tarjeta" />
                    </div>
                    <div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
                        <label for="cardExpirationMonth">CVV</label><br>
                        <input type="text" id="securityCode" maxlength="4" data-checkout="securityCode" placeholder="CVV" onselectstart="return false" onpaste="return false" onCopy="return false" onCut="return false" onDrag="return false" onDrop="return false" autocomplete=off />
                        <img style="width:35px;" src="{$modules_dir}/mercadopago/img/cvv1.jpg" />
                    </div>
                </div>
            </fieldset>
            <br>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                <button type="button" id="enviar" name="enviar" class="btn btn-primary">Pagar Ahora</button>
                <img src="https://secure.mlstatic.com/developers/site/cloud/banners/co/125x125_Todos-los-medios-de-pago.jpg" title="MercadoPago - Medios de pago" alt="MercadoPago - Medios de pago" width="125" height="125"/>
            </div>            
        </form>
    </div>
    <h3 id="pse-group">Pago por PSE</h3>
    <div>
        <form action="{$link->getModuleLink('mercadopago', 'pse')|escape:'html'}" method="post" id="pse" name="pse" >
            <div class="col-xs-12 col-sm-12 col-md-5 col-lg-5">
                <div class="identificacion">
                    <div class="nombre">{$customer}</div>
                    <br>
                    <select class="form-control" id="docType1" name="docType1"></select>
                    <br>
                    <input type="text" id="docNumber1" name="docNumber1" placeholder="12345678" />
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-5 col-lg-5">
                <div class="contenedor-pse">
                    <select id="banks" name="banks" class="form-control">
                        {foreach from=$banks item=bank}
                            <option value="{$bank.id}">{$bank.description}</option>
                        {/foreach}
                    </select>
                    <br>
                    <span><input type="radio" class="form-control" id="persona" name="entity_type" value="individual" />Persona</span>
                    <span><input type="radio" class="form-control" id="empresa" name="entity_type" value="association" />Empresa</span>
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                <button type="button" id="enviar-pse" name="enviar-pse" class="btn btn-primary">Pagar Ahora</button>
                <img src="https://secure.mlstatic.com/developers/site/cloud/banners/co/125x125_Todos-los-medios-de-pago.jpg" title="MercadoPago - Medios de pago" alt="MercadoPago - Medios de pago" width="125" height="125"/>
            </div>
        </form>
    </div>
</div>

{literal}
    <script>
        $('#cardNumber').on('keyup',function(e){
            var bin = getBin($(this).val());
            if (bin != null) {
                Mercadopago.getPaymentMethod({
                    "bin": bin
                }, setPaymentMethodInfo);
            }
        });
        
        $('#enviar').click(function(e){
            e.preventDefault();
            Mercadopago.getInstallments({'bin': getBin($('#cardNumber').val()), 'amount': 3 },setInstallmentsInfo)
            var $form = document.querySelector('#pay');
            Mercadopago.createToken($form, sdkResponseHandler);
        });
        
        $('#pse-group').click(function(){
            $('#docType1').html("");
            var options = $("#docType").html();
            $('#docType1').html(options);
        });
        
        $('#enviar-pse').click(function(e){
            e.preventDefault();
            $('#pse').submit();
        });
    </script>
 {/literal}