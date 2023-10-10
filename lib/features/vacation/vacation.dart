// ignore_for_file: lines_longer_than_80_chars

import 'package:boilerplate/animation/translation_fade_in.dart';
import 'package:boilerplate/features/authentication/cubit/auth_cubit.dart';
import 'package:boilerplate/features/vacation/detail_screen.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:boilerplate/router/app_router.dart';
import 'package:boilerplate/services/auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Vacation extends StatefulWidget {
  const Vacation({super.key});

  @override
  State<Vacation> createState() => _VacationState();
}

class _VacationState extends State<Vacation> {
  List<String> images = [
    Assets.images.tamdao.path,
    Assets.images.maichau.path,
    Assets.images.page5.path,
  ];
  List<String> videos = [
    Assets.videos.tamdao,
    Assets.videos.maichau,
    Assets.videos.halong,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: const Text(
                'Album screen',
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                onPressed: () {
                  _logout(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 15,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.black,
              expandedHeight: 470,
              flexibleSpace: FlexibleSpaceBar(
                background: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.images.page1.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(.1),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Du lịch',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '01/2018 - 10/2023',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              Text(
                                '${images.length} Videos',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TranslationFadeIn(
                        translateDirection: TranslateDirection.up,
                        mChild: Text(
                            style: TextStyle(
                              color: Colors.white.withOpacity(.7),
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                            ),
                            'Lorem ipsum dolor sit amet, '
                            'consectetur adipiscing elit, sed do '
                            'eiusmod tempor incididunt ut labore et dolore magna '
                            'aliqua. Ut enim ad minim veniam, quis nostrud exercitation '
                            'ullamco laboris nisi ut aliquip ex ea commodo consequat. '
                            'Duis aute irure dolor in reprehenderit in voluptate velit '
                            'esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Creator: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      TranslationFadeIn(
                        translateDirection: TranslateDirection.up,
                        delay: const Duration(milliseconds: 300),
                        mChild: Text(
                          'Lê Huy Đức',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Location: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      TranslationFadeIn(
                        translateDirection: TranslateDirection.up,
                        delay: const Duration(milliseconds: 600),
                        mChild: Text(
                          'Tam Đảo, Mai Châu, Hạ Long',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Videos: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TranslationFadeIn(
                        translateDirection: TranslateDirection.up,
                        delay: const Duration(milliseconds: 1000),
                        mChild: SizedBox(
                          height: 100,
                          child: ListView.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index) => buildVideo(
                              context,
                              images[index],
                              videos[index],
                            ),
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    Injector.instance<AuthCubit>().logout();
    context.pushReplacement(AppRouter.loginPath);
  }

  Widget buildVideo(BuildContext context, String imagePath, String videoPath) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Material(
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailScreen(imagePath: imagePath, videoPath: videoPath),
              ),
            ),
            child: Container(
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
