enum Collections {
  chatUser('chat_users'),
  messages('messages'),
  users('users'),
  chats('chats');

  const Collections(this.value);

  final String value;
}

enum ChatUserProperty {
  avatar('avatar'),
  birthday('birthday'),
  createdAt('createdAt'),
  email('email'),
  fullName('fullName'),
  id('id'),
  isHasStory('isHasStory'),
  isOnline('isOnline'),
  lastActive('lastActive'),
  pushToken('pushToken');

  final String value;

  const ChatUserProperty(this.value);
}

enum MessageProperty {
  createdTime('createdTime'),
  fromId('fromId'),
  readAt('readAt'),
  timeStamp('timeStamp'),
  toId('toId'),
  type('type'),
  updatedTime('updatedTime'),
  msg('msg');

  final String value;

  const MessageProperty(this.value);
}
