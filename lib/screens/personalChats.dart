import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications/auth/login.dart';
import 'package:notifications/bloc/Http-bloc/http_Bloc.dart';
import 'package:notifications/bloc/webSocket-bloc/webSocket_Bloc.dart';
import 'package:notifications/bloc/webSocket-bloc/websocket.dart';
import 'package:notifications/main.dart';
import 'package:notifications/screens/chatScreen.dart';
import 'package:provider/provider.dart';

import 'allChats.dart';

class PersonalChats extends StatefulWidget {
  const PersonalChats({Key? key}) : super(key: key);

  @override
  State<PersonalChats> createState() => _PersonalChatsState();
}

class _PersonalChatsState extends State<PersonalChats> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HttpBloc>(context).add(GetUserChats());
    BlocProvider.of<WebSocketBloc>(context).add(ConnectEvent());
  }

  List allChats = [];

  

  removeItem(String username) {
    for (var i = 0; i < allChats.length; i++) {
      if (allChats[i]["username"] == username) {
        allChats.removeAt(i);
        return;
      }
    }
  }

  allUsers(_context) {
    return ListView.builder(
      itemCount: allChats.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (_) => ChatScreen(
                          index: index,
                          username: allChats[index]["username"],
                          profile: allChats[index]["profile"],
                          userId: allChats[index]["_id"],
                        ))).whenComplete(() {
              allChats.clear();
              BlocProvider.of<HttpBloc>(_context).add(GetUserChats());
            });
          },
          leading: Hero(
              tag: allChats[index]["profile"].toString() + index.toString(),
              child: CircleAvatar(
                backgroundImage: NetworkImage(allChats[index]["profile"] ??
                    "https://demofree.sirv.com/nope-not-here.jpg"),
              )),
          title: Text(allChats[index]["username"] ?? "Error Username",
              style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: allChats[index]["message"] != null
              ? Text(allChats[index]["message"]["message"]??"Error Message")
              : const Text("")
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          allChats.clear();
          Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => const AllChats()))
              .whenComplete(
                  () => BlocProvider.of<HttpBloc>(context).add(GetUserChats()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: InkWell(
          onTap: () {
            prefs.clear();
            Navigator.push(context,CupertinoPageRoute(builder: (_)=>LoginScreen()));
          },
          child: Text(
            "My Chats",
            style: TextStyle(
                color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: BlocBuilder<HttpBloc, HttpBlocState>(
        builder: (_context, state) {
          if (state is Loading) {
            return Center(child: const CircularProgressIndicator());
          }
          if (state is UserListState) {
            log(state.users.toString());
            allChats.addAll(state.users);
            return BlocBuilder<WebSocketBloc, WebSocketState>(
              builder: (context, state) {
                if (state is ConnectedState) {
                  log("CONNECTED STATE:---------");
                  log(state.data.toString());
                  if (state.data["newChat"]) {
                    allChats.insert(0, state.data["user"]);
                  } else {
                    removeItem(state.data["user"]["username"]);
                    allChats.insert(0, state.data["user"]);
                  }
                  return allUsers(_context);
                }
                return allUsers(_context);
              },
            );
          }
          return Text(state.toString());
        },
      ),
    );
  }
}
