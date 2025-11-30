import 'dart:convert';

import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/plan/buy_plan/buy_plan_submit_response_model.dart';
import 'package:mine_lab/data/model/plan/buy_plan/buy_plan_response_model.dart';
import 'package:mine_lab/data/repo/plan/buy_plan/buy_plan_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class BuyPlanController extends GetxController {
  BuyPlanRepo buyPlanRepo;
  BuyPlanController({required this.buyPlanRepo});

  bool isLoading = true;
  int walletIndex = 0;

  List<Miners> walletList = [];
  List<ActivePlans> planList = [];

  List<String> paymentSystemList = [
    "Select One",
    "From Balance",
    "From Profit Wallet",
    "Direct Payment",
  ];
  String selectPaymentSystem = "Select One";

  String currency = "";
  String currencySym = "";

  Future<void> initialValue() async {
    currency = buyPlanRepo.apiClient.getCurrencyOrUsername(isCurrency: true);
    currencySym = buyPlanRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    update();
    loadBuyPlanData();
  }

  void setPaymentMethod(String value) {
    selectPaymentSystem = value;
    update();
  }

  /// load plan
  Future<void> loadBuyPlanData() async {
    final context = Get.context;
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    currency = buyPlanRepo.apiClient.getCurrencyOrUsername();

    ResponseModel responseModel = await buyPlanRepo.getBuyPlanData();
    if (responseModel.statusCode == 200) {
      BuyPlanResponseModel model =
          BuyPlanResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status.toString().toLowerCase() ==
          MyStrings!.success.toLowerCase()) {
        paymentSystemList[1] =
            "${MyStrings.fromBalance} ($currencySym${MyConverter.twoDecimalPlaceFixedWithoutRounding(model.data?.balance ?? "0")})";
        paymentSystemList[2] =
            "${MyStrings.fromProfitWallet} ($currencySym${MyConverter.twoDecimalPlaceFixedWithoutRounding(model.data?.profitBalance ?? "0")})";
        walletList = model.data?.miners ?? [];

        changeWallet(walletIndex);
      } else {
        CustomSnackBar.showCustomSnackBar(
            errorList: model.message?.error ?? [MyStrings.somethingWentWrong],
            msg: [],
            isError: true);
      }
    } else {
      CustomSnackBar.showCustomSnackBar(
          errorList: [responseModel.message], msg: [], isError: true);
    }
    isLoading = false;
    update();
  }

  void changeWallet(int index) {
    walletIndex = index;
    Miners wallet = walletList[index];
    planList = wallet.activePlans ?? [];
    selectedIndex = planList.isNotEmpty
        ? selectedIndex > 0
            ? selectedIndex
            : 0
        : -1;
    update();
  }

  bool purchaseLoading = false;
  Future<void> planPurchase({required int planId}) async {
    purchaseLoading = true;
    update();

    printX(selectPaymentSystem);
    String method = paymentSystemList.indexOf(selectPaymentSystem).toString();
    String paymentMethod =
        method == "3" // 1 -> balance | 2 -> gateway | 3 -> profit wallet
            ? "2"
            : method == "2"
                ? "3"
                : method;

    printX(method);
    printX("request $paymentMethod");

    ResponseModel responseModel = await buyPlanRepo.planPurchase(
        planId: planId.toString(), paymentMethod: paymentMethod.toString());
    final context = Get.context;
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    if (responseModel.statusCode == 200) {
      BuyPlanSubmitResponseModel model = BuyPlanSubmitResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));
      if (model.status.toString().toLowerCase() ==
          MyStrings!.success.toLowerCase()) {
        Get.back();
        if (paymentMethod.toString() == '1' || paymentMethod == '3') {
          selectPaymentSystem = paymentSystemList[0];
          CustomSnackBar.success(
              successList:
                  model.message?.success ?? [MyStrings.requestSuccess]);
          loadBuyPlanData();
        } else {
          String title = model.data?.order?.planTitle ?? '';
          String amount = model.data?.order?.amount ?? '';
          String orderId = model.data?.order?.orderId ?? '';
          Get.toNamed(RouteHelper.planPaymentMethodScreen,
              arguments: [title, amount, orderId]);
        }
      } else {
        CustomSnackBar.showCustomSnackBar(
            errorList: model.message?.error ?? [MyStrings.requestFail],
            msg: [],
            isError: true);
      }
    } else {
      CustomSnackBar.showCustomSnackBar(
          errorList: [responseModel.message], msg: [], isError: true);
    }

    purchaseLoading = false;
    update();
    return;
  }

  int selectedIndex = -1;
  void changeIndex(int index) {
    selectedIndex = index;
    update();
  }
}

