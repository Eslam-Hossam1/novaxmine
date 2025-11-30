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

class EmailVerificationController extends GetxController {
  final SmsEmailVerificationRepo repo;

  EmailVerificationController({required this.repo});

  String currentText = "";
  bool needSmsVerification = false;
  bool isProfileCompleteEnable = false;

  bool needTwoFactor = false;
  bool submitLoading = false;
  bool isLoading = false;
  bool resendLoading = false;
  String userEmail = "";

  Future<void> loadData() async {
    userEmail = repo.apiClient.sharedPreferences
            .getString(SharedPreferenceHelper.userEmailKey) ??
        "";

    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;
    final defaultErrorMsg = l10n?.somethingWentWrong ?? 'Something went wrong';

    isLoading = true;
    update();

    final ResponseModel responseModel = await repo.sendAuthorizationRequest();

    if (responseModel.statusCode == 200) {
      final AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      if (model.status == 'error') {
        CustomSnackBar.error(
          errorList: model.message?.error ?? <String>[defaultErrorMsg],
        );
      }
    } else {
      CustomSnackBar.error(errorList: <String>[responseModel.message]);
    }

    isLoading = false;
    update();
  }

  Future<void> verifyEmail(String text) async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final otpEmptyMsg =
        l10n?.otpFieldEmptyMsg ?? 'Please enter the verification code';
    final verifySuccessMsg =
        l10n?.emailVerificationSuccess ?? 'Email verified successfully';
    final verifyFailedMsg =
        l10n?.emailVerificationFailed ?? 'Email verification failed';
    final defaultErrorMsg = l10n?.somethingWentWrong ?? 'Something went wrong';

    if (text.isEmpty) {
      CustomSnackBar.error(errorList: <String>[otpEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    final ResponseModel responseModel = await repo.verify(text);

    if (responseModel.statusCode == 200) {
      final AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      final bool isSMSVerificationEnable =
          model.data?.user?.sv == "0" ? true : false;
      final bool is2FAEnable = model.data?.user?.tv == "0" ? true : false;

      if (model.status?.toLowerCase() == 'success') {
        CustomSnackBar.success(
          successList: model.message?.success ?? <String>[verifySuccessMsg],
        );

        if (isSMSVerificationEnable) {
          Get.offAndToNamed(RouteHelper.smsVerifyScreen);
        } else if (is2FAEnable) {
          Get.offAndToNamed(RouteHelper.twoFactorScreen);
        } else {
          Get.offAndToNamed(RouteHelper.bottomNav);
        }
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? <String>[verifyFailedMsg],
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

  Future<void> sendCodeAgain(BuildContext context) async {
    resendLoading = true;
    update();

    await repo.resendVerifyCode(context: context, isEmail: true);

    resendLoading = false;
    update();
  }
}

