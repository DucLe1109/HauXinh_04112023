import 'package:boilerplate/services/crashlytics_service/crashlytics_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseCrashlyticsService implements CrashlyticsService {
  @override
  Future<void> init() {
    // TODO(boilerplate): implement init
    throw UnimplementedError();
  }

  @override
  Future<void> recordException(dynamic exception, StackTrace? stack) async {
    await FirebaseCrashlytics.instance
        .recordError(exception, stack, fatal: true);
  }
}
