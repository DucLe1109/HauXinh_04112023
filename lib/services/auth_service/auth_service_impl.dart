// ignore_for_file: type_annotate_public_apis

import 'package:boilerplate/core/keys/app_keys.dart';
import 'package:boilerplate/services/auth_service/auth_service.dart';
import 'package:boilerplate/services/local_storage_service/local_storage_service.dart';

class AuthServiceImpl implements AuthService {
  AuthServiceImpl({
    required LocalStorageService localStorageService,
  }) : _localStorageService = localStorageService;
  late final LocalStorageService _localStorageService;

  @override
  bool get isRememberAccount =>
      _localStorageService.getBool(key: AppKeys.isRememberAccount) ?? false;

  @override
  String get password =>
      _localStorageService.getString(key: AppKeys.password) ?? '';

  @override
  String get username =>
      _localStorageService.getString(key: AppKeys.username) ?? '';

  @override
  bool get isSupportBiometry =>
      _localStorageService.getBool(key: AppKeys.isSupportBiometry) ?? false;

  @override
  bool get isHasValidBiometry =>
      _localStorageService.getBool(key: AppKeys.isHasValidBiometry) ?? false;

  @override
  Future<void> setAuthProperty({
    required AuthProperty property,
    required value,
  }) async =>
      _localStorageService.setValue(key: property.value, value: value);

  @override
  String get loginStartTime =>
      _localStorageService.getString(key: AppKeys.loginStartTime) ?? '';

  @override
  String get loginEndTime =>
      _localStorageService.getString(key: AppKeys.loginEndTime) ?? '';
}
