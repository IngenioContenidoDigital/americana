{*
* 2007-2016 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author PrestaShop SA <contact@prestashop.com>
*  @copyright  2007-2016 PrestaShop SA
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*  International Registered Trademark & Property of PrestaShop SA
*}
{capture name=path}{l s='Your addresses'}{/capture}
<div class="box box_address">
    <h1 class="page-subheading">{l s='Your addresses'}</h1>
    <p class="info-title">
        {if isset($id_address) && (isset($smarty.post.alias) || isset($address->alias))}
            {l s='Modify address'}
            {if isset($smarty.post.alias)}
                "{$smarty.post.alias}"
            {else}
                {if isset($address->alias)}"{$address->alias|escape:'html':'UTF-8'}"{/if}
            {/if}
        {else}
            {l s='To add a new address, please fill out the form below.'}
        {/if}
    </p>
    {include file="$tpl_dir./errors.tpl"}
    <p class="required"><sup>*</sup>{l s='Required field'}</p>
    <form action="{$link->getPageLink('address', true)|escape:'html':'UTF-8'}" method="post" class="std" id="add_address">
            <!--h3 class="page-subheading">{if isset($id_address)}{l s='Your address'}{else}{l s='New address'}{/if}</h3-->
        {assign var="stateExist" value=false}
        {assign var="postCodeExist" value=false}
        {assign var="dniExist" value=false}
        {assign var="homePhoneExist" value=false}
        {assign var="idxField" value=1}
        {assign var="mobilePhoneExist" value=false}
        {assign var="atLeastOneExists" value=false}
        <div class="row">
            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                <div class="required form-group" id="adress_alias">
                    <label for="alias">{l s='Please assign an address title for future reference.'} <sup>*</sup></label>
                    <input type="text" id="alias" class="is_required validate form-control" data-validate="{$address_validation.alias.validate}" name="alias" value="{if isset($smarty.post.alias)}{$smarty.post.alias}{elseif isset($address->alias)}{$address->alias|escape:'html':'UTF-8'}{elseif !$select_address}{l s='My address'}{/if}" />
                </div>
            </div>
            <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                {if !$homePhoneExist}
                    <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
                        <div class="form-group phone-number">
                            <label for="phone">{l s='Home phone'}</label>&nbsp;{if isset($one_phone_at_least) && $one_phone_at_least && !$atLeastOneExists}<span class="inline-infos required" style="color:red;">{l s='*'}</span>{/if}
                            <input class="{if isset($one_phone_at_least) && $one_phone_at_least}is_required{/if} validate form-control" data-validate="{$address_validation.phone.validate}" type="tel" id="phone" name="phone" value="{if isset($smarty.post.phone)}{$smarty.post.phone}{else}{if isset($address->phone)}{$address->phone|escape:'html':'UTF-8'}{/if}{/if}"  />
                        </div>
                    </div>
                {/if}
                {if !$mobilePhoneExist}
                    <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
                        <div class="{if isset($one_phone_at_least) && $one_phone_at_least}required {/if}form-group">
                            <label for="phone_mobile">{l s='Mobile phone'}{if isset($one_phone_at_least) && $one_phone_at_least} <sup>**</sup>{/if}</label>
                            <input class="validate form-control" data-validate="{$address_validation.phone_mobile.validate}" type="tel" id="phone_mobile" name="phone_mobile" value="{if isset($smarty.post.phone_mobile)}{$smarty.post.phone_mobile}{else}{if isset($address->phone_mobile)}{$address->phone_mobile|escape:'html':'UTF-8'}{/if}{/if}" />
                        </div>                
                    </div>
                {/if}
            </div>
        </div>
        {foreach from=$ordered_adr_fields item=field_name}
            {if $field_name eq 'company'}
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="company">{l s='Company'}{if isset($required_fields) && in_array($field_name, $required_fields)} <sup>*</sup>{/if}</label>
                        <input class="form-control validate" data-validate="{$address_validation.$field_name.validate}" type="text" id="company" name="company" value="{if isset($smarty.post.company)}{$smarty.post.company}{else}{if isset($address->company)}{$address->company|escape:'html':'UTF-8'}{/if}{/if}" />
                    </div>
                </div>
                {*assign var="idxField" value=($idxField + 1)*}
                {*if ($idxField % 4) eq 0}{assign var="idxField" value=1}<div class="clearfix"></div>{/if*}
            {/if}
            {if $field_name eq 'vat_number'}
                <div class="col-md-4">
                    <div id="vat_area">
                        <div id="vat_number">
                            <div class="form-group">
                                <label for="vat-number">{l s='VAT number'}{if isset($required_fields) && in_array($field_name, $required_fields)} <sup>*</sup>{/if}</label>
                                <input type="text" class="form-control validate" data-validate="{$address_validation.$field_name.validate}" id="vat-number" name="vat_number" value="{if isset($smarty.post.vat_number)}{$smarty.post.vat_number}{else}{if isset($address->vat_number)}{$address->vat_number|escape:'html':'UTF-8'}{/if}{/if}" />
                            </div>
                        </div>
                    </div>
                </div>
                {*assign var="idxField" value=($idxField + 1)*}
                {*if ($idxField % 4) eq 0}{assign var="idxField" value=1}<div class="clearfix"></div>{/if*}
            {/if}
            {if $field_name eq 'dni'}
                {assign var="dniExist" value=true}
                <div class="col-md-4">
                    <div class="required form-group dni">
                        <label for="dni">{l s='Identification number'} <sup>*</sup></label>
                        <input class="form-control" data-validate="{$address_validation.$field_name.validate}" type="text" name="dni" id="dni" value="{if isset($smarty.post.dni)}{$smarty.post.dni}{else}{if isset($address->dni)}{$address->dni|escape:'html':'UTF-8'}{/if}{/if}" />
                        <span class="form_info">{l s='DNI / NIF / NIE'}</span>
                    </div>
                </div>
                {*assign var="idxField" value=($idxField + 1)*}
                {*if ($idxField % 4) eq 0}{assign var="idxField" value=1}<div class="clearfix"></div>{/if*}
            {/if}
            {*if $field_name eq 'firstname'}
                <div class="col-md-4">
                    <div class="required form-group">
                        <label for="firstname">{l s='First name'} <sup>*</sup></label>
                        <input class="is_required validate form-control" data-validate="{$address_validation.$field_name.validate}" type="text" name="firstname" id="firstname" value="{if isset($smarty.post.firstname)}{$smarty.post.firstname}{else}{if isset($address->firstname)}{$address->firstname|escape:'html':'UTF-8'}{/if}{/if}" />
                    </div>
                </div>
                {assign var="idxField" value=($idxField + 1)}
                {if ($idxField % 4) eq 0}{assign var="idxField" value=1}<div class="clearfix"></div>{/if}
            {/if*}
            {*if $field_name eq 'lastname'}
                <div class="col-md-4">
                    <div class="required form-group">
                        <label for="lastname">{l s='Last name'} <sup>*</sup></label>
                        <input class="is_required validate form-control" data-validate="{$address_validation.$field_name.validate}" type="text" id="lastname" name="lastname" value="{if isset($smarty.post.lastname)}{$smarty.post.lastname}{else}{if isset($address->lastname)}{$address->lastname|escape:'html':'UTF-8'}{/if}{/if}" />
                    </div>
                </div>
                {assign var="idxField" value=($idxField + 1)}
                {if ($idxField % 4) eq 0}{assign var="idxField" value=1}<div class="clearfix"></div>{/if}
            {/if*}
            {if $field_name eq 'address1'}
            <br>
            <div class="row">
                <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                    <div class="required form-group">
                        <label for="address1">{l s='Address'} <sup>*</sup>&nbsp;</label><span class="generador">{l s='Generador de Direcciones'}</span>
                        <div id="generador">
                            <div class="row">
                                <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                        <select id="select-1">
                                            <option value="">-- Elegir --</option>
                                            <option value="AU ">Autopista</option>
                                            <option value="AV ">Avenida</option>
                                            <option value="AC ">Avenida Calle</option>
                                            <option value="AK ">Avenida Carrera</option>
                                            <option value="CL ">Calle</option>
                                            <option value="CN ">Camino</option>
                                            <option value="KR ">Carrera</option>
                                            <option value="CT ">Carretera</option>
                                            <option value="CORR ">Corregimiento</option>
                                            <option value="DG ">Diagonal</option>
                                            <option value="FI ">Finca</option>
                                            <option value="HC ">Hacienda</option>
                                            <option value="KM ">Kilometro</option>
                                            <option value="TV ">Transversal</option>
                                            <option value="VT ">Variante</option>
                                            <option value="VI ">Via</option>
                                            <option value="VDA ">Vereda</option>
                                            <option value="ZF "/>Zona Franca</option>
                                        </select>
                                        <input type="text" id="dir-1" autocomplete="off"/>
                                        <select id="select-2">
                                            <option value="">-- Elegir --</option>
                                            <option value="A ">A</option>
                                            <option value="B ">B</option>
                                            <option value="C ">C</option>
                                            <option value="D ">D</option>
                                            <option value="E ">E</option>
                                            <option value="F ">F</option>
                                            <option value="G ">G</option>
                                            <option value="H ">H</option>
                                            <option value="I ">I</option>
                                            <option value="J ">J</option>
                                            <option value="K ">K</option>
                                            <option value="L ">L</option>
                                            <option value="M ">M</option>
                                            <option value="N ">N</option>
                                            <option value="O ">O</option>
                                            <option value="P ">P</option>
                                            <option value="Q ">Q</option>
                                            <option value="R ">R</option>
                                            <option value="S ">S</option>
                                            <option value="T ">T</option>
                                            <option value="U ">U</option>
                                            <option value="V ">V</option>
                                            <option value="W ">W</option>
                                            <option value="X ">X</option>
                                            <option value="Y ">Y</option>
                                            <option value="Z ">Z</option>
                                        </select>
                                        <select id="select-3">
                                            <option value="">-- Elegir --</option>
                                            <option value="BIS ">BIS</option>
                                        </select>
                                        <select id="select-4">
                                            <option value="">-- Elegir --</option>
                                            <option value="ESTE ">Este</option>
                                            <option value="NORTE ">Norte</option>
                                            <option value="OCC ">Occidente</option>
                                            <option value="OESTE ">Oeste</option>
                                            <option value="OR ">Oriente</option>
                                            <option value="SUR ">Sur</option>
                                        </select>
                                    <span>#</span>
                                        <input type="number" id="dir-2"/>
                                        <select id="select-5">
                                            <option value="">-- Elegir --</option>
                                            <option value="A ">A</option>
                                            <option value="B ">B</option>
                                            <option value="C ">C</option>
                                            <option value="D ">D</option>
                                            <option value="E ">E</option>
                                            <option value="F ">F</option>
                                            <option value="G ">G</option>
                                            <option value="H ">H</option>
                                            <option value="I ">I</option>
                                            <option value="J ">J</option>
                                            <option value="K ">K</option>
                                            <option value="L ">L</option>
                                            <option value="M ">M</option>
                                            <option value="N ">N</option>
                                            <option value="O ">O</option>
                                            <option value="P ">P</option>
                                            <option value="Q ">Q</option>
                                            <option value="R ">R</option>
                                            <option value="S ">S</option>
                                            <option value="T ">T</option>
                                            <option value="U ">U</option>
                                            <option value="V ">V</option>
                                            <option value="W ">W</option>
                                            <option value="X ">X</option>
                                            <option value="Y ">Y</option>
                                            <option value="Z ">Z</option>
                                        </select>
                                        <select id="select-6">
                                            <option value="">-- Elegir --</option>
                                            <option value="BIS ">BIS</option>
                                        </select>
                                        <select id="select-7">
                                            <option value="">-- Elegir --</option>
                                            <option value="ESTE ">Este</option>
                                            <option value="NORTE ">Norte</option>
                                            <option value="OCC ">Occidente</option>
                                            <option value="OESTE ">Oeste</option>
                                            <option value="OR ">Oriente</option>
                                            <option value="SUR ">Sur</option>
                                        </select>
                                    <span>-</span>
                                        <input type="number" id="dir-3"/>
                                </div>
                            </div>
                            <br>
                            <div class="row">
                                <div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
                                        <select id="select-8">
                                            <option value="">-- Elegir --</option>
                                            <option value="AD "/>Administracion</option>
                                            <option value="AN "/>Agencia</option>
                                            <option value="AG "/>Agrupacion</option>
                                            <option value="ALM "/>Almacen</option>
                                            <option value="AL "/>Altillo</option>                                
                                            <option value="APTDO "/>Apartado</option>
                                            <option value="AP "/>Apartamento</option>
                                            <option value=AU "/>Autopista</option>
                                            <option value="AV "/>Avenida</option>
                                            <option value="AC "/>Avenica Calle</option>                               
                                            <option value="AK "/>Avenida Carrera</option>
                                            <option value="BR "/>Barrio</option>
                                            <option value="BQ "/>Bloque</option>
                                            <option value="BG "/>Bodega</option>
                                            <option value="BLV "/>Boulevar</option>
                                            <option value="CL "/>Calle</option>
                                            <option value="CN "/>Camino</option>
                                            <option value="KR "/>Carrera</option>
                                            <option value="CT "/>Carretera</option>
                                            <option value="CS "/>Casa</option>
                                            <option value="CEL "/>Celula</option>
                                            <option value="CE "/>Centro Comercial</option>
                                            <option value="CQ "/>Circular</option>
                                            <option value="CV "/>Circunvalar</option>
                                            <option value="CD "/>Ciudadela</option>
                                            <option value="CONJ "/>Conjunto</option>
                                            <option value="CO "/>Conjunto Residencial</option>
                                            <option value="CN "/>Consultorio</option>
                                            <option value="CORR "/>Corregimiento</option>
                                            <option value="DPTO "/>Departamento</option>
                                            <option value="DP "/>Deposito</option>
                                            <option value="DG "/>Diagonal</option>
                                            <option value="ED "/>Edificio</option>
                                            <option value="EN "/>Entrada</option>
                                            <option value="EQ "/>Esquina</option>
                                            <option value="ES "/>Estacion</option>
                                            <option value="ESTE "/>Este</option>
                                            <option value="ET "/>Etapa</option>
                                            <option value="EX "/>Exterior</option>
                                            <option value="FI "/>Finca</option>
                                            <option value="GA "/>Garaje</option>
                                            <option value="HC "/>Hacienda</option>
                                            <option value="IN "/>Interior</option>
                                            <option value="KM "/>Kilometro</option>
                                            <option value="LC "/>Local</option>
                                            <option value="LT "/>Lote</option>
                                            <option value="MZ "/>Manzana</option>
                                            <option value="MN "/>Mezzanine</option>
                                            <option value="MD "/>Modulo</option>
                                            <option value="MCP "/>Municipio</option>
                                            <option value="NORTE "/>Norte</option>
                                            <option value="OCC "/>Occidente</option>
                                            <option value="OESTE "/>Oeste</option>
                                            <option value="OF "/>Oficina</option>
                                            <option value="O "/>Oriente</option>
                                            <option value="PA "/>Parcela</option>
                                            <option value="PQ "/>Parque</option>
                                            <option value="PA "/>Parqueadero</option>
                                            <option value="PJ "/>Pasaje</option>
                                            <option value="PS "/>Paseo</option>
                                            <option value="PN "/>Penthouse</option>
                                            <option value="PI "/>Piso</option>
                                            <option value="PL "/>Planta</option>
                                            <option value="PR "/>Porteria</option>
                                            <option value="PD "/>Predio</option>
                                            <option value="PN "/>Puente</option>
                                            <option value="PT "/>Puesto</option>
                                            <option value="SA "/>Salon</option>
                                            <option value="SEC "/>Sector</option>
                                            <option value="SS "/>Semisotano</option>
                                            <option value="SL "/>Solar</option>
                                            <option value="SO "/>Sotano</option>
                                            <option value="ST "/>Suite</option>
                                            <option value="SM "/>Supermanzana</option>
                                            <option value="SUR "/>Sur</option>
                                            <option value="TER "/>Terminal</option>
                                            <option value="TZ "/>Terraza</option>
                                            <option value="TO "/>Torre</option>
                                            <option value="TV "/>Transversal</option>
                                            <option value="TC "/>Troncal</option>
                                            <option value="UN "/>Unidad</option>
                                            <option value="UL "/>Unidad Residencial</option>
                                            <option value="UR "/>Urbanizacion</option>
                                            <option value="VT "/>Variante</option>
                                            <option value="VI "/>Via</option>
                                            <option value="VDA "/>Vereda</option>
                                            <option value="ZN "/>Zona</option>
                                            <option value="ZF "/>Zona Franca</option>
                                        </select>
                                        <input type="text" id="dir-4"/>
                                        <select id="select-9">
                                            <option value="">-- Elegir --</option>
                                            <option value="AD "/>Administracion</option>
                                            <option value="AN "/>Agencia</option>
                                            <option value="AG "/>Agrupacion</option>
                                            <option value="ALM "/>Almacen</option>
                                            <option value="AL "/>Altillo</option>                                
                                            <option value="APTDO "/>Apartado</option>
                                            <option value="AP "/>Apartamento</option>
                                            <option value=AU "/>Autopista</option>
                                            <option value="AV "/>Avenida</option>
                                            <option value="AC "/>Avenica Calle</option>                               
                                            <option value="AK "/>Avenida Carrera</option>
                                            <option value="BR "/>Barrio</option>
                                            <option value="BQ "/>Bloque</option>
                                            <option value="BG "/>Bodega</option>
                                            <option value="BLV "/>Boulevar</option>
                                            <option value="CL "/>Calle</option>
                                            <option value="CN "/>Camino</option>
                                            <option value="KR "/>Carrera</option>
                                            <option value="CT "/>Carretera</option>
                                            <option value="CS "/>Casa</option>
                                            <option value="CEL "/>Celula</option>
                                            <option value="CE "/>Centro Comercial</option>
                                            <option value="CQ "/>Circular</option>
                                            <option value="CV "/>Circunvalar</option>
                                            <option value="CD "/>Ciudadela</option>
                                            <option value="CONJ "/>Conjunto</option>
                                            <option value="CO "/>Conjunto Residencial</option>
                                            <option value="CN "/>Consultorio</option>
                                            <option value="CORR "/>Corregimiento</option>
                                            <option value="DPTO "/>Departamento</option>
                                            <option value="DP "/>Deposito</option>
                                            <option value="DG "/>Diagonal</option>
                                            <option value="ED "/>Edificio</option>
                                            <option value="EN "/>Entrada</option>
                                            <option value="EQ "/>Esquina</option>
                                            <option value="ES "/>Estacion</option>
                                            <option value="ESTE "/>Este</option>
                                            <option value="ET "/>Etapa</option>
                                            <option value="EX "/>Exterior</option>
                                            <option value="FI "/>Finca</option>
                                            <option value="GA "/>Garaje</option>
                                            <option value="HC "/>Hacienda</option>
                                            <option value="IN "/>Interior</option>
                                            <option value="KM "/>Kilometro</option>
                                            <option value="LC "/>Local</option>
                                            <option value="LT "/>Lote</option>
                                            <option value="MZ "/>Manzana</option>
                                            <option value="MN "/>Mezzanine</option>
                                            <option value="MD "/>Modulo</option>
                                            <option value="MCP "/>Municipio</option>
                                            <option value="NORTE "/>Norte</option>
                                            <option value="OCC "/>Occidente</option>
                                            <option value="OESTE "/>Oeste</option>
                                            <option value="OF "/>Oficina</option>
                                            <option value="O "/>Oriente</option>
                                            <option value="PA "/>Parcela</option>
                                            <option value="PQ "/>Parque</option>
                                            <option value="PA "/>Parqueadero</option>
                                            <option value="PJ "/>Pasaje</option>
                                            <option value="PS "/>Paseo</option>
                                            <option value="PN "/>Penthouse</option>
                                            <option value="PI "/>Piso</option>
                                            <option value="PL "/>Planta</option>
                                            <option value="PR "/>Porteria</option>
                                            <option value="PD "/>Predio</option>
                                            <option value="PN "/>Puente</option>
                                            <option value="PT "/>Puesto</option>
                                            <option value="SA "/>Salon</option>
                                            <option value="SEC "/>Sector</option>
                                            <option value="SS "/>Semisotano</option>
                                            <option value="SL "/>Solar</option>
                                            <option value="SO "/>Sotano</option>
                                            <option value="ST "/>Suite</option>
                                            <option value="SM "/>Supermanzana</option>
                                            <option value="SUR "/>Sur</option>
                                            <option value="TER "/>Terminal</option>
                                            <option value="TZ "/>Terraza</option>
                                            <option value="TO "/>Torre</option>
                                            <option value="TV "/>Transversal</option>
                                            <option value="TC "/>Troncal</option>
                                            <option value="UN "/>Unidad</option>
                                            <option value="UL "/>Unidad Residencial</option>
                                            <option value="UR "/>Urbanizacion</option>
                                            <option value="VT "/>Variante</option>
                                            <option value="VI "/>Via</option>
                                            <option value="VDA "/>Vereda</option>
                                            <option value="ZN "/>Zona</option>
                                            <option value="ZF "/>Zona Franca</option>
                                        </select>
                                        <input type="text" id="dir-5"/>
                                </div>
                                {*if $field_name eq 'address2'*}
                                    <div class="col-xs-7 col-sm-7 col-md-7 col-lg-7">
                                        <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
                                            <label for="address2">{l s='Indicaciones'}</label>    
                                        </div>
                                        <div class="col-xs-8 col-sm-8 col-md-8 col-lg-8">
                                            <div class="required form-group">
                                                <input placeholder="{l s='ej: Puerta Roja, Casa de la esquina, etc...'}" class="validate form-control" data-validate="{$address_validation.$field_name.validate}" type="text" id="address2" name="address2" value="{if isset($smarty.post.address2)}{$smarty.post.address2}{else}{if isset($address->address2)}{$address->address2|escape:'html':'UTF-8'}{/if}{/if}" />
                                            </div>
                                        </div>
                                    </div>
                                    {*assign var="idxField" value=($idxField + 1)*}
                                    {*if ($idxField % 4) eq 0}{assign var="idxField" value=1}<div class="clearfix"></div>{/if*}
                                {*/if*}
                                <br>
                                <div class="col-md-3"><input class="opcion" type="button" value="CONFIRMAR" abbr="confirmar" id="confirmar"/></div>
                            </div>
                        </div>
                        <br>
                        <input readonly style="min-width:85%" class="is_required validate form-control" data-validate="{$address_validation.$field_name.validate}" type="text" id="address1" name="address1" value="{if isset($smarty.post.address1)}{$smarty.post.address1}{else}{if isset($address->address1)}{$address->address1|escape:'html':'UTF-8'}{/if}{/if}" />
                    </div>
                </div>
                {*assign var="idxField" value=($idxField + 1)*}
                {*if ($idxField % 4) eq 0}{assign var="idxField" value=1}<div class="clearfix"></div>{/if*}
            {/if}
            {if $field_name eq 'postcode'}
                {assign var="postCodeExist" value=true}
                <div>
                    <div class="required postcode form-group unvisible">
                        <label for="postcode">{l s='Zip/Postal Code'} <sup>*</sup></label>
                        <input class="is_required validate form-control" data-validate="{$address_validation.$field_name.validate}" type="text" id="postcode" name="postcode" value="{if isset($smarty.post.postcode)}{$smarty.post.postcode}{else}{if isset($address->postcode)}{$address->postcode|escape:'html':'UTF-8'}{/if}{/if}" />
                    </div>
                </div>
            {/if}
                    {if $field_name eq 'Country:name' || $field_name eq 'country' || $field_name eq 'Country:iso_code'}
                    <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                        <div class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
                            <div class="required form-group">
                                <label for="id_country">{l s='Country'} <sup>*</sup></label>
                                <select id="id_country" class="form-control" name="id_country">{$countries_list}</select>
                            </div>
                        </div>
                        {*assign var="idxField" value=($idxField + 1)*}
                        {*if ($idxField % 4) eq 0}{assign var="idxField" value=1}<div class="clearfix"></div>{/if*}
                    {/if}
                    {if $field_name eq 'State:name'}
                        {assign var="stateExist" value=true}
                        <div class="col-xs-5 col-sm-5 col-md-5 col-lg-5">
                            <div class="required id_state form-group">
                                <label for="id_state">{l s='Departamento'} <sup>*</sup></label>
                                <select name="id_state" id="id_state" class="form-control">
                                    <option value="">-- Elija Departamento --</option>
                                </select>
                            </div>
                        </div>
                        {*assign var="idxField" value=($idxField + 1)*}
                        {*if ($idxField % 4) eq 0}{assign var="idxField" value=1}<div class="clearfix"></div>{/if*}
                    {/if}
                    {if $field_name eq 'city'}
                        <div class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
                            <div class="required city form-group">
                                <label for="city">{l s='City'} <sup>*</sup></label>
                                <select name="city" id="city" class="form-control">
                                    <option value="">- Elija una Ciudad -</option>
                                </select>
                            </div>
                        </div>
                    </div>
                        {*if !$stateExist*}

                            {*assign var="idxField" value=($idxField + 1)*}
                            {*if ($idxField % 4) eq 0}{assign var="idxField" value=1}<div class="clearfix"></div>{/if*}
                        {*/if*}
                        {* if customer hasn't update his layout address, country has to be verified but it's deprecated *}
                        {*assign var="idxField" value=($idxField + 1)*}
                        {*if ($idxField % 4) eq 0}{assign var="idxField" value=1}<div class="clearfix"></div>{/if*}
                    {/if}
        {/foreach}
        <div class="clearfix"></div>
        <br>
        <div class="row">
            {if !$postCodeExist}
                <div class="required postcode form-group unvisible">
                    <label for="postcode">{l s='Zip/Postal Code'} <sup>*</sup></label>
                    <input class="is_required validate form-control" data-validate="{$address_validation.postcode.validate}" type="text" id="postcode" name="postcode" value="{if isset($smarty.post.postcode)}{$smarty.post.postcode}{else}{if isset($address->postcode)}{$address->postcode|escape:'html':'UTF-8'}{/if}{/if}" />
                </div>
            {/if}

            {if !$dniExist}
                <div class="required dni form-group unvisible">
                    <label for="dni">{l s='Identification number'} <sup>*</sup></label>
                    <input class="is_required form-control" data-validate="{$address_validation.dni.validate}" type="text" name="dni" id="dni" value="{if isset($smarty.post.dni)}{$smarty.post.dni}{else}{if isset($address->dni)}{$address->dni|escape:'html':'UTF-8'}{/if}{/if}" />
                    <span class="form_info">{l s='DNI / NIF / NIE'}</span>
                </div>
            {/if}
            <!--<div class="clearfix"></div>
            <div class="col-md-4">
                <div class="form-group">
                    <label for="other">{l s='Additional information'}</label>
                    <textarea class="validate form-control" data-validate="{$address_validation.other.validate}" id="other" name="other" cols="26" rows="3" >{if isset($smarty.post.other)}{$smarty.post.other}{else}{if isset($address->other)}{$address->other|escape:'html':'UTF-8'}{/if}{/if}</textarea>
                </div>
            </div>-->
            <div class="clearfix"></div>
            <div class="col-md-12">
                <p class="submit2" style="margin-bottom: 10px; margin-top: 10px;">
                    {if isset($id_address)}<input type="hidden" name="id_address" value="{$id_address|intval}" />{/if}
                    {if isset($back)}<input type="hidden" name="back" value="{$back}" />{/if}
                    {if isset($mod)}<input type="hidden" name="mod" value="{$mod}" />{/if}
                    {if isset($select_address)}<input type="hidden" name="select_address" value="{$select_address|intval}" />{/if}
                    <input type="hidden" name="token" value="{$token}" />
                    <button type="submit" name="submitAddress" id="submitAddress" class="btn btn-default button button-medium">
                        <span>
                            {l s='Save'}
                            <i class="icon-chevron-right right"></i>
                        </span>
                    </button>
                </p>
            </div>
            <div class="clearfix"></div>
        </div>
    </form>
    </div>
