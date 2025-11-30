import 'dart:convert';

import 'package:get/get.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/referral/referral_log/referral_log_response_model.dart';
import 'package:mine_lab/data/repo/referral/referral_log_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class ReferralLogController extends GetxController {
  ReferralLogRepo referralLogRepo;
  ReferralLogController({required this.referralLogRepo});

  bool isLoading = true;
  int page = 0;
  String nextPageUrl = "";
  String currency = "USD";

  List<ReferralData> referralDataList = [];

  void initialState() async {
    page = 0;
    referralDataList.clear();
    isLoading = true;
    update();

    await loadReferralLogData();
    isLoading = false;
    update();
  }

  void initData() async {
    page = 0;
    await loadReferralLogData();
    isLoading = false;
    update();
  }

  void loadPaginationData() async {
    await loadReferralLogData();
    update();
  }

  /// referral log data
  Future<void> loadReferralLogData() async {
    page = page + 1;
    if (page == 1) {
      referralDataList.clear();
    }
    ResponseModel responseModel =
        await referralLogRepo.getReferralLogData(page);
    if (responseModel.statusCode == 200) {
      ReferralLogResponseModel model = ReferralLogResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));
      nextPageUrl = model.data?.logs?.nextPageUrl ?? "";
      if (model.status.toString().toLowerCase() == "success") {
        List<ReferralData>? tempReferralData = model.data?.logs?.data;
        if (tempReferralData != null && tempReferralData.isNotEmpty) {
          referralDataList.addAll(tempReferralData);
        }
        if (page == 1) {
          isLoading = false;
          update();
        }
      } else {
        final context = Get.context;
        final MyStrings =
            context != null ? AppLocalizations.of(context)! : null;
        CustomSnackBar.showCustomSnackBar(
            errorList: model.message?.error ?? [MyStrings!.somethingWentWrong],
            msg: [],
            isError: true);
        return;
      }
    } else {
      CustomSnackBar.showCustomSnackBar(
          errorList: [responseModel.message], msg: [], isError: true);
      return;
    }
  }

  bool hasNext() {
    return nextPageUrl.isNotEmpty &&
            nextPageUrl.isNotEmpty &&
            nextPageUrl != 'null'
        ? true
        : false;
  }
}

