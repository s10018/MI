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

  $("#partslider").slider({
    orientation: 'horizontal',
    range: 'min',
    max: 6,
    min: 0,
    value: $("#partshow").val(),
    step: 1,
    change: function( event, ui ) {
      $("#partshow").val(ui.value);
      $("#part").attr("value", ui.value);
      $("#partshow").trigger("change");
      this.form.submit();
    },
    animate: 'fast'
  });

  $('#partshow').change(function() {
    this.form.submit();
  });

  $('#pages').tabs({
    selected: 1,
    fx: { opacity: 'toggle', duration: 'normal'}
  });

  $("#datepicker").datepicker({
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true,
    yearRange: '2000:2020',
    showMonthAfterYear: false,
    showButtonPanel: true,
    closeText: "Send",
    beforeShow: function() {
      
    },
    onSelect: function() {
    },
    onClose: function(date,inst) {
      if(!(date == params().date)){ this.form.submit(); }
    }
  });

  $('.fancybox')
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

  $(".camera-image").fadeIn(600);
});

