import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:notifications/bloc/Http-bloc/repository.dart';
import 'package:notifications/bloc/webSocket-bloc/websocket.dart';

part 'webSocket_Event.dart';
part 'webSocket_State.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketClient client;
  final DioRepository dioRepository;
  @override
  Future<void> close() {
    client.disconnect();
    return super.close();
  }

  WebSocketBloc(this.client, this.dioRepository) : super(ChatInitial()) {
    on<ListenMessagesEvent>((event, emit) async {
      await emit.onEach(
        client.stream,
        onData: (data) {
          final o = jsonDecode(data as String);
          log(o.toString());
          emit(ListenMessagesState(o, false));
        },
      );
    });

    on<ConnectEvent>((event, emit) async {
      await emit.onEach(
        client.connectedStream,
        onData: (data) {
          final o = jsonDecode(data as String);
          log(o.toString());
          emit(ConnectedState(o));
        },
      );
    });

    on<ListenTypingEvent>((event, emit) async {
      await emit.onEach(
        client.typingStream,
        onData: (data) {
          final o = jsonDecode(data as String);
          log(o.toString());
          emit(ListenMessagesState(o, true));
        },
      );
    });

    on<AddMessageEvent>((event, emit) async {
      client.addMessage(event.message);
    });
    on<SendTypingEvent>((event, emit) async {
      client.sendTyping(event.isTyping);
    });
    on<SendDeleteMessageEvent>((event, emit) async {
      client.deleteUpdate(event.data);
    });
    on<ListenDeleteUpdateMessageEvent>((event, emit) async {
      log("delete event added");
      await emit.onEach(
        client.updateAndDeleteStream,
        onData: (data) {
          final o = jsonDecode(data as String);
          log("After DELETE STATE" + o.toString());
          emit(DeleteUpdateMessageState(o));
        },
      );
    });
  }
}

//2 = 623c117e982915cdd82afd26
//1 = 623c117e982915cdd82afd25
//3 = 623c117e982915cdd82afd27
//4 = 623c117e982915cdd82afd28