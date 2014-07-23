$ ->
  chatApp.prepare()
  $(document).on 'keydown', "form #message", (e) ->
      if e.keyCode == 13
        e.preventDefault();
        chatApp.sendMessage e, $(e.target)
        # chatApp.setRoomToken(chatApp.userToken())
        # return false;
