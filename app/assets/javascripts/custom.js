$(document).ready(function(){
    $(".iconsWrapper a").mouseenter(function(){
        $(this).stop().animate({
            marginTop : -10
        }, 100, function() {
            // Animation complete.
        });
    });
    $(".iconsWrapper a").mouseleave(function(){
        $(this).stop().animate({
            marginTop : 0
        }, 100, function() {
            // Animation complete.
        });
    });
    $('.best_in_place').best_in_place();

//
//        $('select').each(function(){
//            var title = $(this).attr('title');
//            if( $('option:selected', this).val() != ''  ) title = $('option:selected',this).text();
//            $(this)
//                .css({'z-index':10,'opacity':0,'-khtml-appearance':'none'})
//                .after('<span class="selText">' + title + '</span>')
//                .change(function(){
//                    var selTxt = $('option:selected',this).text();
//                    $(this).next().text(selTxt);
//                })
//        });

});