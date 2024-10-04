import 'package:chat_app/src/core/services/method_native/method_native.dart';
import 'package:chat_app/src/presentation/pages/chat_page/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.id});

  final String id;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final MethodChannel _channel = MethodChannel(AppConstant.channel);

  @override
  void initState() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'nativeCallback') {
        final String message = call.arguments;
        print("=============== Native: $message");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('UserId: ${widget.id}'),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            for (int i = 0; i < 10; i++)
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        id: widget.id,
                        receiverId: i.toString(),
                      ),
                    ),
                  );
                },
                child: Text('Go Chat with User $i'),
              ),
          ],
        ),
      ),
    );
  }
}
