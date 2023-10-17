import 'package:boilerplate/core/themes/app_colors.dart';
import 'package:boilerplate/features/contact/view/chatting_widget.dart';
import 'package:boilerplate/features/contact/view/story_widget.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rest_client/rest_client.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: ListView(
        children: [
          buildStorySection(),
          Container(
            height: 1,
            color: Colors.grey[200],
          ),
          buildSearchSection(context),
          buildChatSection(),
        ],
      ),
    );
  }

  Widget buildChatSection() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(Collections.chatUser.value)
          .snapshots(),
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
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              return ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) => Chatting(
                    isOnline: list[index].isOnline,
                    isHasStory: list[index].isHasStory,
                    userName: list[index].fullName,
                    message: list[index].about,
                    time: list[index].createdAt,
                    messageCount: 10),
              );
            case ConnectionState.done:
              return Container();
          }
        }
      },
    );
    return Column(
      children: [
        Chatting(
            isHasStory: true,
            time: 'Today',
            messageCount: 20,
            imageProvider: AssetImage(Assets.images.page4.path),
            message: 'Anh ăn cơm chưa',
            isOnline: true,
            userName: 'Hậu hâm'),
        Chatting(
            time: '15/10',
            messageCount: 2,
            imageProvider: AssetImage(Assets.images.page3.path),
            message: 'what was going on',
            isOnline: true,
            userName: 'My friend 2'),
        const Chatting(
            isHasStory: true,
            messageCount: 3,
            time: '16/10',
            isOnline: true,
            userName: 'My friend 1',
            message: 'What are you doing')
      ],
    );
  }

  Widget buildSearchSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: Theme.of(context)
                .searchBarTheme
                .backgroundColor
                ?.resolve(<MaterialState>{})),
        child: TextField(
          controller: _searchController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            isDense: true,
            prefixIconColor: Theme.of(context).textTheme.bodyMedium?.color,
            prefixIconConstraints: BoxConstraints.loose(const Size(30, 50)),
            prefixIcon: IconButton(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.search,
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
                      color: const Color(0xffF7F7FC),
                      borderRadius: BorderRadius.circular(16),
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
                      borderRadius: BorderRadius.circular(16),
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
                      borderRadius: BorderRadius.circular(18),
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
                      borderRadius: BorderRadius.circular(18),
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
