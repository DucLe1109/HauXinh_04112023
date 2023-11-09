import 'package:boilerplate/bootstrap.dart';
import 'package:boilerplate/configs/app_config.dart';
import 'package:boilerplate/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  await bootstrap(
    firebaseInitialization: () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    },
    flavorConfiguration: () async {
      AppConfig.configDev();
    },
  );
}
