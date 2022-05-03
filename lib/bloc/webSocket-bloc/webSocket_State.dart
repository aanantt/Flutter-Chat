part of 'webSocket_Bloc.dart';

@immutable
abstract class WebSocketState extends Equatable {}

class ChatInitial extends WebSocketState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ListenMessagesState extends WebSocketState {
  final bool forTyping;
  final message;
  ListenMessagesState(this.message, this.forTyping);

  @override
  List<Object?> get props => [identityHashCode(this)];
}

// class ListenTypingState extends WebSocketState {
//   final typingMessage;

//   ListenTypingState(this.typingMessage);

//   @override
//    List<Object?> get props => [typingMessage];
// }

class DeleteUpdateMessageState extends WebSocketState {
  final data;

  DeleteUpdateMessageState(this.data);
  @override
  List<Object?> get props => [data];
}

class ConnectedState extends WebSocketState {
  final data;

  ConnectedState(this.data);
  @override
  // TODO: implement props
  List<Object?> get props => [identityHashCode(this)];
}
