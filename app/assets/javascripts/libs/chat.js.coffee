$.extend chatApp, {
  prepare: () ->
    if chatApp.chatArea().length
      chatApp.chatArea().animate({scrollTop: 100000 }, 2000)
      chatApp.getCurrentUser()
      if chatApp.currentUser.opened_rooms.length > 0
        chatApp.setRoomToken(chatApp.currentUser.opened_rooms[0].token)
        chatApp.reloadMessages(chatApp.getRoomMessages())
  reloadMessages: (messages) ->
    for message in messages
      chatApp.chatArea().append($.tmpl('templates/message', message))


  getRoomMessages: (e, element) ->
    if chatApp.chatArea().length
      messages = []
      $.ajax
        type: "GET"
        url: "/api/v1/messages"
        headers: { 'X-Auth-Token': chatApp.accessToken(), 'X-Room-Token': chatApp.roomToken() }
        success: (data, textStatus, xhr) ->
          messages = data.messages
        async: false
      return messages

  getCurrentUser: (e, element) ->
    if chatApp.chatArea().length
      $.ajax
        type: "GET"
        url: "/api/v1/users/1"
        headers: { 'X-Auth-Token': chatApp.accessToken() }
        success: (data, textStatus, xhr) ->
          chatApp.setCurrentUser(data)
          console.log 'CurrentUser: ', data
        async: false

  sendMessage: (e, element) ->
    if chatApp.chatArea().length
      messageBody = element.val()
      element.val('')
      chatApp.chatArea().animate({scrollTop: 100000 }, 2000);
      if chatApp.roomToken() != undefined
        $.ajax
          type: "POST"
          url: "/api/v1/messages"
          data:
            message:
              body: messageBody
          headers: { 'X-Auth-Token': chatApp.accessToken(), 'X-Room-Token': chatApp.roomToken() }
          success: (data, textStatus, xhr) ->
            console.log 'Message: ', data
            chatApp.chatArea().append($.tmpl('templates/message', data.message))
          async: false
      else
        $.ajax
          type: "POST"
          url: "/api/v1/rooms"
          data:
            message:
              body: messageBody
          headers: { 'X-Auth-Token': chatApp.accessToken() }
          success: (data, textStatus, xhr) ->
            chatApp.setRoomToken(data.room.token)
            console.log 'New Room: ', data
            chatApp.chatArea().append($.tmpl('templates/message', data.room.last_message))
          async: false
    return false
}
