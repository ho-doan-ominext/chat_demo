import 'package:chat_app/src/presentation/pages/chat_page/chat_screen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.id});

  final String id;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
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
