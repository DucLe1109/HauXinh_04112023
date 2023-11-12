import 'dart:io';

import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/features/authentication/cubit/auth_cubit.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_cubit.freezed.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(const SettingState());

  Future<void> updateUserInfo(
      String fullName, String about, String birthday, File? file) async {
    emit(state.copyWith(status: const UILoading(), isLogout: false));
    try {
      await FirebaseUtils.updateUserInfo(fullName, about, birthday);
      if (file != null) {
        await FirebaseUtils.updateAvatar(file);
      }
      emit(state.copyWith(status: const UILoadSuccess(), isLogout: false));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          status:
              UILoadFailed(message: FirebaseUtils.handleException(e.code))));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: const UILoading(), isLogout: true));
    await FirebaseUtils.updateUserStatus(isOnline: false);
    await Injector.instance<AuthCubit>().logout();
    emit(state.copyWith(status: const UILoadSuccess(), isLogout: true));
  }
}
