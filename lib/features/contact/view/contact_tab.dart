import 'package:boilerplate/features/contact/view/chatting_widget.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
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
        title: Text(S.current.contact),
        actions: [
          IconButton(
              onPressed: () {
                ///TODO
              },
              icon: const Icon(CupertinoIcons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    prefixIconColor:
                        Theme.of(context).textTheme.bodyMedium?.color,
                    prefixIconConstraints:
                        BoxConstraints.loose(const Size(30, 50)),
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
            ),
            Chatting(
                time: 'Today',
                messageCount: 20,
                imageProvider: AssetImage(Assets.images.page4.path),
                message: 'Anh ăn cơm chưa',
                hasNewMessage: true,
                userName: 'Hậu hâm'),
            Chatting(
                time: '15/10',
                messageCount: 2,
                imageProvider: AssetImage(Assets.images.page3.path),
                message: 'what was going on',
                hasNewMessage: true,
                userName: 'My friend 2'),
            const Chatting(
                messageCount: 3,
                time: '16/10',
                hasNewMessage: true,
                userName: 'My friend 1',
                message: 'What are you doing')
          ],
        ),
      ),
    );
  }
}
