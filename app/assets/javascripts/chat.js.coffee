$ ->
  chatApp.init()
  $(document).on 'keydown', "form #message", (e) ->
      if e.keyCode == 13
        e.preventDefault();
        chatApp.sendMessage e, $(e.target)

  $(document).on 'click', ".responders-list-item", (e) ->
    chatApp.changeRoom($(this).data('room_token'))

  $(document).on 'click', "#room-close", (e) ->
    chatApp.closeRoom()


