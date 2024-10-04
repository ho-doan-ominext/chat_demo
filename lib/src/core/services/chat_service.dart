import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';

class ChatService {
  final String ip;
  final int port;

  ChatService._({required this.ip, required this.port});

  static ChatService get instance =>
      ChatService._(ip: '10.99.62.215', port: 2909);

  Socket? socket;

  void dispose() {
    instance.socket?.destroy();
  }

  Future<void> initial({
    required String id,
    required ValueChanged<String> onMessage,
  }) async {
    try {
      instance.socket = await Socket.connect(ip, port);

      instance.socket?.write(
        jsonEncode(
          {
            "Message": "from id-$id ${DateTime.now()}",
            "SendId": id,
            "ReceiveId": ""
          },
        ),
      );

      instance.socket?.flush();
      instance.socket?.timeout(const Duration(seconds: 5));
      instance.socket?.listen(
        (data) {
          final String str = String.fromCharCodes(data);
          if (str.isNotEmpty) {
            onMessage(str);
          } else {
            print('=========== else');
          }
        },
        onDone: () {
          log('socket disconnected');
          instance.socket?.destroy();
        },
        onError: (e, s) {
          log('socket error: $e', stackTrace: s);
          instance.socket?.destroy();
        },
      );
    } catch (e) {
      log('socket error: $e');
      instance.socket?.destroy();
    }
  }
}
