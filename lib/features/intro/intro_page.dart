import 'package:boilerplate/animation/translation_fade_in.dart';
import 'package:boilerplate/features/app/bloc/app_bloc.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              TranslationFadeIn(
                translateDirection: TranslateDirection.up,
                mChild: SvgPicture.asset(
                  isDarkMode
                      ? Assets.images.introImageDark.path
                      : Assets.images.introImage.path,
                  width: 260,
                  height: 260,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TranslationFadeIn(
                translateDirection: TranslateDirection.up,
                delay: const Duration(milliseconds: 200),
                mChild: Text(
                  S.current.intro_title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 200,
              ),
              TranslationFadeIn(
                delay: const Duration(milliseconds: 400),
                translateDirection: TranslateDirection.up,
                mChild: Text(
                  S.current.terms,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: TranslationFadeIn(
                      translateDirection: TranslateDirection.up,
                      delay: const Duration(milliseconds: 600),
                      mChild: FilledButton(
                        onPressed: () {
                          context
                              .read<AppBloc>()
                              .add(const AppEvent.disableFirstUse());
                        },
                        style: FilledButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                        child: Text(S.current.start_messaging),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
