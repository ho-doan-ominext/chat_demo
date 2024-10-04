import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_app/src/core/services/notification/notification_offline.dart';
import 'package:chat_app/src/presentation/pages/login_page/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      NotificationOffline.instance.initial();
      NotificationOffline.instance.requestIOSPermissions();
      if (Platform.isAndroid) {
        // var status = await Permission.notification.status;
        // if (status.isDenied) {
        //   // We haven't asked for permission yet or the permission has been denied before, but not permanently.
        // }

        // var statusLocation = await Permission.location.status;
        // if (await Permission.location.isRestricted) {
        //   // The OS restricts access, for example, because of parental controls.
        // }
      }
      runApp(const MyApp());
    },
    (e, s) {
      log('app error: $e', stackTrace: s);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
