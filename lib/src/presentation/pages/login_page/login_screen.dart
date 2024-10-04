import 'package:chat_app/src/presentation/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    hintText: "ID User",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        id: controller.text,
                      ),
                    ),
                  );
                },
                child: const Text('Connect'),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
