import 'dart:io';

import 'package:boilerplate/animation/translation_fade_in.dart';
import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/core/themes/app_colors.dart';
import 'package:boilerplate/core/widget_core.dart';
import 'package:boilerplate/features/app/bloc/app_bloc.dart';
import 'package:boilerplate/features/authentication/cubit/auth_cubit.dart';
import 'package:boilerplate/features/authentication/view/base_loading_dialog.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
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
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          switch (state.status) {
            case UILoadSuccess():
              {
                hideLoading(context);
                if (FirebaseUtils.me.nickName.isNotEmpty &&
                    FirebaseUtils.me.phoneNumber.isNotEmpty) {
                  context.pushReplacement(AppRouter.appDirectorPath);
                } else {
                  context.pushReplacement(AppRouter.infoCollectionScreenPath);
                }
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
        child: Stack(
          children: [
            _buildBgSection(context),
            _buildMainSection(context),
            _buildLoginSection(),
            _buildCopyRightSection(),
            _buildLanguageSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyRightSection() {
    return const Align(
      alignment: Alignment(0, 0.95),
      child: TranslationFadeIn(
        translateDirection: TranslateDirection.up,
        delay: Duration(milliseconds: 700),
        mChild: Text(
          'Copyright 2023, All Rights Reserved',
          style: TextStyle(
              color: Color(0xff014EA2),
              fontSize: 13,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildLoginSection() {
    return Align(
      alignment: const Alignment(0, 0.6),
      child: TranslationFadeIn(
        delay: const Duration(milliseconds: 500),
        translateDirection: TranslateDirection.up,
        mChild: Container(
          margin: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFbLogin(),
              SizedBox(
                width: 20.w,
              ),
              _buildGmailLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(right: 16.w, top: Platform.isAndroid ? 16.w : 40.w),
      alignment: Alignment.topRight,
      child: TranslationFadeIn(
        translateDirection: TranslateDirection.up,
        mChild: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            context.select((AppBloc bloc) => bloc.state.locale) == 'en'
                ? Row(
                    children: [
                      Assets.images.icEngland.image(scale: 17),
                      SizedBox(
                        width: 6.w,
                      ),
                      Text(
                        'English',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey800),
                      )
                    ],
                  )
                : Row(
                    children: [
                      Assets.images.icVietnamese.image(scale: 17),
                      Text(
                        'Tiếng Việt',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey800),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildGmailLogin() {
    return SizedBox(
      width: 120.w,
      child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.green200),
          onPressed: () {
            authCubit.signInWithGoogle();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.images.icGmail.path,
                width: 20.w,
                height: 20.w,
              ),
              SizedBox(
                width: 6.w,
              ),
              Text(
                S.current.sign_in_with_gmail,
                style: TextStyle(
                    fontSize: 13, color: Colors.white.withOpacity(0.8)),
              )
            ],
          )),
    );
  }

  Widget _buildFbLogin() {
    return SizedBox(
      width: 120.w,
      child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.images.icFacebook.path,
                width: 20.w,
                height: 20.w,
              ),
              SizedBox(
                width: 6.w,
              ),
              Text(
                S.current.sign_in_with_facebook,
                style: const TextStyle(fontSize: 13),
              )
            ],
          )),
    );
  }

  Widget _buildBgSection(BuildContext context) {
    return Positioned.fill(
      child:
          Assets.images.loginBackgroundImage.image(fit: BoxFit.cover, scale: 4),
    );
  }

  Widget _buildMainSection(BuildContext context) {
    return TranslationFadeIn(
      delay: const Duration(milliseconds: 300),
      translateDirection: TranslateDirection.up,
      mChild: Align(
        alignment: const Alignment(0, -0.3),
        child: Assets.images.character.image(scale: 4),
      ),
    );
  }
}
