// ignore_for_file: avoid_positional_boolean_parameters, depend_on_referenced_packages, lines_longer_than_80_chars

import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/services/auth_service/auth_service.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthService authService,
  }) : super(const AuthState()) {
    _authService = authService;
    isRememberAccount = _authService.isRememberAccount;
    username = _authService.username;
    password = _authService.password;
    _auth = FirebaseAuth.instance;
  }

  late final AuthService _authService;

  late bool isRememberAccount;
  late String username;
  late String password;
  late final FirebaseAuth _auth;

  Future<void> login(String username, String password) async {
    emit(
      state.copyWith(
        status: const UIStatus.loading(),
      ),
    );
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      if (userCredential.user != null) {
        setLoginSessionDuration();
        setRememberAccount(isRememberAccount);
        isRememberAccount
            ? rememberUser(username, password)
            : rememberUser('', '');

        emit(
          state.copyWith(
            status: const UIStatus.loadSuccess(message: ''),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: UIStatus.loadFailed(message: S.current.has_some_error),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      emit(
        state.copyWith(
          status: UIStatus.loadFailed(
            message: S.current.email_or_password_is_not_correct,
          ),
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    try {
      emit(
        state.copyWith(
          status: const UIStatus.loading(),
        ),
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        setLoginSessionDuration();
        setRememberAccount(isRememberAccount);
        isRememberAccount
            ? rememberUser(username, password)
            : rememberUser('', '');

        if (await FirebaseUtils.isExistUser() == false) {
          await FirebaseUtils.createUser();
        }
        emit(
          state.copyWith(
            status: const UIStatus.loadSuccess(message: ''),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: UIStatus.loadFailed(message: S.current.has_some_error),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed with error code: ${e.code}');
      emit(
        state.copyWith(
          status: UIStatus.loadFailed(
            message: S.current.email_or_password_is_not_correct,
          ),
        ),
      );
    }
  }

  void setRememberAccount(bool value) {
    _authService.setAuthProperty(
      property: AuthProperty.isRememberAccount,
      value: value,
    );
  }

  void setLoginSessionDuration() {
    final String nowString = Utils.getDateTimeNow();
    _authService.setAuthProperty(
      property: AuthProperty.loginStartTime,
      value: nowString,
    );

    final DateTime nowDatetime = DateTime.now();
    final DateTime loginEndTime = nowDatetime.add(const Duration(days: 5));
    final String loginEndTimeFormat =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(loginEndTime);
    _authService.setAuthProperty(
      property: AuthProperty.loginEndTime,
      value: loginEndTimeFormat,
    );
  }

  void rememberUser(String username, String password) {
    _authService
      ..setAuthProperty(property: AuthProperty.username, value: username)
      ..setAuthProperty(property: AuthProperty.password, value: password);
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    isRememberAccount = _authService.isRememberAccount;
    username = _authService.username;
    password = _authService.password;
  }

//
  String getUserNameForBiometric() {
    return _authService.username;
  }

  String getPasswordForBiometric() {
    return _authService.password;
  }
}
