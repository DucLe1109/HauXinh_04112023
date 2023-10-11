import 'dart:math';

import 'package:boilerplate/animation/translation_fade_in.dart';
import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/core/widget_core.dart';
import 'package:boilerplate/features/authentication/cubit/auth_cubit.dart';
import 'package:boilerplate/features/authentication/view/base_loading_dialog.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:boilerplate/router/app_router.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends BaseStateFulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseStateFulWidgetState<LoginScreen> {
  bool shouldUseFirebaseEmulator = false;

  late ValueNotifier<bool> isRememberAccount;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late AuthCubit authCubit;
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  @override
  void initState() {
    super.initState();

    authCubit = Injector.instance();
    isRememberAccount = ValueNotifier(authCubit.isRememberAccount);

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController.text = authCubit.username;
    _passwordController.text = authCubit.password;
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case UILoadSuccess():
            {
              hideLoading(context);
              context.pushReplacement(AppRouter.vacationPath);
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
      child: GestureDetector(
        onTap: Utils.hideKeyboard,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildBgSection(context),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: Column(
                    children: <Widget>[
                      _buildTextFieldSection(context),
                      const SizedBox(
                        height: 16,
                      ),
                      _buildRememberAccount(context),
                      const SizedBox(
                        height: 50,
                      ),
                      _buildLoginButton(),
                      // const SizedBox(
                      //   height: 70,
                      // ),
                      // _buildForgotPasswordSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberAccount(BuildContext context) {
    return TranslationFadeIn(
      delay: const Duration(milliseconds: 900),
      translateDirection: TranslateDirection.up,
      mChild: Row(
        children: [
          const SizedBox(
            width: 3,
          ),
          SizedBox(
            width: 20,
            height: 20,
            child: ValueListenableBuilder(
              builder: (context, value, child) => Checkbox(
                activeColor: const Color.fromRGBO(143, 148, 251, 1),
                value: value,
                onChanged: (bool? value) {
                  onChangeRememberAccount();
                },
              ),
              valueListenable: isRememberAccount,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: onChangeRememberAccount,
            child: Text(
              S.current.remember_account,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordSection() {
    return TranslationFadeIn(
      delay: const Duration(milliseconds: 1100),
      translateDirection: TranslateDirection.up,
      mChild: Text(
        S.current.forget_password,
        style: const TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
      ),
    );
  }

  Widget _buildBgSection(BuildContext context) {
    return Stack(
      children: [
        Assets.images.bgLogin.image(),
        Positioned(
          top: 200,
          child: TranslationFadeIn(
            translateDirection: TranslateDirection.up,
            mChild: Transform.rotate(
                angle: 3 * pi / 2,
                child: Assets.images.hangLamp.image(
                  scale: 6,
                  color: Colors.white,
                )),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 100),
          alignment: Alignment.topCenter,
          child: const TranslationFadeIn(
            translateDirection: TranslateDirection.up,
            mChild: Icon(
              Icons.ac_unit_rounded,
              size: 70,
              color: Colors.white,
            ),
            delay: Duration(milliseconds: 300),
          ),
        ),
        const Positioned(
          right: 20,
          top: 80,
          child: TranslationFadeIn(
            mChild: Icon(
              Icons.watch_later,
              size: 60,
              color: Colors.white,
            ),
            translateDirection: TranslateDirection.up,
            delay: Duration(milliseconds: 500),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          alignment: Alignment.topCenter,
          child: TranslationFadeIn(
            delay: const Duration(milliseconds: 300),
            translateDirection: TranslateDirection.up,
            mChild: Container(
              width: 2,
              height: 100,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return TranslationFadeIn(
      delay: const Duration(milliseconds: 1000),
      translateDirection: TranslateDirection.up,
      mChild: Material(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onLoginButtonPress,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(143, 148, 251, 1),
                  Color.fromRGBO(143, 148, 251, .6),
                ],
              ),
            ),
            child: Center(
              child: Text(
                S.current.login,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldSection(BuildContext context) {
    return TranslationFadeIn(
      delay: const Duration(milliseconds: 800),
      translateDirection: TranslateDirection.up,
      mChild: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(143, 148, 251, .2),
              blurRadius: 30,
              offset: Offset(0, 12),
            ),
            BoxShadow(
              color: Color.fromRGBO(143, 148, 251, .2),
              blurRadius: 30,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            _buildEmail(context),
            _buildPassword(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPassword(BuildContext context) {
    bool isPassword = true;
    return StatefulBuilder(
      builder: (context, setState) => Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        child: TextField(
          onChanged: (value) => setState(() {}),
          obscureText: isPassword,
          enableSuggestions: !isPassword,
          autocorrect: !isPassword,
          focusNode: passwordFocusNode,
          controller: _passwordController,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() {
                      isPassword = !isPassword;
                    });
                  },
                  icon: _passwordController.text.isNotEmpty
                      ? (isPassword
                          ? const Icon(
                              Icons.remove_red_eye_outlined,
                              size: 20,
                            )
                          : const Icon(
                              Icons.remove_red_eye,
                              size: 20,
                            ))
                      : Container(),
                ),
              ],
            ),
            border: InputBorder.none,
            hintText: S.current.password,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 0.3),
          ),
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {});
          },
          onSubmitted: (value) => passwordFocusNode.requestFocus(),
          focusNode: emailFocusNode,
          textAlignVertical: TextAlignVertical.center,
          controller: _emailController,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                _emailController.text = '';
                setState(() {});
              },
              icon: _emailController.text.isNotEmpty
                  ? const Icon(
                      Icons.clear,
                      size: 20,
                    )
                  : Container(),
            ),
            hintText: S.current.email,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
        ),
      ),
    );
  }

  bool validateLoginInfo() {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  bool validateEmailFormat() {
    return _emailController.text.contains('@gmail.com');
  }

  void onLoginButtonPress() {
    Utils.hideKeyboard();
    if (validateLoginInfo()) {
      if (validateEmailFormat()) {
        authCubit.login(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        showToast(
          toastType: ToastType.error,
          context: context,
          title: S.current.login_fail,
          description: S.current.email_format_is_not_correct,
        );
      }
    } else {
      showToast(
        toastType: ToastType.error,
        context: context,
        title: S.current.login_fail,
        description: '${S.current.please_enter} ${getUsernamePasswordEmpty()}',
      );
    }
  }

  String getUsernamePasswordEmpty() {
    if (_emailController.text.isEmpty && _passwordController.text.isEmpty) {
      return S.current.email_and_password;
    }
    if (_passwordController.text.isEmpty) {
      return S.current.password;
    }
    if (_emailController.text.isEmpty) {
      return S.current.email;
    } else {
      return '';
    }
  }

  void onChangeRememberAccount() {
    isRememberAccount.value = !isRememberAccount.value;
    authCubit.isRememberAccount = isRememberAccount.value;
  }
}
