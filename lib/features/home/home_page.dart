import 'package:boilerplate/core/keys/app_keys.dart';
import 'package:boilerplate/core/spacings/app_spacing.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> isHover = ValueNotifier(false);
    return Scaffold(
      key: const Key(WidgetKeys.homeScaffoldKey),
      appBar: AppBar(
        title: Text(S.of(context).home),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MouseRegion(
                      onEnter: (event) => isHover.value = true,
                      onExit: (event) => isHover.value = false,
                      child: ValueListenableBuilder(
                        builder: (context, value, child) => Text(
                          'Title 1',
                          style: TextStyle(
                              color: value ? Colors.amber : Colors.blue,),
                        ),
                        valueListenable: isHover,
                      ),),
                  const Text('Title 1'),
                  const Text('Title 1'),
                  const Text('Title 1'),
                ],
              ),
            ),

            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              child: Text(S.of(context).dog_image_random),
              onPressed: () {
                context.push(AppRouter.dogImageRandomPath);
              },
            ),
            AppSpacing.verticalSpacing32,
            ElevatedButton(
              child: Text(S.of(context).setting),
              onPressed: () {
                context.push(AppRouter.settingPath);
              },
            ),
            AppSpacing.verticalSpacing32,
            ElevatedButton(
              child: Text(S.of(context).assets),
              onPressed: () {
                context.push(AppRouter.assetsPath);
              },
            ),
            AppSpacing.verticalSpacing32,
            ElevatedButton(
              child: Text(S.of(context).image_from_db),
              onPressed: () {
                context.push(AppRouter.imagesFromDbPath);
              },
            ),
          ],
        ),
      ),
    );
  }
}
