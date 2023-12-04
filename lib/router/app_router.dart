import 'package:boilerplate/features/app/view/app_director.dart';
import 'package:boilerplate/features/authentication/login_screen.dart';
import 'package:boilerplate/features/demo/view/assets_page.dart';
import 'package:boilerplate/features/demo/view/images_from_db_page.dart';
import 'package:boilerplate/features/dog_image_random/view/dog_image_random_page.dart';
import 'package:boilerplate/features/home/view/home_page.dart';
import 'package:boilerplate/features/intro/intro_page.dart';
import 'package:boilerplate/features/personal_chat/view/personal_chat_screen.dart';
import 'package:boilerplate/features/setting/cubit/setting_cubit.dart';
import 'package:boilerplate/features/setting/view/infor_utility/information_screen.dart';
import 'package:boilerplate/features/setting/view/setting_page.dart';
import 'package:boilerplate/features/vacation/view/vacation.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/router/navigator_service.dart';
import 'package:boilerplate/utils/dismiss_keyboard_navigation_observer.dart';
import 'package:boilerplate/widgets/error_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rest_client/rest_client.dart';

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

  static const String userInfo = 'userInfo';
  static const String userInfoPath = '/userInfoPath';

  static const String chatScreen = 'chatScreen';
  static const String chatScreenPath = '/chatScreenPath';

  static GoRouter get router => _router;

  static final RouteObserver<PageRoute> _routeObserver = RouteObserver<PageRoute>();
  static final DismissKeyboardNavigationObserver _navigationObserver =
      DismissKeyboardNavigationObserver();

  static final _router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    observers: [_routeObserver, _navigationObserver],
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
        name: chatScreen,
        path: chatScreenPath,
        builder: (context, state) {
          final ChatUser chatUser = state.extra! as ChatUser;
          return ChatScreen(chatUser);
        },
      ),
      GoRoute(
        name: userInfo,
        path: userInfoPath,
        builder: (context, state) {
          final SettingCubit settingCubit = state.extra! as SettingCubit;
          return BlocProvider.value(
              value: settingCubit, child: const InformationScreen());
        },
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
