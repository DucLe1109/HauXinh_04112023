// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/core/widget_core.dart';
import 'package:boilerplate/features/home/cubit/home_cubit.dart';
import 'package:boilerplate/features/list_chat/view/list_chat_screen.dart';
import 'package:boilerplate/features/setting/view/setting_screen.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:boilerplate/router/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomePage extends BaseStateFulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseStateFulWidgetState<HomePage> {
  late PersistentTabController _controller;
  late HomeCubit homeCubit;

  // late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    FirebaseUtils.updateUserStatus(isOnline: true);
    _controller = PersistentTabController(initialIndex: 1);
    homeCubit = Injector.instance();
    Future.delayed(
      const Duration(seconds: 2),
      () => homeCubit.checkAuthentication(),
    );
    AppLifecycleListener(
      onResume: () {
        FirebaseUtils.updateUserStatus(isOnline: true);
      },
      onPause: () {
        FirebaseUtils.updateUserStatus(isOnline: false);
      },
    );
    // Connectivity().checkConnectivity().then((value) {
    //   if (value == ConnectivityResult.none) {
    //     isHasConnection = false;
    //     AwesomeDialog(
    //       dismissOnBackKeyPress: false,
    //       dismissOnTouchOutside: false,
    //       dialogType: DialogType.error,
    //       context: context,
    //       title: S.current.no_connection,
    //       desc: S.current.no_connection_des,
    //       btnOkColor: Colors.redAccent,
    //       btnOkOnPress: () {},
    //     ).show();
    //   }
    // });
    //
    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   if (result == ConnectivityResult.none) {
    //     isHasConnection = false;
    //     AwesomeDialog(
    //       dismissOnBackKeyPress: false,
    //       dismissOnTouchOutside: false,
    //       dialogType: DialogType.error,
    //       context: context,
    //       title: S.current.no_connection,
    //       desc: S.current.no_connection_des,
    //       btnOkColor: Colors.redAccent,
    //       btnOkOnPress: () {},
    //     ).show();
    //   } else if (isHasConnection == false &&
    //           result == ConnectivityResult.wifi ||
    //       result == ConnectivityResult.ethernet) {
    //     isHasConnection = true;
    //     AwesomeDialog(
    //       dismissOnBackKeyPress: false,
    //       dismissOnTouchOutside: false,
    //       dialogType: DialogType.success,
    //       context: context,
    //       title: S.current.connection_is_recover,
    //       desc: S.current.continue_with_app,
    //       btnOkColor: Colors.lightBlue,
    //       btnOkOnPress: () {},
    //     ).show();
    //   }
    // });
  }

  @override
  void dispose() {
    // subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state.status is UILoadFailed) {
          AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            dialogType: DialogType.error,
            context: context,
            title: S.current.authentication,
            desc: S.current.expired_session,
            btnOkColor: Colors.redAccent,
            btnOkOnPress: () {
              context.pushReplacement(AppRouter.appDirectorPath);
            },
          ).show();
        }
      },
      bloc: homeCubit,
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          resizeToAvoidBottomInset: true,
          // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10),
            colorBehindNavBar: Colors.white,
          ),
          itemAnimationProperties: const ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
          ),
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      Container(),
      const ListChatScreen(),
      const SettingScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.phone_circle),
          title: S.current.contact,
          inactiveColorPrimary: Theme.of(context)
              .bottomNavigationBarTheme
              .unselectedIconTheme!
              .color,
          activeColorPrimary: Theme.of(context)
              .bottomNavigationBarTheme
              .selectedIconTheme!
              .color!),
      PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.chat_bubble_2),
          title: S.current.chats,
          inactiveColorPrimary: Theme.of(context)
              .bottomNavigationBarTheme
              .unselectedIconTheme!
              .color,
          activeColorPrimary: Theme.of(context)
              .bottomNavigationBarTheme
              .selectedIconTheme!
              .color!),
      PersistentBottomNavBarItem(
          icon: const Icon(CupertinoIcons.settings),
          title: S.current.setting,
          inactiveColorPrimary: Theme.of(context)
              .bottomNavigationBarTheme
              .unselectedIconTheme!
              .color,
          activeColorPrimary: Theme.of(context)
              .bottomNavigationBarTheme
              .selectedIconTheme!
              .color!),
    ];
  }
}
