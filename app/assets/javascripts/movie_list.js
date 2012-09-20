$(document).ready(function() {

  $urls=['http://farm3.static.flickr.com/2526/4196070281_0a93789862_s.jpg',
         'http://farm3.static.flickr.com/2689/4196824214_fdcf872e3d_s.jpg',
         'http://farm3.static.flickr.com/2429/4196824188_28af5aaed7_s.jpg'];

  for(var i=0; i<$urls.length; i++){
    var src=$urls[i];
    $('<img />')
        .attr('src', src)
        .load(function(){
          $("#demo").append($(this));
        });
  }

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
    selected: 2,
    fx: { opacity: 'toggle', duration: 200 }
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
