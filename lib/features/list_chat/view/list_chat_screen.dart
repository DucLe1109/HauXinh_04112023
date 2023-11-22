import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/core/themes/app_colors.dart';
import 'package:boilerplate/features/list_chat/view/chatting_widget.dart';
import 'package:boilerplate/features/list_chat/view/story_widget.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/router/app_router.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rest_client/rest_client.dart';

class ListChatScreen extends StatefulWidget {
  const ListChatScreen({super.key});

  @override
  State<ListChatScreen> createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ListChatScreen> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  late List<ChatUser> _searchListUser;
  late List<ChatUser> _listUser;
  late bool isSearch;
  late bool isShowClearIcon;

  late Stream<QuerySnapshot<Map<String, dynamic>>> chatUserStream;

  @override
  void initState() {
    super.initState();
    chatUserStream = FirebaseUtils.getAllUsers();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    isSearch = false;
    isShowClearIcon = false;

    _searchListUser = [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text('Chats'),
        actions: [
          SizedBox(
            width: 30,
            child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  ///TODO
                },
                icon: const Icon(CupertinoIcons.app_badge)),
          ),
          IconButton(
              onPressed: () {
                ///TODO
              },
              icon: const Icon(CupertinoIcons.arrow_2_circlepath))
        ],
      ),
      body: GestureDetector(
        onTap: Utils.hideKeyboard,
        child: ListView(
          children: [
            buildStorySection(),
            Container(
              height: 1,
              color: Theme.of(context)
                  .searchBarTheme
                  .backgroundColor
                  ?.resolve(<MaterialState>{}),
            ),
            buildSearchSection(context),
            buildChatSection(),
          ],
        ),
      ),
    );
  }

  Widget buildChatSection() {
    return StreamBuilder(
      stream: chatUserStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const SizedBox(
                width: double.infinity,
                height: 400,
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              final data = snapshot.data?.docs;
              _listUser =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              return ListView.builder(
                shrinkWrap: true,
                itemCount:
                    !isSearch ? _listUser.length : _searchListUser.length,
                itemBuilder: (context, index) => Chatting(
                  onTap: () {
                    context.push(AppRouter.chatScreenPath,
                        extra: !isSearch
                            ? _listUser[index]
                            : _searchListUser[index]);
                  },
                  chatUser:
                      !isSearch ? _listUser[index] : _searchListUser[index],
                ),
              );
            case ConnectionState.done:
              return Container();
          }
        }
      },
    );
  }

  Widget buildSearchSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: TextField(
          cursorColor:
              Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
          focusNode: _searchFocusNode,
          onChanged: (value) {
            _searchListUser.clear();
            for (final element in _listUser) {
              if (element.fullName
                      .toLowerCase()
                      .contains(value.toLowerCase()) ||
                  element.email.toLowerCase().contains(value.toLowerCase())) {
                _searchListUser.add(element);
              }
            }
            setState(() {
              isSearch = value.isNotEmpty;
              isShowClearIcon = value.isNotEmpty;
            });
          },
          style: Theme.of(context).textTheme.bodyMedium,
          onEditingComplete: Utils.hideKeyboard,
          controller: _searchController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: isShowClearIcon
                ? InkWell(
                    onTap: () {
                      _searchController.text = '';
                      setState(() {
                        isSearch = false;
                        isShowClearIcon = false;
                      });
                    },
                    child: const Icon(
                      CupertinoIcons.clear_circled,
                      color: AppColors.grey600,
                      size: 20,
                    ))
                : null,
            isDense: true,
            prefixIconColor: Theme.of(context).textTheme.bodyMedium?.color,
            prefixIconConstraints: BoxConstraints.loose(const Size(30, 50)),
            prefixIcon: IconButton(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.search,
                  color: AppColors.grey600,
                  size: 20,
                )),
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            hintText: S.current.search,
          ),
        ),
      ),
    );
  }

  Widget buildStorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: ListView(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              StoryWidget(
                  description: S.current.your_story,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius:
                          BorderRadius.circular(borderRadiusAvatar - 2),
                    ),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.greyLight,
                          size: 25,
                        )),
                  )),
              const SizedBox(
                width: 10,
              ),
              StoryWidget(
                  description: 'Huy Đức',
                  borderColor: Colors.blue,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(borderRadiusAvatar - 2),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(Assets.images.page1.path)),
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              StoryWidget(
                  description: 'Phan Hậu',
                  borderColor: Colors.blue,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(borderRadiusAvatar - 2),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(Assets.images.page2.path)),
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              StoryWidget(
                  description: 'Minh Hải',
                  borderColor: Colors.blue,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(borderRadiusAvatar - 2),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(Assets.images.page3.path)),
                    ),
                  )),
            ]),
      ),
    );
  }
}
