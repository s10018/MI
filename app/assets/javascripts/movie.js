
$(document).ready(function() {

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

  $(".ui-buttonset").buttonset();
  $(".ui-button").button();
  $("#part_select").buttonset();
  $("#search_switch").buttonset();

  $('#search_switch > input').change(function(){
    $('#search_mode').val($(this).val());
  });

  $('#controller').children('.ui-button').each(function(i){
    $(this).css({
      top:$(document).height()*0.001,
      left:$(document).width()*0.01+$(document).width()*0.01*i
    });
  });

  $('#select_box').hide();
  $('#show_select').click(function(e){
    event.stopPropagation();
    $('#select_box').css({
      top:$(this).offset().top+1.7*$(this).height(),
      left:$(this).offset().left-$('#select_box').width()*0.5
    });
    $('#select_box').fadeToggle(300);
  });
  $('#select_box').css("width",$(document).width()*0.3+"px");
  $('#select_box').skOuterClick(function() {
    $(this).fadeOut(300);
  });

  $('#all_tag').hide();
  $('#tag-list-show').click(function(e){
    event.stopPropagation();
    $('#all_tag').css({
      top:$(this).offset().top+1.7*$(this).height(),
      left:$(this).offset().left-$('#all_tag').width()*0.5
    });
    $('#all_tag').fadeToggle(300); 
  });
  $('#all_tag').css("width",$(document).width()*0.3+"px");
  $('#all_tag').skOuterClick(function() {
    $(this).fadeOut(300);
  });

  $('.tips').tipsy({gravity: 's', fade: true});
  $('.tips-n').tipsy({gravity: 'n', fade: true});
  $('.tips-e').tipsy({gravity: 'e', fade: true});
  $('.tips-w').tipsy({gravity: 'w', fade: true});

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

  posDesign();

  if($("#showed").val() == 'list') {
    $('.image-frame').each(function(i) {
      $(this).css("top",pos[i][2]*$(window).height()+"px");
      $(this).css("left",pos[i][3]*$(window).width()+"px");
    });
    $('#movie-list > .map').fadeOut();
    $("#move-swich").attr("title","switch camera map").children().addClass("icon-th");
    $("#showed").val('list');
    $("#showed_page").val('list');
    $("#showed_date").val('list');
  } else {
    $('.image-frame').each(function(i) {
      $(this).css("top",pos[i][0]*$(window).height()+0.05*$(document).height()+"px");
      $(this).css("left",pos[i][1]*$(window).width()+0.05*$(document).height()+"px");
    });
    $('#movie-list > .map').fadeIn();
    $("#move-swich").attr("title","switch list").children().addClass("icon-facetime-video");
    $("#showed").val('camera');
    $("#showed_page").val('camera');
    $("#showed_date").val('camera');
  }
  $("#move-swich").click(function() {
    if($("#showed").val() == 'list') {
      $('.image-frame').each(function(i) {
        $(this).animate({
          top :pos[i][0]*$(window).height()+0.05*$(document).height()+"px",
          left :pos[i][1]*$(window).width()+"px"
        });
      });
      $('#movie-list > .map').fadeIn();
      $(this).attr("title","switch list")
          .children()
          .removeClass("icon-th")
          .addClass("icon-facetime-video");
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
      $("#showed").val('list');
      $("#showed_page").val('list');
      $("#showed_date").val('list');
      $(this).attr("title","switch carera map")
          .children()
          .removeClass("icon-facetime-video")
          .addClass("icon-th");
    }
  });
  if($('#mode').val() != 'date' && $('#mode').val() != 'part') {
    $('#move-swich')
        .button("option", "disabled", true );
  }

  $('#select_submit').click(function() {
    if($("#datepicker").val() == "") {
      alert("ERROR! please select date!");
      return;
    } else {
      var flag = true;
      $('.part').each(function(){
        if($(this).attr('checked')) {
          $("#part_date").val($("#datepicker").val());
          $("#part_select").submit();
          flag = false;
        }
      });
      if(flag) {
        $("#date_select").submit();
      }
    }
  });
  setTimeout(function() {
    $("#info")
        .animate({
          left :"-4%"
        },1500);
  },500);

});

var pos = [[0.620, 0.42, 0.05, 0.18],
           [0.62, 0.0, 0.05, 0.30],
           [0.300, 0.550, 0.05, 0.42],
           [-0.04, 0.42, 0.05, 0.54],

           [0.3,   0.18, 0.25,   0.18],
           [-0.04, 0.7, 0.25,  0.30],
           [0.2,0.67, 0.25, 0.42], 
           [0.4,0.67, 0.25, 0.54],

           [0.1,0.55, 0.45, 0.18],
           [0.2,0.42, 0.45, 0.30],
           [-0.04, 0.3, 0.45, 0.42],
           [0.1, 0.3, 0.45, 0.54],

           [0.3,0.3, 0.65, 0.18],
           [0.1,0.18, 0.65, 0.30],
           [0.5,0.180, 0.65, 0.42], 
           [0.3, 0.06, 0.65, 0.54] ];

function posDesign() {
  $('#movie-list').css("width",$(document).width()*0.8);
  $('#movie-list').css("height",$(document).height()*1.0);
  $('#movie-list > .map').css("width",$(document).width()*0.8);
  $('#movie-list > .map').css("top",$(document).height()*0.05);
  $('#movie-list > .map').hide();

  $(".image-frame").css("width", $("#movie-list > .map").width()*0.10); // 1 : 0.547 = width():?
  $(".image-frame").css("height", $(document).width()*0.8*0.547*0.15);
}
