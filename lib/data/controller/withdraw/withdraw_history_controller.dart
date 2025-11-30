import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/data/repo/withdraw_repo/withdraw_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';
import '../../../core/utils/my_color.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import '../../model/global/response_model/response_model.dart';
import '../../model/withdraw/withdraw_history_response_model.dart';

class WithdrawHistoryController extends GetxController {
  WithdrawRepo withdrawHistoryRepo;
  WithdrawHistoryController({required this.withdrawHistoryRepo});

  int page = 0;
  bool isLoading = true;
  String currency = "";
  String curSymbol = "";
  String nextPageUrl = "";

  List<WithdrawListModel> withdrawList = [];

  Future<void> loadPaginationData() async {
    await loadWithdrawData();
    update();
  }

  Future<void> loadWithdrawData() async {
    currency = withdrawHistoryRepo.apiClient.getCurrencyOrUsername();
    curSymbol =
        withdrawHistoryRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    page = page + 1;

    if (page == 1) {
      withdrawList.clear();
    }

    String searchText = searchController.text;
    ResponseModel responseModel = await withdrawHistoryRepo
        .getAllWithdrawHistory(page, searchText: searchText);

    if (responseModel.statusCode == 200) {
      WithdrawHistoryResponseModel model =
          WithdrawHistoryResponseModel.fromJson(
              jsonDecode(responseModel.responseJson));
      nextPageUrl = model.data?.withdrawals?.nextPageUrl ?? "";

      if (model.status.toString().toLowerCase() == "success") {
        List<WithdrawListModel>? tempWithdrawList =
            model.data?.withdrawals?.data;
        if (tempWithdrawList != null && tempWithdrawList.isNotEmpty) {
          withdrawList.addAll(tempWithdrawList);
        }
      } else {
        final context = Get.context;
        final MyStrings =
            context != null ? AppLocalizations.of(context)! : null;
        CustomSnackBar.error(
            errorList: model.message?.error ?? [MyStrings!.somethingWentWrong]);
      }
    } else {
      CustomSnackBar.error(errorList: [responseModel.message]);
    }
  }

  bool filterLoading = false;
  Future<void> filterData() async {
    page = 0;
    filterLoading = true;
    update();

    await loadWithdrawData();

    filterLoading = false;
    update();
  }

  bool hasNext() {
    return nextPageUrl.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  void initData() async {
    currency = withdrawHistoryRepo.apiClient.getCurrencyOrUsername();
    page = 0;
    searchController.text = '';
    withdrawList.clear();

    isLoading = true;
    update();

    await loadWithdrawData();

    isLoading = false;
    update();
  }

  bool isSearch = false;
  TextEditingController searchController = TextEditingController();
  void changeSearchStatus() async {
    isSearch = !isSearch;
    update();
    if (!isSearch) {
      initData();
    }
  }

  String getStatus(int index) {
    final context = Get.context;
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;
    String status = withdrawList[index].status == "1"
        ? MyStrings!.approved
        : withdrawList[index].status == "2"
            ? MyStrings!.pending
            : withdrawList[index].status == "3"
                ? MyStrings!.rejected
                : "";

    return status;
  }

  Color getColor(int index) {
    String status = withdrawList[index].status ?? '';

    return status == '1'
        ? MyColor.greenSuccessColor
        : status == '2'
            ? MyColor.pendingColor
            : status == '3'
                ? MyColor.redCancelTextColor
                : MyColor.colorGrey;
  }

  String downloadId = "-1";
  void downloadAttachment(String url, BuildContext context) {
    downloadId = url;
    update();
    //  String mainUrl = '${UrlContainer.downloadAttachmentsUrl}/$url';
    // try {
    //   if (url.isNotEmpty && url != 'null') {
    //     DownloadService.downloadFile(
    //       mainUrl: mainUrl,
    //       fileName: url,
    //       accessToken: withdrawHistoryRepo.apiClient.token,
    //     );
    //   }
    // } catch (e) {
    //   printX(e);
    // } finally {
    downloadId = "-1";
    update();
    // }
  }
}

