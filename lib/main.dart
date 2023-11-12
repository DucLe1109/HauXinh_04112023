import 'package:boilerplate/bootstrap.dart';
import 'package:boilerplate/configs/app_config.dart';
import 'package:boilerplate/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await bootstrap(
    firebaseInitialization: () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
    },
    flavorConfiguration: () async {
      AppConfig.configDev();
    },
  );
}
