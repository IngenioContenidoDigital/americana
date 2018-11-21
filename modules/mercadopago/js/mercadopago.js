$(document).ready(function(){
    $("#accordion").accordion();
    Mercadopago.setPublishableKey($('#public').val());
    Mercadopago.getIdentificationTypes();
});

function getBin(s){
    if(s.length >= 6){
        return s.substr(0,6);
    }else{
        return;
    }
}

function setPaymentMethodInfo(status, response) {
    $('#paymentMethodId').val(response[0].id);
    var src = '/modules/mercadopago/img/';
    switch(response[0].id){
        case 'visa':
            src+='visa.png'
            break;
        case 'master':
            src+='master.png'
            break;
        case 'amex':
            src+='amex.png'
            break;
        case 'discover':
            src+='discover.png'
            break;
        default:
            break;
    }
    $('#franquicia').attr('src',src)
};

function sdkResponseHandler(status, response) {
    if (status != 200 && status != 201) {
        alert("Verifica los Datos Ingresados");
    }else{
        $('#token').val(response.id);
        $('#pay').submit();
    }
};

function setInstallmentsInfo(status, response){
    if (status != 200 && status != 201) {
        alert("Verifica los Datos Ingresados");
    }else{
        $('#issuer').val(response[0].issuer.id);
    }
}
