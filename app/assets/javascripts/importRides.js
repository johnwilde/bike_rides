// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// This function is executed after the DOM is loaded
$(function(){
  $('.button_to').submit(function (){
    $('.status').show();
    $('.status').html("Checking for new rides...");
    return true;
    // $.post($(this).attr('action'), $(this).serialize(), null, "script");
    // return false;
  });
});

