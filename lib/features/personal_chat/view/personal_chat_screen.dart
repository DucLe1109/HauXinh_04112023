// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'dart:math' show pi;

import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/features/personal_chat/cubit/chat_cubit.dart';
import 'package:boilerplate/features/personal_chat/view/message_card.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
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
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rest_client/rest_client.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(this.chatUser, {super.key});

  final ChatUser chatUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
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
    return WillPopScope(
      onWillPop: () {
        if (isShowEmoji.value) {
          isShowEmoji.value = false;
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
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

  void goTopOfList() {
    if (isScrollable) {
      _scrollController.animateTo(
        0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  Widget _buildBottomSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 10.w, right: 10.w, bottom: Platform.isIOS ? 0.w : 10.w),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
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

  /// Sub view
  Widget _buildSendButton(BuildContext context) {
    return Card(
      elevation: 3,
      shape: const CircleBorder(),
      child: Material(
        color: Theme.of(context).colorScheme.secondary,
        shape: const CircleBorder(),
        child: InkWell(
            onTap: () {
              if (_messageEditingController.text.isNotEmpty) {
                _cubit.sendMessage(
                    chatUser: widget.chatUser,
                    msg: _messageEditingController.text.trim());
                _messageEditingController.text = '';
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
            padding: EdgeInsets.fromLTRB(8.w, 6.w, 8.w, 7.w),
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
        maxLines: 2,
        minLines: 1,
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: Theme.of(context).textTheme.bodyMedium?.color,
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
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 12.w),
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
          onTap: () {
            Utils.hideKeyboard();
            isShowEmoji.value = !isShowEmoji.value;
          },
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.w, 6.w, 8.w, 8.w),
            child: Icon(
              CupertinoIcons.smiley_fill,
              size: 20.w,
              color: Colors.blue,
            ),
          )),
    );
  }
}
