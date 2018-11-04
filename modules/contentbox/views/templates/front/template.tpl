{*
*  @author    Miguel Costa for emotionLoop
*  @copyright emotionLoop
*}
{if $category->id AND $category->active}       {if ($category->id_category == 12) OR ($category->id_parent ==12)} 

{$content|escape:nofilter}
{/if}
{/if}
