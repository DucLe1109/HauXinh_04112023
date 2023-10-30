// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'dart:math' show pi;

import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/features/personal_chat/cubit/chat_cubit.dart';
import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/features/personal_chat/view/message_card.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_bloc/default_widget/default_loading_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
  late List<MessageCard> listMessageView;
  late ScrollController _scrollController;
  bool isScrollable = false;
  late ChatCubit _cubit;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late ChangeNotifier changeNotifier;
  late Stream<QuerySnapshot<Map<String, dynamic>>> chatStream;
  List<Message> currentMessageList = [];
  late ValueNotifier<bool> isShowEmoji;

  @override
  void initState() {
    super.initState();
    isShowEmoji = ValueNotifier(false);
    _cubit = ChatCubit(widget.chatUser);
    _cubit.getNewestMessage(chatUser: widget.chatUser, amount: 20);
    listMessageView = [];
    _messageEditingController = TextEditingController();
    _scrollController = ScrollController();
    _messageFocusNode = FocusNode();
    _messageFocusNode.addListener(() {
      if (_messageFocusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    changeNotifier = ChangeNotifier();
    chatStream = FirebaseUtils.getAllMessages(widget.chatUser);

    chatStream.listen((newData) {
      final List<Message> newMessage =
          newData.docs.map((e) => Message.fromJson(e.data())).toList();
      if (listKey.currentState != null &&
          listKey.currentState!.widget.initialItemCount < newMessage.length) {
        final List<Message> updateList = newMessage
            .where((element) => !currentMessageList.contains(element))
            .toList();
        for (final _ in updateList) {
          listKey.currentState!.insertItem(0);
        }
      }
      currentMessageList = newMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.6.w),
          child: Container(
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
            height: 0.6.w,
          ),
        ),
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              size: 18.w,
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
            children: [
              _buildChatSection(context),
              _buildBottomSection(context),
              ValueListenableBuilder(
                valueListenable: isShowEmoji,
                builder: (context, value, child) => Visibility(
                    visible: value,
                    child: SizedBox(
                      height: 300.w,
                      child: EmojiPicker(
                        textEditingController: _messageEditingController,
                        config: Config(
                          buttonMode: ButtonMode.CUPERTINO,
                          emojiSizeMax: 30.w *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1
                                  : 0.7),
                          bgColor: const Color(0xFFF2F2F2),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatSection(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: StreamBuilder(
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                // TODO: Handle this case.
                case ConnectionState.waiting:
                  return const DefaultLoadingWidget();
                case ConnectionState.active:
                // TODO: Handle this case.
                case ConnectionState.done:
                  final data = snapshot.data?.docs
                      .map((e) => Message.fromJson(e.data()))
                      .toList()
                      .reversed
                      .toList();

                  isScrollable = data?.isNotEmpty ?? false;

                  return AnimatedList(
                    key: listKey,
                    itemBuilder: (context, index, animation) {
                      return SizeTransition(
                        sizeFactor: animation,
                        child: MessageCard(message: data![index]),
                      );
                    },
                    initialItemCount: data?.length ?? 0,
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding:
                        EdgeInsets.symmetric(vertical: 16.w, horizontal: 16.w),
                    reverse: true,
                  );
              }
            }
          },
          stream: chatStream,
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
        width: 0.6.w,
        color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
      ))),
      padding:
          EdgeInsets.fromLTRB(12.w, 6.w, 12.w, Platform.isIOS ? 6.w : 15.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTextField(context),
          SizedBox(
            width: 12.w,
          ),
          _buildSendButton(context)
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TextField(
            focusNode: _messageFocusNode,
            style: Theme.of(context).textTheme.bodyMedium,
            minLines: 1,
            controller: _messageEditingController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: S.current.type_something_here,
              hintStyle: Theme.of(context).textTheme.bodySmall,
              contentPadding: EdgeInsets.fromLTRB(8.w, 6.w, 0, 16.w),
              isDense: true,
              border: InputBorder.none,
            ),
          ),
          _buildActionButton()
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Row(
      children: [
        _buildCameraButton(),
        SizedBox(
          width: 16.w,
        ),
        _buildPickImageButton(),
        SizedBox(
          width: 16.w,
        ),
        _buildIconAction(),
      ],
    );
  }

  /// Sub view
  Widget _buildSendButton(BuildContext context) {
    return Card(
      elevation: 3,
      shape: const CircleBorder(),
      child: Material(
        color: const Color.fromARGB(255, 115, 96, 242).withOpacity(0.8),
        shape: const CircleBorder(),
        child: InkWell(
            onTap: () {
              if (_messageEditingController.text.isNotEmpty) {
                FirebaseUtils.sendMessage(
                    messageType: MessageType.text,
                    chatUser: widget.chatUser,
                    msg: _messageEditingController.text.trim());
                _messageEditingController.text = '';
                goTopOfList();
              }
            },
            customBorder: const CircleBorder(),
            child: Padding(
              padding: EdgeInsets.all(9.w),
              child: Transform.rotate(
                angle: -pi / 4,
                child: Icon(
                  Icons.send_rounded,
                  size: 18.w,
                  color: Colors.white,
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
          onTap: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? photo = await picker.pickImage(
                source: ImageSource.gallery, imageQuality: 60);
            if (photo != null) {
              await FirebaseUtils.sendFile(
                  chatUser: widget.chatUser, file: File(photo.path));
            }
          },
          borderRadius: BorderRadius.circular(100),
          child: Assets.icons.icImage.image(
              scale: 20,
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.color
                  ?.withOpacity(0.7))),
    );
  }

  Widget _buildCameraButton() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.w, 6.w, 8.w, 7.w),
            child: Assets.icons.icCamera.image(
                scale: 20,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7)),
          )),
    );
  }

  Widget _buildIconAction() {
    return Material(
      borderRadius: BorderRadius.circular(100),
      color: Colors.transparent,
      child: InkWell(
          onTap: () {
            Utils.hideKeyboard();
            isShowEmoji.value = !isShowEmoji.value;
          },
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.w, 6.w, 8.w, 8.w),
            child: Assets.icons.icSmiley.image(
                scale: 20,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7)),
          )),
    );
  }

  void goTopOfList() {
    if (isScrollable) {
      _scrollController.animateTo(
        0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }
}
