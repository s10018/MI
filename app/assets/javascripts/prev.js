
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

  $('input')
      .css("box-shadow","none")
      .css("border","1px solid #bbbbbb");

  $('input').focus(function(){
    $(this).css("box-shadow","inset 0 0 7px #bbbbbb");
  }).blur(function(){
    $(this).css("box-shadow","none");
  });

  $("body").hide();
});

$('head').append(
	'<style type="text/css">body { display: none; } #fade, #loader { display: block; }</style>'
);
var i = 0;
var int = 0;
jQuery.event.add(window,"load",function() { // 全ての読み込み完了後に呼ばれる関数
	var pageH = $("body").height();
  var delaytime = 100;
	$("#fade").css("height", pageH).delay(1000).fadeOut(800);
	$("#loader").delay(600).fadeOut(300);
	$("body").fadeIn(300);
  $('.image-frame:hidden').each(function(i){
    $(this).delay(delaytime*i-100).fadeIn(1000,function() {

    });
  });
});
