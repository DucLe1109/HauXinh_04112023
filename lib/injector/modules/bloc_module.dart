import 'package:boilerplate/features/app/bloc/app_bloc.dart';
import 'package:boilerplate/features/authentication/cubit/auth_cubit.dart';
import 'package:boilerplate/features/demo/bloc/demo_bloc.dart';
import 'package:boilerplate/features/dog_image_random/bloc/dog_image_random_bloc.dart';
import 'package:boilerplate/features/home/cubit/home_cubit.dart';
import 'package:boilerplate/features/list_chat/cubit/list_chat_cubit.dart';
import 'package:boilerplate/features/personal_chat/cubit/chat_cubit.dart';
import 'package:boilerplate/features/setting/cubit/setting_cubit.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:flutter/foundation.dart';

class BlocModule {
  BlocModule._();

  static void init() {
    final injector = Injector.instance;

    injector
      ..registerLazySingleton<AppBloc>(
        () => AppBloc(
          appService: injector(),
          logService: injector(),
        ),
      )
      ..registerFactory<DogImageRandomBloc>(
        () => DogImageRandomBloc(
          dogImageRandomRepository: injector(),
          dogImageLocalRepository: kIsWeb ? null : injector(),
          logService: injector(),
        ),
      )
      ..registerFactory<HomeCubit>(
        HomeCubit.new,
      )
      ..registerFactory<ListChatCubit>(
        ListChatCubit.new,
      )
      ..registerFactory<ChatCubit>(
        ChatCubit.new,
      )
      ..registerFactory<SettingCubit>(
        SettingCubit.new,
      )
      ..registerLazySingleton(() => AuthCubit(authService: injector()))
      ..registerFactory<DemoBloc>(
        () => DemoBloc(
          dogImageRandomRepository: injector(),
          logService: injector(),
        ),
      );
  }
}
