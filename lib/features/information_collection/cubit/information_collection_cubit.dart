import 'dart:io';

import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'information_collection_cubit.freezed.dart';

part 'information_collection_state.dart';

class InformationCollectionCubit extends Cubit<InformationCollectionState> {
  InformationCollectionCubit() : super(const InformationCollectionState());

  Future<void> addInformation(String nickName, String phone) async {
    emit(state.copyWith(status: const UILoading()));
    try {
      await FirebaseUtils.addInformation(nickName, phone);
      await FirebaseUtils.getSelfInfo();
      emit(state.copyWith(status: const UILoadSuccess()));
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          status:
              UILoadFailed(message: FirebaseUtils.handleException(e.code))));
    }
  }
}
