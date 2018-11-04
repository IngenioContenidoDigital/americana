{if $MENU != ''}
    <!-- Menu -->
    <div id="block_top_menu" class="sf-contener clearfix col-lg-12">
        <div class="cat-title">{l s="Menu" mod="blocktopmenu"}</div>
        <div class="container">
        <ul class="sf-menu clearfix menu-content">
            {$MENU}
            {if $MENU_SEARCH || true}
                <li class="sf-search noBack" style="float:right">
                    <form id="searchbox" action="{$link->getPageLink('search')|escape:'html':'UTF-8'}" method="get">
                        <p>
                            <input type="hidden" name="controller" value="search" />
                            <input type="hidden" value="position" name="orderby"/>
                            <input type="hidden" value="desc" name="orderway"/>
                            <label for="custom_search_query"><input type="text" id="custom_search_query" name="search_query" value="{if isset($smarty.get.search_query)}{$smarty.get.search_query|escape:'html':'UTF-8'}{/if}" /><i class="fa fa-search"> </i></label>
                        </p>
                    </form>
                </li>
            {/if}
        </ul>
    </div>
    </div>
    <!--/ Menu -->
{/if}