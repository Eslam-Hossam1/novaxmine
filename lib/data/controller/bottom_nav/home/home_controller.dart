import 'dart:convert';

import 'package:get/get.dart';
import 'package:mine_lab/core/helper/share_preference_helper.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/util.dart';
import 'package:mine_lab/data/model/account/profile_response_model.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/home/home_response_model.dart';
import 'package:mine_lab/data/model/user/user.dart';
import 'package:mine_lab/data/repo/bottom_nav/home/home_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import 'package:mine_lab/gen_l10n/app_localizations.dart';

class HomeController extends GetxController {
  HomeRepo homeRepo;

  HomeController({required this.homeRepo});

  bool isLoading = true;
  List<Miners> minersList = [];
  List<Transactions> transactionList = [];

  GlobalUser? user;

  String balance = "";
  String referralBonus = "";
  String profitBalance = "";

  WidgetData? widgetData;

  String currencySymbol = '';
  String currency = '';
  String imagePath = "";
  String referralLink = "";

  String rejected = "";
  String pending = "";
  String approved = "";
  String unpaid = "";

  String kycRejectReason = "";

  bool isKycVerified = true;
  bool isKycPending = false;
  bool isKycRejected = false;

  Future<void> loadDashboardData() async {
    currency = homeRepo.apiClient.getCurrencyOrUsername();
    currencySymbol = homeRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    ResponseModel responseModel = await homeRepo.getDashboardData();

    transactionList.clear();

    if (responseModel.statusCode == 200) {
      HomeResponseModel model =
          HomeResponseModel.fromJson(jsonDecode(responseModel.responseJson));
      if (model.status.toString().toLowerCase() == "success") {
        List<Transactions>? tempTransactionList = model.data?.transactions;
        balance =
            "${MyConverter.twoDecimalPlaceFixedWithoutRounding(model.data?.widget?.depositWallet ?? "")} $currency";
        profitBalance =
            "${MyConverter.twoDecimalPlaceFixedWithoutRounding(model.data?.widget?.profitWallet ?? "", precision: 4)} $currency";
        referralLink = model.data?.referralLink ?? "";
        referralBonus =
            "${MyConverter.twoDecimalPlaceFixedWithoutRounding(model.data?.widget?.totalReferralCommission ?? "")} $currency";
        widgetData = model.data?.widget;
        imagePath = "${model.data?.coinImagePath ?? ""}/";

        rejected = model.data?.plan?.rejected ?? "0";
        approved = model.data?.plan?.approved ?? "0";
        pending = model.data?.plan?.pending ?? "0";
        unpaid = model.data?.plan?.unpaid ?? "0";

        user = model.data?.user;
        isKycVerified = model.data?.user?.kv == '1';
        isKycPending = model.data?.user?.kv == '2';
        isKycRejected = model.data?.user?.kv == '0' &&
            (model.data?.user?.kycRejectionReason).toString() != "null";
        kycRejectReason = model.data?.user?.kycRejectionReason ?? '';

        if (tempTransactionList != null && tempTransactionList.isNotEmpty) {
          transactionList.addAll(tempTransactionList);
        }

        List<Miners>? tempMinersList = model.data?.miners;
        if (tempMinersList != null && tempMinersList.isNotEmpty) {
          minersList.addAll(tempMinersList);
        }
      } else {
        final context = Get.context;
        final l10n = context != null ? AppLocalizations.of(context)! : null;
        CustomSnackBar.showCustomSnackBar(
            errorList: model.message?.error ?? [l10n!.somethingWentWrong],
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

  changeStatusColor(String string, int index) {
    String trxType = transactionList[index].trxType ?? "";
    return trxType == "+" ? MyColor.primaryColor : MyColor.colorRed;
  }

  Future<void> loadUserProfileData() async {
    try {
      ResponseModel responseModel = await homeRepo.getUserInfoData();

      if (responseModel.statusCode == 200) {
        ProfileResponseModel model = ProfileResponseModel.fromJson(
            jsonDecode(responseModel.responseJson));
        if (model.status == 'success') {
          await homeRepo.apiClient.sharedPreferences.setString(
              SharedPreferenceHelper.userPhoneNumberKey,
              model.data?.user?.mobile ?? '');
          await homeRepo.apiClient.sharedPreferences.setString(
              SharedPreferenceHelper.userNameKey,
              model.data?.user?.username ?? '');
          await homeRepo.apiClient.sharedPreferences.setString(
              SharedPreferenceHelper.userEmailKey,
              model.data?.user?.email ?? '');
          //   isKycVerified = model.data?.user?.kv ?? '1';
        } else {}
      } else {}
    } catch (e) {
      printX(e.toString());
    }
  }
}
