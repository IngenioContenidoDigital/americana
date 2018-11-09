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
{if !isset($content_only) || !$content_only}
</div><!-- #center_column -->
{if isset($right_column_size) && !empty($right_column_size)}
    <div id="right_column" class="col-xs-12 col-sm-{$right_column_size|intval} column">{$HOOK_RIGHT_COLUMN}</div>
{/if}
</div><!-- .row -->
</div><!-- #columns -->
</div><!-- .columns-container -->
{hook h='gkhomefeatured'}
<br>
<a href="/content/44-americana-credito"><p style="text-align: center;"><img class="img-responsive" src="/img/cms/Banner-Americana-Credito-New.png" /><p></a>
<br>
{if isset($HOOK_FOOTER)}
    <!-- Footer -->
    <div class="footer-container">
        <footer id="footer"  class="container" style="padding-top: 38px;">
            <div style="display: none!important;" class="row">{$HOOK_FOOTER}</div>
            <div class="col-md-4">
                <img src="{$logo_url}" class="img-reponsive">
                <p style="color: #FFF; margin-top: 25px;">
                    Queremos que descubras qué es realmente dormir diferente, si tienes alguna duda o pregunta te invitamos a que nos contactes.
                    <br><br>
                    Dirección:<br>
		    KM 1 V&iacute;a Brice&ntilde;o - Sop&oacute;<br>
		    Vereda Pueblo Viejo. Sector San Camilo Germania<br>
		    Sop&oacute; - Cundinamarca<br><br>
                    Teléfono: +571 668 4949<br>
                    E-mail: clientes@americanadecolchones.com<br><br>

                    SÍGUENOS EN: <a class="footer-social" href="https://www.facebook.com/AmericanaDeColchones/" target="_target"><i class="fa fa-facebook" style="padding: 2px;"> </i></a> <a class="footer-social" href="https://twitter.com/AmericanaDeCol" target="_target"><i class="fa fa-twitter" style="padding: 3px 0px;"> </i></a> <a class="footer-social" href="https://www.instagram.com/americanadecol/" target="_target"><i class="fa fa-instagram" style="padding: 2px 0px;"> </i></a>
                </p>
            </div>  
            <div class="col-md-4">
                <ul class="list-unstyled">
                    <li><strong style="color: #FFF;">NOSOTROS</strong></li>
                    <li><a href="{$link->getCMSLink('6')}">Quienes Somos</a></li>
                    <li><a href="{$link->getCMSLink('7')}">Responsabilidad Social</a></li>
                    <li><a href="{$base_dir_ssl}somos-diferentes">Somos Diferentes</a></li>
                    <li><a href="{$link->getCMSLink('45')}">Videos</a></li>
                    <li><a href="{$link->getCMSLink('8')}">Nuestras certificaciones</a></li>
                    <li><a href="{$link->getPageLink('contact')}">Servicio al cliente</a></li>
                    <li><a href="{$link->getCMSLink('9')}">Términos y condiciones</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <ul class="list-unstyled">
                    <li><strong style="color: #FFF;">CANALES</strong></li>
                    <li><a href="{$link->getCMSLink('11')}">HotelerÍa</a></li>
                    <li><a href="{$link->getCMSLink('12')}">Distribuidores</a></li>
                    <li><a href="{$link->getCMSLink('13')}">Franquicias</a></li>
                </ul>
                <ul class="list-unstyled" style="margin-top: 20px;">
                    <li><a href="{$link->getPageLink('stores')}"><strong style="color: #FFF;">PUNTOS DE VENTA</strong></a></li>
                    <li><a href="{$link->getPageLink('contact')}#trabaja_con_nosotros=true"><strong style="color: #FFF;">TRABAJA CON NOSOTROS</strong></a></li>
                </ul>
            </div>
        </footer>
    </div><!-- #footer -->
{/if}
<div id="gk_medios_pago" class="text-center">
    <br>
    <p style="text-align:center;"><img src="https://secure.mlstatic.com/developers/site/cloud/banners/co/785x40_Todos-los-medios-de-pago.jpg" title="MercadoPago - Medios de pago" alt="MercadoPago - Medios de pago" width="785" height="40"/></p>
    <br>
</div>
</div><!-- #page -->
{/if}
{include file="$tpl_dir./global.tpl"}


</body>
</html>
