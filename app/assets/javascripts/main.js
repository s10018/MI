$(document).ready(function() {
  // パラメータの取得: param().num
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

  $('#pages').tabs({
    selected: 1,
    fx: { opacity: 'toggle', duration: 'normal'}
  });

  $("#datepicker").datepicker({
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true,
    yearRange: '2000:2020',
    showMonthAfterYear: false
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
});

