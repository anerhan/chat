$.extend chatApp, {
  prepare: () ->
    if chatApp.chatArea().length
      chatApp.chatArea().animate({scrollTop: 100000 }, 2000)
      chatApp.getCurrentUser()
      # if chatApp.currentUser.available_rooms.length > 0
        # if chatApp.currentUser.is_anonymous
        #   chatApp.setCurrentRoom(chatApp.currentUser.available_rooms[0])
      if chatApp.currentUser.available_rooms.length > 0
        chatApp.setCurrentRoom(chatApp.currentUser.available_rooms[0])
        chatApp.reloadMessages()
        # chatApp.setRoomToken(chatApp.currentUser.available_rooms[0].token)
        # chatApp.reloadMessages(chatApp.getRoomMessages())
      chatApp.getResponders()
      chatApp.reloadResponders()

      chatApp.chatRespondersArea().find('li').removeClass('active')
      chatApp.currentResponderListItem().addClass('active')

  closeRoom: (roomToken) ->
    roomToken ?= chatApp.currentRoom.token
    room = chatApp.detectRoomByToken(roomToken)
    $.ajax
      type: "DELETE"
      url: "/api/v1/rooms/1"
      headers: { 'X-Auth-Token': chatApp.accessToken(), 'X-Room-Token': chatApp.currentRoom.token }
      success: (data, textStatus, xhr) ->
        console.log roomToken, ' => Room is closed'
        nextItem = chatApp.currentResponderListItem().next()
        if nextItem.length == 0
          nextItem = chatApp.currentResponderListItem().prev()
        chatApp.currentResponderListItem().remove()
        chatApp.changeRoom(nextItem.data('room_token'))
        console.log 'nextRoom', ' => ', nextItem.data('room_token')
      async: false

  changeRoom: (room_token) ->
    chatApp.setCurrentRoom(chatApp.detectRoomByToken(room_token))
    chatApp.chatRespondersArea().find('li').removeClass('active')
    chatApp.currentResponderListItem().addClass('active')
    chatApp.reloadMessages(chatApp.getRoomMessages())

  detectRoomByToken: (room_token) ->
    room = ''
    chatApp.currentUser.available_rooms.filter (item) ->
      room = item if item.token is room_token
    return room

 reloadResponders: (responders) ->
    responders ?= chatApp.currentResponders
    chatApp.chatRespondersArea().empty()
    for responder in responders
      chatApp.chatRespondersArea().append($.tmpl('templates/responder', responder))

  getResponders: (e, element) ->
    if chatApp.chatArea().length
      $.ajax
        type: "GET"
        url: "/api/v1/users/1/responders"
        headers: { 'X-Auth-Token': chatApp.accessToken() }
        success: (data, textStatus, xhr) ->
          chatApp.setCurrentResponders(data.responders)
          console.log 'CurrntResponders: ', chatApp.CurrentResponders
        async: false

  reloadMessages: (messages) ->
    messages ?= chatApp.getRoomMessages()
    chatApp.chatArea().empty()
    for message in messages
      chatApp.chatArea().append($.tmpl('templates/message', message))


  getRoomMessages: (e, element) ->
    if chatApp.chatArea().length
      messages = []
      $.ajax
        type: "GET"
        url: "/api/v1/messages"
        headers: { 'X-Auth-Token': chatApp.accessToken(), 'X-Room-Token': chatApp.currentRoom.token }
        success: (data, textStatus, xhr) ->
          messages = data.messages
        error: () ->
          console.log 'Not Found'
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
      if messageBody.length > 0
        if  chatApp.currentRoom != ''
          $.ajax
            type: "POST"
            url: "/api/v1/messages"
            data:
              message:
                body: messageBody
            headers: { 'X-Auth-Token': chatApp.accessToken(), 'X-Room-Token': chatApp.currentRoom.token }
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
              chatApp.setCurrentRoom(data.room)
              chatApp.getResponders()
              chatApp.reloadResponders()
              console.log 'New Room: ', data
              chatApp.chatArea().append($.tmpl('templates/message', data.room.last_message))
            async: false
    return false
}
