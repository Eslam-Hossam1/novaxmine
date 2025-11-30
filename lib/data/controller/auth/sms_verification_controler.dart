import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/share_preference_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/repo/auth/sms_email_verification_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class SmsVerificationController extends GetxController {
  final SmsEmailVerificationRepo repo;
  SmsVerificationController({required this.repo});

  bool hasError = false;
  bool isLoading = true;
  String currentText = '';

  String userPhone = "";

  Future<void> intData() async {
    userPhone = repo.apiClient.sharedPreferences
            .getString(SharedPreferenceHelper.userPhoneNumberKey) ??
        "";

    isLoading = true;
    update();

    await repo.sendAuthorizationRequest();

    isLoading = false;
    update();
  }

  bool submitLoading = false;

  Future<void> verifyYourSms(String currentText) async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final otpEmptyMsg =
        l10n?.otpFieldEmptyMsg ?? 'Please enter the verification code';
    final smsLabel = l10n?.sms ?? 'SMS';
    final verificationSuccess =
        l10n?.verificationSuccess ?? 'verification successful';
    final verificationFailed =
        l10n?.verificationFailed ?? 'verification failed';
    final defaultErrorMsg = l10n?.somethingWentWrong ?? 'Something went wrong';

    if (currentText.isEmpty) {
      CustomSnackBar.error(errorList: <String>[otpEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    final ResponseModel responseModel =
        await repo.verify(currentText, isEmail: false);

    if (responseModel.statusCode == 200) {
      final AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      final bool is2FAEnable = model.data?.user?.tv == "0" ? true : false;

      if (model.status?.toLowerCase() == 'success') {
        CustomSnackBar.success(
          successList: model.message?.success ??
              <String>['$smsLabel $verificationSuccess'],
        );

        if (is2FAEnable) {
          Get.offAndToNamed(RouteHelper.twoFactorScreen);
        } else {
          Get.offAndToNamed(RouteHelper.bottomNav);
        }
      } else {
        CustomSnackBar.error(
          errorList:
              model.message?.error ?? <String>['$smsLabel $verificationFailed'],
        );
      }
    } else {
      CustomSnackBar.error(
        errorList: <String>[
          responseModel.message.isNotEmpty
              ? responseModel.message
              : defaultErrorMsg
        ],
      );
    }

    submitLoading = false;
    update();
  }

  bool resendLoading = false;

  Future<void> sendCodeAgain(BuildContext context) async {
    resendLoading = true;
    update();

    await repo.resendVerifyCode(context: context, isEmail: false);

    resendLoading = false;
    update();
  }
}

