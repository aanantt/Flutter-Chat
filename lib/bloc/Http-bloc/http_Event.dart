part of 'http_Bloc.dart';

@immutable
abstract class HttpBlocEvent extends Equatable {}

class AddChat extends HttpBlocEvent {
  final String id;

  AddChat(this.id);
  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class GetAllUsers extends HttpBlocEvent {
  @override
  List<Object?> get props => [];
}

class GetUserChats extends HttpBlocEvent {
  @override
  List<Object?> get props => [];
}

class Login extends HttpBlocEvent {
  final String username;
  final String password;
  Login(this.username, this.password);
  @override
  List<Object?> get props => [username, password];
}

class SignUp extends HttpBlocEvent {
  final String username;
  final String password;
  SignUp(this.username, this.password);
  @override
  List<Object?> get props => [username, password];
}

class GetMessages extends HttpBlocEvent {
  final String id;

  GetMessages(this.id);
  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
