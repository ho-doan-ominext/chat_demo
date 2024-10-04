import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';

class ChatService {
  final String ip;
  final int port;

  ChatService({required this.ip, required this.port});

  Future<void> initial({
    required ValueChanged<String> onMessage,
  }) async {
    try {
      final socket = await Socket.connect(ip, port);
      socket.listen(
        (data) {
          final String str = String.fromCharCodes(data);
          if (str.isNotEmpty) {
            onMessage(str);
          }
        },
        onDone: () {
          log('socket disconnected');
          socket.destroy();
        },
        onError: (e, s) {
          log('socket error: $e', stackTrace: s);
          socket.destroy();
        },
      );
    } catch (e) {
      log('socket error: $e');
    }
  }
}
