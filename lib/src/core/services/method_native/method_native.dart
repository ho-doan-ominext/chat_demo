import 'dart:developer';

import 'package:flutter/services.dart';

final MethodChannel channel = MethodChannel(AppConstant.channel);
final MethodChannel channel2 = MethodChannel(AppConstant.channel2)
  ..setMethodCallHandler((call) async {
    switch (call.method) {
      case 'nativeCallback':
        {
          print("Notification: ${call.arguments}");
          return null;
        }
    }
  });

class MethodNative {
  MethodNative._();

  static final instance = MethodNative._();

  void setUser(String userId) async {
    try {
      await channel.invokeMethod('setUser', userId);
    } catch (e) {
      log(e.toString());
    }
  }
}

class AppConstant {
  static String channel = "com.example.chat_app.native";
  static String channel2 = "com.example.chat_app.native2";
}
