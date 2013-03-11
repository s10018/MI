$(document).ready(function() {
  var date = new Date();
  
  $('.tag_input').css("width","50%");
  $('#tag_btn').css("width","30%");
  $('#information').hide();

  $('.tag_form').on("ajax:complete",function(xhr) {
    //完了後
  });
  $('.tag_form').on("ajax:beforeSend",function(xhr) {
    // 送る前
    if($('.tag_input').val() == "") {
      $('#information').removeClass("alert-success");
      $('#information')
          .addClass("alert-error")
          .fadeIn(1000).html("エラー : タグを入力してください")
          .delay(1500).fadeOut(1000);
      return false;
    }
    $('.tag_input').val("");
    return true;
  });
  $('.tag_form').on("ajax:success",function(event, data, status, xhr) {
    //成功した場合
    $('#information').removeClass("alert-error");
    $('#information').addClass("alert-success")
        .fadeIn(1000).text(data.success).delay(1500)
        .fadeOut(1000);
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
  $('.tag_form').on("ajax:error",function(event, data, status, xhr) {
    $('#information').removeClass("alert-success");
    $('#information')
        .addClass("alert-error")
        .fadeIn(1000).html("サーバエラー : 登録できませんでした")
        .delay(1500).fadeOut(1000);
  });

});