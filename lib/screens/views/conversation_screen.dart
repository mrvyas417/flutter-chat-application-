// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:chat_application_task/helper/app_images.dart';
import 'package:chat_application_task/helper/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../helper/constants.dart';
import '../../service/database/databse.dart';
import '../../widgets/widget.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messages = TextEditingController();
  Stream? chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessageStream as dynamic,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                  message: snapshot.data!.docs[index].get('message'),
                  isSendByMe: snapshot.data!.docs[index].get('sendby') ==
                      Constants.myName,
                );
              });
        } else {
          return Container();
        }
      },
    );
  }

  sendMessages() {
    if (messages.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messages.text,
        "sendby": Constants.myName,
        'time': DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addConverSationMessages(widget.chatRoomId, messageMap);
      messages.text = "";
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  @override
  void initState() {
    databaseMethods.getConverSationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBarMain(BuildContext, context),
      body: Column(
        children: [
          Expanded(child: chatMessageList()),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: AppColors.conversationScreenColour,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messages,
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Message',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        )),
                  )),
                  InkWell(
                    onTap: () {
                      sendMessages();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppColors.gradientColour1,
                            AppColors.gradientColour2,
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      child: Image.asset(AppImages.send),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const MessageTile({Key? key, required this.message, required this.isSendByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe
                ? [
                    AppColors.issendGradient1,
                    AppColors.issendGradient2,
                  ]
                : [
                    AppColors.sendbyOther,
                    AppColors.sendbyOther,
                  ],
          ),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
