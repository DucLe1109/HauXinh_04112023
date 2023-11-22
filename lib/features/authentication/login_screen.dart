import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/core/themes/app_colors.dart';
import 'package:boilerplate/core/widget_core.dart';
import 'package:boilerplate/features/authentication/cubit/auth_cubit.dart';
import 'package:boilerplate/features/authentication/view/base_loading_dialog.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:boilerplate/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends BaseStateFulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseStateFulWidgetState<LoginScreen> {
  late AuthCubit authCubit;

  @override
  void initState() {
    super.initState();

    authCubit = Injector.instance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildBgSection(context),
          SizedBox(
            height: 16.w,
          ),
          _buildLoginSection(context),
        ],
      ),
    );
  }

  Widget _buildLoginSection(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case UILoadSuccess():
            {
              hideLoading(context);
              context.pushReplacement(AppRouter.appDirectorPath);
              break;
            }
          case UILoadFailed():
            {
              hideLoading(context);
              showToast(
                toastType: ToastType.error,
                context: context,
                title: S.current.login_fail,
                description: (state.status as UILoadFailed).message,
              );
              break;
            }
          case UILoading():
            {
              showLoading(
                context: context,
                loadingWidget: const BaseLoadingDialog(),
              );
              break;
            }
        }
      },
      bloc: authCubit,
      child: Column(
        children: [
          SizedBox(
            height: 40.w,
          ),
          _buildLoginItem(
              onTap: () => authCubit.signInWithGoogle(),
              backgroundColor: AppColors.green200,
              context: context,
              prefixIcon: SvgPicture.asset(Assets.images.icGmail.path),
              description: S.current.sign_in_with_gmail),
          SizedBox(
            height: 16.w,
          ),
          _buildLoginItem(
              onTap: () {},
              backgroundColor: AppColors.blue200.withOpacity(0.7),
              context: context,
              prefixIcon: SvgPicture.asset(
                Assets.images.icFacebook.path,
                colorFilter:
                    const ColorFilter.mode(AppColors.blue300, BlendMode.srcIn),
              ),
              description: S.current.sign_in_with_facebook),
          SizedBox(
            height: 16.w,
          ),
          _buildLoginItem(
              onTap: () {},
              backgroundColor: AppColors.red200.withOpacity(0.8),
              context: context,
              prefixIcon: SvgPicture.asset(Assets.images.icApple.path),
              description: S.current.sign_in_with_apple),
        ],
      ),
    );
  }

  Container _buildLoginItem(
      {required BuildContext context,
      required Widget prefixIcon,
      Color? backgroundColor,
      Function()? onTap,
      required String description}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: FilledButton(
        style: FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 60.w)),
        onPressed: onTap,
        child: Row(
          children: [
            prefixIcon,
            SizedBox(
              width: 16.w,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBgSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 80.w),
      alignment: Alignment.topCenter,
      child: SvgPicture.asset(
        Assets.images.loginBackground.path,
        width: 300.w,
        height: 300.w,
      ),
    );
  }
}
