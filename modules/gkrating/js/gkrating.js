$(document).ready(function() {
    $('.gkranking ul li i').click(function() {
        $.ajax({
            url: $('#gkranking_link').val(),
            type: 'POST',
            dataType: 'text',
            async: false,
            data: { "gkrankingSubmitStart": "true", "id": $(this).attr('data-pid'), "estrellas": $(this).attr('data-cal') }
        }).done(function(rtn) {
            alert("Gracias por calificar nuestro producto.");
        });
    });
});