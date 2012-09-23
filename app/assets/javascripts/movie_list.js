
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

  $("#datepicker").datepicker({
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true,
    yearRange: '2000:2020',
    showMonthAfterYear: false
  });

  $('#pages').tabs({
    selected: tab_id(),
    fx: { opacity: 'toggle', duration: 'normal'}
  });

  $("a.fancybox")
      .attr('rel', 'gallery')
      .fancybox(
        {
          beforeLoad: function() {
            this.title = $(this.element).attr('caption');
          },
          nextSpeed : 250,
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
				      width	: 50,
				      height	: 50
			      }
          }
        }
      );

});
