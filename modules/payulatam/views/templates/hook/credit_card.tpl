<link rel="stylesheet" type="text/css" href="/modules/payulatam/css/credit_card.css">
{if isset($error)}
<p style="color:red">{l s='An error occured, please try again later.' mod='payulatam'}</p>
{else}

 <script src="/modules/payulatam/js/jquery.creditCardValidator.js"></script>
    <div class="container">
        <div class="row">
            <div class="col-lg-10 col-xs-12 col-sm-10 col-md-7"> 
                <form role="form" class="form-horizontal" method="POST" action="{$base_dir|regex_replace:"/[http://]/":""|escape:'htmlall':'UTF-8'}/modules/payulatam/credit_card.php" id="formPayU" autocomplete="off"> 
                    {if $cardCustomer.num_creditCard != 1000000000000000 && $cardCustomer.num_creditCard != "" }
                        <div class="form-group">
                            <label for="rememberCard" class="control-label col-lg-6 col-xs-12 col-sm-6 text-left" style="text-align: left;">Utilizar mi tarjeta almacenada</label>
                            <div class="col-xs-12 col-sm-6 col-lg-6" style="padding-right: 0px;"><input type="checkbox" name="rememberCard" id="rememberCard" value="0"></div>
                        </div>
                    {/if}
                    <div class="form-group">
                        <label for="nombre" class="control-label col-xs-12 col-sm-6 text-left" style="text-align: left;">Nombre Del Titular</label>
                        <div class="col-xs-12 col-sm-6" style="padding-right: 0px;"><input type="text" name="nombre" id="nombre" class="form-control" placeholder="(Tal cual aparece en la tarjeta de Crédito)" autocomplete="off"/></div>
                    </div>
                    <div class="form-group required" id="ctNt">
                        <label for="numerot" class="control-label col-xs-12 col-sm-6 text-left" style="text-align: left;">Número De Tarjeta De Crédito</label>
                        <div class="col-xs-10 col-sm-5"><input type="password" name="numerot" id="numerot" class="form-control" style="padding-right: 0px;"/></div>
                        <div class="col-xs-2 col-sm-1" style="padding-right: 0px; text-align: right;"><img id="viewcreditcard" src="/modules/payulatam/img/eye-grey32.png"></i></div>
                    </div> 
                    <div class="form-group">
                        <label for="datepicker" class="control-label col-xs-12 col-sm-6 text-left" style="text-align: left;">Fecha De Vencimiento</label>
                        <div class="col-xs-6 col-sm-3" style="padding-right:0px; background: transparent;">{html_select_date prefix=NULL end_year="+15" month_format="%m"
                            year_empty="year" year_extra='id="year" class="form-control"'
                            month_empty="mes" month_extra='id="mes" class="form-control"'
                            display_days=false  display_years=false
                            field_order="DMY" time=NULL}</div>
                            <div class="col-xs-6 col-sm-3" style="padding-right:0px; background: transparent;">{$year_select}</div>
                    </div>
                    <div class="form-group">
                        <label for="codigot" class="control-label col-xs-12 col-sm-6 " style="text-align: left;">Código De Verificación</label>
                        <div class="col-xs-12 col-sm-6" style="padding-right: 0px;"><input type="password" name="codigot" id="codigot" class="form-control"/></div>
                    </div>
                    <div class="form-group">
                        <label for="cuotas" class="control-label col-xs-12 col-sm-6 " style="text-align: left;">Número De Cuotas</label>
                        <div class="col-xs-12 col-sm-6" style="padding-right: 0px;"><select name="cuotas" id="cuotas" class="form-control">
                            {for $foo=1 to 36}
                                <option value="{$foo|string_format:'%2d'}">{$foo|string_format:"%2d"}</option>
                            {/for}
                        </select></div>
                    </div>
                   <div class="form-group btnpayment">
                        <label for="submitTc" class="control-label hidden-xs col-sm-6 " style="text-align: left;"></label>
                        <div class="col-xs-12 col-sm-12 div-button-pay">
                            <button type="submit" id="submitTc" class="button btn btn-default standard-checkout button-medium">
                                <span> Pagar Ahora
                                    <i class="icon-chevron-right right"></i>
                                </span>
                            </button>
                        </div>
                    </div>                                             
                </form>
            </div>
        </div>
    </div>

{/if} 

<style>
    .selector { width: 100%!important; }
    .selector span { width: 100%!important; }
    .radio-inline { margin-left: 15px!important; }
    .radio { padding-top: 3px!important; }
</style>

<script>
    
    $('#submitTc').submit(function(e){
        e.preventDefault();
        var nombre = $("#nombre").val();
        var numerot = $("#numerot").val();
        var mes = $("#mes").val();
        var year = $("#year").val();
        var codigot = $("#codigot").val();
        var cuotas = $("#cuotas").val();

        
        if(nombre== "") $("#nombre").addClass('error');
        if(numerot== "") $("#numerot").addClass('error');
        if(mes== "") $("#mes").addClass('error');
        if(year== "") $("#year").addClass('error');
        if(codigot== "") $("#codigot").addClass('error');
        if(cuotas== "") $("#cuotas").addClass('error');
        
        if( nombre != "" && numerot != "" && mes != "" && year != "" && codigot != "" && cuotas != "" ) {
            $("#nombre").removeClass('error');
            $("#numerot").removeClass('error');
            $("#mes").removeClass('error');
            $("#year").removeClass('error');
            $("#codigot").removeClass('error');
            $("#cuotas").removeClass('error');
            $('#formPayU').submit();
        }
        //return false;
    });
    
    $("#viewcreditcard").click(function(){
        var typeinput = $('#numerot').attr('type');
        if ( typeinput == "password" ) {
            $("#numerot").prop("type","text");
            $(this).attr('src','/modules/payulatam/img/eye-green32.png')
        } else {
            $("#numerot").prop("type","password");
            $(this).attr('src','/modules/payulatam/img/eye-grey32.png')
        }
    });

</script>