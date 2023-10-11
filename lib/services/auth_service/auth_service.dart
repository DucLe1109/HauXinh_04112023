import 'package:boilerplate/core/keys/app_keys.dart';

enum AuthProperty {
  token,
  username,
  password,
  refreshToken,
  sysUsers,
  isRememberAccount,
  accessToken,
  appUserInfo,
  isSupportBiometry,
  isHasValidBiometry,
  loginStartTime,
  loginEndTime,
}

extension AuthPropertyExtension on AuthProperty {
  String get value {
    switch (this) {
      case AuthProperty.token:
        return AppKeys.token;
      case AuthProperty.username:
        return AppKeys.username;
      case AuthProperty.password:
        return AppKeys.password;
      case AuthProperty.refreshToken:
        return AppKeys.refreshToken;
      case AuthProperty.sysUsers:
        return AppKeys.sysUsers;
      case AuthProperty.isRememberAccount:
        return AppKeys.isRememberAccount;
      case AuthProperty.accessToken:
        return AppKeys.accessToken;
      case AuthProperty.appUserInfo:
        return AppKeys.appUserInfo;
      case AuthProperty.isSupportBiometry:
        return AppKeys.isSupportBiometry;
      case AuthProperty.isHasValidBiometry:
        return AppKeys.isHasValidBiometry;
      case AuthProperty.loginStartTime:
        return AppKeys.loginStartTime;
      case AuthProperty.loginEndTime:
        return AppKeys.loginEndTime;
    }
  }
}

abstract class AuthService {
  bool get isRememberAccount;

  String get username;

  String get password;

  bool get isSupportBiometry;

  bool get isHasValidBiometry;

  String get loginStartTime;

  String get loginEndTime;

  Future<void> setAuthProperty({
    required AuthProperty property,
    required dynamic value,
  });
}
