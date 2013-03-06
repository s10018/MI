$(document).ready(function() {
  var date = new Date();
  
  $('.tag_input').css("width","50%");
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

});