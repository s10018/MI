// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery-ui
//= require fancybox
//= require_self
//= require_tree .

var ipad = false;

// パラメータの取得: params[取得したいパラメータ名]
var params = [];

$(function() {
  var hash;
  var hashes = window.location.search.substring(1).split('&'); 
  for(i = 0; i < hashes.length; i++) { 
    hash = hashes[i].split('='); 
    params.push(hash[0]);
    params[hash[0]] = hash[1];
  }
});

$('head').append(
	'<style type="text/css">body { display: none; } #fade, #loader { display: block; }</style>'
);
var i = 0;
var int = 0;
jQuery.event.add(window,"load",function() { // 全ての読み込み完了後に呼ばれる関数
	var pageH = $("body").height();
  var delaytime = 250;
	$("#fade").css("height", pageH).delay(900).fadeOut(800);
	$("#loader").delay(600).fadeOut(300);
	$("body").css("display", "block");
  var int=setInterval(function(){
  });
  $('.camera-image:hidden').each(function(i){
    $(this).delay(delaytime*i-100).fadeIn(1000,function() {
      $(this).parent().prev().hide();
    });
  });
});







