import 'dart:io';

import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_cubit.freezed.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(const SettingState());

  Future<void> updateUserInfo(
      String fullName, String about, String birthday, File? file) async {
    emit(state.copyWith(status: const UILoading()));
    try {
      await FirebaseUtils.updateUserInfo(fullName, about, birthday);
      if (file != null) {
        await FirebaseUtils.updateAvatar(file);
      }
      emit(state.copyWith(status: const UILoadSuccess()));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          status:
              UILoadFailed(message: FirebaseUtils.handleException(e.code))));
    }
  }
}
