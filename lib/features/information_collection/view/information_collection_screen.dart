import 'package:boilerplate/core/bloc_core/ui_status.dart';
import 'package:boilerplate/core/widget_core.dart';
import 'package:boilerplate/features/authentication/view/base_loading_dialog.dart';
import 'package:boilerplate/features/information_collection/cubit/information_collection_cubit.dart';
import 'package:boilerplate/firebase/firebase_utils.dart';
import 'package:boilerplate/generated/assets.gen.dart';
import 'package:boilerplate/generated/l10n.dart';
import 'package:boilerplate/injector/injector.dart';
import 'package:boilerplate/router/app_router.dart';
import 'package:boilerplate/services/app_service/app_service.dart';
import 'package:boilerplate/utils/utils.dart';
import 'package:boilerplate/widgets/base_outline_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class InformationCollectionScreen extends BaseStateFulWidget {
  const InformationCollectionScreen({super.key});

  @override
  State<InformationCollectionScreen> createState() =>
      _InformationCollectionScreenState();
}

class _InformationCollectionScreenState
    extends BaseStateFulWidgetState<InformationCollectionScreen> {
  late TextEditingController _nickNameController;
  late TextEditingController _phoneController;
  late FocusNode _nickNameFocusNode;
  late FocusNode _phoneFocusNode;
  late AppService _appService;
  late InformationCollectionCubit _cubit;
  late GlobalKey _nickNameKey;
  late GlobalKey _phoneKey;

  @override
  void initState() {
    super.initState();
    _nickNameKey = GlobalKey();
    _phoneKey = GlobalKey();
    _appService = Injector.instance();
    _cubit = Injector.instance();
    _nickNameController = TextEditingController();
    _phoneController = TextEditingController();
    _nickNameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();

    _phoneController.text = FirebaseUtils.me.phoneNumber ?? '';
    _nickNameController.text = FirebaseUtils.me.nickName ?? '';

    if (_nickNameController.text.isEmpty) {
      _nickNameFocusNode.requestFocus();
    } else {
      _phoneFocusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    _phoneController.dispose();
    _nickNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_appService.keyboardHeight < MediaQuery.of(context).viewInsets.bottom) {
      _appService.setAppProperty(
          property: AppProperty.keyboardHeight,
          value: MediaQuery.of(context).viewInsets.bottom);
    }
    return GestureDetector(
      onTap: Utils.hideKeyboard,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.w),
              child: BlocListener<InformationCollectionCubit,
                  InformationCollectionState>(
                listener: (context, state) {
                  switch (state.status) {
                    case UILoading():
                      showLoading(
                          context: context,
                          loadingWidget: const BaseLoadingDialog());
                    case UILoadSuccess():
                      hideLoading(context);
                      context.pushNamed(AppRouter.homeNamed);
                    case UILoadFailed():
                      showToast(
                          toastType: ToastType.error,
                          context: context,
                          title: S.current.has_some_error,
                          description: (state.status as UILoadFailed).message);
                  }
                },
                bloc: _cubit,
                child: Column(
                  children: [
                    _buildTopImage(),
                    SizedBox(
                      height: 20.w,
                    ),
                    _buildNickNameComponent(),
                    SizedBox(
                      height: 20.w,
                    ),
                    _buildPhoneComponent(),
                    SizedBox(
                      height: 50.w,
                    ),
                    _buildNextButton(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Image _buildTopImage() => Assets.images.groupPeople.image(scale: 5.5);

  SizedBox _buildNextButton(BuildContext context) {
    return SizedBox(
        width: 120.w,
        child: FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.6)),
            onPressed: onNextButtonClick,
            child: Text(
              S.current.next,
              style: Theme.of(context).textTheme.bodyMedium,
            )));
  }

  BaseTextField _buildNickNameComponent() {
    return BaseTextField(
        key: _nickNameKey,
        isRequired: true,
        label: S.current.nick_name,
        prefixIcon: Icon(
          CupertinoIcons.person_alt_circle,
          size: 20.w,
        ),
        suffixIcon: InkWell(
          splashColor: Colors.transparent,
          onTap: () => _nickNameController.text = '',
          child: Icon(
            Icons.clear,
            size: 20.w,
          ),
        ),
        controller: _nickNameController,
        focusNode: _nickNameFocusNode);
  }

  BaseTextField _buildPhoneComponent() {
    return BaseTextField(
        textInputType: TextInputType.number,
        key: _phoneKey,
        isRequired: true,
        label: S.current.phone_number,
        prefixIcon: Icon(
          CupertinoIcons.phone,
          size: 20.w,
        ),
        suffixIcon: InkWell(
          splashColor: Colors.transparent,
          onTap: () => _nickNameController.text = '',
          child: Icon(
            Icons.clear,
            size: 20.w,
          ),
        ),
        controller: _phoneController,
        focusNode: _phoneFocusNode);
  }

  void onNextButtonClick() {
    if (_nickNameController.text.isEmpty) {
      Scrollable.ensureVisible(_nickNameKey.currentContext!);
    } else if (_phoneController.text.isEmpty) {
      Scrollable.ensureVisible(_phoneKey.currentContext!);
    }

    if (_nickNameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty) {
      _cubit.addInformation(_nickNameController.text, _phoneController.text);
    }
  }
}
