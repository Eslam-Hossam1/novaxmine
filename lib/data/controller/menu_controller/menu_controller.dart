import 'dart:convert';

import 'package:get/get.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/repo/menu_repo/menu_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class MyMenuController extends GetxController {
  MenuRepo menuRepo;
  MyMenuController({required this.menuRepo});

  bool logoutLoading = false;

  Future<void> logout() async {
    final context = Get.context;
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    logoutLoading = true;
    update();

    await menuRepo.logout();
    CustomSnackBar.showCustomSnackBar(
        errorList: [], msg: [MyStrings!.logoutSuccessMsg], isError: false);

    logoutLoading = false;
    update();
    Get.offAllNamed(RouteHelper.loginScreen);
  }

  bool removeLoading = false;
  Future<void> removeAccount() async {
    final context = Get.context;
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    removeLoading = true;
    update();

    final responseModal = await menuRepo.removeAccount();
    if (responseModal.statusCode == 200) {
      AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
          jsonDecode(responseModal.responseJson));
      if (model.status?.toLowerCase() == MyStrings!.success) {
        await menuRepo.clearSharedPrefData();
        Get.offAllNamed(RouteHelper.loginScreen);
        CustomSnackBar.success(
            successList: model.message?.success ??
                [MyStrings.accountDeletedSuccessfully]);
      } else {
        CustomSnackBar.error(
            errorList: model.message?.error ?? [MyStrings.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModal.message]);
    }

    removeLoading = false;
    update();
  }
}

