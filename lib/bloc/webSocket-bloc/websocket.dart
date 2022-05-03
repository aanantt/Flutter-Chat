import 'dart:convert';

import 'package:notifications/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  WebSocketClient(String userId, [bool listenToAll = true]) {
    String? token = '';
    if (listenToAll) {
      messageChannel = IOWebSocketChannel.connect(
          'ws://192.168.43.86:8080/message/$userId',
          headers: {"token": prefs.getString("token")});
      typingChannel = IOWebSocketChannel.connect(
          'ws://192.168.43.86:8080/typing/$userId',
          headers: {"token": prefs.getString("token")});
      updateAndDeleteChannel = IOWebSocketChannel.connect(
          'ws://192.168.43.86:8080/deleteUpdate/$userId',
          headers: {"token": prefs.getString("token")});
    } else {
      connectedUsers = IOWebSocketChannel.connect(
          'ws://192.168.43.86:8080/connect/$userId',
          headers: {"token": prefs.getString("token")});
    }
  }
  late IOWebSocketChannel messageChannel;
  late IOWebSocketChannel updateAndDeleteChannel;
  late IOWebSocketChannel typingChannel;
  late IOWebSocketChannel connectedUsers;

  void disconnect() {
    messageChannel.sink.close();
    typingChannel.sink.close();
    updateAndDeleteChannel.sink.close();
  }

  void addMessage(message) {
    final data = {"message": message};
    messageChannel.sink.add(jsonEncode(data));
  }

  void sendTyping(bool isTyping) {
    final data = {"typing": isTyping};
    typingChannel.sink.add(jsonEncode(data));
  }

  void deleteUpdate(data) {
    updateAndDeleteChannel.sink.add(jsonEncode(data));
  }

  Stream get typingStream => typingChannel.stream;
  Stream get updateAndDeleteStream => updateAndDeleteChannel.stream;
  Stream get stream => messageChannel.stream;
  Stream get connectedStream => connectedUsers.stream;
}
