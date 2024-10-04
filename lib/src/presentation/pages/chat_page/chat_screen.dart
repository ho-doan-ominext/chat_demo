import 'dart:convert';

import 'package:chat_app/src/core/services/chat_service.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.id});

  final String id;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ValueNotifier<List<ChatMessage>> messagesList =
      ValueNotifier<List<ChatMessage>>([]);
  final _channel = ChatService(ip: '10.99.62.215', port: 2909);

  @override
  void initState() {
    _channel.initial(
        id: widget.id,
        onMessage: (data) {
          Map<String, dynamic> valueMap = json.decode(data);
          final mes = ChatMessage.fromJson(valueMap);
          if (mes.sendId == '6' ||
              (mes.sendId == widget.id && mes.receiveId == '6')) {
            final temp = messagesList.value;
            temp.add(mes);
            setState(() {
              messagesList.value = temp;
            });
          }
        });
    // _scrollToBottom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boob'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: messagesList,
                builder: (context, messages, _) {
                  return ListView.builder(
                    itemCount: messages.length,
                    shrinkWrap: true,
                    // controller: _scrollController,
                    // physics: const NeverScrollableScrollPhysics(),
                    reverse: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: (messages[messages.length - 1 - index]
                                      .receiveId ==
                                  widget.id
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (messages[messages.length - 1 - index]
                                          .receiveId ==
                                      widget.id
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              messages[messages.length - 1 - index].message,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
          const SizedBox(
            width: 15,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(width: 15),
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.blue,
                  elevation: 0,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  String message;
  String sendId;
  String receiveId;

  ChatMessage({
    required this.message,
    required this.sendId,
    required this.receiveId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['Message'],
      sendId: json['SendId'],
      receiveId: json['ReceiveId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'sendId': sendId,
        'receiveId': receiveId,
      };
}
