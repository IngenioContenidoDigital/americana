
{**
* ShoppingCart Template
* 
* @author Empty
* @copyright  Empty
* @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*}

<div id="print-quotation">
    <br />
    <h1 class="page-heading">
        {l s='Print a quote' mod='pdfquotation'}
    </h1>
    <div id="customer-information">
        <form>
            <div class="required form-group">
                <label for="first_name">{l s='First Name' mod='pdfquotation'}</label>
                <input name="first_name" id="first_name" type="text" required="required"/>
            </div>

            <div class="required form-group">
                <label for="last_name">{l s='Last Name' mod='pdfquotation'}</label>
                <input name="last_name" id="last_name" type="text" required="required"/>
            </div>

            <div class="required form-group">
                <label for="email">{l s='E mail' mod='pdfquotation'}</label>
                <input name="email" id="email" type="email" required="required"/>
            </div>

            <div class="required form-group">
                <label for="phone">{l s='Phone' mod='pdfquotation'}</label>
                <input name="phone" id="phone" type="text"/>
            </div>

            <div class="clearfix">
                <label>{l s='To be contacted again' mod='pdfquotation'}</label>
                <div class="radio-inline">
                    <label for="yes" class="top">
                        <div class="radio">
                            <span>
                                <input type="radio" name="contacted" id="yes" value="1" checked="checked">
                            </span>
                        </div>
						{l s='Yes' mod='pdfquotation'}
                    </label>
                </div>
                <div class="radio-inline">
                    <label for="no" class="top">
                        <div class="radio">
                            <span>
                                <input type="radio" name="contacted" id="no" value="0">
                            </span>
                        </div>
						{l s='No' mod='pdfquotation'}
                    </label>
                </div>
            </div>

            <input name="spam" id="spam" type="hidden" value=""/>

            <button type="submit" class="button btn btn-default button-medium">
                <span>{l s='Print' mod='pdfquotation'}<i class="icon-chevron-right right"></i></span>
            </button>
        </form>
    </div>
</div>
