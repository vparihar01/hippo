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
});