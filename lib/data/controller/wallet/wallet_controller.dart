import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/utils/util.dart';

import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/data/model/authorization/authorization_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/wallet/wallet_response_model.dart';
import 'package:mine_lab/data/repo/wallet_repo/wallet_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class WalletController extends GetxController {
  WalletRepo walletRepo;
  WalletController({required this.walletRepo});
  bool isLoading = true;
  bool submitLoading = false;
  List<CoinBalances> walletList = [];
  String currency = "";
  String currencySym = "";

  TextEditingController amountController = TextEditingController();

  Future<void> loadWalletData({bool shouldLoading = true}) async {
    currency = walletRepo.apiClient.getCurrencyOrUsername(isCurrency: true);
    currencySym = walletRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    isLoading = shouldLoading;
    update();

    ResponseModel responseModel = await walletRepo.getWalletData();

    walletList.clear();
    final context = Get.context;
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    if (responseModel.statusCode == 200) {
      WalletResponseModel model =
          WalletResponseModel.fromJson(jsonDecode(responseModel.responseJson));

      if (model.status?.toLowerCase() == "success") {
        List<CoinBalances>? tempCoinBalancesList = model.data?.coinBalances;
        if (tempCoinBalancesList != null && tempCoinBalancesList.isNotEmpty) {
          walletList.addAll(tempCoinBalancesList);
        }
      } else {
        CustomSnackBar.error(
            errorList: model.message?.error ?? [MyStrings!.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  Future<void> moveToProfitWallet({required CoinBalances coin}) async {
    String amount = amountController.text.toString();
    double balance = double.parse(coin.balance ?? "0.0");
    final context = Get.context;
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    if (amount.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings!.pleaseEnterYourAmount]);
      return;
    }
    if (double.parse(amount) > balance) {
      CustomSnackBar.error(errorList: [
        "${MyStrings!.amountError.tr} $balance ${coin.miner?.coinCode}"
      ]);
      return;
    }

    submitLoading = true;
    update();

    try {
      ResponseModel responseModel = await walletRepo.moveToProfitWallet(
          amount: amountController.text.toString(),
          minerId: coin.id.toString());
      if (responseModel.statusCode == 200) {
        AuthorizationResponseModel model = AuthorizationResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status.toString().toLowerCase() ==
            MyStrings!.success.toLowerCase()) {
          await loadWalletData(shouldLoading: false);
          Get.back();
          amountController.text = '';
          receivedAmount = "00000";

          CustomSnackBar.success(
              successList:
                  model.message?.success ?? [MyStrings.requestSuccess]);
        } else {
          CustomSnackBar.error(
              errorList: model.message?.error ?? [MyStrings.requestFail]);
        }
      } else {
        CustomSnackBar.showCustomSnackBar(
            errorList: [responseModel.message], msg: [], isError: true);
      }
    } catch (e) {
      printX(e.toString());
    }

    submitLoading = false;
    update();
  }

  void setTextFieldData(int index) {
    clearReceivedAmount();
    amountController.text = walletList[index].wallet ?? '';
  }

  String receivedAmount = "00000";
  void calculateReceivedAmount(int index) {
    try {
      double amount = double.parse(amountController.text.toString());
      double rate = double.parse(walletList[index].miner?.rate ?? "0.0");

      receivedAmount = (amount * rate).toStringAsFixed(6);
    } catch (e) {
      receivedAmount = "0.0";
    }
    update();
  }

  clearReceivedAmount() {
    receivedAmount = "0.0";
    update();
  }
}

