// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'dart:math' show pi;

import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/features/personal_chat/cubit/chat_cubit.dart';
import 'package:boilerplate/features/personal_chat/cubit/chat_state.dart';
import 'package:boilerplate/features/personal_chat/view/message_card.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_bloc/d_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();
    _cubit = ChatCubit(widget.chatUser);
    _cubit.getNewestMessage(chatUser: widget.chatUser, amount: 20);
    listMessageView = [];
    _messageEditingController = TextEditingController();
    _scrollController = ScrollController();
    _messageFocusNode = FocusNode();
    changeNotifier = ChangeNotifier();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _buildBottomSection(context)
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
        child: BlocConsumer(
          listenWhen: (previous, current) =>
              current is SendMessageSuccessState ||
              current is SendMessageLoadingState ||
              current is NewMessageState,
          listener: dListener(
            otherwise: (state) {
              if (state is SendMessageSuccessState) {
                goTopOfList();
                _insertAndPushNewItem(state.message);
              }
              if (state is NewMessageState) {
                goTopOfList();
                _insertAndPushNewItem(state.message);
              }
            },
          ),
          bloc: _cubit,
          buildWhen: (previous, current) =>
              current is LoadingState || current is SuccessState,
          builder: dBuilder<List<Message>, DefaultException>(
            onSuccess: (data) {
              if (data != null) {
                isScrollable = data.isNotEmpty;
                listMessageView = data
                    .map((e) => MessageCard(
                        message: e,
                        animationController: AnimationController(
                            vsync: this,
                            duration:
                                const Duration(milliseconds: fastDuration))))
                    .toList();
              }
              return ListenableBuilder(
                listenable: changeNotifier,
                builder: (context, child) => AnimatedList(
                  key: listKey,
                  itemBuilder: (context, index, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: listMessageView[index],
                    );
                  },
                  initialItemCount: listMessageView.length,
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.w, horizontal: 16.w),
                  reverse: true,
                ),
              );
            },
            otherwise: (BlocState state) {
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void _insertAndPushNewItem(Message message) {
    final newMessageCard = MessageCard(
      message: message,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: fastDuration),
      ),
    );
    listMessageView.insert(0, newMessageCard);
    listKey.currentState!.insertItem(0,
        duration: const Duration(milliseconds: fastDuration - 100));
    newMessageCard.animationController.forward();
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
              color: Theme.of(context).colorScheme.inversePrimary,
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
        color: Theme.of(context).colorScheme.inversePrimary,
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
}
