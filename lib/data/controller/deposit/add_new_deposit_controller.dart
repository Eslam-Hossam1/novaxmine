import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

import '../../../core/route/route.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import '../../model/deposit/deposit_insert_response_model.dart';
import '../../model/deposit/deposit_method_response_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../repo/deposit/deposit_repo.dart';

class AddNewDepositController extends GetxController {
  DepositRepo depositRepo;
  AddNewDepositController({required this.depositRepo});

  bool isLoading = true;

  String selectedValue = "";
  String imagePath = "";
  String depositLimit = "";
  String charge = "";
  String payable = "";
  String amount = "";
  String fixedCharge = "";
  String currency = '';
  String payableText = '';
  String conversionRate = '';
  String inLocal = '';

  List<AppPaymentGateway> methodList = [];
  AppPaymentGateway? paymentMethod;
  TextEditingController amountController = TextEditingController();
  double rate = 1;
  double mainAmount = 0;

  setPaymentMethod(AppPaymentGateway? method) {
    printX("${UrlContainer.baseUrl}/$imagePath/${method?.name}");
    String amt = amountController.text.toString();
    mainAmount = amt.isEmpty ? 0 : double.tryParse(amt) ?? 0;
    paymentMethod = method;
    depositLimit =
        '${MyConverter.formatNumber(method?.minAmount?.toString() ?? '-1')} - ${MyConverter.formatNumber(method?.maxAmount?.toString() ?? '-1')} $currency';
    if (mainAmount > 0) {
      changeInfoWidgetValue(mainAmount);
    }
    update();
  }

  Future<void> getDepositMethod() async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;
    isLoading = true;
    currency = depositRepo.apiClient.getCurrencyOrUsername();
    methodList.clear();
    paymentMethod =
        AppPaymentGateway(id: '-1', name: l10n!.selectOne, currency: currency);
    update();
    try {
      ResponseModel responseModel = await depositRepo.getDepositMethods();

      if (responseModel.statusCode == 200) {
        DepositMethodResponseModel methodsModel =
            DepositMethodResponseModel.fromJson(
                jsonDecode(responseModel.responseJson));

        if (methodsModel.message != null && methodsModel.message != null) {
          List<AppPaymentGateway>? tempList =
              methodsModel.data?.gatewayCurrency;
          if (tempList != null && tempList.isNotEmpty) {
            imagePath = methodsModel.data?.gatewayImage ?? '';
            methodList.addAll(tempList);
          }
          if (methodList.isNotEmpty) {
            setPaymentMethod(methodList.first);
          }
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
        return;
      }
    } catch (e) {
      printX(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  bool submitLoading = false;
  Future<void> submitDeposit() async {
    final context = Get.context;
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    if (paymentMethod?.id.toString() == '-1') {
      CustomSnackBar.error(errorList: [MyStrings!.selectPaymentMethod]);
      return;
    }

    String amount = amountController.text.toString();
    if (amount.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings!.enterAmount]);
      return;
    }

    submitLoading = true;
    update();

    ResponseModel responseModel = await depositRepo.insertDeposit(
        amount: amount,
        methodCode: paymentMethod?.methodCode ?? "",
        currency: paymentMethod?.currency ?? "");

    if (responseModel.statusCode == 200) {
      DepositInsertResponseModel insertResponseModel =
          DepositInsertResponseModel.fromJson(
              jsonDecode(responseModel.responseJson));

      if (insertResponseModel.status.toString().toLowerCase() == "success") {
        showWebView(insertResponseModel.data ?? DepositInsertData());
      } else {
        CustomSnackBar.error(
            errorList: insertResponseModel.message?.error ??
                [MyStrings!.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(
        errorList: [responseModel.message],
      );
    }

    submitLoading = false;
    update();
  }

  void changeInfoWidgetValue(double amount) {
    if (paymentMethod?.id.toString() == '-1') {
      return;
    }

    mainAmount = amount;
    double percent = double.tryParse(paymentMethod?.percentCharge ?? '0') ?? 0;
    double percentCharge = (amount * percent) / 100;
    double temCharge = double.tryParse(paymentMethod?.fixedCharge ?? '0') ?? 0;
    double totalCharge = percentCharge + temCharge;
    charge = '${MyConverter.formatNumber('$totalCharge')} $currency';
    double payable = totalCharge + amount;
    payableText = '$payable $currency';

    rate = double.tryParse(paymentMethod?.rate ?? '0') ?? 0;
    conversionRate = '1 $currency = $rate ${paymentMethod?.currency ?? ''}';
    inLocal = MyConverter.formatNumber('${payable * rate}');

    update();
    return;
  }

  void clearData() {
    depositLimit = '';
    charge = '';
    amountController.text = '';
    isLoading = false;
    methodList.clear();
  }

  bool isShowRate() {
    if (rate > 1 &&
        currency.toLowerCase() != paymentMethod?.currency?.toLowerCase()) {
      return true;
    } else {
      return false;
    }
  }

  void showWebView(DepositInsertData depositInsertData) {
    Get.offAndToNamed(RouteHelper.depositWebViewScreen,
        arguments: depositInsertData);
  }
}

