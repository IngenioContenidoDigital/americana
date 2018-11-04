
<!-- GK Block Viewed products -->
<div id="gkhomefeatured_block">
    <h4 class="title_block text-center">{l s='Productos Destacados' mod='gkhomefeatured'}</h4>
    <div class="col-md-4 col-md-offset-4">
        <p class="subtitulo_gkhomefeatured text-center">Estos son los productos más vistos por otros visitantes.</p>
    </div>
    <div class="clearfix"></div>
    <div class="block_content row-fluid">
        {foreach from=$productsViewedObj item=viewedProduct name=myLoop}
            <div class="col-md-20{if $smarty.foreach.myLoop.last} last_item{elseif $smarty.foreach.myLoop.first} first_item{else} item{/if}">
                <a href="{$viewedProduct->product_link|escape:'html'}" title="{l s='About' mod='blockviewed'} {$viewedProduct->name|escape:html:'UTF-8'}" class="content_img">
                    <img src="{if isset($viewedProduct->id_image) && $viewedProduct->id_image}{$link->getImageLink($viewedProduct->link_rewrite, $viewedProduct->cover, 'home_default')}{else}{$img_prod_dir}{$lang_iso}-home_default.jpg{/if}" alt="{$viewedProduct->legend|escape:html:'UTF-8'}" title="{$viewedProduct->legend|escape:html:'UTF-8'}"/>
                </a>
                <div class="text_desc">
                    <div class="colver-border">
                        <h5 class="s_title_block text-center">
                            <a href="{$viewedProduct->product_link|escape:'html'}" title="{l s='Acerca de' mod='blockviewed'} {$viewedProduct->name|escape:html:'UTF-8'}">
                                <i class="fa fa-search"> </i><br>
                                {$viewedProduct->name|escape:html:'UTF-8'}
                            </a>
                        </h5>
                    </div>
                </div>
            </div>
        {/foreach}
        <div class="clearfix"></div>
    </div>
</div>


<div id="gk_newsletter" class="container">
    <h4 class="title_block text-center">BOLETÍN</h4>
    <div class="col-md-4 col-md-offset-4">
        <p class="subtitulo_gkhomefeatured text-center">Si deseas recibir más información sobre productos, lanzamientos y todo el Descanso Natural que tenemos para ti, déjanos tu email.</p>
    </div>
    <div class="clearfix"></div>
    <form action="{$link->getPageLink('index', true)|escape:'html'}" method="post">
        <input type="hidden" name="action" value="0" />
        <div class="row">
            <div class="col-md-4 col-md-offset-1">
                <input class="form-control" type="text" name="name" size="18" placeholder="TU NOMBRE" />
            </div>
            <div class="col-md-4">
                <input class="inputNew form-control" id="newsletter-input" type="text" name="email" size="18" placeholder="TU EMAIL" />
            </div>
            <div class="col-md-2">
                <button type="submit" value="ok" class="btn tbn-primary form-control" name="submitNewsletter">
                    ENVIAR
                </button>
            </div>
            <div class="clearfix"></div>
        </div>
    </form>
</div>
