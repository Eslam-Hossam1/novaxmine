import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mine_lab/data/model/deposit/deposit_insert_response_model/deposit_insert_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/repo/deposit/deposit_repo.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class ConfirmCoinWalletController extends GetxController {
  ConfirmCoinWalletController({required this.depositRepo});

  final DepositRepo depositRepo;
  bool isSubmitting = false;

  Future<bool> submitCoinWalletDeposit({
    required int coinWalletId,
    required String txHash,
    required String amount,
  }) async {
    if (isSubmitting) return false;

    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;
    final defaultError = l10n?.somethingWentWrong ?? 'Something went wrong';
    final successMessage = l10n?.requestSuccess ?? 'Request successful';

    isSubmitting = true;
    update();

    try {
      final ResponseModel response = await depositRepo.submitCoinWalletDeposit(
        coinWalletId: coinWalletId,
        txHash: txHash,
        amount: amount,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 499) {
        try {
          final decoded = jsonDecode(response.responseJson);
          final model = DepositInsertResponseModel.fromJson(decoded);
          final status = model.status?.toLowerCase() ?? '';
          log(status);
          if (status == 'success') {
            CustomSnackBar.success(
              successList: l10n?.submitDepositSuccessMessage != null
                  ? [l10n!.submitDepositSuccessMessage]
                  : [model.message!],
            );
            return true;
          } else {
            CustomSnackBar.error(errorList: [defaultError]);
            return false;
          }
        } catch (e) {
          CustomSnackBar.error(errorList: [defaultError]);
          return false;
        }
      } else {
        CustomSnackBar.error(errorList: [response.message]);
        return false;
      }
    } catch (e) {
      CustomSnackBar.error(errorList: [defaultError]);
      return false;
    } finally {
      isSubmitting = false;
      update();
    }
  }
}
