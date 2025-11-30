import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/share_preference_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/data/model/auth/error_model.dart';
import 'package:mine_lab/data/model/auth/verification/email_verification_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/repo/auth/login/login_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class ResetPasswordController extends GetxController {
  final LoginRepo loginRepo;

  String email = '';
  String token = '';
  bool submitLoading = false;
  bool checkPasswordStrength = false;

  ResetPasswordController({required this.loginRepo}) {
    checkPasswordStrength = loginRepo.apiClient.getPasswordStrengthStatus();
    _initValidationMessages();
  }

  // FocusNodes
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  // Controllers
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  // قائمة قواعد الباسورد (النصوص متولدة من AppLocalizations)
  List<ErrorModel> passwordValidationRules = [];

  void _initValidationMessages() {
    final context = Get.context;
    if (context != null) {
      final l10n = AppLocalizations.of(context)!;
      passwordValidationRules = [
        ErrorModel(text: l10n.hasUpperLetter, hasError: true),
        ErrorModel(text: l10n.hasLowerLetter, hasError: true),
        ErrorModel(text: l10n.hasDigit, hasError: true),
        ErrorModel(text: l10n.hasSpecialChar, hasError: true),
        ErrorModel(text: l10n.minSixChar, hasError: true),
      ];
    } else {
      // فالات باك إن مفيش context (نصوص إنجليزي بسيطة)
      passwordValidationRules = [
        ErrorModel(text: 'At least one uppercase letter', hasError: true),
        ErrorModel(text: 'At least one lowercase letter', hasError: true),
        ErrorModel(text: 'At least one digit', hasError: true),
        ErrorModel(text: 'At least one special character', hasError: true),
        ErrorModel(text: 'Minimum 6 characters', hasError: true),
      ];
    }
  }

  Future<void> resetPassword() async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final String password = passController.text.trim();

    submitLoading = true;
    update();

    final ResponseModel responseModel =
        await loginRepo.resetPassword(email, password, token);

    if (responseModel.statusCode == 200) {
      final EmailVerificationModel model = EmailVerificationModel.fromJson(
          jsonDecode(responseModel.responseJson));

      if (model.status == 'success') {
        CustomSnackBar.success(
          successList: model.message?.success ??
              [l10n?.requestSuccess ?? 'Request completed successfully'],
        );
        loginRepo.apiClient.sharedPreferences
            .remove(SharedPreferenceHelper.resetPassTokenKey);
        Get.offAndToNamed(RouteHelper.loginScreen);
      } else {
        CustomSnackBar.error(
          errorList:
              model.message?.error ?? [l10n?.requestFail ?? 'Request failed'],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    submitLoading = false;
    update();
  }

  // Regex لقوة الباسورد
  RegExp regex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{6,}$',
  );

  String? validPassword(String value) {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    if (value.isEmpty) {
      return l10n?.enterYourPassword_ ?? 'Please enter your password';
    }

    if (checkPasswordStrength && !regex.hasMatch(value)) {
      return l10n?.invalidPassMsg ?? 'Password does not meet requirements';
    }

    return null;
  }

  void updateValidationList(String value) {
    if (passwordValidationRules.isEmpty) {
      _initValidationMessages();
    }

    passwordValidationRules[0].hasError =
        !value.contains(RegExp(r'[A-Z]')); // Uppercase
    passwordValidationRules[1].hasError =
        !value.contains(RegExp(r'[a-z]')); // Lowercase
    passwordValidationRules[2].hasError =
        !value.contains(RegExp(r'[0-9]')); // Digit
    passwordValidationRules[3].hasError =
        !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')); // Special char
    passwordValidationRules[4].hasError = value.length < 6; // Length

    update();
  }

  bool hasPasswordFocus = false;

  void changePasswordFocus(bool hasFocus) {
    hasPasswordFocus = hasFocus;
    update();
  }
}

