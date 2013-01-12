$(document).ready(function() {

  $('.camera-image').hide();

  $('#wrapper').css("height",$("body").height()*0.82);
  $('.ui-tab').css("height",$("body").height()*0.82);

  // パラメータの取得: params().[取得したいパラメータ名]
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
      'outline': 0, 'detail': 1, 'desc': 2
    };
    return tab_hash[params().mode];
  };

  $("#minute-slider").slider({
    orientation: 'horizontal',
    range: 'min',
    max: 90,
    min: 1,
    value: params().page,
    change: function( event, ui ) {
      $("#page").attr("value", ui.value);
      $("#page").trigger("change");
    },
    animate: 'fast'
  });
  $('#page').change(function() {
    this.form.submit();
  });
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
    selected: 0,
    fx: { opacity: 'toggle', duration: 'normal' }
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
    showAnim: "drop",
    buttonImageOnly: true,
    showOn: "button"
  });

  $('.camera-image-f')
      .attr('rel', 'gallery')
      .fancybox({
		    openEffect	: 'fade',
		    closeEffect	: 'fade',
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
  $('#camera-map-f')
      .attr('rel', 'camera-map')
      .fancybox({
		    openEffect	: 'none',
		    closeEffect	: 'none',
		    nextEffect	: 'none',
		    prevEffect	: 'none',
        beforeLoad: function() {
          $('.map').delay(600).show();
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

	$('#movie-list').fadeIn();

  $(".ui-button").button();
  $("#minute-p").button();
  $("#minute-n").button();
  $("#minute-p").click(function() {
    if(parseInt(params().page) - 1 > 0) {
      $("#page").attr("value", parseInt(params().page) - 1);
      $("#page").trigger("change");
    }
  });
  $("#minute-n").click(function() {
    if(parseInt(params().page) + 1 < 90) {
      $("#page").attr("value", parseInt(params().page) + 1);
      $("#page").trigger("change");
    }
  });
  $(".ui-buttonset").buttonset();
  $("#open_select").click(function() {
    $("#show_select").dialog("open");
    return false;
  });
  $("#show_select").dialog({
    autoOpen: false,
    show: "blind",
    hide: "blind",
    modal: true,
    width: 500,
    height: 500,
    resizable: false
  });
  $('.tips').tipsy({gravity: 's'});
});

$('head').append(
	'<style type="text/css">body { display: none; } #fade, #loader { display: block; }</style>'
);
jQuery.event.add(window,"load",function() { // 全ての読み込み完了後に呼ばれる関数
	var pageH = $("body").height();
  var delaytime = 150;
	$("#fade").css("height", pageH).delay(900).fadeOut(800);
	$("#loader").delay(600).fadeOut(300);
	$("body").css("display", "block");
  for(var i = 0; i < $(".camera-image").length; i++){
    $('.camera-image').eq(i).delay(i*delaytime).fadeIn(600,function() {
      $(this).parent().css("background","#E6E6E6");
    });
  }
});