import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications/bloc/Http-bloc/http_Bloc.dart';
import 'package:notifications/bloc/webSocket-bloc/webSocket_Bloc.dart';
import 'package:notifications/screens/chatScreen.dart';

class AllChats extends StatefulWidget {
  const AllChats({Key? key}) : super(key: key);

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HttpBloc>(context).add(GetAllUsers());
  }

  List allChats = [];

  listChatWidget(_context) {
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
                          isFirstChat: true,
                          username: allChats[index]["username"],
                          profile: allChats[index]["profile"],
                          userId: allChats[index]["_id"],
                        ))).whenComplete(() {
                      allChats.clear();
              BlocProvider.of<HttpBloc>(_context).add(GetAllUsers());
            });
          },
          leading: Hero(
              tag: allChats[index]["profile"].toString() + index.toString(),
              child: CircleAvatar(
                backgroundImage: NetworkImage(allChats[index]["profile"]),
              )),
          title: Text(allChats[index]["username"].toString(),
              style: TextStyle(fontWeight: FontWeight.w600)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        leadingWidth: 0,
        // leading: SizedBox(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Available Users",
          style: TextStyle(
              color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<HttpBloc, HttpBlocState>(
        builder: (_context, state) {
          if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatListState) {
            allChats.addAll(state.chats);

            return listChatWidget(_context);
          }
          return Text(state.toString());
        },
      ),
    );
  }
}
