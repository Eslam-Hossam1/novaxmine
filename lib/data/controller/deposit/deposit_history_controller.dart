import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/views/components/file_download_dialog/download_dialogue.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

import '../../../core/utils/my_color.dart';
import '../../../core/utils/url_container.dart';
import '../../model/deposit/deposit_history_response_model.dart';
import '../../model/global/response_model/response_model.dart';
import '../../repo/deposit/deposit_repo.dart';
import 'package:mine_lab/l10n/app_localizations.dart';

class DepositController extends GetxController {
  final DepositRepo depositRepo;
  DepositController({required this.depositRepo});

  bool isLoading = false;

  String currency = '';
  String curSymbol = '';
  List<DepositHistoryListModel> depositList = [];
  String? nextPageUrl = '';
  String trx = '';

  int page = 1;

  Future<void> beforeInitLoadData() async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final somethingWentWrong =
        l10n?.somethingWentWrong ?? 'Something went wrong';

    currency = depositRepo.apiClient.getCurrencyOrUsername();
    curSymbol = depositRepo.apiClient.getCurrencyOrUsername(isSymbol: true);
    isLoading = true;
    update();

    page = 1;
    depositList.clear();

    final ResponseModel response =
        await depositRepo.getDepositHistory(page: page);

    if (response.statusCode == 200) {
      final DepositHistoryResponseModel model =
          DepositHistoryResponseModel.fromJson(
        jsonDecode(response.responseJson),
      );

      if (model.status?.toLowerCase() == 'success') {
        final List<DepositHistoryListModel>? tempDepositList =
            model.data?.deposits?.data;
        nextPageUrl = model.data?.deposits?.nextPageUrl ?? '';
        if (tempDepositList != null && tempDepositList.isNotEmpty) {
          depositList.addAll(tempDepositList);
        }
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? [somethingWentWrong],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    isLoading = false;
    update();
  }

  int totalPage = 0;

  Future<void> fetchNewList() async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final somethingWentWrong =
        l10n?.somethingWentWrong ?? 'Something went wrong';

    page = page + 1;
    trx = searchController.text;

    final ResponseModel response = await depositRepo.getDepositHistory(
      page: page,
      searchText: trx,
    );

    if (response.statusCode == 200) {
      final DepositHistoryResponseModel model =
          DepositHistoryResponseModel.fromJson(
        jsonDecode(response.responseJson),
      );

      if (model.status?.toLowerCase() == 'success') {
        final List<DepositHistoryListModel>? tempDepositList =
            model.data?.deposits?.data;
        nextPageUrl = model.data?.deposits?.nextPageUrl ?? '';
        if (tempDepositList != null && tempDepositList.isNotEmpty) {
          depositList.addAll(tempDepositList);
        }
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? [somethingWentWrong],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    update();
  }

  bool searchLoading = false;
  TextEditingController searchController = TextEditingController();

  Future<void> searchDepositTrx() async {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final somethingWentWrong =
        l10n?.somethingWentWrong ?? 'Something went wrong';

    trx = searchController.text;
    page = 1;
    searchLoading = true;
    update();
    depositList.clear();

    final ResponseModel response = await depositRepo.getDepositHistory(
      page: page,
      searchText: trx,
    );

    if (response.statusCode == 200) {
      final DepositHistoryResponseModel model =
          DepositHistoryResponseModel.fromJson(
        jsonDecode(response.responseJson),
      );

      if (model.status?.toLowerCase() == 'success') {
        final List<DepositHistoryListModel>? tempDepositList =
            model.data?.deposits?.data;
        nextPageUrl = model.data?.deposits?.nextPageUrl ?? '';
        if (tempDepositList != null && tempDepositList.isNotEmpty) {
          depositList.addAll(tempDepositList);
        }
      } else {
        CustomSnackBar.error(
          errorList: model.message?.error ?? [somethingWentWrong],
        );
      }
    } else {
      CustomSnackBar.error(errorList: [response.message]);
    }

    page = 1;
    searchLoading = false;
    update();
  }

  bool hasNext() {
    if (nextPageUrl != null && nextPageUrl!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void clearFilter() {
    searchController.text = '';
    trx = '';
    beforeInitLoadData();
  }

  int expandedIndex = -1;
  void changeExpandedIndex(int index) {
    if (expandedIndex == index) {
      expandedIndex = -1;
    } else {
      expandedIndex = index;
    }
    update();
  }

  bool isSearch = false;
  void changeIsPress() {
    isSearch = !isSearch;
    if (!isSearch) {
      searchController.text = '';
      clearFilter();
    }
    update();
  }

  String getStatus(int index) {
    final context = Get.context;
    final l10n = context != null ? AppLocalizations.of(context)! : null;

    final approved = l10n?.approved ?? 'Approved';
    final success = l10n?.success ?? 'Success';
    final pending = l10n?.pending ?? 'Pending';
    final rejected = l10n?.rejected ?? 'Rejected';
    final initiated = l10n?.initiated ?? 'Initiated';

    final String status = depositList[index].status ?? '';
    final String methodCode = depositList[index].methodCode ?? '1';

    if (status == '1') {
      final double code = double.tryParse(methodCode) ?? 1;
      return code >= 1000 ? approved : success;
    } else {
      return status == '2'
          ? pending
          : status == '3'
              ? rejected
              : initiated;
    }
  }

  Color getStatusColor(int index) {
    final String status = depositList[index].status ?? '';
    final String methodCode = depositList[index].methodCode ?? '1';

    if (status == '1') {
      final double code = double.tryParse(methodCode) ?? 1;
      return code >= 1000
          ? MyColor.highPriorityPurpleColor
          : MyColor.greenSuccessColor;
    } else {
      return status == '2'
          ? MyColor.pendingColor
          : status == '3'
              ? MyColor.redCancelTextColor
              : MyColor.colorGrey;
    }
  }

  void downloadAttachment(String url, BuildContext context) {
    final String mainUrl = '${UrlContainer.baseUrl}assets/verify/$url';

    if (url.isNotEmpty && url != 'null') {
      showDialog(
        context: context,
        builder: (context) => DownloadingDialog(
          isImage: false,
          url: mainUrl,
          fileName: '',
        ),
      );

      update();
    }
  }
}

