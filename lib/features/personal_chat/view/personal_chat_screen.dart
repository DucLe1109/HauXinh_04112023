import 'dart:math' show pi;

import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/features/personal_chat/view/message_card.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rest_client/rest_client.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(this.chatUser, {super.key});

  final ChatUser chatUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageEditingController;

  final double bottomActionHeight = 70;
  late List<Message> listMessage;
  late Stream<QuerySnapshot<Map<String, dynamic>>> chatStream;

  @override
  void initState() {
    super.initState();
    chatStream = FirebaseUtils.getAllMessages(widget.chatUser);
    _messageEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
            )),
        titleSpacing: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: widget.chatUser.avatar,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatUser.fullName,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text('Last seen on 1 Dec 8:28 am',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall)
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 30,
            child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  ///TODO
                },
                icon: const Icon(
                  CupertinoIcons.search,
                  size: 20,
                )),
          ),
          IconButton(
              onPressed: () {
                ///TODO
              },
              icon: const Icon(
                Icons.menu,
                size: 20,
              ))
        ],
      ),
      body: Column(
        children: [_buildChatSection(context), _buildBottomAction(context)],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Card(
            color: Theme
                .of(context)
                .primaryColor,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
            margin: const EdgeInsets.fromLTRB(horizontalPadding,
                verticalPadding, verticalPadding, horizontalPadding),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  _buildIconAction(),
                  const SizedBox(
                    width: 5,
                  ),
                  _buildChatTextField(context),
                  const SizedBox(
                    width: 12,
                  ),
                  _buildPickImageButton(),
                  const SizedBox(
                    width: 5,
                  ),
                  _buildCameraButton()
                ],
              ),
            ),
          ),
        ),
        Expanded(child: _buildSendButton(context)),
        const SizedBox(
          width: 6,
        )
      ],
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return Card(
      elevation: 3,
      shape: const CircleBorder(),
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Theme
            .of(context)
            .primaryColor,
        shape: const CircleBorder(),
        child: InkWell(
            onTap: () {
              FirebaseUtils.sendMessage(widget.chatUser, '1234');
            },
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Transform.rotate(
                angle: -pi / 4,
                child: const Icon(
                  Icons.send_rounded,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildPickImageButton() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
          borderRadius: BorderRadius.circular(100),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.image,
              size: 23,
              color: Colors.blue,
            ),
          )),
    );
  }

  Widget _buildCameraButton() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
          borderRadius: BorderRadius.circular(100),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              CupertinoIcons.photo_camera_solid,
              size: 22,
              color: Colors.blue,
            ),
          )),
    );
  }

  Widget _buildChatTextField(BuildContext context) {
    return Expanded(
      child: TextField(
        onChanged: (value) {},
        onEditingComplete: Utils.hideKeyboard,
        controller: _messageEditingController,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(borderRadius)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(borderRadius)),
          hintText: S.current.type_something_here,
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildIconAction() {
    return Material(
      borderRadius: BorderRadius.circular(100),
      color: Colors.transparent,
      child: InkWell(
          borderRadius: BorderRadius.circular(100),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              CupertinoIcons.smiley_fill,
              size: 25,
              color: Colors.blue,
            ),
          )),
    );
  }

  Widget _buildChatSection(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: horizontalPadding),
        color: Theme
            .of(context)
            .scaffoldBackgroundColor,
        child: StreamBuilder(
          stream: chatStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 1.5,
                    ),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  listMessage =
                      data?.map((e) => Message.fromJson(e.data())).toList() ??
                          [];
                  if (listMessage.isNotEmpty) {
                    return ListView.builder(
                      itemCount: listMessage.length,
                      itemBuilder: (context, index) =>
                          MessageCard(message: listMessage[index]),
                    );
                  } else {
                    return const Center(
                      child: Text('No connection'),
                    );
                  }
              }
            }
          },
        ),
      ),
    );
  }
}
