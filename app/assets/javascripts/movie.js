
$(document).ready(function() {
  var date = new Date();
  //$("#date").html("<p>"+date.getFullYear()+"</p>");

  $("#datepicker").datepicker({
    dateFormat: 'yy-mm-dd',
    yearRange: '2000:2020',
    showMonthAfterYear: false,
    beforeShow: function() {
    },
    onSelect: function() {
    },
    onClose: function(date,inst) {
    },    
    showAnim: "drop",
    buttonImageOnly: false,
    showOn: "button" 
  }).next()
      .addClass("ui-button tips")
      .html('<i class="icon-calendar"></i>')
      .attr("title","select data from calender")
      .attr("aria-disabled","true");

  $('#select_box').css("top","135%");
  $('#select_box').css("left","-70%");
  $('#select_box').css("width",$(document).width()*0.2+"px");
  $('#select_box').hide();
  $('#show_select').click(function(){ 
    $('#select_box').fadeToggle(300); 
  });

  $('.tips').tipsy({gravity: 's'});
  $('.tips-n').tipsy({gravity: 'n'});
  $('.tips-e').tipsy({gravity: 'e'});
  $('.tips-w').tipsy({gravity: 'w'});

  $('.camera-image-f')
      .attr('rel', 'gallery')
      .fancybox({
        width : '80%',
        type : 'iframe',
		    openEffect	: 'fade',
		    closeEffect	: 'fade',
		    nextEffect	: 'fade',
		    prevEffect	: 'fade',
        wrapCSS : 'my-fancybox',
        'scrolling' : 'no',
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
  $(".ui-buttonset").buttonset();
  $(".ui-button").button();

  $('#movie-list').css("width",$(document).width()*0.8);
  $('#movie-list > .map').css("width",$(document).width()*0.8);
  $('#movie-list > .map').css("top",$(document).height()*0.05);
  $('#movie-list > .map').hide();

  $(".image-frame").css("width", $("#movie-list > .map").width()*0.125); // 1 : 0.547 = width():?
  $(".image-frame").css("height", $(document).width()*0.8*0.547*0.1667);
  $(".image-frame .img-load").css("top",$(document).width()*0.8*0.547*0.1667*0.2);
  $(".image-frame .img-load").css("left",$(document).width()*0.8*0.125*0.3);
  
  var moveflag;
  if($("#showed").val() == 'list') {
    $('.image-frame').each(function(i) {
      $(this).css("top",pos[i][2]*$(window).height()+"px");
      $(this).css("left",pos[i][3]*$(window).width()+"px");
    });
    $('#movie-list > .map').fadeOut();
    $("#move-swich").attr("title","switch camera map").children().addClass("icon-th");
    moveflag = "off";
  } else {
    $('.image-frame').each(function(i) {
      $(this).animate({
        top :pos[i][0]*$(document).height()+0.05*$(document).height()+"px",
        left :pos[i][1]*$(document).width()+"px"
      });
    });
    $('#movie-list > .map').fadeIn();
    $("#move-swich").attr("title","switch list").children().addClass("icon-facetime-video");
    moveflag = "on";
    $("#showed").val('camera');
  }

  $("#pagination").slider({
    orientation: 'horizontal',
    range: false,
    max: $('#max_page').val(),
    min: 1,
    value: $('#page').val(),
    slide: function(event, ui) {
      $('.sp-slider .ui-slider-handle')
          .tipsy("show")
          .attr('title','move!!');
    },
    change: function( event, ui ) {
      $("#page").attr("value", ui.value);
      $("#page").trigger("change");
    },
    animate: 'fast'
  });
  $('#page').change(function() {
    this.form.submit();
  });
  $('.sp-slider .ui-slider-handle')
      .tipsy({live: true, fade: true, gravity:'s'})
      .attr('title',$('#now_time').val());
  $("#move-swich").click(function() {
    if(moveflag == "off") {
      $('.image-frame').each(function(i) {
        $(this).animate({
          top :pos[i][0]*$(window).height()+0.05*$(document).height()+"px",
          left :pos[i][1]*$(window).width()+"px"
        });
      });
      $('#movie-list > .map').fadeIn();
      moveflag = "on";
      $(this).attr("title","switch list").children().removeClass("icon-th").addClass("icon-facetime-video");
      $("#showed").val('camera');
      $("#showed_page").val('camera');
      $("#showed_date").val('camera');
    } else {
      $('.image-frame').each(function(i) {
        $(this).animate({
          top :pos[i][2]*$(window).height()+"px",
          left :pos[i][3]*$(window).width()+"px"
        });
      });
      $('#movie-list > .map').fadeOut();
      moveflag = "off";
      $("#showed").val('list');
      $("#showed_page").val('list');
      $("#showed_date").val('list');
      $(this).attr("title","switch carera map")
          .children()
          .removeClass("icon-facetime-video")
          .addClass("icon-th");
    }
  });
  if($('#mode').val() != 'date') {
    $('#move-swich')
        .button("option", "disabled", true );
  }

  $('input')
      .css("box-shadow","none")
      .css("border","1px solid #bbbbbb");

  $('input').focus(function(){
    $(this).css("box-shadow","inset 0 0 7px #bbbbbb");
  }).blur(function(){
    $(this).css("box-shadow","none");
  });
  $('.tag_input').css("width","60%");
  $('#tag_btn').css("width","30%");

  $('.tag_form').on("ajax:complete",function(xhr) {
    //完了後
  });
  $('.tag_form').on("ajax:beforeSend",function(xhr) {
    // 送る前
    $('.tag_input').val("");
  });
  $('.tag_form').on("ajax:success",function(event, data, status, xhr) {
    //成功した場合
    $('.information').fadeIn(1000).text(data.sucess);
    $('.information').delay(1500).fadeOut(1000);
    $(data.elem).text("").delay(1000).html(function() {
      atag = "";
      data.tags.forEach(function(tag){
        atag += '<a href="/movies/search?tag='
            + tag
            +'" alt="" class="tag" target="_top">'+tag+'</a> ';
      });
      return atag;
    });
  });
  $('.tag_form').on("ajax:error",function(data, status, xhr) {
    alert('ERROR'); //失敗
  });

  $("#minute-p").click(function() {
    $("#page").attr("value", parseInt($("#page").val()) - 1);
    $("#page").trigger("change");
  });
  $("#minute-n").click(function() {
    $("#page").attr("value", parseInt($("#page").val()) + 1);
    $("#page").trigger("change");
  });
  if($('#page').val() >= $('#max_page').val()) {
    $('#minute-n').button("option", "disabled", true );
    $('#minute-n').removeClass("tips");
  }
  if($('#page').val() <= 1) {
    $('#minute-p').button("option", "disabled", true );
    $('#minute-p').removeClass("tips");
  }

});

var pos = [[0.620, 0.435, 0.1, 0.06],
           [0.62, 0.0, 0.1, 0.18],
           [0.300, 0.550, 0.1, 0.30],
           [-0.04, 0.435, 0.1, 0.42],
           [0.3,   0.18, 0.1,   0.54],
           [-0.04, 0.7, 0.1,  0.66],
           [0.2,0.67, 0.3, 0.06], 
           [0.4,0.67, 0.3, 0.18],
           [0.1,0.55, 0.3, 0.30],
           [0.2,0.435, 0.3, 0.42],
           [-0.04,0.33, 0.3, 0.54],
           [0.1,0.3, 0.3, 0.66],
           [0.3,0.3, 0.5, 0.18],
           [0.1,0.18, 0.5, 0.30],
           [0.5,0.180, 0.5, 0.42], 
           [0.3, 0.06, 0.5, 0.54] ];


/*

  var pos = [[580,400],[160,400],[710,250],[580,70],[310,250],[850,70],
             [850,200],[850,300],[710,120],[580,200],[450,20],[450,120],
             [450,250],[310,120],[310,350],[170,250]];

  var rpos = [[580,450],[180,450],[710,250],[590,75],[310,250],[860,75],
             [850,200],[850,300],[710,120],[580,200],[520,75],[450,120],
             [450,250],[310,120],[310,350],[170,250]];

  $('.camera_icon').each(function(i) {
    $(this).css("left",rpos[i][0]);
    $(this).css("top",rpos[i][1]);
  });
  $('.camera-image').hide();
  $('#wrapper').css("height",$("body").height()*0.82);
  $('.ui-tab').css("height",$("body").height()*0.82);
  $('.my-input').focus(function(){
    $(this).css("box-shadow","inset 0 0 7px #bbbbbb");
  }).blur(function(){
    $(this).css("box-shadow","none");
  });

  $("#pagination").slider({
    orientation: 'horizontal',
    range: 'min',
    max: $('#max_page').val(),
    min: 1,
    value: params().page,
    change: function( event, ui ) {
      $("#page").attr("value", ui.value);
      $("#page").trigger("change");
    },
    animate: 'fast'
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

  $('input').hover(function(){});
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

  $("#minute-p").button();
  $("#minute-n").button();
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
    width: 300,
    height: $("body").height()*0.2,
    resizable: true
  });

  $('.image-frame').draggable({
    drag: function() {}
  });
  // $('#pop').popover({
  //   html : true,
  //   content: function() {
  //     return $('.selector').html();
  //   },
  //   title: "i'm sleeping....",
  //   placement:'bottom'
  // });

*/