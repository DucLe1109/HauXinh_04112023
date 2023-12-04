// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:io';
import 'dart:math' show pi;

import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/core/widget_core.dart';
import 'package:boilerplate/features/authentication/view/base_loading_dialog.dart';
import 'package:boilerplate/features/personal_chat/cubit/personal_chat_cubit.dart';
import 'package:boilerplate/features/personal_chat/cubit/personal_chat_state.dart';
import 'package:boilerplate/features/personal_chat/message_type.dart';
import 'package:boilerplate/features/personal_chat/model/message_model.dart';
import 'package:boilerplate/features/personal_chat/view/message_card.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:boilerplate/widgets/app_bar_leading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_bloc/d_bloc.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:rest_client/rest_client.dart';

class ChatScreen extends BaseStateFulWidget {
  const ChatScreen(this.chatUser, {super.key});

  final ChatUser chatUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends BaseStateFulWidgetState<ChatScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  Color sendButtonColor =
      const Color.fromARGB(255, 115, 96, 242).withOpacity(0.8);
  bool isScrollable = false;
  List<XFile> photos = [];
  bool isShowEmoji = false;
  double currentKeyboardHeight = 0;
  double keyboardHeight = 301;
  late bool canBack;

  late TextEditingController _messageEditingController;
  late FocusNode _messageFocusNode;
  late List<MessageCard> listMessageView;
  late ScrollController _scrollController;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late AnimationController _animationController;
  late Animation<double> animation;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> chatUserStream;
  late PersonalChatCubit _cubit;

