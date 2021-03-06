/*
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
 */
//global variables
if (typeof $.uniform.defaults !== 'undefined')
{
    if (typeof contact_fileDefaultHtml !== 'undefined')
        $.uniform.defaults.fileDefaultHtml = contact_fileDefaultHtml;
    if (typeof contact_fileButtonHtml !== 'undefined')
        $.uniform.defaults.fileButtonHtml = contact_fileButtonHtml;
}

$(document).ready(function () {
    $(document).on('change', 'select[name=id_contact]', function () {
        $('.desc_contact').hide();
        $('#desc_contact' + parseInt($(this).val())).show();
    });
    $(document).on('change', 'select[name=id_order]', function () {
        showProductSelect($(this).attr('value'));
    });
    showProductSelect($('select[name=id_order]').attr('value'));
    $('#id_contact').change(function () {
        if ($(this).val() == 2) {
            $('.contenedor_upload_file').removeClass('hidden');
            $('#fileUpload').removeAttr('disabled', 'disabled');
        } else {
            $('.contenedor_upload_file').addClass('hidden');
            $('#fileUpload').attr('disabled', 'disabled');
        }
    });
});
$(window).load(function () {
    if (typeof location.hash != "undefined" && location.hash == '#trabaja_con_nosotros=true') {
        $('.contenedor_upload_file').removeClass('hidden');
        $('#fileUpload').removeAttr('disabled', 'disabled');
    } else if (typeof location.hash != "undefined" && location.hash == '#franquicias') {
        $('#desc_contact0').css('display', 'none');
        $('#desc_contact4').css('display', 'block');
        $('#id_contact').val('4');
        $('#id_contact option[value=4]').attr('selected', 'selected');
        $('#uniform-id_contact>span').text($('#id_contact option[value=4]').text());
        $('.contenedor_upload_file').addClass('hidden');
        $('#fileUpload').attr('disabled', 'disabled');
    } else {
        $('.contenedor_upload_file').addClass('hidden');
        $('#fileUpload').attr('disabled', 'disabled');
    }
});
function showProductSelect(id_order)
{
    $('.product_select').hide().prop('disabled', 'disabled').parent('.selector').hide();
    $('.product_select').parents('.form-group').find('label').hide();
    if ($('#' + id_order + '_order_products').length > 0)
    {
        $('#' + id_order + '_order_products').removeProp('disabled').show().parent('.selector').removeClass('disabled').show();
        $('.product_select').parents('.form-group').show().find('label').show();
    }
}
