import 'dart:async';
import 'dart:io';
import 'dart:math' show pi;

import 'package:boilerplate/animation/translation_fade_in.dart';
import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/features/personal_chat/view/message_card.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  late FocusNode _messageFocusNode;

  late List<Message> listMessage;
  late Stream<QuerySnapshot<Map<String, dynamic>>> chatStream;
  late ScrollController _scrollController;
  bool isScrollable = false;
  late StreamController _streamController;

  @override
  void initState() {
    super.initState();
    chatStream = FirebaseUtils.getAllMessages(widget.chatUser);
    _messageEditingController = TextEditingController();
    _scrollController = ScrollController();
    _messageFocusNode = FocusNode();
    _streamController = StreamController();

    _streamController.stream.listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
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
              borderRadius: BorderRadius.circular(100.w),
              child: CachedNetworkImage(
                imageUrl: widget.chatUser.avatar,
                width: 36.w,
                height: 36.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatUser.fullName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Text('Last seen on 1 Dec 8:28 am',
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 30.w,
            child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  ///TODO
                },
                icon: Icon(
                  CupertinoIcons.search,
                  size: 20.w,
                )),
          ),
          IconButton(
              onPressed: () {
                ///TODO
              },
              icon: Icon(
                Icons.menu,
                size: 20.w,
              ))
        ],
      ),
      body: GestureDetector(
        onTap: Utils.hideKeyboard,
        child: SafeArea(
          child: Column(
            children: [_buildChatSection(context), _buildBottomAction(context)],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 10.w, right: 10.w, bottom: Platform.isIOS ? 0.w : 10.w),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Card(
              color: Theme.of(context).primaryColor,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.w)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  children: [
                    _buildIconAction(),
                    _buildChatTextField(context),
                    SizedBox(
                      width: 12.w,
                    ),
                    _buildPickImageButton(),
                    SizedBox(
                      width: 5.w,
                    ),
                    _buildCameraButton()
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: _buildSendButton(context)),
        ],
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return Card(
      elevation: 3,
      shape: const CircleBorder(),
      child: Material(
        color: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: InkWell(
            onTap: () {
              if (_messageEditingController.text.isNotEmpty) {
                FirebaseUtils.sendMessage(
                    widget.chatUser, _messageEditingController.text);
                _messageEditingController.text = '';

                /// Scroll to top of last element.
                if (isScrollable) {
                  _scrollController.animateTo(
                    0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );
                }
              }
            },
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Transform.rotate(
                angle: -pi / 4,
                child: Icon(
                  Icons.send_rounded,
                  size: 18.w,
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
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.image,
              size: 20.w,
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
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              CupertinoIcons.photo_camera_solid,
              size: 19.w,
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
        focusNode: _messageFocusNode,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(borderRadius)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
              borderRadius: BorderRadius.circular(borderRadius)),
          hintText: S.current.type_something_here,
          contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
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
        padding: EdgeInsets.fromLTRB(15.w, 20.w, 15.w, 10.w),
        color: Theme.of(context).scaffoldBackgroundColor,
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
                  listMessage = listMessage.reversed.toList();
                  isScrollable = listMessage.isNotEmpty;

                  if (listMessage.isNotEmpty) {
                    /// Nếu reversed list view thì phải align top center.
                    return Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        controller: _scrollController,
                        itemCount: listMessage.length,
                        itemBuilder: (context, index) => MessageCard(
                          message: listMessage[index],
                          index: index,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(S.current.say_hello),
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