  @override
  void initState() {
    super.initState();
    canBack = true;
    _cubit = PersonalChatCubit();
    _cubit.initData(
        chatUser: widget.chatUser, numberOfItem: numOfMessagePerPage);
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        final bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          return;
        } else {
          /// Load more message
          _cubit.loadMoreMessage(
              chatUser: widget.chatUser,
              numberOfItem: numOfMessagePerPage,
              lastItemVisible: _cubit.currentListDocumentSnapshot.last);
          return;
        }
      }
    });

    listMessageView = [];
    _messageEditingController = TextEditingController();
    _messageFocusNode = FocusNode();
    _messageFocusNode.addListener(() {
      if (_messageFocusNode.hasFocus) {
        setState(() {
          if (isShowEmoji) {
            isShowEmoji = false;
          }
          currentKeyboardHeight = keyboardHeight;
        });
      }

      if (!_messageFocusNode.hasFocus && !isShowEmoji && canBack) {
        setState(() {
          currentKeyboardHeight = 0;
        });
      }
    });
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: fastDuration));
    animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    chatUserStream = FirebaseUtils.getUserInfo(widget.chatUser);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageEditingController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    _cubit.stopListenMessageStream();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        leading: const AppBarLeading(),
        titleSpacing: 0,
        title: _buildTopSection(),
        actions: _buildTopAction(),
      ),
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              isShowEmoji = false;
              currentKeyboardHeight = 0;
            });
            Utils.hideKeyboard();
          },
          child: Column(
            children: [
              _buildChatSection(context),
              _buildBottomSection(context),
              AnimatedContainer(
                onEnd: () {
                  if (isShowEmoji) {
                    setState(() {});
                  }
                },
                duration: const Duration(milliseconds: 350),
                curve: Curves.ease,
                height: currentKeyboardHeight,
                child: _buildEmoji(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmoji() {
    return Offstage(
      offstage: !isShowEmoji,
      child: EmojiPicker(
        textEditingController: _messageEditingController,
        config: Config(
            buttonMode: ButtonMode.CUPERTINO,
            emojiSizeMax: 23.w *
                (foundation.defaultTargetPlatform == TargetPlatform.iOS
                    ? 1
                    : 0.7),
            bgColor: Theme.of(context).primaryColor,
            indicatorColor: sendButtonColor,
            iconColorSelected: sendButtonColor,
            columns: 8),
      ),
    );
  }

  List<Widget> _buildTopAction() {
    return [
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
    ];
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> _buildTopSection() {
    return StreamBuilder(
      builder: (context, snapshot) {
        ChatUser? chatUser;
        if (snapshot.hasData) {
          chatUser = ChatUser.fromJson(snapshot.data!.data()!);
        }
        return Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100.w),
              child: CachedNetworkImage(
                imageUrl: chatUser?.avatar ?? widget.chatUser.avatar,
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
                    chatUser?.fullName ?? widget.chatUser.fullName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 3.w,
                  ),
                  Text(getCurrentStatus(chatUser),
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
          ],
        );
      },
      stream: chatUserStream,
    );
  }

  String getCurrentStatus(ChatUser? chatUser) {
    return (chatUser?.isOnline ?? false)
        ? S.current.online
        : Utils.formatToLastStatusTime(chatUser?.lastActive);
  }

  Widget _buildChatSection(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          BlocConsumer(
              listener: (context, state) {
                switch (state) {
                  case LoadMoreSuccessfully():
                    listKey.currentState?.insertAllItems(
                        0, state.numberOfNewMessage,
                        duration: Duration.zero);
                    break;
                }
              },
              listenWhen: (previous, current) =>
                  current is LoadMoreSuccessfully,
              builder: (context, state) {
                switch (state) {
                  case LoadingMore():
                    return _buildJumpingDot();
                  case LoadMoreSuccessfully():
                    return Container();
                  default:
                    return Container();
                }
              },
              buildWhen: (previous, current) =>
                  current is LoadingMore ||
                  current is LoadMoreSuccessfully ||
                  current is LoadMoreDone,
              bloc: _cubit),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: BlocConsumer(
                listener: (context, state) {
                  if (state is NewMessageState) {
                    listKey.currentState?.insertItem(0);

                    /// Delete item.
                    if (_cubit.currentListMessage.length >
                        numOfMessagePerPage) {
                      listKey.currentState?.removeItem(
                          _cubit.currentListMessage.length - 1,
                          (context, animation) => Container());
                      _cubit.currentListMessage.removeLast();
                    }
                  }
                  if (state is ErrorState) {
                    showToast(
                        toastType: ToastType.error,
                        context: context,
                        title: S.current.update_fail,
                        description: (state.error as DefaultException).message);
                  }
                },
                bloc: _cubit,
                listenWhen: (previous, current) =>
                    current is NewMessageState || current is ErrorState,
                buildWhen: (previous, current) =>
                    current is InitiateData ||
                    current is InitiateDataSuccessFully,
                builder: (context, state) {
                  switch (state) {
                    case InitiateData():
                      return Center(
                          child: BaseLoadingDialog(
                        startRatio: 0.8,
                        iconHeight: 26.w,
                        iconWidth: 26.w,
                        radius: 28.w,
                        relativeWidth: 1.5,
                      ));
                    case InitiateDataSuccessFully():
                      isScrollable = _cubit.currentListMessage.isNotEmpty;

                      return ListenableBuilder(
                        listenable: _cubit.animatedListNotifier,
                        builder: (context, child) => AnimatedList(
                          physics: const AlwaysScrollableScrollPhysics(),
                          key: listKey,
                          itemBuilder: (context, index, animation) {
                            return SizeTransition(
                              sizeFactor: Tween<double>(begin: 0, end: 1)
                                  .animate(CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOut)),
                              child: SlideTransition(
                                position: Tween(
                                        begin: Offset(0.w, 5.w),
                                        end: Offset.zero)
                                    .animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOut)),
                                child: MessageCard(
                                    chatUser: widget.chatUser,
                                    message: _cubit.currentListMessage[index],
                                    isRounded: isRounded(index)),
                              ),
                            );
                          },
                          initialItemCount: _cubit.currentListMessage.length,
                          controller: _scrollController,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              vertical: 16.w, horizontal: 16.w),
                          reverse: true,
                        ),
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isRounded(int index) {
    return index < _cubit.currentListMessage.length - 1 &&
        _cubit.currentListMessage[index].fromId ==
            _cubit.currentListMessage[index + 1].fromId;
  }

  Widget _buildJumpingDot() {
    return Container(
      padding: EdgeInsets.only(top: 8.w),
      height: 20.w,
      child: JumpingDots(
        verticalOffset: 10,
        color: Colors.orange,
        radius: 6.w,
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
            cursorColor: Theme.of(context).textTheme.bodyMedium?.color,
            focusNode: _messageFocusNode,
            style: Theme.of(context).textTheme.bodyMedium,
            minLines: 1,
            controller: _messageEditingController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: S.current.type_something_here,
              hintStyle: Theme.of(context).textTheme.bodySmall,
              contentPadding: EdgeInsets.fromLTRB(8.w, 6.w, 0, 12.w),
              isDense: true,
              border: InputBorder.none,
            ),
          ),
          SizeTransition(
            sizeFactor: animation,
            child: Container(
              padding: EdgeInsets.only(
                bottom: 12.w,
              ),
              height: 150.w,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: photos.map(_buildPickedImage).toList(),
                ),
              ),
            ),
          ),
          _buildActionButton()
        ],
      ),
    );
  }

  Widget _buildPickedImage(XFile e) {
    return Stack(
      children: [
        Container(
            margin: EdgeInsets.only(left: 12.w, right: 13.w, top: 4.w),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.w),
                child: Image.file(File(e.path)))),
        Positioned.fill(
          top: 0.w,
          right: 8.w,
          child: Align(
            alignment: Alignment.topRight,
            child: Material(
              shape: const CircleBorder(),
              color: Colors.redAccent,
              child: InkWell(
                  borderRadius: BorderRadius.circular(100.w),
                  onTap: () {
                    setState(() {
                      photos.remove(e);
                    });
                    if (photos.isEmpty) {
                      _animationController.reset();
                    }
                  },
                  child: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: Icon(
                        Icons.clear,
                        size: 12.w,
                      ))),
            ),
          ),
        )
      ],
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
        color: sendButtonColor,
        shape: const CircleBorder(),
        child: InkWell(
            onTap: () {
              if (photos.isNotEmpty) {
                sendImageOnlineMode();

                sendImageOfflineMode();

                photos.clear();
                goTopOfList();
                _animationController.reset();
              }
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

  void sendImageOnlineMode() {
    _cubit.sendAllMessage(photos: photos, chatUser: widget.chatUser);
  }

  void sendImageOfflineMode() {
    for (final e in photos) {
      _cubit.currentListMessage.insert(
          0,
          MessageModel(
              imageCacheUri: e.path,
              readAt: '',
              fromId: FirebaseUtils.me.id,
              toId: widget.chatUser.id,
              type: MessageType.temp.name,
              createdTime:
                  DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
              msg: e.path));
      listKey.currentState?.insertItem(0);
    }
  }

  Widget _buildPickImageButton() {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
          onTap: () async {
            Utils.hideKeyboard();
            final ImagePicker picker = ImagePicker();
            final result = await picker.pickMultiImage(imageQuality: 70);
            photos.addAll(result);
            setState(() {
              currentKeyboardHeight = 0;
            });
            if (photos.isNotEmpty) await _animationController.forward();
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
          onTap: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? photo = await picker.pickImage(
                source: ImageSource.camera, imageQuality: 70);

            if (photo != null) {
              photos.add(photo);
            }
            setState(() {
              isShowEmoji = false;
              currentKeyboardHeight = 0;
            });
            if (photos.isNotEmpty) await _animationController.forward();
          },
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
            canBack = false;
            Utils.hideKeyboard();
            setState(() {
              currentKeyboardHeight = keyboardHeight;
            });

            Future.delayed(
              const Duration(milliseconds: 150),
              () => setState(() {
                isShowEmoji = true;
                canBack = true;
              }),
            );
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
