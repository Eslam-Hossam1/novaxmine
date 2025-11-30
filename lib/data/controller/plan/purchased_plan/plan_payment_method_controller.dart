import 'dart:convert';

import 'package:get/get.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/plan/plan_payment_insert_response_model.dart';
import 'package:mine_lab/data/model/plan/plan_payment_method/plan_payment_method_response_model.dart';
import 'package:mine_lab/data/repo/plan/purchased_plan/purchased_plan_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';

class PlanPaymentMethodController extends GetxController {
  final PurchasedPlanRepo purchasedPlanRepo;

  PlanPaymentMethodController({
    required this.purchasedPlanRepo,
    required this.amount,
  });

  bool isLoading = true;

  List<Methods> methodList = [];

  String selectedValue = "";

  String depositLimit = "";
  String charge = "";
  String payable = "";
  String amount = "";
  String fixedCharge = "";
  String currency = '';
  String payableText = '';
  String conversionRate = '';
  String inLocal = '';
  String? nextPageUrl;
  String? crypto;

  String currencySymbol = '';

  Methods? paymentMethod;
  PlanPaymentMethodResponseModel planPaymentMethodResponseModel =
      PlanPaymentMethodResponseModel();
  List<Methods> paymentMethodList = [];

  double rate = 1;
  double mainAmount = 0;

  void setPaymentMethod(Methods? methods) {
    paymentMethod = methods;
    mainAmount = amount.isEmpty ? 0 : double.tryParse(amount) ?? 0;

    depositLimit =
        '${MyConverter.twoDecimalPlaceFixedWithoutRounding(paymentMethod?.minAmount?.toString() ?? '0')} - '
        '${MyConverter.twoDecimalPlaceFixedWithoutRounding(paymentMethod?.maxAmount?.toString() ?? '0')} '
        '$currency';

    changeInfoWidgetValue(mainAmount);
    update();
  }

  void changeInfoWidgetValue(double amount) {
    if (paymentMethod?.id.toString() == '-1') {
      return;
    }

    mainAmount = amount;
    final double percent =
        double.tryParse(paymentMethod?.percentCharge ?? '0') ?? 0;
    final double percentCharge = (amount * percent) / 100;

    final double tempCharge =
        double.tryParse(paymentMethod?.fixedCharge ?? '0') ?? 0;
    final double totalCharge = percentCharge + tempCharge;

    charge =
        '${MyConverter.twoDecimalPlaceFixedWithoutRounding('$totalCharge')} $currency';

    final double totalPayable = totalCharge + amount;
    payableText =
        '${MyConverter.twoDecimalPlaceFixedWithoutRounding('$totalPayable', precision: 8)} $currency';

    rate = double.tryParse(paymentMethod?.rate ?? '0') ?? 0;
    conversionRate = '1 $currency = $rate ${paymentMethod?.currency ?? ''}';
    inLocal = MyConverter.twoDecimalPlaceFixedWithoutRounding(
      '${totalPayable * rate}',
    );

    update();
  }

  bool isShowRate() {
    if (rate > 1 &&
        currency.toLowerCase() != paymentMethod?.currency?.toLowerCase()) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> beforeInitLoadData() async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final selectOneText = l10n?.selectOne ?? 'Select one';

    currency = purchasedPlanRepo.apiClient.getCurrencyOrUsername();
    isLoading = true;
    update();

    planPaymentMethodResponseModel =
        await purchasedPlanRepo.getPlanPaymentMethod();

    paymentMethodList.clear();
    paymentMethodList.add(Methods(name: selectOneText, id: -1));

    if (planPaymentMethodResponseModel.message != null &&
        planPaymentMethodResponseModel.message?.success != null) {
      final List<Methods>? tempPaymentMethodList =
          planPaymentMethodResponseModel.data?.methods;

      if (tempPaymentMethodList != null && tempPaymentMethodList.isNotEmpty) {
        paymentMethodList.addAll(tempPaymentMethodList);
      }

      if (paymentMethodList.isNotEmpty) {
        paymentMethod = paymentMethodList[0];
      }

      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
    }
  }

  bool isSubmitLoading = false;

  Future<void> submitPayment({
    required String amount,
    required String orderId,
  }) async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final selectAGatewayText =
        l10n?.selectAGateway ?? 'Please select a payment gateway';
    final tryAgainText =
        l10n?.gateway ?? 'Something went wrong, please try again';
    final responseErrorText = l10n?.error ?? 'Response error';

    if (paymentMethod?.id.toString() == '-1') {
      CustomSnackBar.error(errorList: [selectAGatewayText]);
      return;
    }

    isSubmitLoading = true;
    update();

    final ResponseModel responseModel = await purchasedPlanRepo.insertPayment(
      order: orderId,
      amount: amount,
      methodCode: paymentMethod?.methodCode ?? "",
      currency: paymentMethod?.currency ?? "",
    );

    if (responseModel.statusCode == 200) {
      final PlanPaymentInsertResponseModel insertResponseModel =
          PlanPaymentInsertResponseModel.fromJson(
        jsonDecode(responseModel.responseJson),
      );

      if (insertResponseModel.status.toString().toLowerCase() == "success") {
        showWebView(insertResponseModel.data?.redirectUrl ?? "");
      } else {
        CustomSnackBar.showCustomSnackBar(
          errorList:
              insertResponseModel.message?.error ?? <String>[tryAgainText],
          msg: const [],
          isError: true,
        );
      }
    } else {
      CustomSnackBar.showCustomSnackBar(
        errorList: [responseErrorText],
        msg: const [],
        isError: true,
      );
    }

    isSubmitLoading = false;
    update();
  }

  void showWebView(String redirectUrl) {
    Get.offAndToNamed(
      RouteHelper.depositWebScreen,
      arguments: redirectUrl,
    );
  }
}
