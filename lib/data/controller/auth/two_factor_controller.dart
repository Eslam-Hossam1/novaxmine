import 'dart:convert';
import 'package:get/get.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/two_factor/two_factor_data_model.dart';
import 'package:mine_lab/data/repo/auth/two_factor_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';

class TwoFactorController extends GetxController {
  final TwoFactorRepo repo;
  TwoFactorController({required this.repo});

  bool submitLoading = false;
  String currentText = '';

  void verify2FACode(String currentText) async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final otpEmptyMsg = l10n?.otpFieldEmptyMsg ?? 'OTP field cannot be empty';
    final requestSuccess =
        l10n?.requestSuccess ?? 'Request completed successfully';
    final requestFail = l10n?.requestFail ?? 'Request failed';
    final somethingWrong = l10n?.somethingWentWrong ?? 'Something went wrong';

    if (currentText.isEmpty) {
      CustomSnackBar.error(errorList: [otpEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    final ResponseModel responseModel = await repo.verify(currentText);

    if (responseModel.statusCode == 200) {
      final AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      if (model.status?.toLowerCase() == 'success') {
        Get.offAndToNamed(RouteHelper.bottomNav);
        CustomSnackBar.success(
          successList: model.message?.success ?? [requestSuccess],
        );
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? [requestFail],
        );
      }
    } else {
      CustomSnackBar.error(
        errorList: [
          responseModel.message.isNotEmpty
              ? responseModel.message
              : somethingWrong
        ],
      );
    }

    submitLoading = false;
    update();
  }

  void enable2fa(String key, String code) async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final otpEmptyMsg = l10n?.otpFieldEmptyMsg ?? 'OTP field cannot be empty';
    final requestSuccess =
        l10n?.requestSuccess ?? 'Request completed successfully';
    final requestFail = l10n?.requestFail ?? 'Request failed';
    final somethingWrong = l10n?.somethingWentWrong ?? 'Something went wrong';

    if (code.isEmpty) {
      CustomSnackBar.error(errorList: [otpEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    final ResponseModel responseModel = await repo.enable2fa(key, code);

    if (responseModel.statusCode == 200) {
      final AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      if (model.status?.toLowerCase() == 'success') {
        CustomSnackBar.success(
          successList: model.message?.success ?? [requestSuccess],
        );
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? [requestFail],
        );
      }
    } else {
      CustomSnackBar.error(
        errorList: [
          responseModel.message.isNotEmpty
              ? responseModel.message
              : somethingWrong
        ],
      );
    }

    submitLoading = false;
    update();
  }

  void disable2fa(String code) async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final otpEmptyMsg = l10n?.otpFieldEmptyMsg ?? 'OTP field cannot be empty';
    final requestSuccess =
        l10n?.requestSuccess ?? 'Request completed successfully';
    final requestFail = l10n?.requestFail ?? 'Request failed';
    final somethingWrong = l10n?.somethingWentWrong ?? 'Something went wrong';

    if (code.isEmpty) {
      CustomSnackBar.error(errorList: [otpEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    final ResponseModel responseModel = await repo.disable2fa(code);

    if (responseModel.statusCode == 200) {
      final AuthorizationResponseModel model =
          AuthorizationResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      if (model.status?.toLowerCase() == 'success') {
        CustomSnackBar.success(
          successList: model.message?.success ?? [requestSuccess],
        );
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? [requestFail],
        );
      }
    } else {
      CustomSnackBar.error(
        errorList: [
          responseModel.message.isNotEmpty
              ? responseModel.message
              : somethingWrong
        ],
      );
    }

    submitLoading = false;
    update();
  }

  bool isLoading = false;
  TwoFactorCodeModel twoFactorCodeModel = TwoFactorCodeModel();

  void get2FaCode() async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final requestFail = l10n?.requestFail ?? 'Request failed';
    final somethingWrong = l10n?.somethingWentWrong ?? 'Something went wrong';

    isLoading = true;
    update();

    final ResponseModel responseModel = await repo.get2FaData();

    if (responseModel.statusCode == 200) {
      final TwoFactorCodeModel model =
          twoFactorCodeModelFromJson(responseModel.responseJson);

      if (model.status?.toLowerCase() == 'success') {
        twoFactorCodeModel = model;
        isLoading = false;
        update();
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? [requestFail],
        );
      }
    } else {
      CustomSnackBar.error(
        errorList: [
          responseModel.message.isNotEmpty
              ? responseModel.message
              : somethingWrong
        ],
      );
    }

    isLoading = false;
    update();
  }
}
