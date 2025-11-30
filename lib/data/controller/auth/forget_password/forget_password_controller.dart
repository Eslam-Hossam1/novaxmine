import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/data/repo/auth/login/login_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class ForgetPasswordController extends GetxController {
  final LoginRepo loginRepo;

  ForgetPasswordController({required this.loginRepo});

  bool submitLoading = false;
  bool isLoading = false;
  TextEditingController emailOrUsernameController = TextEditingController();

  Future<void> submitForgetPassCode(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final String input = emailOrUsernameController.text.trim();

    if (input.isEmpty) {
      CustomSnackBar.error(errorList: [l10n.enterYourEmail]);
      return;
    }

    submitLoading = true;
    update();

    try {
      final String type = input.contains('@') ? 'email' : 'username';
      final String responseEmail =
          await loginRepo.forgetPassword(context, type, input);

      if (responseEmail.isNotEmpty) {
        emailOrUsernameController.clear();
        Get.toNamed(
          RouteHelper.passVerifyScreen,
          arguments: responseEmail,
        );
      } else {
        // لو حابب تضيف رسالة فشل عامة من اللوجاليزيشن:
        // CustomSnackBar.error(errorList: [l10n.somethingWentWrong]);
      }
    } finally {
      submitLoading = false;
      update();
    }
  }
}

