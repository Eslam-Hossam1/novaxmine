import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/url_container.dart';
import 'package:mine_lab/data/model/user/user.dart';
import 'package:mine_lab/data/model/withdraw/withdraw_request_response_model.dart';
import 'package:mine_lab/data/repo/withdraw_repo/withdraw_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

import '../../../core/route/route.dart';
import '../../model/global/response_model/response_model.dart';
import '../../model/withdraw/withdraw_method_response_model.dart';

class AddNewWithdrawController extends GetxController {
  final WithdrawRepo repo;
  AddNewWithdrawController({required this.repo});

  // helper للوصول للـ l10n من Get.context
  AppLocalizations? get _l10n =>
      Get.context != null ? AppLocalizations.of(Get.context!) : null;

  bool isLoading = true;
  String currency = '';
  String currencySym = '';

  List<WithdrawMethod> withdrawMethodList = [];
  TextEditingController amountController = TextEditingController();
  WithdrawMethod? withdrawMethod = WithdrawMethod();

  String withdrawLimit = '';
  String charge = '';
  String payableText = '';
  String conversionRate = '';
  String inLocal = '';

  String imagePath = '';
  String profitWalletBalance = '';

  List<String> authorizationList = [];
  String? selectedAuthorizationMode;

  GlobalUser? user;

  void changeAuthorizationMode(String? value) {
    if (value != null) {
      selectedAuthorizationMode = value;
      update();
    }
  }

  double rate = 1;
  double mainAmount = 0;

  void setWithdrawMethod(WithdrawMethod? method) {
    withdrawMethod = method;

    // أولاً نضبط حدود السحب (بدون استخدام MyStrings)
    withdrawLimit =
        '${MyConverter.formatNumber(method?.minLimit?.toString() ?? '-1')} - '
        '${MyConverter.formatNumber(method?.maxLimit?.toString() ?? '-1')} '
        '$currency';

    // ثمن الرسوم الأساسي (سنحسب التفصيلي في changeInfoWidgetValue)
    charge =
        '${MyConverter.formatNumber(method?.fixedCharge?.toString() ?? '0')} + '
        '${MyConverter.formatNumber(method?.percentCharge?.toString() ?? '0')} %';

    update();

    final String amt = amountController.text.toString();
    mainAmount = amt.isEmpty ? 0 : double.tryParse(amt) ?? 0;

    // إعادة ضبط الحدود (نفس القديم لكن بدون MyStrings)
    withdrawLimit =
        '${MyConverter.formatNumber(method?.minLimit?.toString() ?? '-1')} - '
        '${MyConverter.formatNumber(method?.maxLimit?.toString() ?? '-1')} '
        '$currency';

    changeInfoWidgetValue(mainAmount);
    update();
  }

  void changeInfoWidgetValue(double amount) {
    mainAmount = amount;

    final double percent =
        double.tryParse(withdrawMethod?.percentCharge ?? '0') ?? 0;
    final double percentCharge = (amount * percent) / 100;
    final double temCharge =
        double.tryParse(withdrawMethod?.fixedCharge ?? '0') ?? 0;
    final double totalCharge = percentCharge + temCharge;

    final double payable = amount - totalCharge;
    payableText = '$payable $currency';
    charge = '${MyConverter.formatNumber('$totalCharge')} $currency';

    rate = double.tryParse(withdrawMethod?.rate ?? '0') ?? 0;
    conversionRate = '1 $currency = $rate ${withdrawMethod?.currency ?? ''}';
    inLocal = MyConverter.formatNumber('${payable * rate}');

    update();
    return;
  }

  Future<void> loadDepositMethod() async {
    currency = repo.apiClient.getCurrencyOrUsername();
    currencySym = repo.apiClient.getCurrencyOrUsername(isSymbol: true);
    clearPreviousValue();
    user = null;
    isLoading = true;
    update();

    ResponseModel responseModel = await repo.getAllWithdrawMethod();

    final l10n = _l10n;

    if (responseModel.statusCode == 200) {
      final WithdrawMethodResponseModel model =
          WithdrawMethodResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      if (model.status?.toLowerCase() == 'success') {
        final List<WithdrawMethod>? tempMethodList = model.data?.withdrawMethod;
        if (tempMethodList != null && tempMethodList.isNotEmpty) {
          withdrawMethodList.addAll(tempMethodList);
        }
        user = model.data?.user;
        imagePath = "${UrlContainer.baseUrl}${model.data?.imagePath}";
        profitWalletBalance = model.data?.profitWallet ?? "";
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ??
              [l10n?.somethingWentWrong ?? 'Something went wrong'],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }

    isLoading = false;
    update();
  }

  bool submitLoading = false;

  Future<void> submitWithdrawRequest(BuildContext context) async {
    final l10n = _l10n;

    final String amount = amountController.text;
    final String id = withdrawMethod?.id.toString() ?? '-1';

    if (amount.isEmpty) {
      CustomSnackBar.error(
        errorList: [l10n?.enterAmount ?? 'Please enter amount'],
      );
      return;
    }

    if (id == '-1') {
      CustomSnackBar.error(
        errorList: [
          l10n?.selectPaymentMethod ?? 'Please select a payment method'
        ],
      );
      return;
    }

    if (authorizationList.length > 1) {
      final String selectOneText =
          (l10n?.selectOne ?? 'Select one').toLowerCase();
      if ((selectedAuthorizationMode ?? '').toLowerCase() == selectOneText) {
        CustomSnackBar.error(
          errorList: [
            l10n?.selectAuthModeMsg ?? 'Please select an authorization mode'
          ],
        );
        return;
      }
    }

    double amount1 = 0;
    double maxAmount = 0;

    try {
      amount1 = double.parse(amount);
      maxAmount = double.parse(withdrawMethod?.maxLimit ?? '0');
    } catch (_) {
      return;
    }

    if (maxAmount == 0 || amount1 == 0) {
      CustomSnackBar.error(
        errorList: [l10n?.invalidAmount ?? 'Invalid amount'],
      );
      return;
    }

    submitLoading = true;
    update();

    ResponseModel response = await repo.addWithdrawRequest(
      context,
      withdrawMethod?.id ?? -1,
      amount1,
      selectedAuthorizationMode,
    );

    if (response.statusCode == 200) {
      final WithdrawRequestResponseModel model =
          WithdrawRequestResponseModel.fromJson(
        jsonDecode(response.responseJson),
      );

      if (model.status?.toLowerCase() == 'success') {
        Get.offAndToNamed(
          RouteHelper.withdrawConfirmScreenScreen,
          arguments: [model, withdrawMethod?.name],
        );
      } else {
        CustomSnackBar.error(
          errorList:
              model.message?.error ?? [l10n?.requestFail ?? 'Request failed'],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    submitLoading = false;
    update();
  }

  bool isShowRate() {
    if (rate > 1 &&
        currency.toLowerCase() !=
            (withdrawMethod?.currency?.toLowerCase() ?? '')) {
      return true;
    } else {
      return false;
    }
  }

  void clearPreviousValue() {
    withdrawMethodList.clear();
    amountController.text = '';
    rate = 1;
    submitLoading = false;
    withdrawMethod = WithdrawMethod();
    withdrawLimit = '';
    charge = '';
    payableText = '';
    conversionRate = '';
    inLocal = '';
  }
}

