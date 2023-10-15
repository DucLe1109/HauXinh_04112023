import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:boilerplate/services/auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'home_cubit.freezed.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState()) {
    _authService = Injector.instance<AuthService>();
    loginEndTime = DateFormat('dd/MM/yyyy HH:mm:ss').parse(_authService.loginEndTime);
    final DateTime now = DateTime.now();
    isExpiredSession = now.isAfter(loginEndTime);
  }

  void checkAuthentication() {
    if (isExpiredSession) {
      FirebaseAuth.instance.signOut();
      emit(
        state.copyWith(
          status: const UILoadFailed(message: ''),
        ),
      );
    }
  }

  late DateTime loginEndTime;
  late AuthService _authService;
  late bool isExpiredSession;
}
