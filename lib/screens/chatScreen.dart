import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications/bloc/Http-bloc/http_Bloc.dart';
import 'package:notifications/bloc/Http-bloc/repository.dart';
import 'package:notifications/bloc/webSocket-bloc/webSocket_Bloc.dart';
import 'package:notifications/bloc/webSocket-bloc/websocket.dart';

class ChatScreen extends StatefulWidget {
  final userId;
  final username;
  final index;
  final profile;
  final isFirstChat;
  const ChatScreen(
      {Key? key,
      this.userId,
      this.username,
      this.profile,
      this.index,
      this.isFirstChat = false})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HttpBloc>(context).add(GetMessages(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<HttpBloc, HttpBlocState>(
      builder: (context, state) {
        if (state is Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is GetMessagesState) {
          log("moving..........");
          return BlocProvider(
            create: (context) =>
                WebSocketBloc(WebSocketClient(widget.userId), DioRepository()),
            child: MainChatScreen(
              userId: widget.userId,
              chats: state.message,
              profile: widget.profile,
              username: widget.username,
              isFirstChat: widget.isFirstChat,
            ),
          );
        } else {
          return Text("STATE :- " + state.toString());
        }
      },
    ));
  }
}

class MainChatScreen extends StatefulWidget {
  final userId;
  final chats;
  final isFirstChat;
  final profile;
  final username;
  const MainChatScreen(
      {Key? key,
      this.userId,
      this.chats,
      this.isFirstChat = false,
      this.username,
      this.profile})
      : super(key: key);

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  late bool IsFirstChat;
  @override
  void initState() {
    super.initState();
    IsFirstChat = widget.isFirstChat;
    messages.addAll(widget.chats);
    controller.addListener(_onTypingStopped);
    BlocProvider.of<WebSocketBloc>(context).add(ListenMessagesEvent());
    BlocProvider.of<WebSocketBloc>(context)
        .add(ListenDeleteUpdateMessageEvent());
    BlocProvider.of<WebSocketBloc>(context).add(ListenTypingEvent());
  }

  Timer? _debounce;
  int _debouncetime = 100;

  TextEditingController controller = TextEditingController();
  TextEditingController updateController = TextEditingController();

  List messages = [];

  _onTypingStopped() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      BlocProvider.of<WebSocketBloc>(context).add(SendTypingEvent(false));
    });
  }

  @override
  void dispose() {
    controller.removeListener(_onTypingStopped);
    controller.dispose();
    super.dispose();
  }

  void findAndUpdateRemove(data, List messages) {
    log("data" + data.toString());
    log("data message id : - " + messages.toString());
    final result = messages.firstWhere((element) {
      return element["_id"].toString() == data["messageId"].toString();
    }, orElse: () => "");
    log("RESULT : - " + result.toString());

    if (result != "") {
      if (data["forUpdate"]) {
        for (var i = 0; i < messages.length; i++) {
          if (messages[i]["_id"] == result["_id"]) {
            messages[i]["message"] = data["newMessage"];
          }
        }
        return;
      }
      messages.remove(result);
      return;
    }
    return;
  }

  void showUpdateDialog(id) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: updateController,
                    ),
                    MaterialButton(
                        child: Text("Update"),
                        onPressed: () {
                          final map = {
                            "newMessage": updateController.text,
                            "messageId": id,
                            "forUpdate": true
                          };

                          BlocProvider.of<WebSocketBloc>(context)
                              .add(SendDeleteMessageEvent(map));
                          updateController.clear();
                          Navigator.pop(context);
                        })
                  ],
                ),
              ),
            ));
  }

  Widget chatWidget() {
    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        final msg = messages[index];

        return InkWell(
          onLongPress: () {
            print(msg["_id"]);
            showUpdateDialog(msg["_id"]);
          },
          onTap: () {
            //delete
            final map = {
              "newMessage": updateController.text,
              "messageId": msg["_id"],
              "forUpdate": false
            };
            BlocProvider.of<WebSocketBloc>(context)
                .add(SendDeleteMessageEvent(map));
          },
          child: Align(
            alignment: widget.userId == msg["from"]
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(top: 7),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                  color: widget.userId != msg["from"]
                      ? Colors.blueAccent.shade200
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20)),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              child: Text(
                msg["message"].toString() + index.toString(),
                style: TextStyle(
                    fontSize: 18,
                    color: widget.userId != msg["from"]
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: Container(),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.,
          children: [
            Hero(
              tag: widget.profile,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.profile),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                Text(
                  widget.username,
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
                BlocBuilder<WebSocketBloc, WebSocketState>(
                  builder: (context, state) {
                    return state is ListenMessagesState
                        ? !state.forTyping
                            ? Container()
                            : Text(
                                state.message["typing"] ? "Typing..." : "",
                                style:
                                    TextStyle(fontSize: 9, color: Colors.black),
                              )
                        : Container();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: BlocConsumer<WebSocketBloc, WebSocketState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is ListenMessagesState) {
                      log("New MESSAGE:_" + state.message.toString());
                      if (!state.forTyping) {
                        messages.insert(0, state.message);
                      }

                      return chatWidget();
                    } else if (state is DeleteUpdateMessageState) {
                      findAndUpdateRemove(state.data, messages);
                      return chatWidget();
                    }
                    return chatWidget();
                  },
                ),
              ),
            ),
            TextFormField(
              controller: controller,
              onChanged: (_) {
                BlocProvider.of<WebSocketBloc>(context)
                    .add(SendTypingEvent(true));
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        BlocProvider.of<WebSocketBloc>(context)
                            .add(SendTypingEvent(false));
                        BlocProvider.of<WebSocketBloc>(context)
                            .add(AddMessageEvent(controller.text));
                        if (IsFirstChat) {
                          IsFirstChat = false;
                          BlocProvider.of<HttpBloc>(context)
                              .add(AddChat(widget.userId));
                        }

                        controller.clear();
                      },
                      icon: Icon(Icons.send))),
            )
          ],
        ),
      ),
    );
  }
}
