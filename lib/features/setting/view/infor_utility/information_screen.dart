import 'dart:io';

import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/core/global_variable.dart';
import 'package:boilerplate/core/widget_core.dart';
import 'package:boilerplate/features/authentication/view/base_loading_dialog.dart';
import 'package:boilerplate/features/setting/cubit/setting_cubit.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:boilerplate/widgets/base_outline_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class InformationScreen extends BaseStateFulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState
    extends BaseStateFulWidgetState<InformationScreen> {
  late TextEditingController _fullNameEditingController;
  late TextEditingController _aboutEditingController;
  late TextEditingController _birthdayEditingController;
  late SettingCubit cubit;
  bool isUpdateSuccessfully = false;

  @override
  void initState() {
    super.initState();
    _aboutEditingController = TextEditingController();
    _fullNameEditingController = TextEditingController();
    _birthdayEditingController = TextEditingController();
    _aboutEditingController.text = FirebaseUtils.me.about;
    _fullNameEditingController.text = FirebaseUtils.me.fullName;
    _birthdayEditingController.text = FirebaseUtils.me.birthday;
    cubit = context.read<SettingCubit>();
  }

  @override
  void dispose() {
    _fullNameEditingController.dispose();
    _birthdayEditingController.dispose();
    _aboutEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.pop(isUpdateSuccessfully);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(S.current.user_info,
              style: Theme.of(context).textTheme.bodyLarge),
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
              )),
        ),
        body: BlocListener<SettingCubit, SettingState>(
          listener: (context, state) {
            switch (state.status) {
              case UILoading():
                {
                  showLoading(
                      context: context,
                      loadingWidget: const BaseLoadingDialog());
                  break;
                }
              case UILoadSuccess():
                {
                  context.pop();
                  showToast(
                      toastType: ToastType.success,
                      context: context,
                      title: S.current.successfully,
                      description: S.current.data_is_updated);
                  FirebaseUtils.getSelfInfo();
                  isUpdateSuccessfully = true;
                  break;
                }
              case UILoadFailed():
                {
                  context.pop();
                  showToast(
                      toastType: ToastType.error,
                      context: context,
                      title: S.current.update_fail,
                      description: (state.status as UILoadFailed).message);
                  isUpdateSuccessfully = false;
                }
            }
          },
          bloc: cubit,
          child: GestureDetector(
            onTap: Utils.hideKeyboard,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCircleAvatar(context),
                    const SizedBox(
                      height: 26,
                    ),
                    _buildEmailField(context),
                    const SizedBox(
                      height: 26,
                    ),
                    _buildFullNameField(context),
                    const SizedBox(
                      height: 26,
                    ),
                    _buildAboutField(context),
                    const SizedBox(
                      height: 26,
                    ),
                    _buildBirthdayField(context),
                    const SizedBox(
                      height: 26,
                    ),
                    _buildUpdateButton(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildUpdateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FilledButton(
        onPressed: () {
          Utils.hideKeyboard();
          cubit.updateUserInfo(_fullNameEditingController.text,
              _aboutEditingController.text, _birthdayEditingController.text);
        },
        style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius))),
        child: Text(S.current.update),
      ),
    );
  }

  Widget _buildBirthdayField(BuildContext context) {
    return BaseTextField(
      controller: _birthdayEditingController,
      focusNode: FocusNode(),
      prefixIcon: const Icon(
        Icons.date_range_outlined,
        size: 20,
      ),
      suffixIcon: InkWell(
        splashColor: Colors.transparent,
        onTap: () => _birthdayEditingController.text = '',
        child: const Icon(
          Icons.clear,
          size: 20,
        ),
      ),
      label: S.current.birthday,
    );
  }

  Widget _buildAboutField(BuildContext context) {
    return BaseTextField(
      controller: _aboutEditingController,
      focusNode: FocusNode(),
      prefixIcon: const Icon(
        CupertinoIcons.info,
        size: 20,
      ),
      suffixIcon: InkWell(
        splashColor: Colors.transparent,
        onTap: () => _aboutEditingController.text = '',
        child: const Icon(
          Icons.clear,
          size: 20,
        ),
      ),
      label: S.current.about,
    );
  }

  Widget _buildFullNameField(BuildContext context) {
    return BaseTextField(
      controller: _fullNameEditingController,
      focusNode: FocusNode(),
      prefixIcon: const Icon(
        CupertinoIcons.person,
        size: 20,
      ),
      suffixIcon: InkWell(
        splashColor: Colors.transparent,
        onTap: () => _fullNameEditingController.text = '',
        child: const Icon(
          Icons.clear,
          size: 20,
        ),
      ),
      label: S.current.full_name,
    );
  }

  Text _buildEmailField(BuildContext context) {
    return Text(
      FirebaseUtils.me.email,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w300),
    );
  }

  Stack _buildCircleAvatar(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: CachedNetworkImage(
            imageUrl: FirebaseUtils.me.avatar,
            fit: BoxFit.fill,
            width: 140,
            height: 140,
          ),
        ),
        Positioned(
            top: 100,
            left: 90,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                visualDensity: VisualDensity.compact,
                shape: const CircleBorder(),
              ),
              onPressed: () {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius))),
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      height: 200,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              S.current.pick_profile_picture,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(20),
                                      shape: const CircleBorder(),
                                      backgroundColor:
                                          Theme.of(context).primaryColor),
                                  child: Assets.images.camera.image(scale: 8),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(20),
                                      shape: const CircleBorder(),
                                      backgroundColor:
                                          Theme.of(context).primaryColor),
                                  child: Assets.images.addImage.image(scale: 8),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Icon(
                Icons.edit,
                size: 18,
              ),
            ))
      ],
    );
  }
}
