window.chatApp = {
  currentUser: ''
  currentRoom: ''
  currentResponders: ''
  currentResponderListItem: () ->
    $('#responders-list-item-' + chatApp.currentRoom.token)
  chatRespondersArea: () ->
    $('#chat-responders')
  messageArea: () ->
    $('#message')
  chatArea: () ->
    $('#chat-area')
  accessToken: () ->
    $('#message').data('user_token')
  userToken: () ->
    $('#message').data('user_token')
  setRoomToken: (token) ->
    $('#message').data('room_token', token)
  roomToken: () ->
     $('#message').data('room_token')
  setCurrentUser: (data) ->
    chatApp.currentUser = data.user
  setCurrentRoom: (room) ->
    chatApp.currentRoom = room
  setCurrentResponders: (responders) ->
    chatApp.currentResponders = responders
}
