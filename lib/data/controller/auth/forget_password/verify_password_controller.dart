import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/data/model/auth/verification/email_verification_model.dart';
import 'package:mine_lab/data/repo/auth/login/login_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';

class VerifyPasswordController extends GetxController {
  final LoginRepo loginRepo;

  List<String> errors = [];
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;
  bool remember = false;
  bool hasError = false;
  String currentText = "";

  VerifyPasswordController({required this.loginRepo});

  bool isResendLoading = false;

  Future<void> resendForgetPassCode(BuildContext context) async {
    isResendLoading = true;
    update();

    final String value = email;
    const String type = 'email';

    await loginRepo.forgetPassword(context, type, value);

    isResendLoading = false;
    update();
  }

  bool verifyLoading = false;

  Future<void> verifyForgetPasswordCode(String value) async {
    if (value.isEmpty) return;

    verifyLoading = true;
    update();

    final EmailVerificationModel model =
        await loginRepo.verifyForgetPassCode(value);

    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;
    final String defaultErrorMsg =
        l10n?.verificationFailed ?? 'Verification failed';

    if (model.status == 'success') {
      verifyLoading = false;
      Get.offAndToNamed(
        RouteHelper.resetPasswordScreen,
        arguments: [email, value],
      );
    } else {
      verifyLoading = false;
      update();
      final List<String> errorList =
          model.message?.error ?? <String>[defaultErrorMsg];
      CustomSnackBar.error(errorList: errorList);
    }
  }

  void clearAllData() {
    isLoading = false;
    currentText = '';
  }
}
