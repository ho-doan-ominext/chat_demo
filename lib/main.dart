import 'dart:async';
import 'dart:developer';

import 'package:chat_app/src/presentation/pages/login_page/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(
    () async {
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
