$(document).ready(function() {

  //var date = new Date('2012-01-20 13:10') - new Date('2012-01-20 12:10');
  //alert(date); // (ミリ秒が返ってくる)
  // 1分 -> 60000
  // 1時間 -> 

  $("#pagination").slider({
    orientation: 'horizontal',
    range: false,
    max: parseInt($('#max_page').val()),
    min: 1,
    value: parseInt($('#page').val()),
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

  $("#minute-p").click(function() {
    $("#page").attr("value", parseInt($("#page").val()) - 1);
    $("#page").trigger("change");
  });
  $("#minute-n").click(function() {
    $("#page").attr("value", parseInt($("#page").val()) + 1);
    $("#page").trigger("change");
  });
  if(parseInt($('#page').val()) >= parseInt($('#max_page').val())) {
    $('#minute-n').button("option", "disabled", true );
    $('#minute-n').attr("title","");
  }
  if(parseInt($('#page').val()) <= 1) {
    $('#minute-p').button("option", "disabled", true );
    $('#minute-n').attr("title","");
  }

});