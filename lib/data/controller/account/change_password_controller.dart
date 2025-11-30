import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mine_lab/data/repo/account/change_password_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordRepo changePasswordRepo;

  ChangePasswordController({required this.changePasswordRepo});

  String? currentPass, password, confirmPass;

  bool submitLoading = false;

  TextEditingController currentPassController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  FocusNode currentPassFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPassFocusNode = FocusNode();

  Future<void> changePassword(BuildContext context) async {
    String currentPass = currentPassController.text.toString();
    String password = passController.text.toString();

    bool error = hasError(
        context: context, currentPass: currentPass, password: password);

    if (error) return;

    submitLoading = true;
    update();

    bool b =
        await changePasswordRepo.changePassword(context, currentPass, password);

    if (b) {
      currentPassController.clear();
      passController.clear();
      confirmPassController.clear();
    }

    submitLoading = false;
    update();
  }

  bool hasError({
    required BuildContext context,
    required String currentPass,
    required String password,
  }) {
    final l10n = AppLocalizations.of(context)!;

    List<String> error = [];

    if (currentPass.isEmpty) {
      error.add(l10n.currentPassEmptyMsg);
    }
    if (password.isEmpty) {
      error.add(l10n.newPassEmptyMsg);
    }
    if (confirmPassController.text != passController.text) {
      error.add(l10n.passNoMatchMsg);
    }

    if (error.isNotEmpty) {
      CustomSnackBar.showCustomSnackBar(
          errorList: error, msg: [], isError: true);
      return true;
    }

    return false;
  }

  void clearData() {
    submitLoading = false;
    currentPassController.text = '';
    passController.text = '';
    confirmPassController.text = '';
  }
}

