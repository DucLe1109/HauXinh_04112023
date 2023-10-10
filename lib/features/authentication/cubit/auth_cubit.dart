// ignore_for_file: avoid_positional_boolean_parameters, depend_on_referenced_packages, lines_longer_than_80_chars

import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/services/auth_service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
    _app = Firebase.app();
    _auth = FirebaseAuth.instanceFor(app: _app);
  }

  late final AuthService _authService;

  late bool isRememberAccount;
  late String username;
  late String password;
  late final FirebaseApp _app;
  late final FirebaseAuth _auth;

// late AuthRepository authRepository;

  Future<void> login(String username, String password) async {
    emit(
      state.copyWith(
        status: const UIStatus.loading(),
        isHasValidUser: false,
      ),
    );
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      if (userCredential.user != null) {
        setRememberAccount(isRememberAccount);
        isRememberAccount
            ? rememberUser(username, password)
            : rememberUser('', '');
        setIsHasValidUser(true);

        emit(
          state.copyWith(
            status: const UIStatus.loadSuccess(message: ''),
            isHasValidUser: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: UIStatus.loadFailed(message: S.current.has_some_error),
            isHasValidUser: false,
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
          isHasValidUser: false,
        ),
      );
    }
  }

// void saveUserData(LoginResponse loginResponse) {
//   _authService
//     ..setAuthProperty(
//       property: AuthProperty.token,
//       value: loginResponse.token,
//     )
//     ..setAuthProperty(
//       property: AuthProperty.accessToken,
//       value: loginResponse.jwtToken?.accessToken,
//     )
//     ..setAuthProperty(
//       property: AuthProperty.refreshToken,
//       value: loginResponse.jwtToken?.refreshToken,
//     )
//     ..setSysUsers(loginResponse.sysUsers)
//     ..setJwtToken(loginResponse.jwtToken);
// }
//
  void setRememberAccount(bool value) {
    _authService.setAuthProperty(
      property: AuthProperty.isRememberAccount,
      value: value,
    );
  }

  void rememberUser(String username, String password) {
    _authService
      ..setAuthProperty(property: AuthProperty.username, value: username)
      ..setAuthProperty(property: AuthProperty.password, value: password);
  }

//
  void setIsHasValidUser(bool isHasValidUser) {
    _authService.setAuthProperty(
      property: AuthProperty.isHasValidUser,
      value: isHasValidUser,
    );
  }

//
// Future<void> onChangeRememberPassword({
//   required bool isRememberAccount,
//   required String username,
//   required String password,
// }) async {
//   await _authService.setAuthProperty(
//     property: AuthProperty.isRememberPassword,
//     value: isRememberPassword,
//   );
//   if (isRememberPassword) {
//     rememberUser(username, password);
//   } else {
//     rememberUser('', '');
//   }
// }
//
  void logout() {
    FirebaseAuth.instance.signOut();
    _authService.setAuthProperty(
      property: AuthProperty.isHasValidUser,
      value: false,
    );
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
//
// Future<bool> authenticateWithBiometrics() async {
//   final LocalAuthentication auth = LocalAuthentication();
//   try {
//     return await auth.authenticate(
//       localizedReason: S.current.use_biometry_to_authentication,
//       options: const AuthenticationOptions(
//         stickyAuth: true,
//       ),
//       authMessages: <AuthMessages>[
//         AndroidAuthMessages(
//           signInTitle: S.current.authentication_required,
//           biometricHint: '',
//           cancelButton: S.current.cancel,
//           goToSettingsButton: S.current.setting,
//         ),
//         IOSAuthMessages(cancelButton: S.current.cancel),
//       ],
//     );
//   } on PlatformException catch (e) {
//     debugPrint('Error - ${e.message}');
//     return false;
//   }
// }
}
