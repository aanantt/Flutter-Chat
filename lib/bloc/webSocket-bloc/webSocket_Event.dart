part of 'webSocket_Bloc.dart';

@immutable
abstract class WebSocketEvent extends Equatable {}

class ListenMessagesEvent extends WebSocketEvent {
  @override
  List<Object?> get props => [];
}

class AddMessageEvent extends WebSocketEvent {
  final message;

  AddMessageEvent(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class SendTypingEvent extends WebSocketEvent {
  final isTyping;

  SendTypingEvent(this.isTyping);

  @override
  // TODO: implement props
  List<Object?> get props => [isTyping];
}

class ListenTypingEvent extends WebSocketEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SendDeleteMessageEvent extends WebSocketEvent {
  final Map data;

  SendDeleteMessageEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class ListenDeleteUpdateMessageEvent extends WebSocketEvent {
  @override
  List<Object?> get props => [];
}

class ConnectEvent extends WebSocketEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
