import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_app/src/core/services/notification/notification_offline.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/src/core/services/chat_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: 'http://10.99.62.215:8080/api',
    headers: {
      HttpHeaders.authorizationHeader: 'Basic ${base64.encode(
        utf8.encode('admin:hihi'),
      )}',
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "*/*",
    },
  ),
);

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.id,
    required this.receiverId,
  });

  final String id;
  final String receiverId;

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
          if (data.contains('hihi tesst')) return;
          Map<String, dynamic> valueMap = json.decode(data);
          final mes = ChatMessage.fromJson(valueMap);

          NotificationOffline.instance.sentNotification(
              messagesList.value.length,
              title: mes.sendId,
              body: mes.message,
              payload: '');
          if (mes.sendId == widget.receiverId) {
            messagesList.value = List.from(messagesList.value)..add(mes);
          }
        });
    // _scrollToBottom();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _channel.dispose();
  //   super.dispose();
  // }

  final _chatCtl = TextEditingController();
  final _node = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boob ${widget.receiverId}'),
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
                Expanded(
                  child: TextField(
                    controller: _chatCtl,
                    focusNode: _node,
                    decoration: const InputDecoration(
                      hintText: "Write message...",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                FloatingActionButton(
                  onPressed: () async {
                    if (_chatCtl.text.trim().isEmpty) return;
                    try {
                      var headers = {
                        HttpHeaders.authorizationHeader: 'Basic ${base64.encode(
                          utf8.encode('admin:hihi'),
                        )}',
                        HttpHeaders.contentTypeHeader: "application/json",
                      };
                      var request = http.Request(
                          'POST',
                          Uri.parse(
                              'http://10.99.62.215:8080/api/Message/send-message'));
                      request.body = json.encode({
                        "Message": _chatCtl.text,
                        "SendId": widget.id,
                        "ReceiveId": widget.receiverId,
                      });
                      request.headers.addAll(headers);

                      http.StreamedResponse response = await request.send();

                      if (response.statusCode == 200) {
                        print(await response.stream.bytesToString());
                        _node.unfocus();
                        messagesList.value = List.from(messagesList.value)
                          ..add(
                            ChatMessage(
                              message: _chatCtl.text,
                              sendId: widget.id,
                              receiveId: widget.receiverId,
                            ),
                          );
                        _chatCtl.clear();
                      } else {
                        print(response.reasonPhrase);
                      }
                    } catch (e, s) {
                      log(e.toString(), stackTrace: s);
                    }
                  },
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
