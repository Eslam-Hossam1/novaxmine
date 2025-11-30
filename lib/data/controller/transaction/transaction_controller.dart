import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/data/model/global/response_model/response_model.dart';
import 'package:mine_lab/data/model/transaction/transaction_response_model.dart';
import 'package:mine_lab/data/repo/transaction/transaction_repo.dart';
import 'package:mine_lab/views/components/snackbar/show_custom_snackbar.dart';

class TransactionController extends GetxController {
  TransactionRepo transactionRepo;
  TransactionController({required this.transactionRepo});

  bool isLoading = true;

  final formKey = GlobalKey<FormState>();

  List<String> transactionTypeList = ["All", "Plus", "Minus"];
  List<String> walletTypeList = [
    "All",
    "Deposit Wallet",
    "Earning Wallet",
    "Coin Wallet"
  ];

  List<TransactionData> transactionList = [];
  List<Remarks> remarksList = [
    (Remarks(remark: "All")),
  ];
  List<FilterCurrency> currencyList = [(FilterCurrency(currency: "All"))];

  String trxSearchText = '';
  String? nextPageUrl;
  int page = 0;
  int index = 0;
  String currency = '';

  TextEditingController trxController = TextEditingController();

  String selectedRemark = "All";
  String selectedTrxType = "All";
  String selectedWalletType = "All";
  String selectedCurrency = "All";

  void initialSelectedValue() async {
    page = 0;
    selectedRemark = "All";
    selectedTrxType = "All";
    trxController.text = '';
    trxSearchText = '';
    transactionList.clear();
    isLoading = true;
    update();

    await loadTransaction();
    isLoading = false;
    update();
  }

  Future<void> loadTransaction() async {
    page = page + 1;

    if (page == 1) {
      currency = transactionRepo.apiClient.getCurrencyOrUsername();
      remarksList.clear();
      remarksList.insert(0, Remarks(remark: "All"));
      transactionList.clear();
    }

    ResponseModel responseModel = await transactionRepo.getTransactionList(
      page,
      type: selectedTrxType.toLowerCase(),
      remark: selectedRemark.toLowerCase(),
      currency: selectedCurrency.toLowerCase(),
      walletType: selectedWalletType.toLowerCase(),
      searchText: trxSearchText,
    );

    if (responseModel.statusCode == 200) {
      TransactionResponseModel model = TransactionResponseModel.fromJson(
          jsonDecode(responseModel.responseJson));

      nextPageUrl = model.data?.transactions?.nextPageUrl;

      if (model.status.toString().toLowerCase() == "success") {
        List<TransactionData>? tempDataList = model.data?.transactions?.data;
        if (page == 1) {
          List<Remarks>? tempRemarksList = model.data?.remarks;
          currencyList = model.data?.currency ?? [];
          currencyList.insert(0, FilterCurrency(currency: "All"));
          if (tempRemarksList != null && tempRemarksList.isNotEmpty) {
            for (var element in tempRemarksList) {
              if (element.remark != null &&
                  element.remark?.toLowerCase() != 'null' &&
                  element.remark!.isNotEmpty) {
                remarksList.add(element);
              }
            }
          }
        }
        if (tempDataList != null && tempDataList.isNotEmpty) {
          transactionList.addAll(tempDataList);
        }
      } else {
        final context = Get.context;
        final MyStrings =
            context != null ? AppLocalizations.of(context)! : null;
        CustomSnackBar.showCustomSnackBar(
            errorList: model.message?.error ?? [MyStrings!.somethingWentWrong],
            msg: [],
            isError: true);
      }
    } else {
      CustomSnackBar.showCustomSnackBar(
          errorList: [responseModel.message], msg: [], isError: true);
    }
    update();
  }

  void changeSelectedRemark(String remarks) {
    selectedRemark = remarks;
    update();
  }

  void changeSelectedTrxType(String trxType) {
    selectedTrxType = trxType;
    update();
  }

  void changeSelectedCurrency(FilterCurrency currency) {
    selectedCurrency = currency.currency ?? '';
    update();
  }

  void changeSelectedWalletType(String walletType) {
    selectedWalletType = walletType;
    update();
  }

  bool filterLoading = false;

  Future<void> filterData() async {
    trxSearchText = trxController.text;
    page = 0;
    filterLoading = true;
    update();
    transactionList.clear();

    await loadTransaction();

    filterLoading = false;
    update();
  }

  bool hasNext() {
    return nextPageUrl != null &&
            nextPageUrl!.isNotEmpty &&
            nextPageUrl != 'null'
        ? true
        : false;
  }

  bool isSearch = false;
  void changeSearchIcon() {
    isSearch = !isSearch;
    update();
    if (!isSearch) {
      initialSelectedValue();
    }
  }
}

