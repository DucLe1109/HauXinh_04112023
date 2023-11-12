import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/core/widget_core.dart';
import 'package:boilerplate/features/setting/cubit/setting_cubit.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:boilerplate/router/app_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rest_client/rest_client.dart';

class SettingScreen extends BaseStateFulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends BaseStateFulWidgetState<SettingScreen> {
  late SettingCubit cubit;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> selfStream;

  @override
  void initState() {
    super.initState();
    cubit = Injector.instance();
    selfStream = FirebaseUtils.getSelfInfoStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(S.current.setting),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          child: Column(
            children: [
              _buildSettingInfo(context),
              const SizedBox(
                height: 12,
              ),
              _buildSettingUtility(
                context: context,
                title: S.current.account,
                icon: CupertinoIcons.person,
              ),
              _buildSettingUtility(
                context: context,
                title: S.current.appearance_and_language,
                icon: Icons.light_mode_outlined,
              ),
              _buildSettingUtility(
                context: context,
                title: S.current.notification,
                icon: Icons.notifications_active_outlined,
              ),
              _buildSettingUtility(
                context: context,
                title: S.current.help,
                icon: Icons.help_outline,
              ),
              _buildSettingUtility(
                context: context,
                title: S.current.biometry,
                icon: Icons.touch_app_outlined,
              ),
              BlocListener<SettingCubit, SettingState>(
                listenWhen: (previous, current) => current.isLogout == true,
                listener: (context, state) {
                  switch (state.status) {
                    case UILoadSuccess():
                      context.pushReplacement(AppRouter.appDirectorPath);
                  }
                },
                bloc: cubit,
                child: _buildSettingUtility(
                  context: context,
                  title: S.current.log_out,
                  icon: Icons.logout,
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      title: S.current.log_out,
                      desc: S.current.are_you_sure,
                      btnCancelOnPress: () {},
                      btnCancelColor: Colors.green[300],
                      btnOkColor: Colors.blue[300],
                      btnOkOnPress: () {
                        cubit.logout();
                      },
                    ).show();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingInfo(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        ChatUser? me;
        if (snapshot.hasData) {
          me = ChatUser.fromJson(snapshot.data!.data()!);
        }
        return ListTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          onTap: () {
            context.push(AppRouter.userInfoPath, extra: cubit);
          },
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              imageUrl: me?.avatar ?? FirebaseUtils.me.avatar,
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
          title: Text(
            me?.fullName ?? FirebaseUtils.me.fullName,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              me?.email ?? FirebaseUtils.me.email,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right_rounded,
            size: 30,
          ),
        );
      },
      stream: selfStream,
    );
  }

  Widget _buildSettingUtility({
    required BuildContext context,
    required String title,
    required IconData icon,
    Function()? onTap,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      leading: Icon(
        icon,
        size: 25,
        color: Theme.of(context).textTheme.bodyMedium!.color,
      ),
      horizontalTitleGap: 0,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right_rounded,
        size: 30,
      ),
    );
  }
}
