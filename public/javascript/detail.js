
$('a.fancybox')
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


