import 'dart:developer';
import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  late String token;
  Auth({ required token});

  changeValue(String newToken) {
    token = newToken;
    log(token.toString());
    notifyListeners();
  }

  String get _token => token;
}
