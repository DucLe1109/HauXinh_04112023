import 'dart:math' show pi;

import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  @override
  void initState() {
    super.initState();
    _messageEditingController = TextEditingController();
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
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: widget.chatUser.avatar,
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                widget.chatUser.fullName,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500),
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
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 80),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              padding: const EdgeInsets.fromLTRB(
                  verticalPadding, verticalPadding, verticalPadding, horizontalPadding),
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.add,
                            size: 25,
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {},
                      onEditingComplete: Utils.hideKeyboard,
                      controller: _messageEditingController,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(borderRadius)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0),
                            borderRadius: BorderRadius.circular(borderRadius)),
                        filled: true,
                        fillColor: Theme.of(context)
                            .searchBarTheme
                            .backgroundColor
                            ?.resolve({}),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Transform.rotate(
                    angle: -pi / 4,
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.send,
                              size: 20,
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
