import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notifications/bloc/Http-bloc/repository.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart';

part 'http_Event.dart';
part 'http_State.dart';

class HttpBloc extends Bloc<HttpBlocEvent, HttpBlocState> {
  final DioRepository repository;
  HttpBloc(this.repository) : super(BlocInitial()) {
    on<Login>((event, emit) async {
      emit(Loading());
      try {
        await repository.login(event.username, event.password);
        emit(LogInState());
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
    on<GetMessages>((event, emit) async {
      emit(Loading());
      try {
        log("in get event");
        final msg = await repository.getMessagesHistory(event.id);
        emit(GetMessagesState(msg));
      } catch (e) {
        log(e.toString());
        emit(ErrorState(e.toString()));
      }
    });
    on<GetAllUsers>((event, emit) async {
      emit(Loading());
      log("loading....");
      try {
        final list = await repository.getAllChats();
        log(list.toString());
        emit(ChatListState(list));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
    on<GetUserChats>((event, emit) async {
      emit(Loading());
      try {
        final list = await repository.getUserChats();
        emit(UserListState(list));
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
    on<AddChat>((event, emit) async {
      log("getting add chat");
      try {
        await repository.addChats(event.id);
      } catch (e) {
        log(e.toString());
      }
    });
    on<SignUp>((event, emit) async {
      try {
        await repository.signUp(event.username, event.password);
        emit(LogInState());
      } catch (e) {
        log(e.toString());
        emit(ErrorState(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
     return super.close();
  }
}

// on<ListenStreamEvent>((event, emit) async {
//   log("here");
// await emit.onEach(
//   channel.stream,
//   onData: (data) {
//     log(data.toString());
//     emit(StreamState(data));
//     // add(MessageReceivedEvent(data));
//   },
// );
// });
// on<MessageReceivedEvent>((event, emit) {
//   emit(StreamState(event.message));
// });

// on<SendMessageEvent>((event, send) {
//   channel.sink.add(event.message);
// });
