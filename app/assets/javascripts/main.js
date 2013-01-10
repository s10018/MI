$(document).ready(function() {

  // パラメータの取得: params().num
  var params = function() {
    var vars = [], hash;
    hashes = window.location.search.substring(1).split('&'); 
    for(i = 0; i < hashes.length; i++) { 
      hash = hashes[i].split('='); 
      vars.push(hash[0]);
      vars[hash[0]] = hash[1];
    }
    return vars;
  };
  var tab_id = function() {
    tab_hash = {
      'outline': 0, 'detail': 1
    };
    return tab_hash[params().mode];
  };

  $("#slider").slider({
    orientation: 'horizontal',
    range: 'min',
    max: 100,
    value: 50,
    slide: refreshImage,
    change: refreshImage,
    animate: 'fast'
  });

  function refreshImage() {
    var value = $( '#slider' ).slider( 'value' );
  }
  var part_hash = {
    '0時限目':0,  
    '1時限目':1,  
    '2時限目':2,  
    '昼休み' :3,
    '3時限目':4,  
    '4時限目':5,  
    '5時限目':6,
    '6時限目':7
  };
  $("#partslider").slider({
    orientation: 'horizontal',
    range: 'min',
    max: 7,
    min: 0,
    value: part_hash[$("#partshow").text()],
    step: 1,
    change: function( event, ui ) {
      var value = part_hash[ui.value];
      $("#part").attr("value", ui.value);
      $("#part").trigger("change");
    },
    animate: 'fast'
  });
  $('#part').change(function() {
    this.form.submit();
  });
  $('#pages').tabs({
    selected: 1,
    fx: { opacity: 'toggle', duration: 'normal'}
  });

  $("#datepicker").datepicker({
    dateFormat: 'yy-mm-dd',
    yearRange: '2000:2020',
    showMonthAfterYear: false,
    beforeShow: function() {
    },
    onSelect: function() {
    },
    onClose: function(date,inst) {
      if(!(date == params().date)){ this.form.submit(); }
    },
    showAnim: "drop"
  });

  $('.camera-image-f')
      .attr('rel', 'gallery')
      .fancybox({
		    openEffect	: 'none',
		    closeEffect	: 'none',
		    nextEffect	: 'fade',
		    prevEffect	: 'fade',
        beforeLoad: function() {
          this.title = $(this.element).attr('caption');
        },
        helpers : {
          overlay : {
            css : {
              'background' : 'rgba(0, 0, 0, 0.7)'
            }
          },
          title : {
            type : 'inside'
          },
			    thumbs	: {
				    width	: 32,
				    height	: 24
			    }
        }
      });
  $('#camera-map-f')
      .attr('rel', 'camera-map')
      .fancybox({
		    openEffect	: 'none',
		    closeEffect	: 'none',
		    nextEffect	: 'fade',
		    prevEffect	: 'fade',
        helpers : {
          overlay : {
            css : {
              'background' : 'rgba(0, 0, 0, 0.7)'
            }
          },
          title : {
            type : 'inside'
          },
			    thumbs	: {
				    width	: 32,
				    height	: 24
			    }
        }
      });

	$('.camera-image').hide();//hide all the images on the page
	$('#movie-list').fadeIn();//fades in the hidden images one by one

  $("#range-check").buttonset();
  $("#order-select").buttonset();
  $("#process-box").buttonset();
  $("#camera-map-f").button();
  
});

var i = 0;//initialize
var int=0;//Internet Explorer Fix

function doThis() {
	var imgs = $('.camera-image').length + 1;//count the number of images on the page
	if (i >= imgs) {// Loop the images
		clearInterval(int); //When it reaches the last image the loop ends
	  $('.image-frame').css("background","#eee");//fades in the hidden images one by one
	}
	$('.camera-image:hidden').eq(0).fadeIn(600);//fades in the hidden images one by one
	i++; //add 1 to the count
}
$('head').append(
	'<style type="text/css">#body { display: none; } #fade, #loader { display: block; }</style>'
);
jQuery.event.add(window,"load",function() { // 全ての読み込み完了後に呼ばれる関数
	var pageH = $("body").height();
	$("#fade").css("height", pageH).delay(900).fadeOut(800);
	$("#loader").delay(600).fadeOut(300);
	$("div#body").css("display", "block");
  var int = setInterval("doThis(i)",150);
});