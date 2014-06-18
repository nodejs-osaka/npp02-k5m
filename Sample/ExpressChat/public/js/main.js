(function($){
  $(function(){

    function dispMsg( data ){
      //画面にメッセージを表示する
      //上に表示されるメッセージが最新となる

      var message = data.message;
      if ( message == "" )
      {
        return;
      }

      var name = data.name;

      var msg = "";
      if ( name != null ) msg = name + " > ";
      msg += message;

      var elem = $("<li>");
      elem.text( msg ).addClass("list").css({
        "opacity": 0.0
      }).hide();

      $( "#message" ).prepend( elem );

      var height = elem.height();
      elem.css({
        "height": 0
      }).show().animate({
        "height": height,
        "opacity": 1.0
      }, 200 );
    }

    var socket = io.connect();

    //
    socket.on('status', function (data) {

      var online = data.online;
      if ( typeof(online) == "number" ){
        $( "#online" )
          .hide()
          .css({
            "opacity": 0.0
          })
          .text( online )
          .show()
          .animate({
            "opacity": 1.0
          }, 100 );
      }

      var pid = data.pid;
      if ( typeof(pid) == "number" ){
        pid = "<--pid: " + pid;
        $( "#pid" )
          .hide()
          .css({
            "opacity": 0.0
          })
          .text( pid )
          .show()
          .animate({
            "opacity": 1.0
          }, 100 );
      }


    });

    //
    socket.on('message', dispMsg);

    $("#send").click(function(){
      //メッセージ入力欄が空白でなければメッセージを送信する
      var message = $( "#msg" ).val();
      if ( message === "" )
      {
        return;
      }
      var name = $( "#name" ).val();
      if ( name == null || name == "" ) name = "Anonymous";

      var sendData = {
        "name": name,
        "message": message
      };

      socket.emit("sendMsg", sendData );

      $( "#msg" ).val( "" );
    });

  });

})(jQuery);