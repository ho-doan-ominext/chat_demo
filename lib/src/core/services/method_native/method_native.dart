import 'package:flutter/services.dart';

class MethodNative {
  MethodNative._();

  Future<void> getNativeFlavor() async {
    MethodChannel channel = MethodChannel(AppConstant.channel);
    await channel.invokeMethod("getFlavor").then((result) {});
  }

  static void nativeCallbackNotification(String message) {
    print("Notification: $message");
  }

  static final instance = MethodNative._();
}

class AppConstant {
  static String channel = "com.example.chat_app.native";
}
