import 'package:boilerplate/features/app/bloc/app_bloc.dart';
import 'package:boilerplate/features/authentication/login_screen.dart';
import 'package:boilerplate/features/intro/intro_page.dart';
import 'package:boilerplate/features/vacation/vacation.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:boilerplate/services/auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDirector extends StatelessWidget {
  const AppDirector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (prev, next) => prev.isFirstUse != next.isFirstUse,
      builder: (context, state) {
        final bool isFirstUse = state.isFirstUse;
        if (isFirstUse) {
          return const IntroPage();
        } else {
          return Injector.instance<AuthService>().isHasValidUser
              ? const Vacation()
              : const LoginScreen();
        }
      },
    );
  }
}