</div>
<ul class="footer_links clearfix">
    <li>
        <a class="btn btn-defaul button button-small" href="{$link->getPageLink('addresses', true)|escape:'html':'UTF-8'}">
            <span><i class="icon-chevron-left"></i> {l s='Back to your addresses'}</span>
        </a>
    </li>
</ul>
{literal}
    <script>
        $(document).ready(function(){
            $('#generador').hide();
        })
        
        $('.generador').click(function(){
            $('#generador').show("slow");
        })
        
        $('#confirmar').click(function(){
            var addr = $('#select-1').val()+$('#dir-1').val()+$('#select-2').val()+$('#select-3').val()+$('#select-4').val()+" "+$('#dir-2').val()+$('#select-5').val()+$('#select-6').val()+$('#select-7').val()+" "+$('#dir-3').val()+" "+$('#select-8').val()+$('#dir-4').val()+" "+$('#select-9').val()+$('#dir-5').val()
            addr=addr.replace(/\s\s+/g,' ')
            $('#address1').val(addr.toUpperCase());
        })
        
        $('#id_state').change(function(){
            $('#city').val("").change();
            var state = $(this).val();
            $.ajax({
                method:'post',
                url: './AjaxCities.php',
                data:{'state':state},
                success:function(response){
                    var result = $.parseJSON(response);
                    $('#city').empty();
                    $('#city').append($('<option>', {
                            value: "",
                            text: "- Elija una Ciudad -"
                    }));
                    $.each(result,function(i, item){
                        $('#city').append($('<option>', {
                            value: item.id_cities,
                            text: item.ciudad
                        }));
                    })
                }
            })
        });
    </script>
{/literal}
{strip}
    {if isset($smarty.post.id_state) && $smarty.post.id_state}
        {addJsDef idSelectedState=$smarty.post.id_state|intval}
    {elseif isset($address->id_state) && $address->id_state}
        {addJsDef idSelectedState=$address->id_state|intval}
    {else}
        {addJsDef idSelectedState=false}
    {/if}
    {if isset($smarty.post.id_country) && $smarty.post.id_country}
        {addJsDef idSelectedCountry=$smarty.post.id_country|intval}
    {elseif isset($address->id_country) && $address->id_country}
        {addJsDef idSelectedCountry=$address->id_country|intval}
    {else}
        {addJsDef idSelectedCountry=false}
    {/if}
    {if isset($countries)}
        {addJsDef countries=$countries}
    {/if}
    {if isset($vatnumber_ajax_call) && $vatnumber_ajax_call}
        {addJsDef vatnumber_ajax_call=$vatnumber_ajax_call}
    {/if}
{/strip}
