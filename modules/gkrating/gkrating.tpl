<!-- Block GK Rating -->
{if isset($gk_product_id) && $gk_product_id}
    <input type="hidden" id="gkranking_link" value="{$smarty.server.REQUEST_URI}">
    <div class="gkranking clearfix">
        <ul class="list-unstyled list-inline">
            {for $pro=1 to $gk_product_rating}
                <li><i title="Dar {$pro} estrellas a éste producto" class="fa fa-star" data-pid="{$gk_product_id}" data-cal="{$pro}"> </i></li>
            {/for}

            {if (5 - $gk_product_rating) > 0}
                {for $pro=1 to (5 - $gk_product_rating)}
                    <li><i title="Dar {$pro + $gk_product_rating} estrellas a éste producto" class="fa fa-star-o" data-pid="{$gk_product_id}" data-cal="{$pro + $gk_product_rating}"> </i></li>
                {/for}
            {/if}
        </ul>
    </div>
{/if}
<!-- /Block GK Rating -->