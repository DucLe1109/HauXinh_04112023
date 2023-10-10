import 'package:boilerplate/features/app/view/app_director.dart';
import 'package:boilerplate/features/authentication/login_screen.dart';
import 'package:boilerplate/features/demo/view/assets_page.dart';
import 'package:boilerplate/features/demo/view/images_from_db_page.dart';
import 'package:boilerplate/features/dog_image_random/view/dog_image_random_page.dart';
import 'package:boilerplate/features/home/home_page.dart';
import 'package:boilerplate/features/intro/intro_page.dart';
import 'package:boilerplate/features/setting/setting_page.dart';
import 'package:boilerplate/features/vacation/vacation.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/widgets/error_page.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static const String appDirector = 'appDirector';
  static const String appDirectorPath = '/';

  static const String introNamed = 'intro';
  static const String introPath = '/intro';

  static const String loginNamed = 'login';
  static const String loginPath = '/login';

  static const String vacationName = 'vacation';
  static const String vacationPath = '/vacationPath';

  static const String homeNamed = 'home';
  static const String homePath = '/';

  static const String settingNamed = 'setting';
  static const String settingPath = '/setting';

  static const String assetsNamed = 'assets';
  static const String assetsPath = '/assets';

  static const String dogImageRandomNamed = 'dogImageRandom';
  static const String dogImageRandomPath = '/dogImageRandom';

  static const String imagesFromDbNamed = 'imagesFromDb';
  static const String imagesFromDbPath = '/imagesFromDb';

  static GoRouter get router => _router;
  static final _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        name: loginNamed,
        path: loginPath,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        name: introNamed,
        path: introPath,
        builder: (context, state) {
          return const IntroPage();
        },
      ),
      GoRoute(
        name: appDirector,
        path: appDirectorPath,
        builder: (context, state) {
          return const AppDirector();
        },
      ),
      GoRoute(
        name: vacationName,
        path: vacationPath,
        builder: (context, state) => const Vacation(),
      ),
      GoRoute(
        name: homeNamed,
        path: homePath,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        name: settingNamed,
        path: settingPath,
        builder: (context, state) => const SettingPage(),
      ),
      GoRoute(
        name: assetsNamed,
        path: assetsPath,
        builder: (context, state) => const AssetsPage(),
      ),
      GoRoute(
        name: dogImageRandomNamed,
        path: dogImageRandomPath,
        builder: (context, state) => const DogImageRandomPage(),
      ),
      GoRoute(
        name: imagesFromDbNamed,
        path: imagesFromDbPath,
        builder: (context, state) {
          if (!kIsWeb) {
            return const ImagesFromDbPage();
          }

          return ErrorPage(
            content: S.current.didnt_supported,
          );
        },
      ),
    ],
  );
}
