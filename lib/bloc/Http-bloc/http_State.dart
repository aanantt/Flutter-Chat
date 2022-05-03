part of 'http_Bloc.dart';

@immutable
abstract class HttpBlocState extends Equatable {}

class BlocInitial extends HttpBlocState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LogInState extends HttpBlocState {
  LogInState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserListState extends HttpBlocState {
  final List users;
  UserListState(this.users);

  @override
  List<Object?> get props => [];
}

class ChatListState extends HttpBlocState {
  final List chats;
  ChatListState(this.chats);

  @override
  List<Object?> get props => [];
}

class ErrorState extends HttpBlocState {
  final String error;

  ErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Loading extends HttpBlocState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SignUpState extends HttpBlocState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetMessagesState extends HttpBlocState {
  final List message;

  GetMessagesState(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
