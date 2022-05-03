import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
// import '../test/state.dart';
import 'package:notifications/auth/login.dart';
import 'package:notifications/screens/personalChats.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import 'bloc/Http-bloc/http_Bloc.dart';
import 'bloc/Http-bloc/repository.dart';
import 'bloc/webSocket-bloc/webSocket_Bloc.dart';
import 'bloc/webSocket-bloc/websocket.dart';

late SharedPreferences prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<WebSocketBloc>(
        create: (context) => WebSocketBloc(WebSocketClient("",false), DioRepository()),
      ),
      BlocProvider<HttpBloc>(
        create: (context) => HttpBloc(DioRepository()),
      ),
    ],
    child: MyApp(token: token),
  ));
}

class MyApp extends StatelessWidget {
  final token;

  const MyApp({Key? key, this.token}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: token.toString() != "null" ?  PersonalChats() : LoginScreen(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   // var channel =
//   //     IOWebSocketChannel.connect('ws://192.168.43.86:8080/message/3/2');
//   @override
//   void initState() {
//     super.initState();
//     WebSocketClient client = WebSocketClient("12");
//     client.stream.listen((event) {});
//     // BlocProvider.of<HttpBloc>(context).add(ListenStreamEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       floatingActionButton: Builder(builder: (context) {
//         return FloatingActionButton(
//           // onPressed: () =>
//           //     BlocProvider.of<HttpBloc>(context).add(ListenStreamEvent()),
//           onPressed: () => showBottomSheet(
//               context: context,
//               builder: (_) => Builder(builder: (context) {
//                     return Container(
//                       height: 100,
//                       child: TextFormField(
//                         onChanged: (s) {
//                           var map = '{"message": "$s"}';
//                           // context.read<HttpBloc>().add(SendMessageEvent(map));
//                           // BlocProvider.of<HttpBloc>(context)
//                           //     .add(SendMessageEvent(map));
//                           // channel.sink.add(map);
//                         },
//                       ),
//                     );
//                   })),
//           child: Icon(Icons.message),
//         );
//       }),
//       body: BlocBuilder<HttpBloc, HttpBlocState>(
//         builder: (context, state) {
//           return Center(
//             child: Column(
//               children: [
//                 // state is StreamState ? Text(state.message) : Text("nothing"),
//               ],
//             ),
//           );
//         },
//       ),
//       // body: StreamBuilder(
//       //   stream: channel.stream,
//       //   builder: (BuildContext context, AsyncSnapshot snapshot) {
//       //     if (snapshot.hasData) {
//       //       return ListTile(
//       //         title: Text(snapshot.data.toString()),
//       //       );
//       //     }
//       //     return const Center(child: CircularProgressIndicator());
//       //   },
//       // ),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }





// // class SecondClass extends StatefulWidget {
// //   const SecondClass({Key? key}) : super(key: key);

// //   @override
// //   State<SecondClass> createState() => _SecondClassState();
// // }

// // class _SecondClassState extends State<SecondClass> {
// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     super.initState();
// //     BlocProvider.of<HttpBloc>(context).add(GetAuth());
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("widget.title"),
// //       ),
//       // body: BlocBuilder<HttpBloc, HttpBlocState>(
//       //   builder: (context, state) {
//       //     return Center(
//       //       child: Column(
//       //         children: [
//       //           state is GetAuthState ? Text(state.token) : Text("nothing"),
//       //           TextFormField(
//       //             onChanged: (value) {
//       //               BlocProvider.of<HttpBloc>(context)
//       //                   .add(ChangeAuth(token: value));
//       //             },
//       //           )
//       //         ],
//       //       ),
//       //     );
//       //   },
//       // ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () => Navigator.push(
// //             context, MaterialPageRoute(builder: (_) => SecondClass())),
// //         tooltip: 'Run',
// //         child: const Icon(Icons.add),
// //       ), // This trailing comma makes auto-formatting nicer for build methods.
// //     );
// //   }
// // }

// // // class SecondClass extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     Auth pro = Provider.of<Auth>(context);
// // //     return Scaffold(
// // //       appBar: AppBar(),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: <Widget>[
// // //             Text(pro.token.toString()),
// // //             SizedBox(
// // //               height: 20,
// // //             ),
// // //             TextFormField(
// // //               onChanged: (value) {
// // //                 Provider.of<Auth>(context, listen: false).changeValue(value);
// // //               },
// // //             )
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
