import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/share_preference_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/data/model/auth/error_model.dart';
import 'package:mine_lab/data/model/auth/registration_response_model.dart';
import 'package:mine_lab/data/model/auth/sign_up_model/sign_up_model.dart';
import 'package:mine_lab/data/model/general_setting/general_settings_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/repo/auth/general_setting_repo.dart';
import 'package:mine_lab/data/repo/auth/registration/registration_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class RegistrationController extends GetxController {
  final RegistrationRepo registrationRepo;
  final GeneralSettingRepo generalSettingRepo;

  RegistrationController({
    required this.registrationRepo,
    required this.generalSettingRepo,
  });

  // Focus nodes
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  // Text controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  bool isLoading = true;
  bool agreeTC = false;

  GeneralSettingResponseModel generalSettingsResponseModel =
      GeneralSettingResponseModel();

  // from general setting api
  bool checkPasswordStrength = false;
  bool needAgree = true;

  bool submitLoading = false;

  String? firstname;
  String? lastname;
  String? email;
  String? password;
  String? confirmPassword;

  // قائمة قواعد الباسورد (بتتضبط في onInit)
  List<ErrorModel> passwordValidationRules = [];

  @override
  void onInit() {
    super.onInit();
    _initPasswordRules();
  }

  void _initPasswordRules() {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    passwordValidationRules = [
      ErrorModel(
        text: l10n?.hasUpperLetter ??
            'Password must contain at least one uppercase letter',
        hasError: true,
      ),
      ErrorModel(
        text: l10n?.hasLowerLetter ??
            'Password must contain at least one lowercase letter',
        hasError: true,
      ),
      ErrorModel(
        text: l10n?.hasDigit ?? 'Password must contain at least one digit',
        hasError: true,
      ),
      ErrorModel(
        text: l10n?.hasSpecialChar ??
            'Password must contain at least one special character',
        hasError: true,
      ),
      ErrorModel(
        text: l10n?.minSixChar ?? 'Password must be at least 6 characters',
        hasError: true,
      ),
    ];
  }

  Future<void> registerUser() async {
    submitLoading = true;
    update();

    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;
    final defaultSuccessMsg =
        l10n?.requestSuccess ?? 'Request completed successfully';
    final defaultErrorMsg = l10n?.somethingWentWrong ?? 'Something went wrong';

    final SignUpModel signUpModel = getUserData();
    final ResponseModel response =
        await registrationRepo.registerUser(signUpModel);

    if (response.statusCode == 200) {
      final RegistrationResponseModel registrationModel =
          RegistrationResponseModel.fromJson(
        jsonDecode(response.responseJson),
      );

      if (registrationModel.status.toString().toLowerCase() == "success") {
        CustomSnackBar.success(
          successList:
              registrationModel.message?.success ?? [defaultSuccessMsg],
        );
        await checkAndGotoNextStep(registrationModel);
      } else {
        CustomSnackBar.error(
          errorList:
              registrationModel.message?.error ?? <String>[defaultErrorMsg],
        );
      }
    } else {
      CustomSnackBar.error(errorList: <String>[response.message]);
    }

    submitLoading = false;
    update();
  }

  void updateAgreeTC() {
    agreeTC = !agreeTC;
    update();
  }

  SignUpModel getUserData() {
    final String referenceValue =
        referralCodeController.text.toString().split('=').last;

    return SignUpModel(
      firstName: firstNameController.text.toString(),
      lastName: lastNameController.text.toString(),
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
      refference: referenceValue,
      agree: agreeTC,
    );
  }

  Future<void> checkAndGotoNextStep(
    RegistrationResponseModel responseModel, {
    bool isSocialLogin = false,
  }) async {
    final bool needEmailVerification =
        responseModel.data?.user?.ev == "1" ? false : true;
    final bool needSmsVerification =
        responseModel.data?.user?.sv == "1" ? false : true;
    final bool isTwoFactorEnable =
        responseModel.data?.user?.tv == '1' ? false : true;

    final SharedPreferences preferences =
        registrationRepo.apiClient.sharedPreferences;

    await preferences.setString(
      SharedPreferenceHelper.userIdKey,
      responseModel.data?.user?.id.toString() ?? '-1',
    );
    await preferences.setString(
      SharedPreferenceHelper.accessTokenKey,
      responseModel.data?.accessToken ?? '',
    );
    await preferences.setString(
      SharedPreferenceHelper.accessTokenType,
      responseModel.data?.tokenType ?? '',
    );
    await preferences.setString(
      SharedPreferenceHelper.userEmailKey,
      responseModel.data?.user?.email ?? '',
    );
    await preferences.setString(
      SharedPreferenceHelper.userNameKey,
      responseModel.data?.user?.username ?? '',
    );
    await preferences.setString(
      SharedPreferenceHelper.userPhoneNumberKey,
      responseModel.data?.user?.mobile ?? '',
    );

    await registrationRepo.sendUserToken();

    final bool isProfileCompleteEnable =
        responseModel.data?.user?.profileComplete == '0' ? true : false;

    if (isProfileCompleteEnable) {
      Get.offAndToNamed(RouteHelper.profileCompleteScreen);
    } else if (needEmailVerification) {
      Get.offAndToNamed(RouteHelper.emailVerifyScreen);
    } else if (needSmsVerification) {
      Get.offAndToNamed(RouteHelper.smsVerifyScreen);
    } else if (isTwoFactorEnable) {
      Get.offAndToNamed(RouteHelper.twoFactorScreen);
    } else {
      Get.offAndToNamed(RouteHelper.bottomNav);
    }
  }

  Future<void> initData() async {
    isLoading = true;
    update();

    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;
    final defaultErrorMsg = l10n?.somethingWentWrong ?? 'Something went wrong';
    final registrationDisabledMsg =
        l10n?.somethingWentWrong ?? 'Registration is currently disabled';

    final ResponseModel response = await generalSettingRepo.getGeneralSetting();

    if (response.statusCode == 200) {
      final GeneralSettingResponseModel model =
          GeneralSettingResponseModel.fromJson(
        jsonDecode(response.responseJson),
      );

      if (model.status?.toLowerCase() == 'success') {
        generalSettingsResponseModel = model;
        registrationRepo.apiClient.storeGeneralSetting(model);

        if (model.data?.generalSetting?.registration?.toLowerCase() == '0') {
          CustomSnackBar.error(errorList: <String>[registrationDisabledMsg]);
          Get.offAllNamed(RouteHelper.loginScreen);
          return;
        }
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? <String>[defaultErrorMsg],
        );
        return;
      }
    } else {
      if (response.statusCode == 503) {
        noInternet = true;
        update();
      }
      CustomSnackBar.error(errorList: <String>[response.message]);
      return;
    }

    needAgree =
        generalSettingsResponseModel.data?.generalSetting?.agree.toString() ==
                '0'
            ? false
            : true;

    checkPasswordStrength = generalSettingsResponseModel
                .data?.generalSetting?.securePassword
                .toString() ==
            '0'
        ? false
        : true;

    isLoading = false;
    update();
  }

  bool noInternet = false;

  void changeInternetStatus(bool hasInternet) {
    noInternet = false;
    initData();
    update();
  }

  RegExp regex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{6,}$',
  );

  String? validatePassword(String value) {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;
    final emptyMsg = l10n?.pleaseEnterPassword ?? 'Please enter your password';
    final invalidMsg =
        l10n?.invalidPassMsg ?? 'Password does not meet requirements';

    if (value.isEmpty) {
      return emptyMsg;
    } else {
      if (checkPasswordStrength) {
        if (!regex.hasMatch(value)) {
          return invalidMsg;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  bool hasPasswordFocus = false;
  void changePasswordFocus(bool hasFocus) {
    hasPasswordFocus = hasFocus;
    update();
  }

  void updateValidationList(String value) {
    passwordValidationRules[0].hasError =
        value.contains(RegExp(r'[A-Z]')) ? false : true;
    passwordValidationRules[1].hasError =
        value.contains(RegExp(r'[a-z]')) ? false : true;
    passwordValidationRules[2].hasError =
        value.contains(RegExp(r'[0-9]')) ? false : true;
    passwordValidationRules[3].hasError =
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ? false : true;
    passwordValidationRules[4].hasError = value.length >= 6 ? false : true;

    update();
  }
}

